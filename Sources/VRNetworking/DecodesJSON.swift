// Created by Рамазанов Виталий Глебович on 18/09/22

import Foundation

public protocol DecodesJSON {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}
