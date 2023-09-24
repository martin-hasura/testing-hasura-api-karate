# Testing Hasura GraphQL APIs with Karate

A sample for how to run automated Karate tests (https://github.com/intuit/karate) against a GraphQL API (Hasura).

This is the associated repo for the blog post which can be found here:

https://hasura.io/blog/testing-hasura-graphql-apis-with-karate/

### First load up your sample Hasura API:
```
docker-compose up hasura postgres -d
```

### Then, load your Hasura metadata:
```
docker exec hasura bash -c "chmod +x /hasura/load_metadata.sh && /hasura/load_metadata.sh"
```
This can also be automated by using the `v2.33.4.cli-migrations-v3` image.
You can read more on those here: https://hasura.io/docs/latest/migrations-metadata-seeds/auto-apply-migrations/

### And then run tests with:
```
docker-compose up karate
```