public with sharing class Api extends ffhttp_Client.AbstractClient {

    // CTORS

    public Api() {
        setCredentials( new ffhttp_Client.NamedCredentials(SetupBackendConnection.DEV_NAME) );
    }


    // PUBLIC

    public Resources getThings() {
        return (Resources) get('/things/', new Resources('Things')).execute();
    }


    // PRIVATE

    private Request get(String endpoint, ffhttp_IDeserialize deserializer) {
        return new Request(this, endpoint, ffhttp_Client.REQUEST_METHOD_GET, null, deserializer);
    }


    private Request post(String endpoint, ffhttp_IHttpContent request, ffhttp_IDeserialize deserializer) {
        return new Request(this, endpoint, ffhttp_Client.REQUEST_METHOD_POST, request, deserializer);
    }


    // INNER

    private class Request extends ffhttp_Client.AbstractClientRequest {
        public Request(IAbstractClient client, String endpoint, String requestMethod, ffhttp_IHttpContent httpContent, ffhttp_IDeserialize deserializer) {
            super(client, endpoint, requestMethod, httpContent, deserializer);
        }

        private Request param(String key, Object param) {
            super.addParam(key, param);
            return this;
        }
    }
}