# Testing Hasura GraphQL APIs with Karate

A sample for how to run automated Karate tests (https://github.com/intuit/karate) against a GraphQL API (Hasura).

This is the associated repo for the blog post which can be found here:

https://hasura.io/blog/testing-hasura-graphql-apis-with-karate/

### First load up your sample Hasura API:
```
docker-compose up hasura db
```


### And then run tests with:
```
docker-compose up karate
```