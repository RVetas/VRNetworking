//
//  NetworkMiddleware.swift
//  
//
//  Created by Виталий Рамазанов on 29.01.2023.
//

import Foundation

public protocol NetworkMiddleware {
	func before(request: URLRequest, with parameters: RequestParameters)
	func onError(_ error: Error, requestParameters: RequestParameters)
	func onFinish(request: URLRequest, data: Data, response: HTTPURLResponse)
}

public extension NetworkMiddleware {
	func before(request: URLRequest, with parameters: RequestParameters) { }
	func onError(_ error: Error, requestParameters: RequestParameters) { }
	func onFinish(data: Data, response: HTTPURLResponse) { }
}
