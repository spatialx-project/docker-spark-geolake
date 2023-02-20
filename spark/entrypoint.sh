#!/bin/bash

/opt/spark/sbin/start-master.sh -p 7077
/opt/spark/sbin/start-worker.sh spark://spark-iceberg:7077
/opt/spark/sbin/start-history-server.sh
/opt/spark/sbin/start-thriftserver.sh

# Entrypoint, for example notebook, pyspark or spark-sql
if [[ $# -gt 0 ]] ; then
    eval "$1"
fi