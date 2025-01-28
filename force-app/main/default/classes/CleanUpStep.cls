public with sharing class CleanUpStep extends SetupStep {
   
    public override ApexPages.Message getStatus() {
		return new ApexPages.Message(ApexPages.Severity.INFO, 'message');
	}

    public override String buttonLabel() {
		return 'Run';
	}

	public override PageReference run() {
		return null;
	}
}