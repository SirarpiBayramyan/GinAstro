//
//  UserDefaults.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 15.02.25.
//

import Foundation

extension UserDefaults {
    
    private var cachedUserKey: String { "cachedUser" }

    var cachedUser: User? {
        get {
            if let data = data(forKey: cachedUserKey) {
                return try? JSONDecoder().decode(User.self, from: data)
            }
            return nil
        }
        set {
            if let newValue = newValue {
                if let data = try? JSONEncoder().encode(newValue) {
                    set(data, forKey: cachedUserKey)
                }
            } else {
                removeObject(forKey: cachedUserKey)
            }
        }
    }
}
