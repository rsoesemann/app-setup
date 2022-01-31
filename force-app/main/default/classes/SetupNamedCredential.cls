public with sharing class SetupNamedCredential extends SetupStep {

    public String endpoint { get; set; }
    public String username { get; set; }
    public String password { get; set; }
    public String callbackUrl { get; set; }

    @TestVisible
    private static final String ENDPOINT_FOR_TESTS = 'https://salesforce-integration.com/for-testing-purposes-only';


    // PUBLIC

    public List<NamedCredential> namedCredential {
        get {
            List<NamedCredential> namedCredential = [SELECT Endpoint FROM NamedCredential WHERE DeveloperName = :SetupPageCtrl.DEV_NAME LIMIT 1];
            if(!namedCredential.isEmpty()) {
                endpoint = namedCredential[0].Endpoint;
            }
            return namedCredential;
        }
        private set;
    }


    public Boolean authorized {
        get {
            try {
                return true;
            }
            catch(Exception ex) {
                return false;
            }
        }
        private set;
    }


    public String baseUrl {
        get {
            String result = null;

            for(NamedCredential credential : namedCredential) {
                result = credential.Endpoint;
            }

            return (Test.isRunningTest()) ?  ENDPOINT_FOR_TESTS : result;
        }
        private set;
    }


    public override ApexPages.Message getStatus() {
        Boolean setupDone = !(namedCredential.isEmpty());
        ApexPages.Severity severity = (setupDone && authorized) ? ApexPages.Severity.CONFIRM : ApexPages.Severity.WARNING;

        String sentence = (setupDone) ? Label.SetupNamedCredentialFinished : Label.SetupNamedCredentialUnfinished;

        String message = String.format(Label.SetupNamedCredentialStepDescription, new List<String>{ setupLink(namedCredential), sentence });

        return new ApexPages.Message(severity, message);
    }


    public override String buttonLabel() {
        return 'Execute';
    }


    public override PageReference run() {
        createNamedCredential();
        return currentPage();
    }


    // PRIVATE

    private void createNamedCredential() {
        MetadataService.NamedCredential credential = new MetadataService.NamedCredential();
        credential.fullName = SetupPageCtrl.DEV_NAME;
        credential.label = SetupPageCtrl.DEV_NAME;
        credential.allowMergeFieldsInBody = false;
        credential.allowMergeFieldsInHeader = true;
        credential.generateAuthorizationHeader = true;
        credential.principalType = 'NamedUser';
        credential.protocol = 'Password';

        // Note: Remove trailing / as we append /api
        credential.endpoint = endpoint.removeEnd('/');
        credential.username = username.trim();
        credential.password = password.trim();

        create(credential);
    }
}