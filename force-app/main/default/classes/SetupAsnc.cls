public with sharing class SetupAsnc extends SetupStep.ForBatch implements Database.Batchable<Account> {

	private List<Account> toMigrate;


	// PUBLIC

	public override ApexPages.Message getStatus() {
		toMigrate = [SELECT Id FROM Account];
		ApexPages.Severity severity = (toMigrate.isEmpty()) ? ApexPages.Severity.CONFIRM : ApexPages.Severity.WARNING;
		String message = toMigrate.size() + ' Accounts need to be migrated (via batch job).';
		return new ApexPages.Message(severity, message);
	}


	public override void execute() {
		if(Test.isRunningTest()) {
			execute(null, start(null));
			finish(null);
		}
		else {
			Database.executeBatch(this);
		}
	}


	public List<Account> start(Database.BatchableContext ctx) {
		return toMigrate;
	}


	public void execute(Database.BatchableContext ctx, List<SObject> accounts) {
		update accounts;
	}


	public void finish(Database.BatchableContext ctx) { }

}