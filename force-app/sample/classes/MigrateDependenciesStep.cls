public with sharing class MigrateDependenciesStep extends SetupStep {

	public List<Metadata> dependencies { get; private set; }

    
    public override ApexPages.Message getStatus() {
        String query ='SELECT MetadataComponentName, MetadataComponentType, RefMetadataComponentName, RefMetadataComponentType ' +
                       'FROM MetadataComponentDependency ' +
                       'WHERE MetadataComponentName = "Account.OldField__c" AND MetadataComponentType = "CustomField"';
 
        dependencies = toolingApiQuery(query);

		if(dependencies.isEmpty()) {
			return new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Great! There are no local dependencies on the deprecated field.');
		} else {
			return new ApexPages.Message(ApexPages.Severity.WARNING, 'Please remove or migrate the following local dependencies on the deprecated field.');
		}
	}

    public override String buttonLabel() {
		return 'n/a';
	}

	public override PageReference run() {
		return null;
	}
}