[![CI](https://github.com/mcascallares/confluent-data-contracts/actions/workflows/run.yml/badge.svg)](https://github.com/mcascallares/confluent-data-contracts/actions/workflows/run.yml)

# Confluent Data Contracts

This repo shows Confluent Data Contracts in action, following the instructions detailed in 
[this blog post](https://www.confluent.io/en-gb/blog/data-contracts-confluent-schema-registry/)


## Requirements

- Docker (latest versions bundled with former Docker Compose)
- kafka-avro-console-producer CLI
- kafka-avro-console-consumer CLI
- jq CLI for some formatting


## Start the environment

```
docker compose up -d
```


## Check the logs

```
docker compose logs -f
```

## Register a plain vanilla schema

```
jq -n --rawfile schema order.avsc '{schema: $schema}' | 
  curl -s http://localhost:8081/subjects/orders-value/versions \
  --header "Content-Type: application/json" --header "Accept: application/json" \
  --data @-
```

## Enhancing the data contract with metadata

```
curl -s http://localhost:8081/subjects/orders-value/versions \
  --header "Content-Type: application/json" --header "Accept: application/json" \
  --data "@order_metadata.json"
```

## Adding data quality rules to the data contract

```
curl -s http://localhost:8081/subjects/orders-value/versions \
  --header "Content-Type: application/json" --header "Accept: application/json" \
  --data @order_ruleset.json
```


## Disabling a rule

```
curl -s http://localhost:8081/subjects/orders-value/versions \
  --header "Content-Type: application/json" --header "Accept: application/json" \
  --data @order_ruleset_disabled.json
```


## Client applications

From the output, of the previous commands, we capture the ID of the schema we want to use.

Assumming that the last evolution was registered with ID = 3, we can start consumers and 
producers respectively


```
kafka-avro-console-consumer \
  --topic orders \
  --bootstrap-server localhost:9092
```

For the producer we specify the ID=3, if your ID is different, update it accordingly

```
kafka-avro-console-producer \
  --topic orders \
  --broker-list localhost:9092 \
  --property value.schema.id=3
{"orderId": 1, "customerId": 2, "totalPriceCents": 12000, "state": "Pending", "timestamp": 1693591356 }
```

## Shutdown and destroy the environment

```
docker compose down -v
```
