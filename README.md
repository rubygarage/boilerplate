# Boilerplate Rails API

## Boilerplate features

Project wiki: https://github.com/rubygarage/boilerplate/wiki

### Handling JSON API URI query with Trailblazer nested operations

| Operation | Description | HTTP request example |
| --- | --- | --- |
| ```Api::V1::Lib::Operation::Filtering``` | Sets JSON API filtering with ```all_filters``` as default matcher | ```GET /users?filter[email-eq]=user@email.com&filter[name-cont]=son&match=any_filters``` |
| ```Api::V1::Lib::Operation::PerformFiltering``` | Provides JSON API filtering with ```ctx[:filter_options]``` options | ```GET /users?filter[email-eq]=user@email.com&filter[name-cont]=son&match=any_filters``` |
| ```Api::V1::Lib::Operation::Sorting``` | Sets JSON API sorting | ```GET /users?sort=name,-age``` |
| ```Api::V1::Lib::Operation::PerformOrdering``` | Provides JSON API sorting | ```GET /users?sort=name,-age``` |
| ```Api::V1::Lib::Operation::Inclusion``` | Provides JSON API inclusion of related resources. Dot-separated relationship path supporting not implemented at this time | ```GET /users?include=team,organization``` |
| ```Api::V1::Lib::Operation::Pagination``` | Provides JSON API pagination with offset strategy. Accepts ```AciveRelation``` or ```Array``` as collection. By default returns 25 items per page | ```GET /users?page[number]=1&page[size]=1``` |

### Trailblazer macroses

| Macros | Description |
| --- | --- |
| ```Macro::Assign``` | Provides to assign into context value from other context/context chains |
| ```Macro::AddContractError``` | Provides to set custom error to namespaced contract |
| ```Macro::Contract::Schema``` | Provides to use ```Dry::Validation.Schema``` as operation contract |
| ```Macro::Decorate``` | Provides to decorate ctx object with specified decorator. Supports object or collection as model |
| ```Macro::Inject``` | Provides to set dependency injection in operations |
| ```Macro::LinksBuilder``` | Provides to proxy resource path to ```Service::JsonApi::Paginator``` and sets composed links into context |
| ```Macro::Model``` | Provides to assign model into context. Supports assign by relation chain, relation find_by |
| ```Macro::ModelRemove``` | Provides to destroy and delete model. |
| ```Macro::Renderer``` | Provides to render operation result with specified serializer with strict following Jsonapi specification |
| ```Macro::Semantic``` | Provides to set value of semantic marker (```semantic_success``` or ```semantic_failure```) into context |
| ```Macro::Policy``` | Set semantic marker ```semantic_failure``` to equel ```:forbidden``` and add errors if no policy|

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
| ```ApplicationDecorator``` | Base application decorator class |
| ```ApplicationSerializer``` | Base application serializer class |
| ```ApplicationWorker``` | Base application worker class |

### Upload files

Boilerplate used `Shrine` for upload files local and to S3.
Create you own uploader and inherit it from `ApplicationUploader`.
For more [info](https://shrinerb.com/docs/getting-started)

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
Generate a request spec file:
```
rails generate rspec:swagger API::MyController
```
Building api documentation is pretty easy, just run:

```
rake rswag
```

and find it into:

```
./api-docs/index.html
```

### Running Rails console

```
bin/docker rails c
```

### Running linters

```
lefthook run all
```

### Using DIP

You can develop you application with `DIP`([more info](https://github.com/bibendi/dip))

For running services with docker.

```
dip run `the name of service`
```

Launch application with all services.
```
dip provision
```

List all available run commands.
```
dip ls
```
### Sentry Notifire

To start work with sentry you should add dsn key to credentials under `sentry_dsn` name.

To get first error with `Sentry` raise `Raven.capture_exception` with exception as an argument.

More information [here](https://docs.sentry.io/platforms/ruby/guides/rails/)

### Password complexity for User

Must contain at least 8 characters, of which: At list one upper case, at list one lowe case,

at list one number, at list one special symbols from the list: `-_!@#$%^&*`.

For example: `qwertY1@`
