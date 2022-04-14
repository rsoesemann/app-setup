public with sharing class SetupBackendConnection extends SetupStep {

    public static final String DEV_NAME = 'MockLab_Integration';
    public static final String API_ENDPOINT = 'https://rsoesemann.mocklab.io';

    // PUBLIC

    public String callback { get{ return callbackUrl(); } set; }
    public String clientId { get; set; }
    public String clientSecret { get; set; }

    public List<AuthProvider> authProvider {
        get {
            return [SELECT DeveloperName, AuthorizeUrl, LinkKickoffUrl, ConsumerKey, ConsumerSecret FROM AuthProvider WHERE DeveloperName = :DEV_NAME LIMIT 1];
        }
        private set;
    }


    public List<NamedCredential> namedCredential {
        get {
            return [SELECT DeveloperName, Endpoint FROM NamedCredential WHERE DeveloperName = :DEV_NAME LIMIT 1];
        }
        private set;
    }


    public override ApexPages.Message getStatus() {
        if(!authProvider.isEmpty()) {
            clientId = authProvider[0].ConsumerKey;
            clientSecret = authProvider[0].ConsumerSecret;
        }

        Boolean setupDone = (!authProvider.isEmpty() && !namedCredential.isEmpty());
        Boolean isAuthorized = isAuthorized();

        ApexPages.Severity severity = (isAuthorized) ? ApexPages.Severity.CONFIRM :
                                      ((setupDone) ? ApexPages.Severity.ERROR : Apexpages.Severity.INFO);

        String fragment = (setupDone) ? ' are set up correctly ' : ' need to be created. ';
        fragment += (isAuthorized) ? 'API access is established.' : 'No API access yet!';

        String message = String.format('An {0} and a {1} to connect with {2} {3}.',
            new List<String>{ setupLink(authProvider), setupLink(namedCredential),
                              link('your Account', 'https://app.mocklab.io/'),
                              fragment });
        return new ApexPages.Message(severity, message);
    }


    public override String buttonLabel() {
        return 'Execute';
    }


    public override PageReference run() {
        createAuthProvider();
        createNamedCredential();
        
        return oAuthKickoffUrl();
    }

    // PRIVATE

    private void createAuthProvider() {
        // Note: Make it run in all test no matter of the state of the org (no test isolation for this)
        if(authProvider.isEmpty() || Test.isRunningTest()) {
            createSObject(
                '<urn1:type>AuthProvider</urn1:type>' +
                '<urn1:DeveloperName>' + DEV_NAME + '</urn1:DeveloperName>' +
                '<urn1:FriendlyName>' + DEV_NAME + '</urn1:FriendlyName>' +
                '<urn1:ProviderType>OpenIdConnect</urn1:ProviderType>' +
                '<urn1:OptionsSendAccessTokenInHeader>true</urn1:OptionsSendAccessTokenInHeader>' +
                '<urn1:OptionsSendClientCredentialsInHeader>false</urn1:OptionsSendClientCredentialsInHeader>' +
                '<urn1:DefaultScopes>producer</urn1:DefaultScopes>' +
                '<urn1:ConsumerKey>' + clientId + '</urn1:ConsumerKey>' +
                '<urn1:ConsumerSecret>' + clientSecret + '</urn1:ConsumerSecret>' +
                '<urn1:AuthorizeUrl>' + API_ENDPOINT + '/oauth/authorize</urn1:AuthorizeUrl>' +
                '<urn1:TokenUrl>' + API_ENDPOINT + '/oauth/token</urn1:TokenUrl>' +
                '<urn1:UserInfoUrl>' + API_ENDPOINT + '/userinfo</urn1:UserInfoUrl>'
            );
        }
    }


    private void createNamedCredential() {
        // Note: Make it run in all test no matter of the state of the org (no test isolation for this)
        if(namedCredential.isEmpty() || Test.isRunningTest()) {
            MetadataService.NamedCredential cred = new MetadataService.NamedCredential();
            cred.fullName = DEV_NAME;
            cred.label = DEV_NAME;
            cred.allowMergeFieldsInBody = false;
            cred.allowMergeFieldsInHeader = false;
            cred.authProvider = DEV_NAME;
            cred.generateAuthorizationHeader = true;
            cred.principalType = 'NamedUser';
            cred.protocol = 'Oauth';
            cred.authProvider = DEV_NAME;
            cred.endpoint = API_ENDPOINT;
            cred.oauthScope = 'openid, profile, email';

            create(cred);
        }
    }


    private PageReference oAuthKickoffUrl() {
        PageReference result = new PageReference(authProvider[0].LinkKickoffUrl);
        result.getParameters().put('startURL', '/lightning/n/Setup');
        return result;
    }    @SuppressWarnings('PMD.ApexOpenRedirect')
   
   /* private PageReference oAuthKickoffUrl() {
        String domain = Url.getOrgDomainUrl().toExternalForm();
        String path = '/services/auth/xds/' + DEV_NAME;
      
        PageReference result = new PageReference(domain + path);
        result.getParameters().put('scope', 'producer');
        return result;
        
    }*/


    public static String callbackUrl() {
        return Url.getOrgDomainUrl().toExternalForm() + '/services/authcallback/' + DEV_NAME;
    }


    private HTTPResponse createSObject(String fragment) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL.getOrgDomainUrl().toExternalForm() + '/services/Soap/u/53.0');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml; charset=UTF-8');
        request.setHeader('SOAPAction', 'ignored');
        request.setBody('<?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:urn="urn:partner.soap.sforce.com" xmlns:urn1="urn:sobject.partner.soap.sforce.com"><env:Header><SessionHeader xmlns="urn:partner.soap.sforce.com"><sessionId>' + UserInfo.getSessionId() + '</sessionId></SessionHeader></env:Header><env:Body><urn:create><urn:sObjects>' +
                            + fragment + '</urn:sObjects></urn:create></env:Body></env:Envelope>');

        return new Http().send(request);
    }


    private Boolean isAuthorized() {
        

        return false;
    }
}