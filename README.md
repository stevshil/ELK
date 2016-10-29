Vagrant ELK stack enterprise ready using the instructions from;
* http://www.everybodyhertz.co.uk/setting-up-a-relk-stack-a-how-to/

Builds 5 independent servers, allowing you to add more logstash forwarders.

The logstash forwarders (lfw) are those servers whos log files or data you wish to scavenge. These send their log information to Redis MQ services which is then read by the logstash indexer.  The indexer sends the information to Elasticsearch.

Useful Redis commands to check the queues;
* ```redis-cli```
  * Connect to the service on the servers
* ```LLEN logstash```
  * Where logstash is the name of the queue
  * Views number of messages in queue
* ```LPOP logstash```
  * Read a message from the logstash queue
