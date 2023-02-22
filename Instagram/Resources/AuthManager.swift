//
//  AuthManager.swift
//  Instagram
//
//  Created by Anıl Bürcü on 20.02.2023.
//

import FirebaseAuth

public class AuthManager {
    static let shared = AuthManager()
    
    // MARK: - Public
    
    public func registerNewUser(username: String, email:String, password:String, completion: @escaping (Bool) -> Void){
        /*
         -Create account
         -Insert account to database
         */
        
        
        
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate{
                
                /*
                 -Check if username is available
                 -Check if email is available
                 */
                
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil, result != nil else{
                        // Firebase auth could not create account
                        completion(false)
                        return
                    }
                    // Insert into database
                    DatabaseManager.shared.insertNewUser(with: email, username: username) {inserted in
                        if inserted {
                            completion(true)
                            return
                        }
                        else{
                            //Failed insert to database
                            completion(false)
                            return
                        }
                    }
                }
                
            }
            else {
                // either username or email does not exist
                completion(false)
            }
            
        }
        
    }
    
    public func loginUser(username: String?, email:String?, password:String,completion: @escaping (Bool) -> Void){
        if let email = email {
            //email login
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else{
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        else if let username = username {
            //username login
            
            
            print(username)
        }
    }
    /// Attempt to logout Firebase user
    public func logOut(completion: (Bool) -> Void){
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch  {
            print(error)
            completion(false)
            return
        }
    }
}

