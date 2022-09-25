// Created by Рамазанов Виталий Глебович on 18/09/22

import Foundation

public protocol HandlesNetwork {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
    func download(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws  -> (URL, URLResponse)
}
