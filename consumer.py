#!/usr/bin/env python
from kafka import KafkaConsumer

c = KafkaConsumer(bootstrap_servers="localhost:9092".split(","), auto_offset_reset="earliest", group_id="demo_no_key", metadata_max_age_ms=10000)

c.subscribe(["demo_without_key"])

for msg in c:
  #print msg
  print("----")
  print("Topic: ", msg.topic, "======= Partition: " , msg.partition, " ====== Key: ", msg.key, " ======== Value: ", msg.value, " ======== Offset: ", msg.offset)
