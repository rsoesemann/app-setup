public with sharing class MigrateFieldStep extends BatchSetupStep {

	private Integer migrated = 0;

	// PUBLIC

	public override ApexPages.Message getStatus() {
		ApexPages.Message result = super.getStatus();

		if(result == null) {
			Integer toMigrate = [SELECT Count() FROM Account WHERE NewEqualsNewField__c = FALSE];
			ApexPages.Severity severity = (toMigrate > 0) ? ApexPages.Severity.WARNING : ApexPages.Severity.CONFIRM;
			String message = toMigrate + ' Accounts need to be migrated (via batch job).';
			result = new ApexPages.Message(severity, message);
		}

		return result;
	}


	public List<SObject> start(Database.BatchableContext ctx) {
		FeatureManagement.setPackageIntegerValue('TotalRecordsToMigrate', [SELECT Count() FROM Account WHERE NewEqualsNewField__c = FALSE]);
		return [SELECT OldField__c, NewField__c 
				FROM Account 
				WHERE NewEqualsNewField__c = FALSE
				WITH SYSTEM_MODE 
				FOR UPDATE ];
	}


	public void execute(Database.BatchableContext ctx, List<SObject> scope) {
		for(Account account : (List<Account>) scope) {
			account.NewField__c = account.OldField__c;
		}

		update scope;
		migrated += scope.size();
		FeatureManagement.setPackageIntegerValue('TotalRecordsMigrated',migrated);
	}


	public void finish(Database.BatchableContext ctx) { 
		// Note: Set it again to see if during migration new records might have been created.
		FeatureManagement.setPackageIntegerValue('TotalRecordsToMigrate', [SELECT Count() FROM Account]);
	}
}