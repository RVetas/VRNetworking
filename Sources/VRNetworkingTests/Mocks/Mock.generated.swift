// Generated using Sourcery 2.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
























public class DecodesJSONMock: DecodesJSON {

    public init() {}



    //MARK: - decode<T>

    public var decodeFromThrowableError: Error?
    public var decodeFromCallsCount = 0
    public var decodeFromCalled: Bool {
        return decodeFromCallsCount > 0
    }
    public var decodeFromReceivedArguments: (type: T.Type, data: Data)?
    public var decodeFromReceivedInvocations: [(type: T.Type, data: Data)] = []
    public var decodeFromReturnValue: T where T: Decodable!
    public var decodeFromClosure: ((T.Type, Data) throws -> T where T: Decodable)?

    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        if let error = decodeFromThrowableError {
            throw error
        }
        decodeFromCallsCount += 1
        decodeFromReceivedArguments = (type: type, data: data)
        decodeFromReceivedInvocations.append((type: type, data: data))
        if let decodeFromClosure = decodeFromClosure {
            return try decodeFromClosure(type, data)
        } else {
            return decodeFromReturnValue
        }
    }

}
public class EncodesJSONMock: EncodesJSON {

    public init() {}



    //MARK: - encode<T>

    public var encodeThrowableError: Error?
    public var encodeCallsCount = 0
    public var encodeCalled: Bool {
        return encodeCallsCount > 0
    }
    public var encodeReceivedValue: T?
    public var encodeReceivedInvocations: [T] = []
    public var encodeReturnValue: Data where T: Encodable!
    public var encodeClosure: ((T) throws -> Data where T: Encodable)?

    public func encode<T>(_ value: T) throws -> Data where T: Encodable {
        if let error = encodeThrowableError {
            throw error
        }
        encodeCallsCount += 1
        encodeReceivedValue = value
        encodeReceivedInvocations.append(value)
        if let encodeClosure = encodeClosure {
            return try encodeClosure(value)
        } else {
            return encodeReturnValue
        }
    }

}
public class HandlesNetworkMock: HandlesNetwork {

    public init() {}



    //MARK: - data

    public var dataForDelegateThrowableError: Error?
    public var dataForDelegateCallsCount = 0
    public var dataForDelegateCalled: Bool {
        return dataForDelegateCallsCount > 0
    }
    public var dataForDelegateReceivedArguments: (request: URLRequest, delegate: URLSessionTaskDelegate?)?
    public var dataForDelegateReceivedInvocations: [(request: URLRequest, delegate: URLSessionTaskDelegate?)] = []
    public var dataForDelegateReturnValue: (Data, URLResponse)!
    public var dataForDelegateClosure: ((URLRequest, URLSessionTaskDelegate?) async throws -> (Data, URLResponse))?

    public func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        if let error = dataForDelegateThrowableError {
            throw error
        }
        dataForDelegateCallsCount += 1
        dataForDelegateReceivedArguments = (request: request, delegate: delegate)
        dataForDelegateReceivedInvocations.append((request: request, delegate: delegate))
        if let dataForDelegateClosure = dataForDelegateClosure {
            return try await dataForDelegateClosure(request, delegate)
        } else {
            return dataForDelegateReturnValue
        }
    }

    //MARK: - download

    public var downloadForDelegateThrowableError: Error?
    public var downloadForDelegateCallsCount = 0
    public var downloadForDelegateCalled: Bool {
        return downloadForDelegateCallsCount > 0
    }
    public var downloadForDelegateReceivedArguments: (request: URLRequest, delegate: URLSessionTaskDelegate?)?
    public var downloadForDelegateReceivedInvocations: [(request: URLRequest, delegate: URLSessionTaskDelegate?)] = []
    public var downloadForDelegateReturnValue: (URL, URLResponse)!
    public var downloadForDelegateClosure: ((URLRequest, URLSessionTaskDelegate?) async throws -> (URL, URLResponse))?

    public func download(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (URL, URLResponse) {
        if let error = downloadForDelegateThrowableError {
            throw error
        }
        downloadForDelegateCallsCount += 1
        downloadForDelegateReceivedArguments = (request: request, delegate: delegate)
        downloadForDelegateReceivedInvocations.append((request: request, delegate: delegate))
        if let downloadForDelegateClosure = downloadForDelegateClosure {
            return try await downloadForDelegateClosure(request, delegate)
        } else {
            return downloadForDelegateReturnValue
        }
    }

}
public class NetworkServiceMock: NetworkService {

    public init() {}



    //MARK: - sendRequest<RequestModel: Encodable, ResponseModel: Decodable>

    public var sendRequestParametersBodyRequestModelResponseModelThrowableError: Error?
    public var sendRequestParametersBodyRequestModelResponseModelCallsCount = 0
    public var sendRequestParametersBodyRequestModelResponseModelCalled: Bool {
        return sendRequestParametersBodyRequestModelResponseModelCallsCount > 0
    }
    public var sendRequestParametersBodyRequestModelResponseModelReceivedArguments: (parameters: RequestParameters, body: RequestModel?, requestModel: RequestModel.Type?, responseModel: ResponseModel.Type)?
    public var sendRequestParametersBodyRequestModelResponseModelReceivedInvocations: [(parameters: RequestParameters, body: RequestModel?, requestModel: RequestModel.Type?, responseModel: ResponseModel.Type)] = []
    public var sendRequestParametersBodyRequestModelResponseModelReturnValue: ResponseModel!
    public var sendRequestParametersBodyRequestModelResponseModelClosure: ((RequestParameters, RequestModel?, RequestModel.Type?, ResponseModel.Type) async throws -> ResponseModel)?

    public func sendRequest<RequestModel: Encodable, ResponseModel: Decodable>(parameters: RequestParameters, body: RequestModel?, requestModel: RequestModel.Type?, responseModel: ResponseModel.Type) async throws -> ResponseModel {
        if let error = sendRequestParametersBodyRequestModelResponseModelThrowableError {
            throw error
        }
        sendRequestParametersBodyRequestModelResponseModelCallsCount += 1
        sendRequestParametersBodyRequestModelResponseModelReceivedArguments = (parameters: parameters, body: body, requestModel: requestModel, responseModel: responseModel)
        sendRequestParametersBodyRequestModelResponseModelReceivedInvocations.append((parameters: parameters, body: body, requestModel: requestModel, responseModel: responseModel))
        if let sendRequestParametersBodyRequestModelResponseModelClosure = sendRequestParametersBodyRequestModelResponseModelClosure {
            return try await sendRequestParametersBodyRequestModelResponseModelClosure(parameters, body, requestModel, responseModel)
        } else {
            return sendRequestParametersBodyRequestModelResponseModelReturnValue
        }
    }

    //MARK: - sendRequest<RequestModel: Encodable>

    public var sendRequestParametersBodyRequestModelThrowableError: Error?
    public var sendRequestParametersBodyRequestModelCallsCount = 0
    public var sendRequestParametersBodyRequestModelCalled: Bool {
        return sendRequestParametersBodyRequestModelCallsCount > 0
    }
    public var sendRequestParametersBodyRequestModelReceivedArguments: (parameters: RequestParameters, body: RequestModel?, requestModel: RequestModel.Type?)?
    public var sendRequestParametersBodyRequestModelReceivedInvocations: [(parameters: RequestParameters, body: RequestModel?, requestModel: RequestModel.Type?)] = []
    public var sendRequestParametersBodyRequestModelReturnValue: Data!
    public var sendRequestParametersBodyRequestModelClosure: ((RequestParameters, RequestModel?, RequestModel.Type?) async throws -> Data)?

    public func sendRequest<RequestModel: Encodable>(parameters: RequestParameters, body: RequestModel?, requestModel: RequestModel.Type?) async throws -> Data {
        if let error = sendRequestParametersBodyRequestModelThrowableError {
            throw error
        }
        sendRequestParametersBodyRequestModelCallsCount += 1
        sendRequestParametersBodyRequestModelReceivedArguments = (parameters: parameters, body: body, requestModel: requestModel)
        sendRequestParametersBodyRequestModelReceivedInvocations.append((parameters: parameters, body: body, requestModel: requestModel))
        if let sendRequestParametersBodyRequestModelClosure = sendRequestParametersBodyRequestModelClosure {
            return try await sendRequestParametersBodyRequestModelClosure(parameters, body, requestModel)
        } else {
            return sendRequestParametersBodyRequestModelReturnValue
        }
    }

    //MARK: - sendMultipartRequest<ResponseModel: Decodable>

    public var sendMultipartRequestParametersMultipartDataResponseModelThrowableError: Error?
    public var sendMultipartRequestParametersMultipartDataResponseModelCallsCount = 0
    public var sendMultipartRequestParametersMultipartDataResponseModelCalled: Bool {
        return sendMultipartRequestParametersMultipartDataResponseModelCallsCount > 0
    }
    public var sendMultipartRequestParametersMultipartDataResponseModelReceivedArguments: (parameters: RequestParameters, multipartData: [MultipartData], responseModel: ResponseModel.Type)?
    public var sendMultipartRequestParametersMultipartDataResponseModelReceivedInvocations: [(parameters: RequestParameters, multipartData: [MultipartData], responseModel: ResponseModel.Type)] = []
    public var sendMultipartRequestParametersMultipartDataResponseModelReturnValue: ResponseModel!
    public var sendMultipartRequestParametersMultipartDataResponseModelClosure: ((RequestParameters, [MultipartData], ResponseModel.Type) async throws -> ResponseModel)?

    public func sendMultipartRequest<ResponseModel: Decodable>(parameters: RequestParameters, multipartData: [MultipartData], responseModel: ResponseModel.Type) async throws -> ResponseModel {
        if let error = sendMultipartRequestParametersMultipartDataResponseModelThrowableError {
            throw error
        }
        sendMultipartRequestParametersMultipartDataResponseModelCallsCount += 1
        sendMultipartRequestParametersMultipartDataResponseModelReceivedArguments = (parameters: parameters, multipartData: multipartData, responseModel: responseModel)
        sendMultipartRequestParametersMultipartDataResponseModelReceivedInvocations.append((parameters: parameters, multipartData: multipartData, responseModel: responseModel))
        if let sendMultipartRequestParametersMultipartDataResponseModelClosure = sendMultipartRequestParametersMultipartDataResponseModelClosure {
            return try await sendMultipartRequestParametersMultipartDataResponseModelClosure(parameters, multipartData, responseModel)
        } else {
            return sendMultipartRequestParametersMultipartDataResponseModelReturnValue
        }
    }

    //MARK: - sendMultipartRequest

    public var sendMultipartRequestParametersMultipartDataThrowableError: Error?
    public var sendMultipartRequestParametersMultipartDataCallsCount = 0
    public var sendMultipartRequestParametersMultipartDataCalled: Bool {
        return sendMultipartRequestParametersMultipartDataCallsCount > 0
    }
    public var sendMultipartRequestParametersMultipartDataReceivedArguments: (parameters: RequestParameters, multipartData: [MultipartData])?
    public var sendMultipartRequestParametersMultipartDataReceivedInvocations: [(parameters: RequestParameters, multipartData: [MultipartData])] = []
    public var sendMultipartRequestParametersMultipartDataReturnValue: Data!
    public var sendMultipartRequestParametersMultipartDataClosure: ((RequestParameters, [MultipartData]) async throws -> Data)?

    public func sendMultipartRequest(parameters: RequestParameters, multipartData: [MultipartData]) async throws -> Data {
        if let error = sendMultipartRequestParametersMultipartDataThrowableError {
            throw error
        }
        sendMultipartRequestParametersMultipartDataCallsCount += 1
        sendMultipartRequestParametersMultipartDataReceivedArguments = (parameters: parameters, multipartData: multipartData)
        sendMultipartRequestParametersMultipartDataReceivedInvocations.append((parameters: parameters, multipartData: multipartData))
        if let sendMultipartRequestParametersMultipartDataClosure = sendMultipartRequestParametersMultipartDataClosure {
            return try await sendMultipartRequestParametersMultipartDataClosure(parameters, multipartData)
        } else {
            return sendMultipartRequestParametersMultipartDataReturnValue
        }
    }

    //MARK: - download

    public var downloadParametersThrowableError: Error?
    public var downloadParametersCallsCount = 0
    public var downloadParametersCalled: Bool {
        return downloadParametersCallsCount > 0
    }
    public var downloadParametersReceivedParameters: RequestParameters?
    public var downloadParametersReceivedInvocations: [RequestParameters] = []
    public var downloadParametersReturnValue: URL!
    public var downloadParametersClosure: ((RequestParameters) async throws -> URL)?

    public func download(parameters: RequestParameters) async throws -> URL {
        if let error = downloadParametersThrowableError {
            throw error
        }
        downloadParametersCallsCount += 1
        downloadParametersReceivedParameters = parameters
        downloadParametersReceivedInvocations.append(parameters)
        if let downloadParametersClosure = downloadParametersClosure {
            return try await downloadParametersClosure(parameters)
        } else {
            return downloadParametersReturnValue
        }
    }

}
