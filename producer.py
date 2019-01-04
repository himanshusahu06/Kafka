#!/usr/bin/env python
from kafka import KafkaProducer
import time

producer = KafkaProducer(bootstrap_servers=["localhost:9092"], metadata_max_age_ms=10000)


"""
# Sync producer
print producer.send("demo", b'It does not matter').get()

# Have keeps send a message to broker with the same key

TOPIC = "demo"
print "Send data with key"
while True:
  producer.send(TOPIC, key="demo123", value="It does not matter")
  time.sleep(1)
"""
# Produce with out a key
TOPIC = "demo_without_key"
value="It does not matter"
while True:
  producer.send(TOPIC, value=value)
  print("Sent data to topic: %s, with key: null, value:%s" % (TOPIC, value))
  time.sleep(1)


