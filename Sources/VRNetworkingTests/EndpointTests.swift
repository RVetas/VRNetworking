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
}

private extension EndpointTests {
    enum TestData {
        static let invalidString = "';dslf"
        static let invalidHostString = "https://🧐/api/v1/method"
        static let invalidSchemeString = ";lk/example.com/api/v1/method"
        static let validString = "https://example.com/api/v1/method"
        static let scheme = "https"
        static let host = "example.com"
        static let path = "/api/v1/method"
    }
}
