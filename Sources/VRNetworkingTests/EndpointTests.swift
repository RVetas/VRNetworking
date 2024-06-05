// Created by Рамазанов Виталий Глебович on 19/09/22

import XCTest
import VRNetworking

final class EndpointTests: XCTestCase {
    func testInitWithValidString() {
        // when
        let endpoint = Endpoint(string: TestData.validString)!
        // then
        XCTAssertEqual(endpoint.scheme, TestData.scheme)
        XCTAssertEqual(endpoint.host, TestData.host)
        XCTAssertEqual(endpoint.path, TestData.path)
    }
    
    func testInitWithInvalidString() {
        // then
        XCTAssertNil(Endpoint(string: TestData.invalidString))
    }
    
    func testInitWithInvalidHostString() {
        // then
        XCTAssertNil(Endpoint(string: TestData.invalidHostString))
    }
    
    func testInitWithInvalidSchemeString() {
        // then
        XCTAssertNil(Endpoint(string: TestData.invalidSchemeString))
    }
	
	func testWithQuery() {
		let endpoint = Endpoint(string: TestData.withQuery)
		XCTAssertEqual(endpoint?.query, TestData.expectedQuery)
		XCTAssertEqual(URLComponents(from: endpoint!).queryItems, TestData.expectedQueryItems)
	}
	
	func testWithEmptyQueryFullInit() {
		let endpoint = Endpoint(scheme: "https", host: "example.com", path: "")
		XCTAssertEqual(URLComponents(from: endpoint).url?.absoluteString, "https://example.com")
	}
	
	func testWithEmptyQueryStringInit() {
		let endpoint = Endpoint(string: "https://example.com")
		XCTAssertEqual(URLComponents(from: endpoint!).url?.absoluteString, "https://example.com")
	}
	
	func testWithPort() {
		let endpoint = Endpoint(string: TestData.localhostWithPort)!
		XCTAssertEqual(URLComponents(from: endpoint).url?.absoluteString, TestData.localhostWithPort)
	}
}

private extension EndpointTests {
    enum TestData {
        static let invalidString = "';dslf"
        static let invalidHostString = "https://\\:2433/api/v1/method"
        static let invalidSchemeString = ";lk/example.com/api/v1/method"
        static let validString = "https://example.com/api/v1/method"
        static let scheme = "https"
        static let host = "example.com"
        static let path = "/api/v1/method"
		static let withQuery = "https://example.com/api/v1/method?item=value"
		static let expectedQuery = ["item": "value"]
		static let expectedQueryItems = [URLQueryItem(name: "item", value: "value")]
		static let localhostWithPort = "http://localhost:1234/api/v1/method?item=value"
    }
}
