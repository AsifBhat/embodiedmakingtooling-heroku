jQuery ($) ->
samplejson = [
  {
    "name": "F0001",
    "description": "A fast and fully-featured autocomplete library",
    "tokens": [
      "F0001"
    ]
  },
  {
    "name": "S0001",
    "description": "A Ruby client for the Cassandra distributed database",
    "tokens": [
      "S0001"
    ]
  },
  {
    "name": "C0001",
    "description": "Refactored version of code.google.com/hadoop-gpl-compression for hadoop 0.20",
    "tokens": [
      "C0001"
    ]
  },
  {
    "name": "F0002",
    "description": "A Ruby client library for Scribe",
    "tokens": [
      "F0002"
    ]
  },
  {
    "name": "S0002",
    "description": "A Thrift client wrapper that encapsulates some common failover behavior",
    "tokens": [
      "S0002"
    ]
  },
  {
    "name": "C0002",
    "description": "Minimal templating with {{mustaches}} in JavaScript",
    "tokens": [
      "C0002"
    ]
  },
  {
    "name": "F0003",
    "description": "A JVM Kestrel client that aggregates queues from multiple servers. Implemented in Scala with Java bindings. In use at Twitter for all JVM Search and Streaming Kestrel interactions.",
    "tokens": [
      "F0003"
    ]
  },
  {
    "name": "S0003",
    "description": "A flexible sharding framework for creating eventually-consistent distributed datastores",
    "tokens": [
      "S0003"
    ]
  },
  {
    "name": "C0003",
    "description": "Twitter's out-of-date, forked thrift",
    "tokens": [
      "C0003"
    ]
  },
  {
    "name": "F0004",
    "description": "A distributed, fault-tolerant graph database",
    "tokens": [
      "F0004"
    ]
  },
  {
    "name": "S0004",
    "description": "A Ruby client library for FlockDB",
    "tokens": [
      "S0004"
    ]
  },
  {
    "name": "C0004",
    "description": "A slightly more standard sbt project plugin library ",
    "tokens": [
      "C0004"
    ]
  },
  {
    "name": "F0005",
    "description": "Snowflake is a network service for generating unique ID numbers at high scale with some simple guarantees.",
    "tokens": [
      "F0005"
    ]
  },
  ]

$('#query').typeahead({        
 local: samplejson,
 template: [  
  '<p style="font-size:10">{{name}}</p>',

 ].join(''), 
 engine: Hogan 
}) 