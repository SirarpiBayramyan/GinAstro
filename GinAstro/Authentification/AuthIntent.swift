////
////  AuthIntent.swift
////  GinAstro
////
////  Created by Sirarpi Bayramyan on 18.02.25.
////
//
//import Foundation
//import Combine
//
//class AuthIntent {
//
//    private weak var model: AuthModel? // Weak reference to avoid retain cycle
//    private let authService: FirebaseAuthService
//    private var cancellables = Set<AnyCancellable>()
//
//    init(model: AuthModel, authService: FirebaseAuthService = FirebaseAuthService()) {
//        self.model = model
//        self.authService = authService
//        checkAuthentication()
//    }
//
//     func checkAuthentication() {
//        if let cachedUser = UserDefaults.standard.cachedUser {
//            model?.state = .authenticated(cachedUser)
//        } else {
//            model?.state = .unauthenticated
//        }
//    }
//
//    func register(name: String, email: String, password: String, birthdate: Date, gender: Gender) {
//        model?.state = .loading
//        authService.registerUser(name: name, email: email, password: password, birthdate: birthdate, gender: gender)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                switch completion {
//                case .failure(let error):
//                    self?.model?.state = .error(error.localizedDescription)
//                case .finished:
//                    break
//                }
//            }, receiveValue: { [weak self] user in
//                UserDefaults.standard.cachedUser = user
//                self?.model?.state = .authenticated(user)
//            })
//            .store(in: &cancellables)
//    }
//
//    func login(email: String, password: String) {
//        model?.state = .loading
//        authService.loginUser(email: email, password: password)
//            .flatMap { [weak self] _ -> AnyPublisher<User?, Error> in
//                guard let self = self else { return Fail(error: NSError(domain: "AuthError", code: 0, userInfo: nil)).eraseToAnyPublisher() }
//                return self.authService.fetchCurrentUser()
//            }
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                switch completion {
//                case .failure(let error):
//                    self?.model?.state = .error(error.localizedDescription)
//                case .finished:
//                    break
//                }
//            }, receiveValue: { [weak self] user in
//                if let user = user {
//                    UserDefaults.standard.cachedUser = user
//                    self?.model?.state = .authenticated(user)
//                } else {
//                    self?.model?.state = .unauthenticated
//                }
//            })
//            .store(in: &cancellables)
//    }
//
//    func signOut() {
//        authService.logout()
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                switch completion {
//                case .failure(let error):
//                    self?.model?.state = .error(error.localizedDescription)
//                case .finished:
//                    break
//                }
//            }, receiveValue: { [weak self] _ in
//                UserDefaults.standard.cachedUser = nil
//                self?.model?.state = .unauthenticated
//            })
//            .store(in: &cancellables)
//    }
//}
