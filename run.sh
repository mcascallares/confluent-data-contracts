#!/bin/sh

echo "Register a plain vanilla schema"
jq -n --rawfile schema order.avsc '{schema: $schema}' | curl http://localhost:8081/subjects/orders-value/versions --header 'Content-Type: application/json' --header 'Accept: application/json' --data @-      

echo "\n\nEnhancing the data contract with metadata"
curl http://schema-registry:8081/subjects/orders-value/versions --header 'Content-Type: application/json' --header 'Accept: application/json' --data @order_metadata.json

echo "\n\nAdding data quality rules to the data contract"
curl http://schema-registry:8081/subjects/orders-value/versions --header 'Content-Type: application/json' --header 'Accept: application/json' --data @order_ruleset.json

echo "\n\nDisabling a rule"
curl http://schema-registry:8081/subjects/orders-value/versions --header 'Content-Type: application/json' --header 'Accept: application/json' --data @order_ruleset_disabled.json