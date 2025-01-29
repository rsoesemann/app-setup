public with sharing class RemoveFieldStep extends SetupStep {
   
	public override ApexPages.Message getStatus() {
		Boolean fieldExists = Schema.SObjectType.Account.fields.getMap().containsKey('OldField__c');
		
		if(fieldExists) {
			return new ApexPages.Message(ApexPages.Severity.WARNING, 'The custom field still exists and needs to be removed.');
		} else {
			return new ApexPages.Message(ApexPages.Severity.CONFIRM, 'The custom field has been removed and everything is good.');
		}
	}

    public override String buttonLabel() {
		return null;
	}

	public override PageReference run() {
		return null;
	}
}