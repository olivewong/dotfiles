# gRPC Notes
#notes
[YouTube](https://www.youtube.com/watch?v=hVrwuMnCtok)
[YouTube](https://www.youtube.com/watch?v=XRXTsQwyZSU)

## About gRPC
* Allows you to define request and response for RPC (Remote Procedure Calls) and handles the rest for u
* Sends small, performant messages (protobuf)
* Deals with communication between micro services 
* Built on top of HTTP2.0
* Offers convenience, scalability, and performance benefits
* Open-source, developed by Google

## gRPC: Convenience and scalability benefits
* Handles all the connections to the HTTP services
	* 	All of these have their own HTTP libraries (Python requests HTTP 1.1, Java HttpURLConnection) but you can just use gRPC
* Code generation using *protocol buffers*  `.proto`
	* Contains message schema 
	* Defines which Procedures are Callable Remotely
		* You implement the actual details in whichever language (i.e. annotations.go?) 

## Performance benefits
* Protocol buffers are serialized and sent as binaries across the wire (this is smaller and more efficient than JSON)
	* *gRPC vs. REST* JSON is key-value, v space inefficient but still the default for REST API
	* Less effort than compression (gzip), gRPC handles it all for you

## Example 
	* Frontend
	* Backend server running microservices (Python, Java, Go)
		* In photo file, messages have `int`,  `string`, then you implement the details in the actual Java file

