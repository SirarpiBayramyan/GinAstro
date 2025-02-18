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


class HoroscopeIntent: ObservableObject {

    @Published private(set) var state: HoroscopeState = .idle
    private let contentService = ContentGeneratorService()
    private var cancellables = Set<AnyCancellable>()



    func loadHoroscope(for sign: String, period: HoroscopePeriod) {
        state = .loading
        contentService.generateHoroscope(for: sign, period: period)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.state = .failure(error)
                }
            }, receiveValue: { [weak self] horoscope in
                self?.state = .success(horoscope)
            })
            .store(in: &cancellables)
    }
}

class HoroscopeViewModel: ObservableObject {

    @Published var state: HoroscopeState = .idle
    var cancellables = Set<AnyCancellable>()
    
    lazy var intentHandler: HoroscopeIntentHandler = {
        DefaultHoroscopeIntentHandler(contentService: contentService, viewModel: self)
    }()

    private let contentService =  ContentGeneratorService()

}

