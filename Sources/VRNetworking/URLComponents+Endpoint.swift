// Created by Рамазанов Виталий Глебович on 18/09/22

import Foundation

public extension URLComponents {
    init(from endpoint: Endpoint) {
        self.init()
        scheme = endpoint.scheme
        host = endpoint.host
        path = endpoint.path
		port = endpoint.port
		percentEncodedQueryItems = endpoint.query.flatMap {
			$0.map { key, value in
				URLQueryItem(name: key, value: value)
			}
		}
    }
}
