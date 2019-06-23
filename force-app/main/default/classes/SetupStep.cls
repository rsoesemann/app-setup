public abstract class SetupStep {

    // ABSTRACT

    public abstract ApexPages.Message getStatus();
    public abstract PageReference run();
    public abstract String buttonLabel();


    // PUBLIC

    public String getMessage() {
        return getStatus().getSummary();
    }


    public String getSeverity() {
        return getStatus().getSeverity().name();
    }


    public String getButtonLabel() {
        return buttonLabel();
    }


    public PageReference doRun() {
        PageReference result;

        try {
            result = run();
        }
        catch(Exception ex) {
            ApexPages.addMessages(ex);
        }

        return result;
    }


    // PROTECTED

    protected void create(List<MetadataService.Metadata> metadata) {
        MetadataService.MetadataPort mdapi = new MetadataService.MetadataPort();
        mdapi.SessionHeader = new MetadataService.SessionHeader_element();
        mdapi.SessionHeader.sessionId = UserInfo.getSessionId();

        for(MetadataService.SaveResult result : mdapi.createMetadata(metadata)) {
            if(result != null) {
                if(result.errors != null) {
                    List<String> messages = new List<String>();
                    messages.add((result.errors.size()==1 ? 'Error ' : 'Errors ') +
                            'occured processing component ' + result.fullName + '.');
                    for(MetadataService.Error error : result.errors) {
                        messages.add(error.message + ' (' + error.statusCode + ').' +
                                ( error.fields!=null && error.fields.size() > 0 ?
                                        ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
                    }

                    if(messages.size() > 0) {
                        throw new MetadataServiceException(String.join(messages, ' '));
                    }
                }

                if(!result.success) {
                    throw new MetadataServiceException('Request failed with no specified error.');
                }
            }
        }
    }


    // INNER

    public abstract class ForBatch extends SetupStep {

        public abstract void execute();

        public virtual override ApexPages.Message getStatus() {
            if(countBatchWithStatus(new List<String>{'Failed', 'Aborted'}) > 0) {
                return new ApexPages.Message(ApexPages.Severity.ERROR, 'Execution failed. Please let an Admin check the Apex Job Logs to find out why.');
            }
            else if(countBatchWithStatus(new List<String>{'Holding', 'Queued', 'Preparing', 'Processing'}) > 1) {
                return new ApexPages.Message(ApexPages.Severity.INFO, 'Execution has started and might take a while. Please check this page (or the Apex Jobs in Setup) in a few minutes.');
            }
            else if(countBatchWithStatus(new List<String>{'Completed'}) == 1) {
                return new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Execution completed. Please let an admin manually check the correctness of the migration.');
            }

            return null;
        }


        public override String buttonLabel() {
            return 'Run...';
        }


        public override PageReference run() {
            execute();
            return new PageReference('/apexpages/setup/listAsyncApexJobs.apexp');
        }


        private Integer countBatchWithStatus(List<String> statuses) {
            String className = String.valueOf(this).split(':')[0];
            return [SELECT COUNT() FROM AsyncApexJob WHERE Status IN :statuses AND ApexClass.Name LIKE :className];
        }
    }


    public class MetadataServiceException extends Exception {}
}