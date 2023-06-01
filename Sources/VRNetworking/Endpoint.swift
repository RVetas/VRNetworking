// Created by Рамазанов Виталий Глебович on 18/09/22

import Foundation

public struct Endpoint: Equatable {
    public let scheme: String
    public let host: String
    public let path: String
	public let query: [String: String?]
	
    public init(
        scheme: String,
        host: String,
        path: String,
		query: [String: String?] = [:]
    ) {
        self.scheme = scheme
        self.host = host
        self.path = path
		self.query = query
    }
    
    public init?(string: String) {
        guard
            let components = URLComponents(string: string),
            let scheme = components.scheme,
            let host = components.host
        else {
            return nil
        }
        self.scheme = scheme
        self.host = host
        self.path = components.path
		self.query = components.queryItems?.compactMap { $0 }.reduce(into: [String: String?]()) { dictionary, query in
			dictionary[query.name] = query.value
		} ?? [String: String?]()
    }
}

extension Endpoint: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(scheme)\(host)\(path)"
    }
}
