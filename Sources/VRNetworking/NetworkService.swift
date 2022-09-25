// Created by Рамазанов Виталий Глебович on 18/09/22

import Foundation

public protocol NetworkService {
    func sendRequest<RequestModel: Encodable, ResponseModel: Decodable>(
        parameters: RequestParameters,
        body: RequestModel?,
        requestModel: RequestModel.Type?,
        responseModel: ResponseModel.Type
    ) async throws -> ResponseModel
    
    func sendRequest<RequestModel: Encodable>(
        parameters: RequestParameters,
        body: RequestModel?,
        requestModel: RequestModel.Type?
    ) async throws -> Data
}

public extension NetworkService {
    func sendRequest<RequestModel: Encodable, ResponseModel: Decodable>(
        parameters: RequestParameters,
        body: RequestModel,
        responseModel: ResponseModel.Type
    ) async throws -> ResponseModel {
        try await sendRequest(
            parameters: parameters,
            body: body,
            requestModel: nil,
            responseModel: responseModel
        )
    }
    
    func sendRequest<ResponseModel: Decodable>(
        parameters: RequestParameters,
        responseModel: ResponseModel.Type
    ) async throws -> ResponseModel {
        return try await sendRequest(parameters: parameters, body: nil, requestModel: EncodableDummy.self, responseModel: responseModel)
    }
    
    func sendRequest<RequestModel: Encodable>(
        parameters: RequestParameters,
        body: RequestModel?
    ) async throws -> Data {
        try await sendRequest(
            parameters: parameters,
            body: body,
            requestModel: nil
        )
    }
    
    func sendRequest(
        parameters: RequestParameters
    ) async throws -> Data {
        try await sendRequest(parameters: parameters, body: nil, requestModel: EncodableDummy.self)
    }
}
