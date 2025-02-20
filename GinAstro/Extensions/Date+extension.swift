//
//  Date+extension.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 19.02.25.
//

import Foundation

extension Date {

    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

}

