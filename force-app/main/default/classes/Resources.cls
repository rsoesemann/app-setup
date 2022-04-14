public class Resources extends ffhttp_AbstractJsonSerializable implements ffhttp_IDeserialize {

    private String type;
    private List<Resource> resources = new List<Resource>();


    // CTORS

    public Resources(String type) {
        this.type = type;
    }


    // PUBLIC

    public Resources resources(List<Resource> resources) {
        this.resources = resources;
        return this;
    }


    // PUBLIC

    public List<Resource> get() {
        return resources;
    }


    public override String serialize() {
        List<Map<String, Object>> raw = new List<Map<String, Object>>();

        for(Resource resource : resources) {
            raw.add(resource.properties);
        }

        String result = JSON.serialize(raw, true);
        return result;
    }


    public Object deserialize(String jsonString) {
        for(Object properties : (List<Object>) JSON.deserializeUntyped(jsonString)) {
            // Note: type is known as such Deserializers are constructed using ctor(type)
            Resource resource = new Resource(type);
            resource.properties = (Map<String, Object>) properties;

            resources.add(resource);
        }

        return this;
    }
}