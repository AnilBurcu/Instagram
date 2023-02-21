//
//  DatabaseManager.swift
//  Instagram
//
//  Created by Anıl Bürcü on 20.02.2023.
//

import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()

    private let database = Database.database().reference()
    
    
    // MARK: - Public
    
    /// Check if username and email available
    /// -Parameters
    ///     -email : String representing email
    ///     -username: String representing username
    
    public func canCreateNewUser(with email: String, username:String, completion: (Bool) -> Void) {
        completion(true)
        
    }
    
    /// Inesrt new users data to database
    /// -Parameters
    ///     -email : String representing email
    ///     -username: String representing username
    ///     -completion: Asycn callback for result if database entry succeded
    
    public func insertNewUser(with email: String, username: String,completion: @escaping (Bool) -> Void){
        database.child(email.safeDatabaseKey()).setValue(["username":username]) {error, _ in
            if error == nil {
                //succeed
                completion(true)
                return
            }
            else {
                //failed
                completion(false)
                return
            }
            
            
        }
    }

    
}
