public with sharing class MigrateStep extends SetupStep {
      
    public override ApexPages.Message getStatus() {
		return new ApexPages.Message(ApexPages.Severity.ERROR, 'message');
	}

    public override String buttonLabel() {
		return 'Run';
	}

	public override PageReference run() {
		return null;
	}
}