//
//  AuthManager.swift
//  Instagram
//
//  Created by Anıl Bürcü on 22.03.2023.
//

import FirebaseAuth
import Foundation


final class AuthManager {
    
    static let shared = AuthManager()
    
    enum AuthError: Error {
        case newUserCreation
    }
    
    private init() {}
    
    let auth = Auth.auth()
    
    public var isSignedIn:Bool {
        return auth.currentUser != nil
    }
    
    public func signIn(
        email:String,
        password: String,
        completion: @escaping (Result<User,Error>) -> Void){
            
        }
    
    public func signUp(
        email:String,
        username:String,
        password: String,
        profilePicture:Data?,
        completion: @escaping (Result<User,Error>) -> Void){
            
            // Create Account
            
            let newUser = User(username: username, email: email)
            
            auth.createUser(withEmail: email, password: password){result, error in
                guard result != nil, error == nil else {
                    completion(.failure(AuthError.newUserCreation))
                    return
                }
                
                DatabaseManager.shared.createUser(newUser: newUser){success in
                    if success {
                        StorageManager.shared.uploadProfilePicture(username: username, data: profilePicture) { uploadSuccess in
                            completion(.success(newUser))
                        }
                    }else {
                        completion(.failure(AuthError.newUserCreation))
                    }
                }
            }
        }
    
    public func signOut(completion: @escaping (Bool)-> Void) {
        do {
            try auth.signOut()
            completion(true)
        } catch  {
            print(error)
            completion(false)
        }
    }
    
}
