// Created by Рамазанов Виталий Глебович on 18/09/22

import Foundation

@available(iOS 15.0, *)
public final class DefaultNetworkService: NetworkService {
    
    private let networkHandler: HandlesNetwork
    private let encoder: EncodesJSON
    private let decoder: DecodesJSON
	private let middlewares: [NetworkMiddleware]
    
    public init(
        networkHandler: HandlesNetwork = URLSession(configuration: URLSessionConfiguration.default),
        encoder: EncodesJSON = JSONEncoder(),
        decoder: DecodesJSON = JSONDecoder(),
		middlewares: [NetworkMiddleware] = []
    ) {
        self.networkHandler = networkHandler
        self.encoder = encoder
        self.decoder = decoder
		self.middlewares = middlewares
    }
    
    public func sendRequest<RequestModel: Encodable>(
        parameters: RequestParameters,
        body: RequestModel?,
        requestModel: RequestModel.Type?
    ) async throws -> Data {
		do {
			let request = try request(parameters: parameters, body: body, requestModel: RequestModel.self)
			middlewares.forEach { $0.before(request: request, with: parameters) }
			let (data, _) = try await send(request: request)
			return data
		} catch {
			middlewares.forEach { $0.onError(error, requestParameters: parameters) }
			throw error
		}
    }
    
    public func sendRequest<RequestModel: Encodable, ResponseModel: Decodable>(
        parameters: RequestParameters,
        body: RequestModel?,
        requestModel: RequestModel.Type?,
        responseModel: ResponseModel.Type
    ) async throws -> ResponseModel {
		do {
			let request = try request(parameters: parameters, body: body, requestModel: RequestModel.self)
			middlewares.forEach { $0.before(request: request, with: parameters) }
			let (data, _) = try await send(request: request)
			return try decode(model: ResponseModel.self, from: data)
		} catch {
			middlewares.forEach { $0.onError(error, requestParameters: parameters) }
			throw error
		}
    }
    
    public func download(
        parameters: RequestParameters
    ) async throws -> URL {
		do {
			let request = try request(
				parameters: parameters,
				body: nil,
				requestModel: EncodableDummy.self
			)
			middlewares.forEach { $0.before(request: request, with: parameters) }
			let (url, response) = try await networkHandler.download(for: request, delegate: nil)
			guard let response = response as? HTTPURLResponse else {
				throw NetworkError.invalidResponse
			}

			NotificationCenter.default.post(
				Notification(
					name: Notification.Name.VRNetworking.didCompleteRequest,
					object: nil,
					userInfo: [
						Notification.Key.url: url,
						Notification.Key.request: request,
						Notification.Key.response: response
					]
				)
			)
			middlewares.forEach {
				$0.onFinish(
					request: request,
					data: url.absoluteString.data(using: .utf8) ?? Data(),
					response: response
				)
			}
			
			switch response.statusCode {
				case 200...299:
					return url
				default:
					throw NetworkError.invalidResponseCode(responseCode: response.statusCode, response: response)
			}
		} catch {
			let errorToThrow: Error
			if type(of: error) != NetworkError.self {
				errorToThrow = NetworkError.otherError(error)
			} else {
				errorToThrow = error
			}
			middlewares.forEach { $0.onError(errorToThrow, requestParameters: parameters) }
			throw errorToThrow
		}
    }
    
    public func sendMultipartRequest<ResponseModel: Decodable>(
        parameters: RequestParameters,
        multipartData: [MultipartData],
        responseModel: ResponseModel.Type
    ) async throws -> ResponseModel {
		do {
			var request = try request(parameters: parameters, body: nil, requestModel: EncodableDummy.self)
			middlewares.forEach { $0.before(request: request, with: parameters) }
			let multipartRequest = MultipartRequest()
			multipartData.forEach { _ = multipartRequest.adding(multipartData: $0) }
			
			request.setValue("multipart/form-data; boundary=\(multipartRequest.boundary)", forHTTPHeaderField: "Content-Type")
			request.httpBody = multipartRequest.finalized().httpBody as Data
			
			let (data, _) = try await send(request: request)
			return try decode(model: ResponseModel.self, from: data)
		} catch {
			middlewares.forEach { $0.onError(error, requestParameters: parameters) }
			throw error
		}
    }
    
    public func sendMultipartRequest(
        parameters: RequestParameters,
        multipartData: [MultipartData]
    ) async throws -> Data {
		do {
			var request = try request(parameters: parameters, body: nil, requestModel: EncodableDummy.self)
			middlewares.forEach { $0.before(request: request, with: parameters) }
			let multipartRequest = MultipartRequest()
			multipartData.forEach { _ = multipartRequest.adding(multipartData: $0) }
			
			request.setValue("multipart/form-data; boundary=\(multipartRequest.boundary)", forHTTPHeaderField: "Content-Type")
			request.httpBody = multipartRequest.finalized().httpBody as Data
			
			let (data, _) = try await send(request: request)
			return data
		} catch {
			middlewares.forEach { $0.onError(error, requestParameters: parameters) }
			throw error
		}
    }
}

private extension DefaultNetworkService {
    private func send(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await networkHandler.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            NotificationCenter.default.post(
                Notification(
                    name: Notification.Name.VRNetworking.didCompleteRequest,
                    object: nil,
                    userInfo: [
                        Notification.Key.data: data,
                        Notification.Key.request: request,
                        Notification.Key.response: response
                    ]
                )
            )
			middlewares.forEach { $0.onFinish(request: request, data: data, response: response) }
            
            switch response.statusCode {
                case 200...299:
                    return (data, response)
                    
                case 500:
                    guard let apiError = try? decode(model: APIError.self, from: data) else {
                        throw NetworkError.invalidResponseCode(responseCode: response.statusCode, response: response)
                    }
					throw NetworkError.apiError(message: apiError.message, response: response)
                    
                default:
                    throw NetworkError.invalidResponseCode(responseCode: response.statusCode, response: response)
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
