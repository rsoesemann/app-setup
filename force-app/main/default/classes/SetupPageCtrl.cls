public with sharing class SetupPageCtrl extends SetupCtrl {

    public static final String DEV_NAME = 'Integration';

    public SetupNamedCredential credential { get; private set; }
    public SetupConnectedApp connectedApp { get; private set; }
    public SetupUsingBatch batch { get; private set; }


    // CONSTRUCTOR

    public SetupPageCtrl() {
        credential = new SetupNamedCredential();
        connectedApp = new SetupConnectedApp();
        batch = new SetupUsingBatch();
    }

    
    // PUBLIC

    public override List<SetupStep> steps() {
        return new List<SetupStep>{ credential, connectedApp, batch };
    }
}