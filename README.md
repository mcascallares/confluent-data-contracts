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
  curl http://localhost:8081/subjects/orders-value/versions --json @-
```

## Enhancing the data contract with metadata

```
curl http://localhost:8081/subjects/orders-value/versions \
  --json @order_metadata.json
```

## Adding data quality rules to the data contract

```
curl http://localhost:8081/subjects/orders-value/versions \
  --json @order_ruleset.json
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
```

## Shutdown and destroy the environment

```
docker compose down -v
```
