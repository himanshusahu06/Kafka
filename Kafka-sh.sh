##################################################################################################################################################################
#######                                                       	APACHE KAFKA Shell Commands	                                                         #########
##################################################################################################################################################################

#install Apache kafka and zookeeper. it will automatically install apache zookeeper and other dependencies
brew install kafka

#Start zookeeper Server
zkserver start

#stop zookeeper Server
zkserver stop

#start kafka Server
kafka-server-start.sh /usr/local/etc/kafka/server.properties

#stop kafka Server
kafka-server-stop.sh

#check if kafka and zookeeper is running or not
#jps is command to list all the running java processes names along with respective ports
#QuorumPeerMain is process for Apache zookeeper
#Kafka is process for kafka process. there might be other processes running
jps

##################################################################################################################################################################
#                                               	Basic Kafka commands to get Informations                                                                 #
##################################################################################################################################################################

#create new Topic with REPLICATION_FACTOR and PARTITION_COUNT
#The REPLICATION_FACTOR factor controls how many servers will replicate each message that is written.
#The PARTITION_COUNT controls in how many partition topics will be divided
#kafka-topics.sh --create --zookeeper HOST:PORT --replication-factor REPLICATION_FACTOR --partitions PARTITION_COUNT --topic TOPICNAME
kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic newKafkaTopic

#Get a list of topics in Kafka server
#kafka-topics.sh --list --zookeeper HOST:PORT
kafka-topics.sh --list --zookeeper localhost:2181

#delete a topic
#kafka-topics.sh --delete --zookeeper HOST:PORT --topic TOPICNAME
kafka-topics.sh --delete --zookeeper localhost:2181 --topic newKafkaTopic

##################################################################################################################################################################
#							 single node cluster with a single broker								 #
##################################################################################################################################################################

#Start Producer to Send Messages
#Broker-list - The list of brokers that we want to send the messages to. In this case we only have one broker.
#The Config/server.properties file contains broker port id, since we know our broker is listening on port 9092, so you can specify it directly.
kafka-console-producer.sh --broker-list localhost:9092 --topic newKafkaTopic

#Start Consumer to Receive Messages
# If you want to consume message from beginning from the topic use --from-beginning
# Else it will start consuming only newly produced message
kafka-console-consumer.sh --bootstrap-server 127.0.0.1:9092 --zookeeper 127.0.0.1:2181 --topic newKafkaTopic --from-beginning --consumer.config consumer_config.cfg


##################################################################################################################################################################
#							Single Node cluster with Multiple Brokers								 #
##################################################################################################################################################################

#Start Multiple Brokers – open three new terminals to start each broker one by one.
#Broker1
kafka-server-start.sh /usr/local/etc/kafka/server.properties
#Broker2
kafka-server-start.sh /usr/local/etc/kafka/server-one.properties
#Broker3
kafka-server-start.sh /usr/local/etc/kafka/server-two.properties


# Create a new Topic
kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 1 --topic MultiBrokerTopic --config <CONFIG_KEY=CONFIG_VALUE>

# Alter a created topic, you can modify existing config
kafka-topics.sh --alter --zookeeper localhost:2181 --topic MultiBrokerTopic --config <CONFIG_KEY=NEW_CONFIG_VALUE>

#Get Informmtaion about particular topic
kafka-topics.sh --describe --zookeeper localhost:2181 --topic MultiBrokerTopic

# Start Producer to Send Messages - This procedure remains the same as in the single broker configuration
kafka-console-producer.sh --broker-list localhost:9092 --topic MultiBrokerTopic

# Start Consumer to Receive Messages - This procedure remains the same as shown in the single broker Configuration
kafka-console-consumer.sh --bootstrap-server 127.0.0.1:9092 --zookeeper 127.0.0.1:2181 --topic MultiBrokerTopic --from-beginning --consumer.config consumer_config.cfg


##################################################################################################################################################################
#                                                       	     Basic Topic Operations 	                                                                 #
##################################################################################################################################################################

# Modifying a Topic
kafka-topics.sh --zookeeper localhost:2181 --alter --topic test --partitions new_count

# Deleting a topic
kafka-topics.sh --zookeeper localhost:2181 --delete --topic topic_name

# Find offset of perticular consumer over a topic
bin/kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --group group_test --zookeeper localhost:2181 --topic test
