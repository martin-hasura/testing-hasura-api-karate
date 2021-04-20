# Testing Hasura GraphQL API's with Karate
 
So you've created your new GraphQL API was Hasura - what's next? 

It'd be a great idea to write some unit tests against your expected queries to make sure everything keeps working in your application as you make changes to your GraphQL API.

There are a few differences between how to test your GraphQL endpoint vs a set of REST endpoints.

The first is what you're querying against. 

REST endpoints will most often times be broken up against a set of endpoints which will return the responses for their equivalent resources.

In GraphQL, you'll be looking at hitting one endpoint (in Hasura's case http://yourapplication.com/v1/graphql) - using a query which will request your selected resources.

This is super-powerful since being able to select resources (especially joined / relationship-based) on the fly increases the speed of development, though also increases the need for unit tests in development and production.

The second change is the response itself. 

In querying REST endpoints a response will usually yield `200 (ok)` response to signify that a request was successful. A lot of the time REST-based tooling will rely on this response specifically.

In contrast, in GraphQL it is possible to have a partial success returning some information, while also return an error other parts. These would be returned as a response of `200` with an `errors` object in the GraphQL JSON response.

While this can be good for granular error logging - it does bring up a few corner cases in testing GraphQL APIs if they are relying too heavily on the REST-like `200 (ok)` response paradigm.

## Karate

In this quick tutorial we're going to be taking a look at using Karate (https://github.com/intuit/karate) which is an open-source test automation suite by Intuit to test our Hasura GraphQL API.

Karate has a ton of features from browser automation for UI testing, to parallel testing, to OCR - we're going to be taking a look at some of the more basic API request / response features, as well as the ability to create some nice Cucumber HTML test reporting.

## Getting Started

To get started, you download our repo from this location:
https://github.com/martin-hasura/testing-hasura-api-karate

Running this command from the directory will bring up your GraphQL API with a sample schema and some dummy data:
```
docker-compose up hasura db
```

## Testing with Karate
We're using the implementation of Docker-izing Karate from Quentin Barlas here: https://github.com/qbarlas/karate-dsl - which is a little more lightweight than the official Karate containers which contain scaffolding for doing browser-based testing in Chrome.

You'll be able to find the main test file we'll be using at: `./karate/tests/testCases.feature` (tip: if you're using VSCode there's actually a Karate extension which will give you some nice code formatting).

### Your First Karate Feature

Once we're in the file you'll notice a number of test cases with commented with descriptions of what each area does in Karate syntax.

```
Feature: Test Hasura Blog Engine GraphQL API

Background:
* url 'http://host.docker.internal:8080/v1/graphql'
```
This will define the name of the Feature we're testing along with the endpoint we'll be testing. For this example we'll just be creating one Feature and will be running five tests.

### Queries and Variables

```
Given def query = read('getPosts.gql')
```
Karate has the ability to read GraphQL requests from files (these are files are found relative to your `.feature` file you're running).

```
And request { query: '#(query)' }

// or

And request { query: '#(query)', variables: '#(variables)' }
```

You can then pass your query object with your request - as well as create variable object(s) to use in your GraphQL requests.

Queries can also be written inline as well, and can use '```' for linebreaks and increased legibility (an example is in the `testCases.feature`).

### Headers

In the examples we'll be passing your headers like the following:

```
And header x-hasura-admin-secret = 'admin_secret_for_testing'
And header x-hasura-role = 'author'
And header x-hasura-user-id = 1
```

This will allow us to test things like emulating our `x-hasura-role` as well as `x-hasura-user-id` to check things like our permissions system setup (for example, we have a test case for *Users Cannot View Draft Posts*).

You can read more about customizing headers for more complicated use cases, such as dynamic headers, here: https://github.com/intuit/karate#managing-headers-ssl-timeouts-and-http-proxy and here: https://github.com/intuit/karate#configure-headers.

### Assertions

We'll also want to actually test for something. Karate has a deep set of assertion functions for checking your responses for the data you're requesting: https://github.com/intuit/karate#payload-assertions

```
* status 200
```

We can start by checking that our response status has returned as `200 (ok)`.

Now, remember earlier on we mentioned that just because a GraphQL response returns `200` doesn't necessarily mean that everything is ok.

```
* match response == "#object"
* match response.errors == '#notpresent'
```

What we're doing here is checking that 1) our response is returned as an object, and 2) our response doesn't have any error object included.

We can then get into testing the actual data which is returned as part of the response, such as:

```
* def postList = response.data.cms_post
* match postList !contains { status : "draft" }
```
The post list doesn't contain any *draft* posts.

```
* def postCount = (response.data.cms_post.length)
* assert postCount >= 1
```
The post list *is greater than 1*.

```
* def return_obj = response.data.delete_cms_post.returning[0]
* match return_obj contains { title: "karate_test" }
```

The return object contains an exact match (in this case to a deleted post).

## Running Your Tests
Finally, we'll run the tests in a Docker container.

First, make sure your API is up and running from the earlier `docker-compose up` - you can then run your test suite with:

```
docker-compose up karate
```

This will output your test results in the `stdout` and create a new  test result HTML report in the `./karate/results` directory of your project.

Happy testing!