public with sharing class SetupConnectedApp extends SetupStep implements Canvas.CanvasLifecycleHandler{

    private final static String BASE_URL = SetupBackendConnection.API_ENDPOINT;

    public String canvasAppURL { get; set; }
    public String callbackURL { get; set; }


    // PUBLIC

    public override ApexPages.Message getStatus() {
        Boolean setupDone = !connectedApp.isEmpty();
        ApexPages.Severity severity = (setupDone) ? ApexPages.Severity.CONFIRM : ApexPages.Severity.WARNING;
        String sentence = (setupDone) ? '{0} has been created successfully' : 'Connected app needs to be created';
        String message = String.format(sentence, new List<String>{ setupLink(connectedApp) });

        return new ApexPages.Message(severity, message);
    }


    public List<ConnectedApplication> connectedApp {
        get { return [SELECT Name FROM ConnectedApplication WHERE Name = :SetupPageCtrl.DEV_NAME LIMIT 1]; }
    }


    public override String buttonLabel() {
        return 'Execute';
    }


    public override PageReference run() {
        createConnectedApp();

        return currentPage();
    }


    // CANVAS LIFECYCLE

    public Set<Canvas.ContextTypeEnum> excludeContextTypes(){
        return new Set<Canvas.ContextTypeEnum>{ Canvas.ContextTypeEnum.ORGANIZATION };
    }

    
    public void onRender(Canvas.RenderContext renderContext){
        System.debug('Canvas lifecycle called.');
    }


    // PRIVATE

    private void createConnectedApp() {
        MetadataService.ConnectedApp app = new MetadataService.ConnectedApp();
        app.fullName = SetupPageCtrl.DEV_NAME;
        app.label = SetupPageCtrl.DEV_NAME;
        app.contactEmail = UserInfo.getUserEmail();
        app.attributes = connectedAppAttributes();
        app.oauthConfig = oauthConfig();
        app.canvasConfig = canvasConfig();

        create(app);
    }


    private MetadataService.ConnectedAppOauthConfig oauthConfig() {
        MetadataService.ConnectedAppOauthConfig result = new MetadataService.ConnectedAppOauthConfig();
        result.isAdminApproved = true;
        result.callbackUrl = callbackURL;
        result.scopes = new List<String>{ 'Basic', 'Full', 'Api', 'Web', 'RefreshToken', 'OpenID', 'Chatter' };

        return result;
    }


    private MetadataService.ConnectedAppCanvasConfig canvasConfig() {
        MetadataService.ConnectedAppCanvasConfig result = new MetadataService.ConnectedAppCanvasConfig();
        result.accessMethod = 'Post';
        result.canvasUrl = canvasAppURL;
        result.lifecycleClass = 'SetupConnectedApp';
        result.locations = new List<String>{ 'Aura' };

        return result;
    }


    private List<MetadataService.ConnectedAppAttribute> connectedAppAttributes() {
        MetadataService.ConnectedAppAttribute firstName = new MetadataService.ConnectedAppAttribute();
        firstName.key = 'userFirstName';
        firstName.formula = '$User.FirstName';

        MetadataService.ConnectedAppAttribute lastName = new MetadataService.ConnectedAppAttribute();
        lastName.key = 'userLastName';
        lastName.formula = '$User.LastName';

        MetadataService.ConnectedAppAttribute email = new MetadataService.ConnectedAppAttribute();
        email.key = 'userEmail';
        email.formula = '$User.Email';

        MetadataService.ConnectedAppAttribute profile = new MetadataService.ConnectedAppAttribute();
        profile.key = 'userProfile';
        profile.formula = '$Profile.Name';

        MetadataService.ConnectedAppAttribute role = new MetadataService.ConnectedAppAttribute();
        role.key = 'role';
        role.formula = '"Administrator,User"';

        return new List<MetadataService.ConnectedAppAttribute>{ firstName, lastName, email, profile, role };
    }
}