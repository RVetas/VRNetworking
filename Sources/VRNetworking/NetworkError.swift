// Created by Рамазанов Виталий Глебович on 18/09/22

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case encodingError(EncodingError?)
    case decodingError(DecodingError?)
    case otherError(Error)
	case invalidResponseCode(responseCode: Int, response: HTTPURLResponse)
	case apiError(message: String, response: HTTPURLResponse)
}

public struct APIError: Decodable {
    public let message: String
}
