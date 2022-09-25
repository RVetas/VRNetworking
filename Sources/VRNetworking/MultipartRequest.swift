//
//  File.swift
//  
//
//  Created by Виталий Рамазанов on 25.09.2022.
//

import Foundation

public struct MultipartRequest {
    
    public init() { }
    
    public let boundary: String = "VRLibs.VRNetworking.MultipartRequestBoundary"
    public private(set) var httpBody = NSMutableData()
    
    public func addingData(name: String, fileName: String?, data: Data, mimeType: String) -> Self {
        httpBody.append(dataForm(name: name, fileName: fileName, data: data, mimeType: mimeType))
        return self
    }
    
    public func finalized() -> Self {
        httpBody.append("--\(boundary)--")
        return self
    }
    
    private func dataForm(
        name: String,
        fileName: String?,
        data: Data,
        mimeType: String
    ) -> Data {
        let field = NSMutableData()
        
        field.append("--\(boundary)\r\n")
        if let fileName = fileName {
            field.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n")
        } else {
            field.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        }
        
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
