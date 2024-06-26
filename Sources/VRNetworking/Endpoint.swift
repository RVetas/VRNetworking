// Created by Рамазанов Виталий Глебович on 18/09/22

import Foundation

public struct Endpoint: Equatable {
    public let scheme: String
    public let host: String
    public let path: String
	public let port: Int?
	public let query: [String: String?]?
	
    public init(
        scheme: String,
        host: String,
		port: Int? = nil,
        path: String,
		query: [String: String?]? = nil
    ) {
        self.scheme = scheme
        self.host = host
		self.port = port
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
		self.port = components.port
		self.query = components.queryItems?.compactMap { $0 }.reduce(into: [String: String?]()) { dictionary, query in
			dictionary[query.name] = query.value
		}
    }
}

extension Endpoint: CustomDebugStringConvertible {
    public var debugDescription: String {
		"\(scheme)\(host)\(port.flatMap { ":\($0.description)" } ?? "")\(path)"
    }
}
