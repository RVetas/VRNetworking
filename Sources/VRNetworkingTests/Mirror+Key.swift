// Created by Рамазанов Виталий Глебович on 18/09/22

extension Mirror {
    static func value<T>(of object: Any, forKey key: String) -> T? {
        Mirror(reflecting: object).value(forKey: key)
    }
    
    func value<T>(forKey key: String) -> T? {
        children.first(where: { label, _ in label == key })?.value as? T
    }
}
