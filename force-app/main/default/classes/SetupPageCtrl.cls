public with sharing class SetupPageCtrl extends SetupCtrl {

    public static final String DEV_NAME = 'Integration';

    public SetupBackendConnection connection { get; private set; }
    public SetupConnectedApp connectedApp { get; private set; }
    public SetupUsingBatch batch { get; private set; }
    public SetupRemoveDeprecated deprecated { get; private set; }


    // CONSTRUCTOR

    public SetupPageCtrl() {
        connection = new SetupBackendConnection();
        connectedApp = new SetupConnectedApp();
        batch = new SetupUsingBatch();
        deprecated = new SetupRemoveDeprecated();
    }

    
    // PUBLIC

    public override List<SetupStep> steps() {
        return new List<SetupStep>{ connection, connectedApp, batch, deprecated };
    }
}