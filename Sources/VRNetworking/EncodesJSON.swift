// Created by Рамазанов Виталий Глебович on 18/09/22

import Foundation

public protocol EncodesJSON {
    func encode<T>(_ value: T) throws -> Data where T: Encodable
}
