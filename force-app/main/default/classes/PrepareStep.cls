public with sharing class PrepareStep extends SetupStep {
    
    public override ApexPages.Message getStatus() {
		return new ApexPages.Message(ApexPages.Severity.CONFIRM, 'message');
	}

    public override String buttonLabel() {
		return 'Run';
	}

	public override PageReference run() {
		return null;
	}
}