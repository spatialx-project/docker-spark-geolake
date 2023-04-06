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

Open [http://localhost:8888](http://localhost:8888) in browser, there are 2 notebooks inside :

- [geolake-scala-demo](spark/notebooks/geolake-scala-demo.ipynb): shows an example of how to use geolake scala api to read/write data from/to geolake.

- [benchmark-portotaxi](spark/notebooks/benchmark-portotaxi.ipynb): this notebook runs a benchmark on portotaxi dataset which has 1.7M records. You will see the reading/writing performance of the 3 Parquet format(GeoLake Parqeut, GeoParquet, GeoParquet(bbox)) for spatial data. You will also see how the partition reolution parameter affects the performance.

Ports 4041, 4042 and 4043 are also forwarded, so you can access Spark Web UI if necessary.
