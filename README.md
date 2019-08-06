# Boilerplate Rails API

This README would normally document whatever steps are necessary to get the application up and running.

**Trailblazer macroses**

| Macros | Description |
| --- | --- |
| ```Macro::Assign``` | Provides to assign into context value from other context/context chains |
| ```Macro::Model``` | Provides to assign model into context. Supports assign by relation chain, relation find_by|
| ```Macro::ModelDelete``` | Provides to delete model |
| ```Macro::ModelDestroy``` | Provides to destroy model |
| ```Macro::ModelDecorator``` | Provides to decorate model with specified decorator. Supports object or collection as model |
| ```Macro::LinksBuilder``` | Provides to proxy resource path to ```Service::Jsonapi::Paginator``` and sets composed links into context |
| ```Macro::Renderer``` | Provides to render operation result with specified serializer with strict following Jsonapi specification |
| ```Macro::Contract::Schema``` | Provides to use ```Dry::Validation.Schema``` as operation contract |
| ```Macro::Semantic``` | Provides to set value of semantic marker (```semantic_success``` or ```semantic_failure```) into context |

**Services**

| Service | Description |
| --- | --- |
| ```Service::Pagy``` | Wrapes active record or elastic collection into ```Pagy``` |
| ```Service::Jsonapi::Paginator``` | Buildes pagination links with ```Pagy``` |
| ```Service::Jsonapi::ResourceSerializer``` | ```FastJson``` serializer factory |
| ```Service::Jsonapi::ResourceErrorSerializer``` | Resource error serializer service with strict following Jsonapi specification |
| ```Service::Jsonapi::UriQueryErrorSerializer``` | URI query error serializer service with strict following Jsonapi specification |
