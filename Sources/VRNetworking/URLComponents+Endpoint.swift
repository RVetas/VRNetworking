// Created by Рамазанов Виталий Глебович on 18/09/22

import Foundation

public extension URLComponents {
    init(from endpoint: Endpoint) {
        self.init()
        scheme = endpoint.scheme
        host = endpoint.host
        path = endpoint.path
		percentEncodedQueryItems = endpoint.query.map {
			URLQueryItem(name: $0, value: $1)
		}
    }
}
