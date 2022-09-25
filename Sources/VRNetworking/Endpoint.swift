// Created by Рамазанов Виталий Глебович on 18/09/22

import Foundation

public struct Endpoint {
    public let scheme: String
    public let host: String
    public let path: String

    public init(
        scheme: String,
        host: String,
        path: String
    ) {
        self.scheme = scheme
        self.host = host
        self.path = path
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
    }
}
