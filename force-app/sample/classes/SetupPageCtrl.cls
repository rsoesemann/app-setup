public with sharing class SetupPageCtrl extends SetupCtrl {

    public MigrateFieldStep migrateStep { get; private set; }
    public MigrateDependenciesStep dependencyStep { get; private set; }
    public RemoveFieldStep removeStep { get; private set; }
    


    // CONSTRUCTOR

    public SetupPageCtrl() {
        migrateStep = new MigrateFieldStep();
        dependencyStep = new MigrateDependenciesStep();
        removeStep = new RemoveFieldStep();
    }

    
    // PUBLIC

    public override List<SetupStep> steps() {
        return new List<SetupStep>{ migrateStep, dependencyStep, removeStep };
    }
}