# syntax=docker/dockerfile:1
FROM python:3.9-bullseye

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      sudo \
      curl \
      vim \
      unzip \
      openjdk-11-jdk \
      build-essential \
      software-properties-common \
      ssh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Jupyter and other python deps
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Add scala kernel via spylon-kernel
RUN python3 -m spylon_kernel install

# Download and install IJava jupyter kernel
RUN curl https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip -Lo ijava-1.3.0.zip \
  && unzip ijava-1.3.0.zip \
  && python3 install.py --sys-prefix \
  && rm ijava-1.3.0.zip

## Download spark and hadoop dependencies and install

# Optional env variables
ENV SPARK_HOME=${SPARK_HOME:-"/opt/spark"}
ENV HADOOP_HOME=${HADOOP_HOME:-"/opt/hadoop"}
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9.5-src.zip:$PYTHONPATH

RUN mkdir -p ${HADOOP_HOME} && mkdir -p ${SPARK_HOME}
WORKDIR ${SPARK_HOME}

# Download spark
RUN curl https://archive.apache.org/dist/spark/spark-3.3.1/spark-3.3.1-bin-hadoop3.tgz -o spark-3.3.1-bin-hadoop3.tgz \
 && tar xvzf spark-3.3.1-bin-hadoop3.tgz --directory /opt/spark --strip-components 1 \
 && rm -rf spark-3.3.1-bin-hadoop3.tgz

# Download jars dependency
RUN curl 'http://spatialx-datalake-test.oss-cn-beijing.aliyuncs.com/dla/spark/upload/sedona-geolake-extension-3.3_2.12-0.1.1.jar?OSSAccessKeyId=LTAI4GAXzLCYkaLpGu9ZKp4J&Expires=2538985343&Signature=oXsr9RdWUG855D9xkEpp5bkqgvA%3D' -Lo sedona-geolake-extension-3.3_2.12-0.1.1.jar \
    && mv sedona-geolake-extension-3.3_2.12-0.1.1.jar /opt/spark/jars \
    && curl 'http://spatialx-datalake-test.oss-cn-beijing.aliyuncs.com/dla/spark/upload/geolake-spark-runtime-3.3_2.12-1.1.0.jar?OSSAccessKeyId=LTAI4GAXzLCYkaLpGu9ZKp4J&Expires=2538985277&Signature=IER82CD7Z2KVPyOqM%2BK34nQSV9M%3D' -Lo geolake-spark-runtime-3.3_2.12-1.1.0.jar \
    && mv geolake-spark-runtime-3.3_2.12-1.1.0.jar /opt/spark/jars \
    && curl https://repo1.maven.org/maven2/org/wololo/jts2geojson/0.17.0/jts2geojson-0.17.0.jar -Lo jts2geojson-0.17.0.jar \
    && mv jts2geojson-0.17.0.jar /opt/spark/jars \
    && curl https://repo1.maven.org/maven2/org/datasyslab/geotools-wrapper/geotools-24.0/geotools-wrapper-geotools-24.0.jar -Lo geotools-wrapper-geotools-24.0.jar \
    && mv geotools-wrapper-geotools-24.0.jar /opt/spark/jars \
    && curl https://jdbc.postgresql.org/download/postgresql-42.2.24.jar -o postgresql-42.2.24.jar \
    && mv postgresql-42.2.24.jar /opt/spark/jars \
    && curl https://repo1.maven.org/maven2/org/apache/sedona/sedona-viz-3.0_2.12/1.3.1-incubating/sedona-viz-3.0_2.12-1.3.1-incubating.jar -Lo sedona-viz-3.0_2.12-1.3.1-incubating.jar \
    && mv sedona-viz-3.0_2.12-1.3.1-incubating.jar /opt/spark/jars

# RUN curl https://tabular-repository-public.s3.amazonaws.com/releases/io/tabular/tabular-client-runtime/0.40.0/tabular-client-runtime-0.40.0.jar -Lo tabular-client-runtime-0.40.0.jar \
#  && mv tabular-client-runtime-0.40.0.jar /opt/spark/jars

# Download Java AWS SDK
# RUN curl https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/2.17.257/bundle-2.17.257.jar -Lo bundle-2.17.257.jar \
#  && mv bundle-2.17.257.jar /opt/spark/jars

# Download URL connection client required for S3FileIO
# RUN curl https://repo1.maven.org/maven2/software/amazon/awssdk/url-connection-client/2.17.257/url-connection-client-2.17.257.jar -Lo url-connection-client-2.17.257.jar \
#  && mv url-connection-client-2.17.257.jar /opt/spark/jars

# Install AWS CLI
# RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
#  && unzip awscliv2.zip \
#  && sudo ./aws/install \
#  && rm awscliv2.zip \
#  && rm -rf aws/

# Add iceberg spark runtime jar to IJava classpath
ENV IJAVA_CLASSPATH=/opt/spark/jars/*

RUN mkdir -p /home/iceberg/localwarehouse /home/iceberg/notebooks /home/iceberg/warehouse /home/iceberg/spark-events /home/iceberg /home/iceberg/data

# Add a notebook command
RUN echo '#! /bin/sh' >> /bin/notebook \
 && echo 'export PYSPARK_DRIVER_PYTHON=jupyter-notebook' >> /bin/notebook \
 && echo "export PYSPARK_DRIVER_PYTHON_OPTS=\"--notebook-dir=/home/iceberg/notebooks --ip='*' --NotebookApp.token='' --NotebookApp.password='' --port=8888 --no-browser --allow-root\"" >> /bin/notebook \
 && echo "pyspark" >> /bin/notebook \
 && chmod u+x /bin/notebook

# Add a pyspark-notebook command (alias for notebook command for backwards-compatibility)
RUN echo '#! /bin/sh' >> /bin/pyspark-notebook \
 && echo 'export PYSPARK_DRIVER_PYTHON=jupyter-notebook' >> /bin/pyspark-notebook \
 && echo "export PYSPARK_DRIVER_PYTHON_OPTS=\"--notebook-dir=/home/iceberg/notebooks --ip='*' --NotebookApp.token='' --NotebookApp.password='' --port=8888 --no-browser --allow-root\"" >> /bin/pyspark-notebook \
 && echo "pyspark" >> /bin/pyspark-notebook \
 && chmod u+x /bin/pyspark-notebook

RUN mkdir -p /root/.ipython/profile_default/startup
COPY ipython/startup/* /root/.ipython/profile_default/startup

COPY spark-defaults.conf /opt/spark/conf
COPY entrypoint.sh .
RUN chmod u+x /opt/spark/sbin/* && \
    chmod u+x /opt/spark/bin/* && \
    chmod u+x entrypoint.sh
ENV PATH="/opt/spark/sbin:/opt/spark/bin:${PATH}"
ENTRYPOINT ["./entrypoint.sh"]
CMD ["notebook"]