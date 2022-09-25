// Created by Рамазанов Виталий Глебович on 18/09/22

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case encodingError(EncodingError?)
    case decodingError(DecodingError?)
    case otherError(Error)
    case invalidResponseCode(responseCode: Int)
}
