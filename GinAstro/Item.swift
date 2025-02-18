//
//  Item.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 15.02.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
