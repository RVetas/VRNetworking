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
