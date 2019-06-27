public with sharing class SetupCtrl {

    public SetupNamedCredential connection { get; private set; }
    public SetupUsingBatch migrate { get; private set; }


    // CONSTRUCTOR

    public SetupCtrl() {
        connection = new SetupNamedCredential();
        migrate = new SetupUsingBatch();
    }
}