//
//  DreamViewModel.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 18.02.25.
//
import Foundation
import Combine

class DreamViewModel: ObservableObject {
    
    @Published var state: HoroscopeState = .idle
    private let contentService = ContentGeneratorService()
    private var cancellables = Set<AnyCancellable>()

    func fetchDreamInterpretation(dream: String) {
        state = .loading
        if !dream.isEmpty {
            contentService.generateDreamInterpretation(for: dream)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        self?.state = .failure(error)
                    }
                }, receiveValue: { [weak self] interpretation in
                    self?.state = .success(interpretation)
                })
                .store(in: &cancellables)
        } else {
            state = .failure(NetworkError.invalidResponse)
        }
    }
}

enum NetworkError: Error {
    case invalidResponse
    case noInternet
}
