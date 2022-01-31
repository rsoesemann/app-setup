public with sharing class SetupUsingBatch extends BatchSetupStep {

	// PUBLIC

	public override ApexPages.Message getStatus() {
		ApexPages.Message result = super.getStatus();

		if(result == null) {
			Integer toMigrate = [SELECT Count() FROM Account];
			ApexPages.Severity severity = (toMigrate > 0) ? ApexPages.Severity.WARNING : ApexPages.Severity.CONFIRM;
			String message = toMigrate + ' Accounts need to be migrated (via batch job).';
			result = new ApexPages.Message(severity, message);
		}

		return result;
	}


	public List<SObject> start(Database.BatchableContext ctx) {
		return [SELECT Id FROM ApexClass];
	}


	public void execute(Database.BatchableContext ctx, List<SObject> scope) {
		for(Integer i=0; i<100000000; i++) {
			Integer a = i*i;
		}
	}


	public void finish(Database.BatchableContext ctx) { }
}