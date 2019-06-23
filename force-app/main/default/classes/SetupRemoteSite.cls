public with sharing class SetupRemoteSite extends SetupStep {

	private static final String ENDPOINT_URL = 'http://www.my-app.com/api';

	// PUBLIC

	public override ApexPages.Message getStatus() {
		ApexPages.Severity severity = (siteExists()) ? ApexPages.Severity.CONFIRM : ApexPages.Severity.WARNING;
		return new ApexPages.Message(severity, 'A Remote Site Setting is required to run My App.');
	}


	public override String buttonLabel() {
		return 'Execute';
	}


	public override PageReference run() {
		MetadataService.RemoteSiteSetting site = new MetadataService.RemoteSiteSetting();
		site.fullName = 'A360Integration';
		site.isActive = true;
		site.disableProtocolSecurity = false;
		site.url = ENDPOINT_URL;

		create(new List<MetadataService.Metadata>{ site });

		return null;
	}


	// PRIVATE

	private Boolean siteExists() {
		HttpRequest request = new HttpRequest();
		request.setEndpoint(URL.getOrgDomainUrl().toExternalForm() + '/services/data/v45.0/tooling/query?q=SELECT+Id+from+RemoteProxy+WHERE+EndpointUrl=%27' + ENDPOINT_URL + '%27');
		request.setMethod('GET');
		request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
		request.setHeader('Content-Type', 'application/json');

		return Pattern.matches('(?<=EndpointUrl":")(.+(?="))', new Http().send(request).getBody());
	}
}