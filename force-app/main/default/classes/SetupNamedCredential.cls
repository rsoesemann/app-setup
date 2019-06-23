public with sharing class SetupNamedCredential extends SetupStep {

	public String apiEndpoint { get; set; }


	// PUBLIC

	public List<NamedCredential> namedCredential {
		get {
			List<NamedCredential> namedCredential = [SELECT Endpoint FROM NamedCredential WHERE DeveloperName = 'A360Backend' LIMIT 1];
			if(!namedCredential.isEmpty()) {
				apiEndpoint = namedCredential[0].Endpoint;
			}
			return namedCredential;
		}
		private set;
	}


	public override ApexPages.Message getStatus() {
		ApexPages.Severity severity = (namedCredential.isEmpty()) ? ApexPages.Severity.WARNING : ApexPages.Severity.CONFIRM;
		return new ApexPages.Message(severity, 'A Named Credential is needed for My App to connect with its API.');
	}


	public override String buttonLabel() {
		return 'Execute';
	}


	public override PageReference run() {
		if(namedCredential.isEmpty()) {
			MetadataService.NamedCredential cred = new MetadataService.NamedCredential();
			cred.fullName = 'A360Backend';
			cred.label = 'A360 Backend';
			cred.allowMergeFieldsInBody = false;
			cred.allowMergeFieldsInHeader = true;
			cred.generateAuthorizationHeader = true;
			cred.oauthScope = 'namedCredential refresh_token';
			cred.principalType = 'NamedUser';
			cred.protocol = 'Oauth';

			cred.endpoint = apiEndpoint.trim();

			create(new List<MetadataService.Metadata>{ cred });
		}

		return null;
	}
}