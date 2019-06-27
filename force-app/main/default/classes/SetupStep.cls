public abstract class SetupStep {

    // ABSTRACT

    public abstract ApexPages.Message getStatus();
    public abstract PageReference run();
    public abstract String getButtonLabel();


    // PUBLIC

    public String getMessage() {
        return getStatus().getSummary();
    }


    public String getSeverity() {
        return getStatus().getSeverity().name();
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

    public class MetadataServiceException extends Exception {}
}