# Boilerplate Rails RESTful JSON API

This API is implemented according to the [JSON API spec v1.1](https://jsonapi.org/format/1.1/)

## Filtering
**Description:** JSON API filtering with `all_filters` as default matcher.

**URI example:** `GET /users?filter[email-eq]=user@email.com&filter[name-cont]=son&match=any_filters`

## Sorting
**Description:** JSON API sorting.

**URI example:** `GET /users?sort=name,-age`

## Inclusion
**Description:** JSON API inclusion of related resources. Dot-separated relationship path supporting not implemented at this time.

**URI example:** `GET /users?include=team,organization`

## Pagination
**Description:** JSON API pagination with offset strategy.

**URI example:** `GET /users?page[number]=1&page[size]=1`
