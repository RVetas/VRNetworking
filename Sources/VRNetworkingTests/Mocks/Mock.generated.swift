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

@testable import VRNetworking























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
public class NetworkMiddlewareMock: NetworkMiddleware {

    public init() {}



    //MARK: - before

    public var beforeRequestWithCallsCount = 0
    public var beforeRequestWithCalled: Bool {
        return beforeRequestWithCallsCount > 0
    }
    public var beforeRequestWithReceivedArguments: (request: URLRequest, parameters: RequestParameters)?
    public var beforeRequestWithReceivedInvocations: [(request: URLRequest, parameters: RequestParameters)] = []
    public var beforeRequestWithClosure: ((URLRequest, RequestParameters) -> Void)?

    public func before(request: URLRequest, with parameters: RequestParameters) {
        beforeRequestWithCallsCount += 1
        beforeRequestWithReceivedArguments = (request: request, parameters: parameters)
        beforeRequestWithReceivedInvocations.append((request: request, parameters: parameters))
        beforeRequestWithClosure?(request, parameters)
    }

    //MARK: - onError

    public var onErrorRequestParametersCallsCount = 0
    public var onErrorRequestParametersCalled: Bool {
        return onErrorRequestParametersCallsCount > 0
    }
    public var onErrorRequestParametersReceivedArguments: (error: Error, requestParameters: RequestParameters)?
    public var onErrorRequestParametersReceivedInvocations: [(error: Error, requestParameters: RequestParameters)] = []
    public var onErrorRequestParametersClosure: ((Error, RequestParameters) -> Void)?

    public func onError(_ error: Error, requestParameters: RequestParameters) {
        onErrorRequestParametersCallsCount += 1
        onErrorRequestParametersReceivedArguments = (error: error, requestParameters: requestParameters)
        onErrorRequestParametersReceivedInvocations.append((error: error, requestParameters: requestParameters))
        onErrorRequestParametersClosure?(error, requestParameters)
    }

    //MARK: - onFinish

    public var onFinishRequestDataResponseCallsCount = 0
    public var onFinishRequestDataResponseCalled: Bool {
        return onFinishRequestDataResponseCallsCount > 0
    }
    public var onFinishRequestDataResponseReceivedArguments: (request: URLRequest, data: Data, response: HTTPURLResponse)?
    public var onFinishRequestDataResponseReceivedInvocations: [(request: URLRequest, data: Data, response: HTTPURLResponse)] = []
    public var onFinishRequestDataResponseClosure: ((URLRequest, Data, HTTPURLResponse) -> Void)?

    public func onFinish(request: URLRequest, data: Data, response: HTTPURLResponse) {
        onFinishRequestDataResponseCallsCount += 1
        onFinishRequestDataResponseReceivedArguments = (request: request, data: data, response: response)
        onFinishRequestDataResponseReceivedInvocations.append((request: request, data: data, response: response))
        onFinishRequestDataResponseClosure?(request, data, response)
    }

    //MARK: - onDownload

    public var onDownloadResponseCallsCount = 0
    public var onDownloadResponseCalled: Bool {
        return onDownloadResponseCallsCount > 0
    }
    public var onDownloadResponseReceivedResponse: HTTPURLResponse?
    public var onDownloadResponseReceivedInvocations: [HTTPURLResponse] = []
    public var onDownloadResponseClosure: ((HTTPURLResponse) -> Void)?

    public func onDownload(response: HTTPURLResponse) {
        onDownloadResponseCallsCount += 1
        onDownloadResponseReceivedResponse = response
        onDownloadResponseReceivedInvocations.append(response)
        onDownloadResponseClosure?(response)
    }

}
