public abstract with sharing class SetupStep {

    // ABSTRACT

    public abstract ApexPages.Message getStatus();
    public abstract PageReference run();
    public abstract String buttonLabel();

    // PUBLIC

    public Boolean success {
        get {
            return (getStatus().getSeverity() == ApexPages.Severity.CONFIRM);
        }
        private set;
    }


    public String getMessage() {
        return getStatus().getSummary();
    }


    public String getSeverity() {
        return getStatus().getSeverity().name();
    }
    

    public PageReference doRun() {
        PageReference result = null;

        try {
            result = run();
        }
        catch(Exception ex) {
            ApexPages.addMessages(ex);
        }

        return result;
    }


    public String buttonLabel {
        get {
            return buttonLabel();
        }
    }


    public virtual Boolean getShowButtonOnSuccess() {
        return false;
    }


    // PROTECTED

    protected String setupLink(List<SObject> records) {
        SObjectType type = records.getSObjectType();
        Id id = null;

        if(!records.isEmpty() && records[0] != null) {
            type = records[0].getSObjectType();
            id = records[0].Id;
        }

        return setupLink(id, '' + type, type.getDescribe().getLabel());
    }


    protected String setupLink(SObject record) {
        return setupLink(new List<SObject>{ record });
    }


    protected String setupLink(SObjectType type) {
        return '<b><a href="/lightning/setup/ObjectManager/' + type + '/FieldsAndRelationships/view" target="_blank">' + type.getDescribe().getLabel() + '</a></b>';
    }


    
    protected String setupLink(String id, String type, String label) {
        return (id == null) ? '<b>' + label + '</b>'  : '<b><a href="/lightning/setup/' + type + '/page?address=%2F' + id +'" target="_blank">' + label + '</a></b>';
    }


    protected String setupLink(String label, String url) {
        return '<b><a href="' + url +'" target="_blank">' + label + '</a></b>';
    }


    protected String link(String label, String url) {
        return '<b><a href="' + url +'" target="_blank">' + label + '</a></b>';
    }



    protected PageReference currentPage() {
        PageReference result = Page.setup;
        result.setRedirect(true);
        return result;
    }

    
    // INNER

    public abstract class ForBatch extends SetupStep {

        public abstract void execute();

        public virtual override ApexPages.Message getStatus() {
            if(countBatchWithStatus(new List<String>{'Failed', 'Aborted'}) > 0) {
                return new ApexPages.Message(ApexPages.Severity.ERROR, 'Batch job failed. Check the logs.');
            }
            else if(countBatchWithStatus(new List<String>{'Holding', 'Queued', 'Preparing', 'Processing'}) > 1) {
                return new ApexPages.Message(ApexPages.Severity.INFO, 'Batch job pending. Check the logs.');
            }
            else if(countBatchWithStatus(new List<String>{'Completed'}) == 1) {
                return new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Batch job completed.');
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

}