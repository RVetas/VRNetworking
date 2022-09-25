// Created by Рамазанов Виталий Глебович on 18/09/22

import Foundation

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

public struct MultipartRequest {
    
    public let boundary: String = UUID().uuidString
    public private(set) var httpBody = NSMutableData()
    
    public func addingData(name: String, data: Data, mimeType: String) -> Self {
        httpBody.append(dataForm(name: name, data: data, mimeType: mimeType))
        return self
    }
    
    public func finalized() -> Self {
        httpBody.append("--\(boundary)--")
        return self
    }
    
    private func dataForm(
        name: String,
        data: Data,
        mimeType: String
    ) -> Data {
        let field = NSMutableData()
        
        field.append("--\(boundary)\r\n")
        field.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        field.append("Content-Type: \(mimeType)\r\n")
        field.append("\r\n")
        field.append(data)
        field.append("\r\n")
        
        return field as Data
    }
}

extension NSMutableData {
    func append(_ string: String) {
        string.data(using: .utf8).flatMap { append($0) }
    }
}
