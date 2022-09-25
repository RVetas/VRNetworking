import VRNetworking
import Foundation

final class DecoderMock<Result>: DecodesJSON {
    
    var decodeStub: Result?
    var decodeError: Error?
    var decodeWasCalled: Int = 0
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        if let error = decodeError { throw error }
        decodeWasCalled += 1
        return decodeStub as! T
    }
}

final class EncoderMock: EncodesJSON {
    
    var encodeStub: Data?
    var encodeError: Error?
    var encodeWasCalled: Int = 0
    
    func encode<T>(_ value: T) throws -> Data where T: Encodable {
        if let error = encodeError { throw error }
        encodeWasCalled += 1
        return encodeStub!
    }
}

final class HandlesNetworkMock: HandlesNetwork {
    
    var downloadForDelegateThrowableError: Error?
    var downloadForDelegateReceivedRequest: URLRequest?
    var downloadForDelegateReceivedDelegate: URLSessionTaskDelegate?
    var downloadForDelegateStub: (URL, URLResponse)!
    var downloadForDelegateCallsCount: Int = 0
    
    func download(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (URL, URLResponse) {
        if let downloadForDelegateThrowableError = downloadForDelegateThrowableError {
            throw downloadForDelegateThrowableError
        }
        
        downloadForDelegateReceivedRequest = request
        downloadForDelegateReceivedDelegate = delegate
        downloadForDelegateCallsCount += 1
        
        return downloadForDelegateStub!
    }
    
    
    var dataForDelegateThrowableError: Error?
    var dataForDelegateCallsCount = 0
    var dataForDelegateCalled: Bool {
        return dataForDelegateCallsCount > 0
    }
    var dataForDelegateReceivedArguments: (request: URLRequest, delegate: URLSessionTaskDelegate?)?
    var dataForDelegateReceivedInvocations: [(request: URLRequest, delegate: URLSessionTaskDelegate?)] = []
    var dataForDelegateReturnValue: (Data, URLResponse)!

    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        if let error = dataForDelegateThrowableError {
            throw error
        }
        dataForDelegateCallsCount += 1
        dataForDelegateReceivedArguments = (request: request, delegate: delegate)
        dataForDelegateReceivedInvocations.append((request: request, delegate: delegate))
        
        return dataForDelegateReturnValue
    }
    
}
