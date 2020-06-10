public with sharing class SetupNamedCredential extends SetupStep {

	public String apiEndpoint { get; set; }
	public List<NamedCredential> namedCredential { get; private set; }


	// PUBLIC

	public override ApexPages.Message getStatus() {
		namedCredential = [SELECT Endpoint FROM NamedCredential WHERE DeveloperName = 'MyAppBackend' LIMIT 1];

		if(namedCredential.isEmpty()) {
			return new ApexPages.Message(ApexPages.Severity.WARNING,
					'A Named Credential needs to be set up for My App to connect with its Backend.');
		}
		else {
			apiEndpoint = namedCredential[0].Endpoint;
        
			return new ApexPages.Message(ApexPages.Severity.CONFIRM, setupLink(namedCredential) + ' was created successfully.');
		}
	}


	public override String buttonLabel() {
		return 'Execute';
	}


	public override PageReference run() {
		MetadataService.NamedCredential cred = new MetadataService.NamedCredential();
		cred.fullName = 'MyAppBackend';
		cred.label = 'My App Backend';
		cred.generateAuthorizationHeader = true;
		cred.oauthScope = 'api refresh_token';
		cred.principalType = 'NamedUser';
		cred.protocol = 'NoAuthentication';
		cred.endpoint = apiEndpoint.trim() + 'backend/api';

		create(new List<MetadataService.Metadata>{ cred });

		return currentPage();
	}
}