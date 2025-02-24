//
//  FirebaseAuthService.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 17.02.25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseAnalytics
import Combine

class FirebaseAuthService {
    
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    /// Register a new user
    func registerUser(name: String, email: String, password: String, birthdate: Date, gender: Gender) -> AnyPublisher<User, Error> {
        Future { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let uid = authResult?.user.uid else {
                    promise(.failure(NSError(domain: "AuthError", code: 0, userInfo: nil)))
                    return
                }
                
                let user = User(id: uid, name: name, email: email, birthdate: birthdate, gender: gender)
                self.saveUserToFirestore(user: user)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            promise(.failure(error))
                        }
                    }, receiveValue: { savedUser in
                        promise(.success(savedUser))
                    })
                    .store(in: &self.cancellables)
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Save user data to Firestore
    private func saveUserToFirestore(user: User) -> AnyPublisher<User, Error> {
        Future { promise in
            self.db.collection("users").document(user.id).setData([
                "name": user.name,
                "email": user.email,
                "birthdate": user.birthdate,
                "gender": user.gender.rawValue
            ]) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(user))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Login a user
    func loginUser(email: String, password: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Fetch current user from Firestore
    func fetchCurrentUser() -> AnyPublisher<User?, Error> {
        Future { promise in
            guard let currentUser = Auth.auth().currentUser else {
                promise(.success(nil))
                return
            }
            
            let uid = currentUser.uid
            self.db.collection("users").document(uid).getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                if let data = document?.data(),
                   let name = data["name"] as? String,
                   let email = data["email"] as? String,
                   let birthdateTimestamp = data["birthdate"] as? Timestamp,
                   let genderRaw = data["gender"] as? String,
                   let gender = Gender(rawValue: genderRaw) {
                    
                    let birthdate = birthdateTimestamp.dateValue()
                    let user = User(id: uid, name: name, email: email, birthdate: birthdate, gender: gender)
                    promise(.success(user))
                } else {
                    promise(.success(nil))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Logout
    func logout() -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Update User Data in Firestore
    func updateUserData(user: User) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.db.collection("users").document(user.id).updateData([
                "name": user.name,
                "email": user.email,
                "birthdate": user.birthdate,
                "gender": user.gender.rawValue
            ]) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Delete user account
    func deleteAccount() -> AnyPublisher<Void, Error> {
        Future { promise in
            guard let user = Auth.auth().currentUser else {
                promise(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])))
                return
            }
            
            let userId = user.uid
            
            // 1. Delete user data from Firestore
            self.db.collection("users").document(userId).delete { firestoreError in
                if let firestoreError = firestoreError {
                    promise(.failure(firestoreError))
                    return
                }
                
                // 2. Delete user from Firebase Authentication
                user.delete { authError in
                    if let authError = authError {
                        promise(.failure(authError))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// firebase Analytics implementation
struct GaAnalytics {
    
    static func logAction(name: String, params: [String: Any]?) {
        Analytics.logEvent(name, parameters: params)
    }
    
    static func logScreen(name: String) {
        Analytics.logEvent(name, parameters: nil)
    }
}
