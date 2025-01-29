public with sharing class MigrateDependenciesStep extends SetupStep {

	public List<ToolingApiRecord> dependencies { get; private set; }

    
    public override ApexPages.Message getStatus() {
		List<ToolingApiRecord> response = toolingApiQuery('SELECT Id  FROM CustomField WHERE TableEnumOrId = \'Account\' AND DeveloperName = \'OldField\'');
        dependencies = toolingApiQuery('SELECT MetadataComponentId, MetadataComponentName, MetadataComponentType FROM MetadataComponentDependency WHERE RefMetadataComponentId = \'' + response[0].Id + '\'');

		if(dependencies.isEmpty()) {
			return new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Great! There are no local dependencies on the deprecated field.');
		} else {
			return new ApexPages.Message(ApexPages.Severity.ERROR, 'Please remove or migrate the following local dependencies on the deprecated field.');
		}
	}

    public override String buttonLabel() {
		return null;
	}

	public override PageReference run() {
		return null;
	}

	// PRIVATE

	// Note: Tooling API with Session Id allowed by Salesforce without Named Cred
	@SuppressWarnings('PMD.ApexSuggestUsingNamedCred')
	private List<ToolingApiRecord> toolingApiQuery(String query) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL.getOrgDomainUrl().toExternalForm() + '/services/data/v62.0/tooling/query?q=' +  query.replace(' ', '+'));
        request.setMethod('GET');
        request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json');

        ToolingApiResponse result = (ToolingApiResponse) JSON.deserialize( new Http().send(request).getBody(), ToolingApiResponse.class);
		return result.records;
    }


    // INNER

    public class ToolingApiResponse {
        public List<ToolingApiRecord> records;
    }


	// Note: Names need to match ToolingAPI response
    @SuppressWarnings('PMD.FieldNamingConventions')
	public class ToolingApiRecord {
        public String MetadataComponentId  { get; private set; }
        public String MetadataComponentName  { get; private set; }
		public String MetadataComponentType  { get; private set; }
		public String Id  { get; private set; }
    }
}