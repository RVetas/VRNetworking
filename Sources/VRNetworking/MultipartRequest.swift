//
//  File.swift
//  
//
//  Created by Виталий Рамазанов on 25.09.2022.
//

import Foundation

public struct MultipartData {
    public let name: String
    public let fileName: String?
    public let data: Data
    public let mimeType: String
    
    public init(
        name: String,
        fileName: String?,
        data: Data,
        mimeType: String
    ) {
        self.name = name
        self.fileName = fileName
        self.data = data
        self.mimeType = mimeType
    }
}

struct MultipartRequest {
    
    public init() { }
    
    public let boundary: String = "VRLibs.VRNetworking.MultipartRequestBoundary"
    public private(set) var httpBody = NSMutableData()
    
    public func addingData(name: String, fileName: String?, data: Data, mimeType: String) -> Self {
        httpBody.append(dataForm(name: name, fileName: fileName, data: data, mimeType: mimeType))
        return self
    }
    
    public func adding(multipartData: MultipartData) -> Self {
        httpBody.append(dataForm(multipartData: multipartData))
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
    
    private func dataForm(multipartData: MultipartData) -> Data {
        dataForm(
            name: multipartData.name,
            fileName: multipartData.fileName,
            data: multipartData.data,
            mimeType: multipartData.mimeType
        )
    }
}

extension NSMutableData {
    func append(_ string: String) {
        string.data(using: .utf8).flatMap { append($0) }
    }
}
