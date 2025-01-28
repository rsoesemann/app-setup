public with sharing class SetupPageCtrl extends SetupCtrl {

    public PrepareStep prepare { get; private set; }
    public MigrateStep migrate { get; private set; }
    public CleanUpStep clean { get; private set; }
    


    // CONSTRUCTOR

    public SetupPageCtrl() {
        prepare = new PrepareStep();
        migrate = new MigrateStep();
        clean = new CleanUpStep();
    }

    
    // PUBLIC

    public override List<SetupStep> steps() {
        return new List<SetupStep>{ prepare, migrate, clean };
    }
}