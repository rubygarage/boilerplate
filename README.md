# Boilerplate Rails API

## Boilerplate features

### Handling JSON API URI query with Trailblazer nested operations

| Operation | Description | HTTP request example |
| --- | --- | --- |
| ```Api::V1::Lib::Operation::Filtering``` | Provides JSON API filtering with ```all_filters``` as default matcher | ```GET /users?filter[email-eq]=user@email.com&filter[name-cont]=son&match=any_filters``` |
| ```Api::V1::Lib::Operation::Sorting``` | Provides JSON API sorting | ```GET /users?sort=name,-age``` |
| ```Api::V1::Lib::Operation::Inclusion``` | Provides JSON API inclusion of related resources. Dot-separated relationship path supporting not implemented at this time | ```GET /users?include=team,organization``` |
| ```Api::V1::Lib::Operation::Pagination``` | Provides JSON API pagination with offset strategy. Accepts ```AciveRelation``` or ```Array``` as collection. By default returns 25 items per page | ```GET /users?page[number]=1&page[size]=1``` |

### Trailblazer macroses

| Macros | Description |
| --- | --- |
| ```Macro::Assign``` | Provides to assign into context value from other context/context chains |
| ```Macro::Model``` | Provides to assign model into context. Supports assign by relation chain, relation find_by |
| ```Macro::ModelDelete``` | Provides to delete model |
| ```Macro::ModelDestroy``` | Provides to destroy model |
| ```Macro::ModelDecorator``` | Provides to decorate model with specified decorator. Supports object or collection as model |
| ```Macro::LinksBuilder``` | Provides to proxy resource path to ```Service::JsonApi::Paginator``` and sets composed links into context |
| ```Macro::Renderer``` | Provides to render operation result with specified serializer with strict following Jsonapi specification |
| ```Macro::Contract::Schema``` | Provides to use ```Dry::Validation.Schema``` as operation contract |
| ```Macro::Semantic``` | Provides to set value of semantic marker (```semantic_success``` or ```semantic_failure```) into context |
| ```Macro::AddContractError``` | Provides to set custom error to namespaced contract) |

### Services

| Service | Description |
| --- | --- |
| ```Service::Pagy``` | Wrapes active record collection / array into ```Pagy``` |
| ```Service::JsonApi::Paginator``` | Buildes pagination links with ```Pagy``` |
| ```Service::JsonApi::ResourceSerializer``` | ```FastJson``` serializer factory |
| ```Service::JsonApi::ResourceErrorSerializer``` | Resource error serializer service with strict following Jsonapi specification |
| ```Service::JsonApi::HashErrorSerializer``` | Hash error serializer service with strict following Jsonapi specification |
| ```Service::JsonApi::UriQueryErrorSerializer``` | URI query error serializer service with strict following Jsonapi specification |
| ```Api::V1::Lib::Service::JsonApi::ColumnsBuilder``` | Auxiliary service for performing validation dependencies for filtering/sorting operations. Build collection with ```Api::V1::Lib::Service::JsonApi::Column``` instances |

### Constants

| Constant | Description |
| --- | --- |
| ```JsonApi::Filtering::PREDICATES``` | Available JSON API filter predicates by column type |
| ```JsonApi::Filtering::OPERATORS``` | Available JSON API filter matchers |
| ```JsonApi::Pagination::MINIMAL_VALUE``` | Pagination per page configuration |
| ```Constants::TokenNamespace::SESSION``` | Session JWT token namespace |
| ```Constants::TokenNamespace::RESET_PASSWORD``` | Reset password JWT token namespace |

### Application base classes

| Class | Description |
| --- | --- |
| ```ApplicationEndpoint``` | Base class that responsible for handling statuses of HTTP-responses, works with DefaultEndpoint concern |
| ```ApiController``` | Base application controller class that available for unauthorized users |
| ```ApplicationOperation``` | Base application operation class |
| ```ApplicationContract``` | Base application contract class. Use it for build/update entity. Otherwise use ```Dry::Validation.Schema``` |
| ```ApplicationSerializer``` | Base application serializer class |
| ```ApplicationWorker``` | Base application worker class |


## Docker

Install [docker and docker-compose](https://docs.docker.com/compose/install/)
```
sudo apt-get install docker docker-compose
```

### Run the project

```
docker-compose up
```

### Running the tests

```
bin/docker rspec
```

### Building API documentation

Building api documentation is pretty easy, just run:

```
bin/docker rails api:doc:v1
```

and find it into:

```
./public/api/docs/v1/index.html
```

### Running Rails console

```
bin/docker rails c
```

### Running linters

```
overcommit -r
```
