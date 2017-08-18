### Apache Kafka
Decoupling of data streams from source to target system.
1. distributed fault tolerant
2. horizontal scalability : (Add nodes to architecture and system will be scaled accordingly)
3. decoupling of system dependencies
4. Can be integrated with Big data technologies
5. Stream Processing (Kafka Stream API)

#### Topics
1. a particular stream of data
2. Topic splits in partitions

#### Partitions
1. Each partition is ordered
2. Each message within a partition gets an incremental id (offset)
3. Each partition has it's own offsets

#### Offsets
1. Offset is local to each partition
2. Order is guaranteed only within a partition
3. Data is kept only for a limited time
4. Written data is immutable
5. You can have as many partitions per topic as you want
6. You push data to topic not to the partitions, data is assigned to partitions randomly be default unless specified.

#### Brokers
1. A kafka cluster is composed of multiple servers and these server is called broker
2. Each broker is identified by with its integer ID
3. Each broker contains certain topic partitions
4. Each broker can contain multiple partitions from different topics
5. After connecting to any broker (bootstrap broker), you will be connected to entire cluster.
	
eg: suppose you are connected to Broker 1 which doesn't have any partition of topic 2 and you are pushing data to topic 2, since you are connected to entire cluster it means kafka will take care of which broker have topic 2 partition.

##### Topic Replication Factor
1. should be grater that 2 or 3.
2. In case a broker is down, another broker can server the  data.

##### Leader
1. At any time only 1 broker can be leader for a given partition 
2. Only the Leader can receive and server data for a partition
3. The other broker will synchronize the data.
4. There each partition has: ONE LEADER AND multiple ISR (IN-SYNC REPLICA)

##### Producers
Writes data to topics.
Only specify the topic name and one broker to connect, kafka will automatically take care of routing of data to the right brokers.
Automatically load balancing by broker.
	
##### Message Acknowledgement 
Producer can choose to receive acknowledgment of data writes:
		**Acks=0** : producer won't  wait for acknowledgment (possible data loss) (least safe) (super quick)
		**Acks=1** : Producer will wait for leader acknowledgment (possible data loss) (moderate safe) (quick)
		**Acks= all** : Leader + Replica acknowledgment (no data loss) (safest)

##### Producer Message Keys
Producer can choose to send a key with the message.
if a key us sent, then the producer has the guarantee that all messages for that key will always go to the same partition, guarantee ordered data.

#### Consumers
1. Read data from topic.
2. Only specify the topic name and one broker to connect, kafka will automatically take care of pulling the data from the right brokers.
3. Data is read in order for each partitions.

##### CONSUMER GROUP
1. consumer read data in consumer groups.
2. each consumer within a group reads from exclusive partitions.
3. **You can't have more #consumers than #partitions** (otherwise some will be inactive).
4. one consumer can read from multiple partition but a partition can not be read from multiple consumer from same consumer group, but it a partition can be read by multiple consumer from different consumerGroups.
    ONE CONSUMER PER PARTITION from a consumer group.
    MULTIPLE PARTITION PER CONSUMER iff no_of_partition > no_of_consumer_in_a_consumer_group.

##### Consumer Offsets
1. Kafka stores the offsets at which a consumer group has been reading.
2. The offsets commit live in a Kafka topic named "__consumer_offsets".
3. When a consumer has processed data received from kafka, it should be committing the offsets.
4. If a consumer process dies it will be able to read back from where it left off (because of consumer offsets).

#### Apache Zookeeper
1. manages brokers (keep lists of them).
2. performs leader election for partitions.
3. It notify kafka in case of changes (new topic, broker dies/comes up, delete topics...).
4. Zookeeper usually operates in an odd quorum (server/brokers 3,5,7).
5. One zookeeper is leader, rest of else are followers.
6. kafka broker communicates with leader zookeeper.

###### Kafka Guarantees 
1. ordered push messages per topic-partition.
2. orders pull messages per topic-partition.
3. With a replication factor of N, producer and consumers can tolerate up to N-1 brokers being down.
4. As long as number of partitions remains constant for a topic, the same key will always go to same partition.
5. IF PARTITION COUNT INCREASES DURING TOPIC LIFECYCLE, IT WILL BREAK KEY ORDERING GUARENTEE.
6. IF THE REPLICATION FACTOR INCREASES DURING A TOPIC LIFECYCLE, YOU PUT MORE PRESSURE ON YOUR CLUSTER WHICH WILL DECREASE PERFORMANCE
	
###### DELIVERY SEMANTICS FOR CONSUMERS
1. consumer choose when to commit offsets.
2. **at most once** : offsets are committed ASA the message is received. If processing goes wrong, message will be lost. you can't read it again.
3. **at least once** : offsets are committed after the message is processed. Your processing should be idempotent (eg. idempotent transaction).

###### MORE PARTITION
1. Better parallelism, better performance, more consumer can consume data.
2. BUT more files opened in the system.
3. BUT if a broker fails (unclean shutdown), more leader elections.
4. BUT added latency to replicate the data.
5. PARTITION PER TOPIC = (1 or 2) x (# of Brokers), max 10 partitions

###### REPLICATION FACTOR
1. Replication factor should be minimum 2, maximum 3.
2. if replication performance is an issue, get a better broker instead of modifying replication factor.

###### SEGMENT
1. Topics are made of partition.
2. Partitions are made of segments (files).
3. Segments (files) are made of data.
4. Only one segment will be ACTIVE per partition (the data is being written to)
	**log.segment.bytes** = the max size of a single segment of bytes.
	**log.segment.ms** = the time kafka wait before committing the segment if not full

##### SEGMENT INDEXS
1. Segment comes with two indexes.
    a) An offset to position indexes : allow kafka where to read to find a message.
	b) A timestamp to offset index: allow kafka to find a message with a timestamp.
2. A smaller **log.segment.bytes** means
	a) more segment per partition.
	b) log compaction happens more often.
	c) BUT kafka has to keep more files opened.		
	
###### LOG CLEANUP POLICIES
1. Kafka cluster make data expire based on policy. This concept is called log cleanup.
    a) **log.cleanup.policy** = **delete** (default for all user topic)
        delete based on age of data (default to 1 week)
		delete based on max size of log (partition) (default to -1 == infinite)
	b) **log.cleanup.policy** = **compact** (default for **__consumer_offsets** topic)
		delete based on key of your messages
		you push two messages with same key then it will delete old one retain latest one.
2. It happens on every partition segment.
	smaller/more segments means log cleanup will happen more frequently.
	Log cleanup shouldn't happen too often because it takes CPU and RAM resources.

###### *DELETE* LOG CLEANUP POLICY (log.cleanup.policy = delete):
1. All log policies are partition level configuration
	**log.retention.hours** : number of hours to keep the data (default one week)
        higher number means more disk space.
		lower number means less data is retained.
	**log.retention.bytes** : max size of bytes in in each partition (-1 INFINITE default)
		useful to keep size of log under a threshold
		if log.retention.bytes is 500MB it means that as soon as partition reaches 500MB data it will delete old segment.
	
###### *COMPACT* LOG CLEANUP POLICY
1. Log compaction ensures that your log partition contains at least one known value for a specific key within a partition.
2. We only keep the latest update for a key in our log.
3. New consumer won't see any old key after log compaction.
4. log compaction only remove the data, no re-ordering happens.
5. de duplication is done after a segment is committed.
	
**segment.ms**
	This configuration controls the period of time after which Kafka will force the log to roll even if the segment file isn't full to ensure that retention can delete or compact old data.

###### OTHER CONFIGURATION:
	max.messages.bytes (default to 1MB) -> maximum size of message
	
###### SPRING KAFKA
https://projects.spring.io/spring-kafka/
https://spring.io/blog/2015/04/15/using-apache-kafka-for-integration-and-data-processing-pipelines-with-spring
https://github.com/spring-projects/spring-kafka
https://github.com/spring-projects/spring-integration-kafka

