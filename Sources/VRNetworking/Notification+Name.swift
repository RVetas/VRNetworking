//
//  Notification+Name.swift
//  
//
//  Created by Виталий Рамазанов on 25.09.2022.
//

import Foundation

public extension Notification.Name {
    enum VRNetworking {
        public static let didCompleteRequest = Notification.Name("VRNetworking.notification.name.didCompleteRequest")
    }
}

public extension Notification {
    enum Key {
        public static let url = "VRNetworking.notification.key.url"
        public static let data = "VRNetworking.notification.key.data"
        public static let request = "VRNetworking.notification.key.request"
        public static let response = "VRNetworking.notification.key.response"
    }
}
