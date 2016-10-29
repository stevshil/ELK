# 2 Day Workshop - Elasticsearch Logstash Kibana Stack

## Day 1

1. **What is ELK**
    * What is ELK
    * How does it fit into business
    	* As an IT project
      * As a statistical analysis system
    * Architecture

2. **Installation**
    * Types of installation
      * Packages, zip, tgz
    * Separation of components
  	* Kibana and ElasticSearch
  	* Logstash on servers/workstations to monitor

3. **Essential configuration**
	 * Firewall considerations
	 * Understanding YAML for ElasticSearch and Kibana
   * Key parameters to make the components talk to each other

4. **Making Logstash talk to ElasticSearch**
	* Simple logstash configuration
      * Testing using standard input
      * Checking output via stdout or /var/log
	* Sending data to ElasticSearch

5. **Layout of the Logstash file**
	* Files for specific tasks - the conf.d directory
	* File format - inputs, filters and outputs
	* Understanding the different plug-ins
		* Where to find further information and available plug-ins
	* Grabbing logs from servers

6. **Viewing the logs in Kibana**
	* Using Kibana filters
		* Constructions
		* Saving
		* Changing the view of the log information
	* Creating visuals and dashboards

## Day 2

7. **Running as a service**
	* If installed manually

8. **Configuration errors**
	* How to spot an error in configuration
	* configtest command

9. **Logstash filters**
	* Why?
	* Example of catching numerical data
		* Trying to use it in Kibana visuals
	* Using grok to create fields and data types
		* Revisit Kibana visuals
	* Creating dynamic fieldnames
	* CSV data parsing
	* Mutating data
	* Spliting data
	* Metrics
		* Ref = http://blog.eagerelk.com/how-to-configure-the-metrics-logstash-filter/
		* What are they and why are they useful - link back to Kibana

10. **Viewing new fields in Kibana**
	* Updating ElasticSearch
	* Fieldname issues
	* Visualising new fields

11. **Securing Kibana**
	* The architecture
	* Proxy with authentication
	* Ensuring only the proxy accesses Kibana - firewalls

12. **A look at scaling ELK**
	* Load balancing Kibana
	* Reducing connections to ElasticSearch
	* ElasticSearch clusters
		* http://www.everybodyhertz.co.uk/setting-up-a-relk-stack-a-how-to/
		*  https://www.digitalocean.com/community/tutorials/how-to-set-up-a-production-elasticsearch-cluster-on-ubuntu-14-04
