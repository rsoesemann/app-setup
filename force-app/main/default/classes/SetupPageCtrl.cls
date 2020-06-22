public with sharing class SetupPageCtrl extends SetupCtrl {

    public SetupNamedCredential connection { get; private set; }
    public SetupUsingBatch migrate { get; private set; }

    // CONSTRUCTOR

    public SetupPageCtrl() {
        connection = new SetupNamedCredential();
        migrate = new SetupUsingBatch();
    }

    // PUBLIC

    public override List<SetupStep> steps() {
        return new List<SetupStep>{ connection, migrate };
    }
}