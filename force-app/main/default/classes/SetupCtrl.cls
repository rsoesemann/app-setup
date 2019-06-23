public with sharing class SetupCtrl {

    public SetupNamedCredential connection { get; private set; }
    public SetupRemoteSite site { get; private set; }
    public SetupAsnc migrate { get; private set; }


    // CONSTRUCTOR

    public SetupCtrl() {
        connection = new SetupNamedCredential();
        site = new SetupRemoteSite();
        migrate = new SetupAsnc();
    }
}