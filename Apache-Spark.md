### Apache Spark

1. Fast and general engine for large data processing.
2. Distributed processing of large data sets.
3. Cluster computing framework.
4. Built on top of Hadoop MapReduce.
5. It extends the MapReduce model to efficiently use more types of computations which includes **stream processing**, **interactive queries**, **batch applications** and **iterative algorithm**.
6. Spark uses Hadoop in two ways – one is storage and second is processing.
7. Spark uses **in-memory cluster computing** that increases the processing speed of an application.
8. Built around one concept - **RDD (Resilient Distributed Datasets)**

#### Apache Spark Features

1. **Speed** Run Programs up to 100x times faster than Hadoop MapReduce in memory and 10x times faster on disk (possible by reducing number of r/w operations to disk). It stores the intermediate processing data in memory.

2. **DAG (Directed Acyclic Graph)** optimizes workflows.

3. **Advanced Analytics** Spark not only supports ‘Map’ and ‘reduce’. It also supports SQL queries, Streaming data, Machine learning (ML), and Graph algorithms.

#### Spark Built on Hadoop

**Standalone** : Spark Standalone deployment means Spark occupies the place on top of HDFS(Hadoop Distributed File System) and space is allocated for HDFS, explicitly. Here, Spark and MapReduce will run side by side to cover all spark jobs on cluster.

**Hadoop Yarn** : Hadoop Yarn deployment means, simply, spark runs on Yarn (cluster management technology). It helps to integrate Spark into Hadoop ecosystem. It allows other components to run on top of stack.

**Spark in MapReduce (SIMR)** : Spark in MapReduce is used to launch spark job in addition to standalone deployment. With SIMR, user can start Spark and uses its shell without any administrative access.

------------

### Resilient Distributed Datasets (RDD)

**Resilient** : If one node goes down in your cluster it can still recover from that and pickup from where it left off.

**Distributed** : Splits up your data and process across nodes in cluster.

1. Fundamental data structure of Spark.
2. Immutable distributed collection of objects.
3. Each dataset in RDD is divided into logical partitions which may be computed on different nodes of the cluster.
4. RDD can contain any type of objects, including user-defined classes.
8. RDD is a fault-tolerant.

### Spark Context

1. Created by driver program.
2. Responsible for making RDD *resilient* and *distributed*.
3. RDD can also be created from JDBC, Elastic Search, HBase, Cassandra.
4. Load up date from Amazon S3, HDFS.

### Transforming RDD's

**map()** apply a function in every row of RDD.

**flatmap()** is similar to map, but each input item can be mapped to 0 or more output items.

**filter()** trim down unnecessary data from RDD.

**distinct()** remove duplicate rows from RDD.

**sample()** creates a random sample RDD from input RDD.

**union(), intersection(), subtract(), cartesian()** Perform set operations on RDD between any two RDD's.

All these functions doesn't modify original RDD because it is immutable.

### RDD Actions

**collect()** takes the result of an RDD and passes back to driver script.

**count()** get a count of how many rows are there in RDD.

**countByValue()** returns a Map containing <unique value, count> where *count* is a integer describing how many times each unique value appears.

**take()** returns first k result in RDD.

**reduce()** this actually combine together all the different value associated with a given value (similar to reduce in Hadoop).

**In spark, nothing actually happens until you call an action on RDD. When you call any action, it will go and figure out what's the best optimal path for producing these results. At that point spark construct *Directed Acyclic Graph*, execute it in most optimal manner on cluster.**

### Spark Internals
Step by step description of how spark works internally....
1. A job is broken into stages based on when data needs to be reorganized.
2. Each stage is broken into tasks which may be distributed across a cluster.
3. Finally the task are scheduled across your cluster and executed.


### Key/Value RDD's
Key value RDDs are same as general RDD but it contains data in key value pairs instead of rows. It is just a map pairs of data into the RDD using tuples.You can create pair RDD something like this...

`val keyValuePairRDD = originalRDD.map(x=> (x,1))`

Ok to have tuples or other objects as value as well.

If RDD contains tuples and tuple contains two objects then spark automatically treat that RDD as key/value RDD.

**reduceByKey()** combine value with the same key using some function.

`rdd.reduceByKey((x, y) => x+y)` it adds up all the values of the same key and return a new RDD.

**groupByKey()** - Group value with the same key and returns `(key, List of values of same key)`.

**sortByKey()** - Sort an RDD by key.

**keys()** - Create an RDD of just keys.

**values()** - Create an RDD of just values.

**join, rightOuterJoin, leftOuterJoin, cogroup, subtractByKey** - Create an RDD by doing some SQL style joins on two key/value RDD.

`With key/value data, use mapValues() and flatMapValues() if your transformation doesn't affect the keys. It's more efficient.`
