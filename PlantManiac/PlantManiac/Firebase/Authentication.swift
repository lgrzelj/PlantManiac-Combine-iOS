//
//  Authentication.swift
//  PlantManiac
//
//  Created by ASELab on 27.07.2025..
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    static let shared = AuthService() // singleton
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Registration

    func register(email: String, name: String, username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in

                if let error = error as NSError? {
                print("❌ Auth error code: \(error.code)")
                    print("❌ Auth error message: \(error.localizedDescription)")
                    print("❌ Full error: \(error)")
                    completion(.failure(error))
                    return
                }
                
                guard let uid = result?.user.uid else {
                    print("❌ UID nije pronađen.")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "UID not found."])))
                    return
                }
                
                print("✅ Kreiran korisnik s UID: \(uid)")
                
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
                "createdAt": Timestamp()
            ]
            print("✅ Korisnik kreiran s UID: \(uid)")

            self.db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    print("❌ Firestore spremanje nije uspjelo: \(error.localizedDescription)")

                    completion(.failure(error))
                } else {
                    print("✅ Korisnik uspješno spremljen u Firestore.")

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
            print("✅ Pronađen email: \(email)")

            
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
}
