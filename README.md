# iOS Utils

This library's purpose is to make networking in an application easier. It provides simple interface to build network requests using async/await.

## How-to

### Network Requests
`DefaultNetworkService` is a basic entity that provides everything to build a request. 
For example, if you need to send a get request and receive a model, you can do it this way:
```Swift
struct ResponseModel: Decodable {
	// ... some code ...
}

let service = DefaultNetworkService()
do {
	// response will have ResponseModel type
	let response = try await service.sendRequest(
		parameters: RequestParameters(
			endpoint: Endpoint(scheme: "https", host: "example.com", path: ""),
			requestMethod: .get,
			headers: [
				"Content-Type": "application/json"
			]
		),
		responseModel: ResponseModel.self
	)
} catch {
	// error handling
}
```

As shown above, you can configure endpoint, request method, headers and expected response model. 
Also, it is possible to configure body of the request, using `body` property along with `requestModel` property.

### Multipart Requests
Another way to use `DefaultNetworkService` is sending multipart requests. It may be done like this:

```Swift
struct ResponseModel: Decodable {
	// ...
}

let audioData: Data = ...
let service = DefaultNetworkService()

do {
	// response will have ResponseModel type
	let response = try await service.sendMultipartRequest(
		parameters: RequestParameters(
			endpoint: Endpoint(scheme: "https", host: "example.com", path: ""),
			requestMethod: .post,
			headers: nil
		),
		multipartData: [
			MultipartData(name: "audio", fileName: "audio.m4a", data: audioData, mimeType: "audio/m4a")
		],
		responseModel: ResponseModel.self
	)
} catch {
	// error handling
}
```

### Downloading files

You can also download files with `DefaultNetworkService` using `.download(parameters:)` method:
```Swift
let service = DefaultNetworkService()

do {
	// response will store a URL of a downloaded file
	let response = try await service.download(
		parameters: RequestParameters(
			endpoint: Endpoint(
				scheme: "https",
				host: "example.com",
				path: ""
			),
			requestMethod: .get,
			headers: nil
		)
	)
} catch {
	// error handling
}
```

### Middlewares

#### Interface

```swift
public protocol NetworkMiddleware {
	func before(request: URLRequest, with parameters: RequestParameters)
	func onError(_ error: Error, requestParameters: RequestParameters)
}
```

#### Usage

Middlewares allow you to attach additional logic to your service. E.g. logging requests parameters or logging errors could be implemented using a middleware.

```swift
final class ErrorLoggingMiddleware: NetworkMiddleware {
	func onError(_ error: Error, requestParameters: RequestParameters) {
		SomeLogger().log(error)
	}
}

// This service will call ErrorLoggingMiddleWare.onError every time error occurs
let service = DefaultNetworkService(middlewares: [ErrorLoggingMiddleware()])
```

