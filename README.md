# Boilerplate Rails API

This README would normally document whatever steps are necessary to get the application up and running.

### Boilerplate features

#### Handling JSON API URI query with Trailblazer nested operations

| Operation | Description | HTTP request example |
| --- | --- | --- |
| ```Api::V1::Lib::Operation::Sorting``` | JSON API sorting | ```GET /users?sort=name,-age``` |
| ```Api::V1::Lib::Operation::Pagination``` | JSON API pagination with offset strategy. Accepts ```AciveRelation``` or ```Array``` as collection | ```GET /users?page[number]=1&page[size]=1``` |
| ```Api::V1::Lib::Operation::Inclusion``` | JSON API inclusion of related resources. Dot-separated relationship path supporting not implemented at this time | ```GET /users?include=team,organization``` |

#### Trailblazer macroses

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

#### Services

| Service | Description |
| --- | --- |
| ```Service::Pagy``` | Wrapes active record or elastic collection into ```Pagy``` |
| ```Service::JsonApi::Paginator``` | Buildes pagination links with ```Pagy``` |
| ```Service::JsonApi::ResourceSerializer``` | ```FastJson``` serializer factory |
| ```Service::JsonApi::ResourceErrorSerializer``` | Resource error serializer service with strict following Jsonapi specification |
| ```Service::JsonApi::UriQueryErrorSerializer``` | URI query error serializer service with strict following Jsonapi specification |


### Docker

Install [docker and docker-compose](https://docs.docker.com/compose/install/)
```
sudo apt-get install docker docker-compose
```

#### Run the project

```
docker-compose up
```

#### Running the tests

```
bin/docker rspec
```

#### Building API documentation

Please note, documentation building task requires an installed Aglio. So you should install it before:

```
sudo npm install --unsafe-perm --verbose -g aglio
```

Then you can build api documentation:

```
bin/docker rails api:doc:v1
```

and find it into:

```
./public/api/docs/v1
```

#### Running Rails console

```
bin/docker rails c
```

#### Running linters

```
overcommit -r
```
