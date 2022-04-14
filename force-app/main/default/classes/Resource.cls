public class Resource extends ffhttp_AbstractJsonSerializable implements ffhttp_IDeserialize {

    public String type;
    public SObject record;
    public Map<String, Object> properties = new Map<String, Object>();


    // CTORS

    public Resource(String type) {
        this.type = type;
    }


    // PUBLIC

    public Boolean has(String property) {
        return new Property(this, property).exists();
    }


    public Object get(String property) {
        return new Property(this, property).get();
    }


    public void put(String property, Object value) {
        new Property(this, property).set(value);
    }


    public override String serialize() {
        return JSON.serialize(properties, true);
    }


    public Object deserialize(String jsonString) {
        properties = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        return this;
    }


    // PRIVATE

    @TestVisible
    private Resource with(String name, Object value) {
        put(name, value);

        return this;
    }


    // INNER

    private class Property {

        private Map<String, Object> valueMap;
        private String property;


        // CTORS

        public Property(Resource resource, String property) {
            valueMap = resource.properties;

            while(property.contains('.')) {
                String nestedProperty = property.substringBefore('.');

                if(!valueMap.containsKey(nestedProperty)) {
                    valueMap.put(nestedProperty, new Map<String, Object>());
                }
                valueMap = (Map<String, Object>) valueMap.get(nestedProperty);

                property = property.substringAfter('.');
            }

            this.property = property;
        }


        public Object get() {
            return (valueMap == null) ? null : valueMap.get(property);
        }


        public void set(Object value) {
            valueMap.put(property, value);
        }


        public Boolean exists() {
            return (get() != null);
        }
    }
}