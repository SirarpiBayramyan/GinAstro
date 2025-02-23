//
//  HoroscopeIntentHandler.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 18.02.25.
//

import Combine
import Foundation

protocol HoroscopeIntentHandler {
    func loadHoroscope(for sign: ZodiacSign, period: HoroscopePeriod, category: ContentCategory)
}

class DefaultHoroscopeIntentHandler: HoroscopeIntentHandler {
    private let contentService: ContentGeneratorService
    private weak var viewModel: HoroscopeViewModel?
    
    init(contentService: ContentGeneratorService, viewModel: HoroscopeViewModel) {
        self.contentService = contentService
        self.viewModel = viewModel
    }
    
    func loadHoroscope(for sign: ZodiacSign, period: HoroscopePeriod,  category: ContentCategory) {
        viewModel?.state = .loading
        contentService.generateHoroscope(for: sign.rawValue, period: period, category: category)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.viewModel?.state = .failure(error)
                }
            }, receiveValue: { [weak self] horoscope in
                self?.viewModel?.state = .success(horoscope)
            })
            .store(in: &viewModel!.cancellables)
    }
}
