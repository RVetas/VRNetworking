//
//  NetworkMiddleware.swift
//  
//
//  Created by Виталий Рамазанов on 29.01.2023.
//

import Foundation

public protocol NetworkMiddleware {
	func before(request: URLRequest, with parameters: RequestParameters)
}
