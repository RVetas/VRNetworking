// Created by Рамазанов Виталий Глебович on 18/09/22

import XCTest
import VRNetworking

final class DefaultNetworkServiceTests: XCTestCase {

    var service: DefaultNetworkService!
    var networkHandlerMock: HandlesNetworkMock!
    var encoderMock: EncoderMock!
	var middlewareMock: NetworkMiddlewareMock!
    fileprivate var decoderMock: DecoderMock<TestData.ResponseType>!
    
    override func setUp() {
        networkHandlerMock = HandlesNetworkMock()
        encoderMock = EncoderMock()
        decoderMock = DecoderMock<TestData.ResponseType>()
		middlewareMock = NetworkMiddlewareMock()
		
        service = DefaultNetworkService(
            networkHandler: networkHandlerMock!,
            encoder: encoderMock,
            decoder: decoderMock,
			middlewares: [middlewareMock]
        )
    }
    
    /* MARK: -
         public func sendRequest<RequestModel: Encodable, ResponseModel: Decodable>(
             parameters: RequestParameters,
             body: RequestModel?,
             requestModel: RequestModel.Type?,
             responseModel: ResponseModel.Type
         )
    */
    
    func testDefaultInitParameters() {
        // given
        let service = DefaultNetworkService()
        
        // when
        let networkHandler: URLSession? = Mirror.value(of: service, forKey: "networkHandler")
        let encoder: JSONEncoder? = Mirror.value(of: service, forKey: "encoder")
        let decoder: JSONDecoder? = Mirror.value(of: service, forKey: "decoder")
        
        XCTAssertNotNil(networkHandler)
        XCTAssertEqual(networkHandler?.configuration, URLSessionConfiguration.default)
        
        XCTAssertNotNil(encoder)
        XCTAssertNotNil(decoder)
    }
    
    func testInvalidURL() async {
        do {
            // when
            _ = try await service.sendRequest(parameters: TestData.InvalidURL.requestParameters, responseModel: Data.self)
            XCTFail("Should throw NetworkService.invalidURL")
        } catch {
            // then
            XCTAssertEqual(error as! NetworkError, NetworkError.invalidURL)
        }
    }
    
    func testValidCall() async {
        // given
        networkHandlerMock.dataForDelegateReturnValue = (Data(), TestData.ValidData.response)
        encoderMock.encodeStub = Data()
        decoderMock.decodeStub = TestData.ResponseType()
        // when
        do {
            let response = try await service.sendRequest(
                parameters: TestData.ValidData.requestParameters,
                body: EncodableDummy(),
                requestModel: nil,
                responseModel: TestData.ResponseType.self
            )
            // then
            XCTAssertEqual(networkHandlerMock.dataForDelegateCallsCount, 1)
            XCTAssertEqual(response, networkHandlerMock.dataForDelegateReturnValue!.0)
            XCTAssertEqual(networkHandlerMock.dataForDelegateReceivedArguments!.request, TestData.ValidData.expectedRequest)
            XCTAssertNil(networkHandlerMock.dataForDelegateReceivedArguments!.delegate)
            XCTAssertEqual(encoderMock.encodeWasCalled, 1)
            XCTAssertEqual(decoderMock.decodeWasCalled, 1)
            XCTAssertEqual(response, decoderMock.decodeStub)
			XCTAssertEqual(middlewareMock.beforeRequestWithCallsCount, 1)
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.parameters, TestData.ValidData.requestParameters)
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.request, TestData.ValidData.expectedRequest)
        } catch {
            XCTFail("Method should not throw")
        }
    }
    
    func testInvalidEncoding() async {
        // given
        networkHandlerMock.dataForDelegateReturnValue = (Data(), TestData.ValidData.response)
        encoderMock.encodeError = TestData.InvalidEncoding.encodingError
        decoderMock.decodeStub = TestData.ResponseType()
        // when
        do {
            _ = try await service.sendRequest(
                parameters: TestData.ValidData.requestParameters,
                body: EncodableDummy(),
                requestModel: nil,
                responseModel: TestData.ResponseType.self
            )
        } catch {
            if case let .encodingError(encodingError) = error as? NetworkError {
                guard encodingError != nil else {
                    XCTFail("Method should throw encoding error")
                    return
                }
				XCTAssertEqual(middlewareMock.onErrorRequestParametersCallsCount, 1)
				XCTAssertEqual(middlewareMock.onErrorRequestParametersReceivedArguments?.requestParameters, TestData.ValidData.requestParameters)
				XCTAssertTrue(middlewareMock.onErrorRequestParametersReceivedArguments?.error is NetworkError)
                XCTAssertTrue(true)
            } else {
                XCTFail("Method should throw encoding error")
            }
        }
    }
    
    func testInvalidDecoding() async {
        // given
        networkHandlerMock.dataForDelegateReturnValue = (Data(), TestData.ValidData.response)
        encoderMock.encodeStub = TestData.ResponseType()
        decoderMock.decodeError = TestData.InvalidDecoding.error
        // when
        do {
            _ = try await service.sendRequest(
                parameters: TestData.ValidData.requestParameters,
                body: EncodableDummy(),
                requestModel: nil,
                responseModel: TestData.ResponseType.self
            )
        } catch {
            if case let .decodingError(encodingError) = error as? NetworkError {
                guard encodingError != nil else {
                    XCTFail("Method should throw encoding error")
                    return
                }
                
				XCTAssertEqual(middlewareMock.onErrorRequestParametersCallsCount, 1)
				XCTAssertEqual(middlewareMock.onErrorRequestParametersReceivedArguments?.requestParameters, TestData.ValidData.requestParameters)
				XCTAssertTrue(middlewareMock.onErrorRequestParametersReceivedArguments?.error is NetworkError)
                XCTAssertTrue(true)
            } else {
                XCTFail("Method should throw encoding error")
            }
        }
    }
    
    func testInvalidResponseCode() async {
        // given
        networkHandlerMock.dataForDelegateReturnValue = (Data(), TestData.ValidData.response)
        encoderMock.encodeStub = Data()
        decoderMock.decodeStub = TestData.ResponseType()
        // when
        do {
            _ = try await service.sendRequest(
                parameters: TestData.InvalidResponseCode.requestParameters,
                body: EncodableDummy(),
                requestModel: nil,
                responseModel: TestData.ResponseType.self
            )
        } catch {
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.parameters, TestData.ValidData.requestParameters)
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.request, TestData.ValidData.expectedRequest)
			XCTAssertEqual(middlewareMock.onErrorRequestParametersCallsCount, 1)
			XCTAssertEqual(middlewareMock.onErrorRequestParametersReceivedArguments?.requestParameters, TestData.ValidData.requestParameters)
			XCTAssertTrue(middlewareMock.onErrorRequestParametersReceivedArguments?.error is NetworkError)
            if case let .invalidResponseCode(responseCode: code) = error as? NetworkError {
                XCTAssertEqual(code, 500)
            } else {
                XCTFail("Method should throw invalidResponseCode error")
            }
        }
    }
    
    func testInvalidResponse() async {
        // given
        networkHandlerMock.dataForDelegateReturnValue = (Data(), URLResponse())
        encoderMock.encodeStub = Data()
        decoderMock.decodeStub = TestData.ResponseType()
        // when
        do {
            _ = try await service.sendRequest(
                parameters: TestData.InvalidResponseCode.requestParameters,
                body: EncodableDummy(),
                requestModel: nil,
                responseModel: TestData.ResponseType.self
            )
        } catch {
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.parameters, TestData.ValidData.requestParameters)
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.request, TestData.ValidData.expectedRequest)
			XCTAssertEqual(middlewareMock.onErrorRequestParametersCallsCount, 1)
			XCTAssertEqual(middlewareMock.onErrorRequestParametersReceivedArguments?.requestParameters, TestData.ValidData.requestParameters)
			XCTAssertTrue(middlewareMock.onErrorRequestParametersReceivedArguments?.error is NetworkError)
            if case .invalidResponse = error as? NetworkError {
                XCTAssertTrue(true)
            } else {
                XCTFail("Method should throw invalidResponse error")
            }
        }
    }
    
    func testNetworkHandlerError() async {
        // given
        networkHandlerMock.dataForDelegateThrowableError = ErrorDummy.err
        encoderMock.encodeStub = Data()
        decoderMock.decodeStub = TestData.ResponseType()
        
        do {
            _ = try await service.sendRequest(
                parameters: TestData.InvalidResponseCode.requestParameters,
                body: EncodableDummy(),
                requestModel: nil,
                responseModel: TestData.ResponseType.self
            )
        } catch {
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.parameters, TestData.ValidData.requestParameters)
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.request, TestData.ValidData.expectedRequest)
			XCTAssertEqual(middlewareMock.onErrorRequestParametersCallsCount, 1)
			XCTAssertEqual(middlewareMock.onErrorRequestParametersReceivedArguments?.requestParameters, TestData.ValidData.requestParameters)
			XCTAssertTrue(middlewareMock.onErrorRequestParametersReceivedArguments?.error is NetworkError)
            if
                case let .otherError(error) = error as? NetworkError,
                case .err = error as? ErrorDummy
            {
                XCTAssertTrue(true)
            } else {
                XCTFail("Method should throw ServiceError.other(ErrorDummy.err)")
            }
        }
    }
    
    /* MARK: -
         public func sendRequest<RequestModel: Encodable>(
             parameters: RequestParameters,
             body: RequestModel?,
             requestModel: RequestModel.Type?
         ) async throws
     */
    func testValidCallWithoutReturnType() async {
        // given
        networkHandlerMock.dataForDelegateReturnValue = (TestData.data, TestData.ValidData.response)
        // when
        do {
            let result = try await service.sendRequest(
                parameters: TestData.ValidData.requestParameters
            )
            // then
            XCTAssertEqual(result, TestData.data)
            XCTAssertEqual(networkHandlerMock.dataForDelegateCallsCount, 1)
            XCTAssertEqual(networkHandlerMock.dataForDelegateReceivedArguments!.request, TestData.ValidData.expectedRequest)
            XCTAssertNil(networkHandlerMock.dataForDelegateReceivedArguments!.delegate)
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.parameters, TestData.ValidData.requestParameters)
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.request, TestData.ValidData.expectedRequest)
        } catch {
            XCTFail("Method should not throw")
        }
    }
    
    /* MARK: -
     public func download(
         parameters: RequestParameters
     ) async throws -> URL
     */
    func testValidDownloadCall() async {
        // given
        networkHandlerMock.downloadForDelegateReturnValue = (TestData.Download.url, TestData.Download.response)

        do {
            // when
            let result = try await service.download(parameters: TestData.Download.requestParameters)
            
            // then
            XCTAssertEqual(result, TestData.Download.url)
            XCTAssertEqual(networkHandlerMock.downloadForDelegateCallsCount, 1)
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.parameters, TestData.ValidData.requestParameters)
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.request, TestData.ValidData.expectedRequest)
        } catch {
            XCTFail("Should not throw")
        }
    }
    
    func testInvalidDownloadResponseCall() async {
        // given
        networkHandlerMock.downloadForDelegateReturnValue = (TestData.Download.url, TestData.Download.invalidResponse)
        
        do {
            // when
            _ = try await service.download(parameters: TestData.Download.requestParameters)
        } catch {
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.parameters, TestData.ValidData.requestParameters)
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.request, TestData.ValidData.expectedRequest)
			XCTAssertEqual(middlewareMock.onErrorRequestParametersCallsCount, 1)
			XCTAssertEqual(middlewareMock.onErrorRequestParametersReceivedArguments?.requestParameters, TestData.ValidData.requestParameters)
			XCTAssertTrue(middlewareMock.onErrorRequestParametersReceivedArguments?.error is NetworkError)
            guard case .invalidResponse = error as? NetworkError else {
                XCTFail("Invalid error throws")
                return
            }
            XCTAssertTrue(true)
        }
    }
    
    func testInvalidDownloadResponseCodeCall() async {
        // given
        networkHandlerMock.downloadForDelegateReturnValue = (TestData.Download.url, TestData.Download.invalidResponseCode)
        
        do {
            // when
            _ = try await service.download(parameters: TestData.Download.requestParameters)
        } catch {
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.parameters, TestData.ValidData.requestParameters)
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.request, TestData.ValidData.expectedRequest)
			XCTAssertEqual(middlewareMock.onErrorRequestParametersCallsCount, 1)
			XCTAssertEqual(middlewareMock.onErrorRequestParametersReceivedArguments?.requestParameters, TestData.ValidData.requestParameters)
			XCTAssertTrue(middlewareMock.onErrorRequestParametersReceivedArguments?.error is NetworkError)
            guard case let .invalidResponseCode(responseCode: code) = error as? NetworkError else {
                XCTFail("Invalid error throws")
                return
            }
            XCTAssertEqual(code, 500)
            XCTAssertTrue(true)
        }
    }
    
    func testThrowsDownloadCall() async {
        // given
        networkHandlerMock.downloadForDelegateThrowableError = ErrorDummy.err
        
        do {
            // when
            _ = try await service.download(parameters: TestData.Download.requestParameters)
        } catch {
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.parameters, TestData.ValidData.requestParameters)
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.request, TestData.ValidData.expectedRequest)
			XCTAssertEqual(middlewareMock.onErrorRequestParametersCallsCount, 1)
			XCTAssertEqual(middlewareMock.onErrorRequestParametersReceivedArguments?.requestParameters, TestData.ValidData.requestParameters)
			XCTAssertTrue(middlewareMock.onErrorRequestParametersReceivedArguments?.error is NetworkError)
            guard
                case let .otherError(innerError) = error as? NetworkError,
                case .err = innerError as? ErrorDummy
            else {
                XCTFail("Invalid error thrown")
                return
            }
            
            XCTAssertTrue(true)
        }
    }
    
    func testThrowsNetworkErrorDownloadCall() async {
        // given
        networkHandlerMock.downloadForDelegateThrowableError = NetworkError.invalidURL
        
        do {
            // when
            _ = try await service.download(parameters: TestData.Download.requestParameters)
        } catch {
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.parameters, TestData.ValidData.requestParameters)
			XCTAssertEqual(middlewareMock.beforeRequestWithReceivedArguments?.request, TestData.ValidData.expectedRequest)
			XCTAssertEqual(middlewareMock.onErrorRequestParametersCallsCount, 1)
			XCTAssertEqual(middlewareMock.onErrorRequestParametersReceivedArguments?.requestParameters, TestData.ValidData.requestParameters)
			XCTAssertTrue(middlewareMock.onErrorRequestParametersReceivedArguments?.error is NetworkError)
            guard case .invalidURL = error as? NetworkError else {
                XCTFail("Invalid error thrown")
                return
            }
            
            XCTAssertTrue(true)
        }
    }
}

struct EncodableDummy: Encodable { }

enum ErrorDummy: Error {
    case err
}

private extension DefaultNetworkServiceTests {
    enum TestData {
        typealias RequestType = EncodableDummy
        typealias ResponseType = Data
        
        static let data = "1234".data(using: .utf8)!
        
        enum Download {
            static let url = URL(string: "https://example.com")!
            static let response: HTTPURLResponse = {
                let value = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
                return value!
            }()
            static let requestParameters = RequestParameters(
                endpoint: Endpoint(string: "https://google.com")!,
                requestMethod: .get,
                headers: nil
            )
            
            static let invalidResponse = URLResponse()
            static let invalidResponseCode: HTTPURLResponse = {
                let value = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
                return value!
            }()
        }
        
        enum InvalidURL {
            static let requestParameters = RequestParameters(
                endpoint: Endpoint(scheme: "sdl", host: "asdlk", path: ";;;"),
                requestMethod: .get,
                headers: nil
            )
        }
        
        enum ValidData {
            static let url = URLComponents(from: requestParameters.endpoint).url!
            
            static let response: HTTPURLResponse = {
                let value = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
                return value!
            }()
            
            static let expectedRequest: URLRequest = {
                var request = URLRequest(url: url)
                request.httpMethod = requestParameters.requestMethod.rawValue
                request.allHTTPHeaderFields = requestParameters.headers
                return request
            }()
            
            static let requestParameters = RequestParameters(
                endpoint: Endpoint(scheme: "https", host: "google.com", path: ""),
                requestMethod: .get,
                headers: nil
            )
        }
        
        enum InvalidEncoding {
            static let encodingError = EncodingError.invalidValue((), .init(codingPath: [], debugDescription: "", underlyingError: NSError()))
        }
        
        enum InvalidDecoding {
            static let error = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "", underlyingError: NSError()))
        }
        
        enum InvalidResponseCode {
            static let url = URLComponents(from: requestParameters.endpoint).url!
            
            static let response: HTTPURLResponse = {
                let value = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
                return value!
            }()
            
            static let expectedRequest: URLRequest = {
                var request = URLRequest(url: url)
                request.httpMethod = requestParameters.requestMethod.rawValue
                request.allHTTPHeaderFields = requestParameters.headers
                return request
            }()
            
            static let requestParameters = RequestParameters(
                endpoint: Endpoint(scheme: "https", host: "google.com", path: ""),
                requestMethod: .get,
                headers: nil
            )
        }
    }
}

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
            case (.invalidURL, .invalidURL): return true
            case (.invalidResponse, .invalidResponse): return true
            case (.encodingError, .encodingError): return true
            case (.decodingError, .decodingError): return true
            case (.otherError, .otherError): return true
            case (.invalidResponseCode, .invalidResponseCode): return true
            default: return false
        }
    }
}
