#!/bin/bash

METADATA_FILE="/hasura/metadata.json"
HASURA_ENDPOINT="http://localhost:8080/v1/metadata"
METADATA_CONTENT=$(cat $METADATA_FILE)

JSON_PAYLOAD=$(cat <<EOF
{
    "type" : "replace_metadata",
    "version": 2,
    "args": $METADATA_CONTENT
}
EOF
)

curl -X POST $HASURA_ENDPOINT \
     -H "Content-Type: application/json" \
     -H "x-hasura-role: admin" \
     -H "x-hasura-admin-secret: admin_secret_for_testing" \
     -d "$JSON_PAYLOAD"