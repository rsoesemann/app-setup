@IsTest
@TestVisible
private class ToolingApiMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setBody('{"size":1,"totalSize":1,"done":true,"queryLocator":null,"entityTypeName":"RemoteProxy","records":[{"attributes":{"type":"RemoteProxy","url":"/services/data/v45.0/tooling/sobjects/RemoteProxy/0rp6E0000005GBOQA2"},"EndpointUrl":"https://www.spiegel.de"}]}');
        res.setStatusCode(200);
        return res;
    }
}