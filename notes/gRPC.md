# gRPC Notes
#notes
[YouTube](https://www.youtube.com/watch?v=hVrwuMnCtok)
[YouTube](https://www.youtube.com/watch?v=XRXTsQwyZSU)

## About gRPC
* Allows you to define request and response for RPC (Remote Procedure Calls) and handles the rest for you
* Sends small, performant messages (protobuf)
* Deals with communication between micro services 
* Built on top of HTTP2.0
* Offers convenience, scalability, and performance benefits
* Open-source, developed by Google

## Convenience and scalability benefits
* Handles all the connections to the HTTP services
	* 	All of these have their own HTTP libraries (Python requests lib, Java HttpURLConnection) but you can just use gRPC to handle everything
* Code generation using *protocol buffers*  `.proto`
	* Contains message schema 
	* Defines which Procedures are Callable Remotely
		* You implement the actual details in whichever language (i.e. annotations.go?) 

## Performance benefits
* Protocol buffers are serialized and sent as binaries across the wire (this is smaller and more efficient than JSON)
	* gRPC vs. REST: JSON is key-value, v space inefficient but still the default for REST API
	* Less effort than compression (gzip), gRPC handles it all for you

## Example 
* Frontend
* Backend server running microservices (Python, Java, Go)
	* In proto file, messages have `int`,  `string`, then you implement the details in the actual Java file

![Image](https://miro.medium.com/max/1400/1*Eg16Mg5l9l_n8O-Eer4-ug.png)

## RPC
* Not new, handles communication between services but gRPC solves a lot of the problems

## How to use it?
1. Define messages and services using Protocol Buffers `.proto`
2. `.proto` generates the rest of gRPC code, can work for over 12 different programming languages
3. You implement stuff defined in the protocol buffer

### Example.proto

```
message Greeting {
string first_name = 1;
}
message GreetRequest {
Greeting greeting = 1
}
message GreetResponse {
string result = 1;
}
service GreetService {
rpc Greet(GreetRequest) returns (GreetResponse) {};
}
```
