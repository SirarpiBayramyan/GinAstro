//
//  FullScreenGifView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 23.02.25.
//

import SwiftUI
import UIKit

struct FullScreenGifView: View {
    var body: some View {
        GIFView(gifName: "launch") // Use the name of your GIF file (without .gif)
            .edgesIgnoringSafeArea(.all) // Make it full screen
    }
}


struct GIFView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        if let gif = UIImage.gif(name: gifName) {
            imageView.image = gif
        }
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}
}


// GIF extension to load the GIF properly
extension UIImage {
    public static func gif(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else { return nil }
        guard let imageData = try? Data(contentsOf: bundleURL) else { return nil }
        return gif(data: imageData)
    }

    public static func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        return UIImage.animatedImage(with: (0..<CGImageSourceGetCount(source)).compactMap {
            UIImage(cgImage: CGImageSourceCreateImageAtIndex(source, $0, nil)!
)
        }, duration: 1.0)
    }
}



#Preview {
    FullScreenGifView()
}
