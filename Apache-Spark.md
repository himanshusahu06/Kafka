### Apache Spark

1. Apache Spark is cluster computing framework.
2. It was built on top of Hadoop MapReduce.
3. It extends the MapReduce model to efficiently use more types of computations which includes **stream processing**, **interactive queries**, **batch applications** and **iterative algorithm**.
4. Spark was introduced by Apache Software Foundation for speeding up the Hadoop computational computing software process.
5. Spark uses Hadoop in two ways – one is storage and second is processing.
6. Spark uses **in-memory cluster computing** that increases the processing speed of an application.

#### Apache Spark Features

1. **Speed** Spark helps to run an application in Hadoop cluster and upto 100 times faster in memory and upto 10 times faster when running on disk (possible by reducing number of read/write operations to disk). It stores the intermediate processing data in memory.

2. **Advanced Analytics** Spark not only supports ‘Map’ and ‘reduce’. It also supports SQL queries, Streaming data, Machine learning (ML), and Graph algorithms.

3. Spark provides built-in APIs in Java, Scala, or Python.

#### Spark Built on Hadoop

**Standalone** : Spark Standalone deployment means Spark occupies the place on top of HDFS(Hadoop Distributed File System) and space is allocated for HDFS, explicitly. Here, Spark and MapReduce will run side by side to cover all spark jobs on cluster.

**Hadoop Yarn** : Hadoop Yarn deployment means, simply, spark runs on Yarn (cluster management technology). It helps to integrate Spark into Hadoop ecosystem. It allows other components to run on top of stack.

**Spark in MapReduce (SIMR)** : Spark in MapReduce is used to launch spark job in addition to standalone deployment. With SIMR, user can start Spark and uses its shell without any administrative access.

#### Resilient Distributed Datasets (RDD)
1. RDD is a fundamental data structure of Spark. 
2. It is an immutable distributed collection of objects.
3. Each dataset in RDD is divided into logical partitions,
4. which may be computed on different nodes of the cluster.
5. RDDs can contain any type of objects, including user-defined classes.
6. RDD is a read-only, partitioned collection of records
7. RDDs can be created through deterministic operations on either data or stable storage or other RDDs.
8. RDD is a fault-tolerant.

