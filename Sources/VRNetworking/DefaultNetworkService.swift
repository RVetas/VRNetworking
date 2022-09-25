// Created by Рамазанов Виталий Глебович on 18/09/22

import Foundation

@available(iOS 15.0, *)
public final class DefaultNetworkService: NetworkService {
    
    private let networkHandler: HandlesNetwork
    private let encoder: EncodesJSON
    private let decoder: DecodesJSON
    
    public init(
        networkHandler: HandlesNetwork = URLSession.shared,
        encoder: EncodesJSON = JSONEncoder(),
        decoder: DecodesJSON = JSONDecoder()
    ) {
        self.networkHandler = networkHandler
        self.encoder = encoder
        self.decoder = decoder
    }
    
    public func sendRequest<RequestModel: Encodable>(
        parameters: RequestParameters,
        body: RequestModel?,
        requestModel: RequestModel.Type?
    ) async throws -> Data {
        let request = try request(parameters: parameters, body: body, requestModel: RequestModel.self)
        return (try await send(request: request)).0
    }
    
    public func sendRequest<RequestModel: Encodable, ResponseModel: Decodable>(
        parameters: RequestParameters,
        body: RequestModel?,
        requestModel: RequestModel.Type?,
        responseModel: ResponseModel.Type
    ) async throws -> ResponseModel {
        let request = try request(parameters: parameters, body: body, requestModel: RequestModel.self)
        let (data, _) = try await send(request: request)
        
        return try decode(model: ResponseModel.self, from: data)
    }
    
    public func download(
        parameters: RequestParameters
    ) async throws -> URL {
        let request = try request(
            parameters: parameters,
            body: nil,
            requestModel: EncodableDummy.self
        )
        
        do {
            let (url, response) = try await networkHandler.download(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            switch response.statusCode {
                case 200...299:
                    return url
                default:
                    throw NetworkError.invalidResponseCode(responseCode: response.statusCode)
            }
            
        } catch {
            if type(of: error) != NetworkError.self {
                throw NetworkError.otherError(error)
            } else {
                throw error
            }
        }
    }
    
    public func sendMultipartRequest<ResponseModel: Decodable>(
        parameters: RequestParameters,
        multipartRequest: MultipartRequest,
        responseModel: ResponseModel.Type
    ) async throws -> ResponseModel {
        var request = try request(parameters: parameters, body: nil, requestModel: EncodableDummy.self)
        request.setValue("multipart/form-data; boundary=\(multipartRequest.boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = multipartRequest.finalized().httpBody as Data
        
        let (data, _) = try await send(request: request)
        return try decode(model: ResponseModel.self, from: data)
    }
    
    public func sendMultipartRequest(
        parameters: RequestParameters,
        multipartRequest: MultipartRequest
    ) async throws -> Data {
        var request = try request(parameters: parameters, body: nil, requestModel: EncodableDummy.self)
        request.setValue("multipart/form-data; boundary=\(multipartRequest.boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = multipartRequest.finalized().httpBody as Data
        
        let (data, _) = try await send(request: request)
        return data
    }
}

private extension DefaultNetworkService {
    private func send(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await networkHandler.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            switch response.statusCode {
                case 200...299:
                    return (data, response)
                    
                default:
                    throw NetworkError.invalidResponseCode(responseCode: response.statusCode)
            }
            
        } catch {
            if type(of: error) != NetworkError.self {
                throw NetworkError.otherError(error)
            } else {
                throw error
            }
        }
    }

    private func request<RequestModel: Encodable>(
        parameters: RequestParameters,
        body: RequestModel?,
        requestModel: RequestModel.Type?
    ) throws -> URLRequest {
        guard let url = URLComponents(from: parameters.endpoint).url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = parameters.requestMethod.rawValue
        request.allHTTPHeaderFields = parameters.headers
        
        try body.flatMap {
            request.httpBody = try encode(model: $0)
        }
        
        return request
    }

    private func encode<Model: Encodable>(model: Model) throws -> Data {
        do {
            return try encoder.encode(model)
        } catch {
            throw NetworkError.encodingError(error as? EncodingError)
        }
    }
    
    private func decode<Model: Decodable>(model: Model.Type, from data: Data) throws -> Model {
        do {
            return try decoder.decode(Model.self, from: data)
        } catch {
            throw NetworkError.decodingError(error as? DecodingError)
        }
    }
}
