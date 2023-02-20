# Spark + Geolake Quickstart Image

This is a dokcer environment to quickly get up a geolake service with

-  a JDBC catalog (Postgres)
-  a computing engine(Spark 3.3)
-  a storage backend(local file system)


Geolake is built on top of [Apache Iceberg](https://iceberg.apache.org/), this project was also borrowed from [docker-spark-iceberg](https://github.com/tabular-io/docker-spark-iceberg).

## Start

```shell
docker compose up
```

Open (http://localhost:8888)[http://localhost:8888] in browser.

