@TestVisible
@IsTest
private class MdApiMock implements WebServiceMock {
    public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint,
                        String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        MetadataService.createMetadataResponse_element responseElement = new MetadataService.createMetadataResponse_element();

        MetadataService.SaveResult sr = new MetadataService.SaveResult();
        sr.success = true;

        responseElement.result = new List<MetadataService.SaveResult>{ sr };
        response.put('response_x', responseElement);
    }
}