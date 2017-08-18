Apache Kafka

Decoupling of data streams from source to target system.

1. distributed fault tolerant
2. horizontal scalability : (Add nodes to architecture and system will be scaled accordingly)
3. decoupling of system dependencies
4. Can be integrated with Big data technologies
5. Stream Processing (Kafka Stream API)


TOPICS:
	a particular stream of data
	Topic splits in partitions

PARTITIONS:
	Each partition is ordered
	Each message within a partition gets an incremental id (offset)
	Each partition has it's own offsets

Offset is local to each partition
Order is guaranteed only within a partition
Data is kept only for a limited time
Written data is immutable
You can have as many partitions per topic as you want
You push data to topic not to the partitions, data is assigned to partitions randomly be default unless specified

BROKERS:
	A kafka cluster is composed of multiple servers and these server is called broker
	Each broker is identified by with its integer ID
	Each broker contains certain topic partitions
	Each broker can contain multiple partitions from different topics
	After connecting to any broker (bootstrap broker), you will be connected to entire cluster.
	
	:::: suppose you are connected to Broker 1 which doesn't have any partition of topic 2 and you are pushing data to topic 2, since you are connected to entire cluster it means kafka will take care of which broker have topic 2 partition.

TOPIC REPLICATION FACTOR:
	should be grater that 2 or 3.
	In case a broker is down, another broker can server the  data.
	
LEADER:
	At any time only 1 broker can be leader for a given partition 
	Only the Leader can receive and server data for a partition
	The other broker will synchronize the data.
	There each partition has: ONE LEADER AND multiple ISR (IN-SYNC REPLICA)
	
PRODUCERS:
	Writes data to topics.
	Only specify the topic name and one broker to connect, kafka will automatically take care of routing of data to the right brokers.
	Automatically load balancing by broker.
	
ACKNOWLEGDMENT:
	Producer can choose to receive acknowledgment of data writes:
		Acks=0 ; producer won't  wait for acknowledgment (possible data loss) (least safe) (super quick)
		Acks=1 ; Producer will wait for leader acknowledgment (possible data loss) (moderate safe) (quick)
		Acks= all ; Leader + Replica acknowledgment (no data loss) (safest)

PRODUCERS: Message Keys
	Producer can choose to send a key with the message.
	if a key us sent, then the producer has the guarantee that all messages for that key will always go to the same partition, guarantee ordered data.
	

CONSUMERS:
	Read data from topic.
	Only specify the topic name and one broker to connect, kafka will automatically take care of pulling the data from the right brokers.
	Data is read in order for each partitions.

CONSUMER GROUP:
	consumer read data in consumer groups.
	each consumer within a group reads from exclusive partitions.
	YOU CAN NOT HAVE MORE CONSUMERS THAN PARTITIONS (otherwise some will be inactive).
	one consumer can read from multiple partition but a partition can not be read from multiple consumer from same consumer group, but it a partition can be read by multiple consumer from different consumerGroups.
	ONE CONSUMER PER PARTITION from a consumer group.
	MULTIPLE PARTITION PER CONSUMER iff no_of_partition > no_of_consumer_in_a_consumer_group.
	

CONSUMER OFFSETS:
	Kafka stores the offsets at which a consumer group has been reading.
	The offsets commit live in a Kafka topic named "__consumer_offsets".
	When a consumer has processed data received from kafka, it should be committing the offsets.
	If a consumer process dies it will be able to read back from where it left off (because of consumer offsets).

APACHE ZOOKEEPER:
	manages brokers (keep lists of them).
	performs leader election for partitions.
	It notify kafka in case of changes (new topic, broker dies/comes up, delete topics...).
	Zookeeper usually operates in an odd quorum (server/brokers 3,5,7).
	One zookeeper is leader, rest of else are followers.
	kafka broker communicates with leader zookeeper.

KAFKA GUARENTEES:
	ordered push messages per topic-partition.
	orders pull messages per topic-partition.
	With a replication factor of N, producer and consumers can tolerate up to N-1 brokers being down.
	As long as number of partitions remains constant for a topic, the same key will always go to same partition.
	IF PARTITION COUNT INCREASES DURING TOPIC LIFECYCLE, IT WILL BREAK KEY ORDERING GUARENTEE.
	IF THE REPLICATION FACTOR INCREASES DURING A TOPIC LIFECYCLE, YOU PUT MORE PRESSURE ON YOUR CLUSTER WHICH WILL DECREASE PERFORMANCE
	
DELIVERY SEMANTICS FOR CONSUMERS:
	consumer choose when to commit offsets.
	at most once ::::::: offsets are committed ASA the message is received. If processing goes wrong, message will be lost. you can't read it again.
	at least once ::::::: offsets are committed after the message is processed. Your processing should be idempotent (eg. idempotent transaction).



MORE PARTITION:
	better parallelism, better performance, more consumer can consume data.
	BUT more files opened in the system.
	BUT if a broker fails (unclean shutdown), more leader elections.
	BUT added latency to replicate the data.
	PARTITION PER TOPIC = (1 or 2) x (# of Brokers), max 10 partitions

REPLICATION FACTOR:
	should be minimum 2, maximum 3
	if replication performance is an issue, get a  better broker instead of modifying RF.

SEGMENT:
	topics are made of partition.
	partitions are made of segments (files).
	segments (files) are made of data.
	only one segment will be ACTIVE per partition (the data is being written to)
	log.segment.bytes = the max size of a single segment of bytes.
	log.segment.ms = the time kafka wait before committing the segment if not full
	
SEGMENT INDEXS:
	Segment comes with two indexes.
		1. An offset to position indexes : allow kafka where to read to find a message.
		2. A timestamp to offset index: allow kafka to find a message with a timestamp.
	A smaller log.segment.bytes means:
		more segment per partition.
		log compaction happens more often.
		BUT kafka has to keep more files opened.		
	

LOG CLEANUP POLICIES:
	Kafka cluster make data expire based on policy. This concept is called log cleanup.
	1. log.cleanup.policy = delete (default for all user topic)
		delete based on age of data (default to 1 week)
		delete based on max size of log (partition) (default to -1 == infinite)
	2. log.cleanup.policy = compact (default for __consumer_offsets topic)
		delete based on key of your messages
		you push two messages with same key then it will delete old one retain latest one.
		
	It happens on every partition segment.
	smaller/more segments means log cleanup will happen more frequently.
	Log cleanup shouldn't happen too often because it takes CPU and RAM resources.
	


DELETE LOG CLEANUP POLICY (log.cleanup.policy = delete):
	all log policies are partition level configuration
	log.retention.hours -> number of hours to keep the data (default one week)
		higher number means more disk space.
		lower number means less data is retained 
	log.retention.bytes -> max size of bytes in in each partition (-1 INFINITE default)
		useful to keep size of log under a threshold
		if log.retention.bytes is 500MB it means that as soon as partition reaches 500MB data it will delete old segment.
	
	
LOG CLEANUP POLICY: COMPACT:
	Log compaction ensures that your log partition contains at least one known value for a specific key within a partition.
	We only keep the latest update for a key in our log.
	new consumer won't see any old key after log compaction.
	log compaction only remove the data, no re-ordering happens.
	de duplication is done after a segment is committed.
	
segment.ms
	This configuration controls the period of time after which Kafka will force the log to roll even if the segment file isn't full to ensure that retention can delete or compact old data.


OTHER CONFIGURATION:
	max.messages.bytes (default to 1MB) -> maximum size of message


	
SPRING KAFKA
https://projects.spring.io/spring-kafka/
https://spring.io/blog/2015/04/15/using-apache-kafka-for-integration-and-data-processing-pipelines-with-spring
https://github.com/spring-projects/spring-kafka
https://github.com/spring-projects/spring-integration-kafka

