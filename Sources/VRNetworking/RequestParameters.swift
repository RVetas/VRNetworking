// Created by Рамазанов Виталий Глебович on 18/09/22

public struct RequestParameters {
    
    public let endpoint: Endpoint
    public let requestMethod: HTTPRequestMethod
    public let headers: [String: String]?
    
    public init(
        endpoint: Endpoint,
        requestMethod: HTTPRequestMethod,
        headers: [String: String]?
    ) {
        self.endpoint = endpoint
        self.requestMethod = requestMethod
        self.headers = headers
    }
}
