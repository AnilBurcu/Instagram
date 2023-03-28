//
//  DatabaseManager.swift
//  Instagram
//
//  Created by Anıl Bürcü on 22.03.2023.
//

import FirebaseFirestore
import Foundation


final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    let database = Firestore.firestore()
    
    public func post(for username: String, completion: @escaping (Result <[Post],Error>) -> Void){
        let ref = database.collection("user").document(username).collection("posts")
        ref.getDocuments {snapshot, error in
            guard let posts = snapshot?.documents.compactMap({ Post(with: $0.data())
                
            }),
                  error == nil else {return}
            completion(.success(posts))
        }
    }
    
    /// Find user with username
    /// - Parameters:
    ///   - username: Source username
    ///   - completion: Result callback
    public func findUser(with email: String, completion: @escaping (User?) -> Void) {
        let ref = database.collection("user")
        ref.getDocuments { snapshot, error in
            
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }),
                  error == nil else {
                completion(nil)
                return
            }

            let user = users.first(where: { $0.email == email })
            completion(user)
        }
    }
    
    public func createPost(newPost: Post,completion: @escaping(Bool)->Void){
        guard let username = UserDefaults.standard.string(forKey: "username")else {
            completion(false)
            return
        }
        let reference = database.document("user/\(username)/posts/\(newPost.id)")
        guard let data = newPost.asDictionary() else {
            completion(false)
            return
        }
        
        reference.setData(data) {error in
            completion(error == nil)
        }
    }
    
    public func createUser(newUser: User,completion: @escaping(Bool)->Void){
        let reference = database.document("user/\(newUser.username)")
        guard let data = newUser.asDictionary() else {
            completion(false)
            return
        }
        
        reference.setData(data) {error in
            completion(error == nil)
        }
    }
    
}
