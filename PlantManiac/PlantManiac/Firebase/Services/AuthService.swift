//
//  Authentication.swift
//  PlantManiac
//
//  Created by ASELab on 27.07.2025..
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthService {
    
    static let shared = AuthService() // singleton
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    var name: String = ""
    var username: String = ""
    
    private init() {}
    
    // MARK: - Registration

    func register(email: String, name: String, username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in

                if let error = error as NSError? {
                print("Auth error code: \(error.code)")
                    print("Auth error message: \(error.localizedDescription)")
                    print("Full error: \(error)")
                    completion(.failure(error))
                    return
                }
                
                guard let uid = result?.user.uid else {
                    print("UID nije pronađen.")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "UID not found."])))
                    return
                }
                
                print("Kreiran korisnik s UID: \(uid)")
                
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "UID not found."])))
                return
            }
            
            let userData: [String: Any] = [
                "name": name,
                "username": username,
                "email": email,
                "notifications": false
            ]
            print("Korisnik kreiran s UID: \(uid)")

            self.db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    print("Firestore spremanje nije uspjelo: \(error.localizedDescription)")

                    completion(.failure(error))
                } else {
                    print("Korisnik uspješno spremljen u Firestore.")

                    completion(.success(()))
                }
            }
        }
    }
    
    //check if username is available
    func checkUsernameAvailability(_ username: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Greška pri provjeri username-a: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                let isAvailable = snapshot?.documents.isEmpty ?? true
                completion(isAvailable)
            }
    }


    
    // MARK: - Login
    func loginWithUsername(username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let usersRef = db.collection("users")
        usersRef.whereField("username", isEqualTo: username).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                       let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Korisničko ime nije pronađeno."])
                       completion(.failure(error))
                       return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty,
                  let email = documents.first?.data()["email"] as? String else {
                let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Username not found."])
                completion(.failure(error))
                return
            }
            print("Pronađen email: \(email)")

            
            // Login with email and pass
            self.login(email: email, password: password, completion: completion)
        }
    }

    
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    func fetchUserData(completion: @escaping (Result<(String, String), Error>) -> Void) {
            guard let uid = auth.currentUser?.uid else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])))
                return
            }

            db.collection("users").document(uid).getDocument { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = snapshot?.data() else {
                    completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Podaci nisu pronađeni."])))
                    return
                }

                let name = data["name"] as? String ?? "Nepoznato"
                let username = data["username"] as? String ?? "Nepoznato"
                self.name = name
                self.username = username

                completion(.success((name, username)))
            }
        }
    
    func updateNotificationsPreference(enabled: Bool, completion: ((Error?) -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).updateData(["notifications": enabled]) { error in
            completion?(error)
        }
    }

    //upotreba COMBINE
    private var cancellables = Set<AnyCancellable>()

    func fetchNotificationsPreference() -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else {
                promise(.success(false))
                return
            }
            
            Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
                if let error = error {
                    print("Greška pri dohvaćanju notifikacija: \(error.localizedDescription)")
                    promise(.success(false))
                    return
                }
                let data = snapshot?.data()
                let enabled = data?["notifications"] as? Bool ?? false
                promise(.success(enabled))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Logout
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try auth.signOut()
            print("Korisnik je odjavljen.")
            completion(.success(()))
        } catch let signOutError as NSError {
            print("Greška prilikom odjave: \(signOutError.localizedDescription)")
            completion(.failure(signOutError))
        }
    }

    
}
