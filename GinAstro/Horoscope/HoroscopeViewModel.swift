//
//  HoroscopeViewModel.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 17.02.25.
//

import Foundation
import Combine

enum HoroscopeState {
    case idle
    case loading
    case success(String)
    case failure(Error)
}

class HoroscopeViewModel: ObservableObject {

    @Published var state: HoroscopeState = .idle
    var cancellables = Set<AnyCancellable>()
    var category: ContentCategory

    init(category: ContentCategory) {
        self.category = category
    }

    lazy var intentHandler: HoroscopeIntentHandler = {
        DefaultHoroscopeIntentHandler(contentService: contentService, viewModel: self)
    }()

    private let contentService =  ContentGeneratorService()

}

