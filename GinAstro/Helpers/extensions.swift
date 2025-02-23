//
//  extensions.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 23.02.25.
//

import UIKit

// Helper Extensions
extension UIImage {
    func toBase64() -> String {
        return self.jpegData(compressionQuality: 0.8)?.base64EncodedString() ?? ""
    }
}
