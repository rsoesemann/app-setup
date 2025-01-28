public with sharing class SetupPageCtrl extends SetupCtrl {

    public static final String DEV_NAME = 'Integration';

    public SetupUsingBatch batch { get; private set; }


    // CONSTRUCTOR

    public SetupPageCtrl() {
        batch = new SetupUsingBatch();
    }

    
    // PUBLIC

    public override List<SetupStep> steps() {
        return new List<SetupStep>{ batch };
    }
}