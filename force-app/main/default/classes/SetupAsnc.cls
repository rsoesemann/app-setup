public with sharing class SetupAsnc extends SetupStep.ForBatch {

	public override void execute() {

	}


	public override ApexPages.Message getStatus() {
		Integer count = [SELECT COUNT() FROM Account WHERE BillingCountry = 'Germany' LIMIT 1];
		ApexPages.Severity severity = (count == 0) ? ApexPages.Severity.CONFIRM : ApexPages.Severity.INFO;

		return new ApexPages.Message(severity, count + ' German Accounts need to be prepared for DSVGO.');
	}
}