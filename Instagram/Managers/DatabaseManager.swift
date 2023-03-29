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
    
    
    public func findUsers(
        with usernamePrefix: String,
        completion: @escaping ([User]) -> Void
    ) {
        let ref = database.collection("user")
        ref.getDocuments { snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }),
                  error == nil else {
                completion([])
                return
            }
            let subset = users.filter({
                $0.username.lowercased().hasPrefix(usernamePrefix.lowercased())
            })

            completion(subset)
        }
    }
    
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
    
    /// Gets posts for explore page
    /// - Parameter completion: Result callback
    public func explorePosts(completion: @escaping ([(post: Post, user: User)]) -> Void) {
        let ref = database.collection("user")
        ref.getDocuments { snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }),
                  error == nil else {
                completion([])
                return
            }

            let group = DispatchGroup()
            var aggregatePosts = [(post: Post, user: User)]()

            users.forEach { user in
                group.enter()

                let username = user.username
                let postsRef = self.database.collection("users/\(username)/posts")

                postsRef.getDocuments { snapshot, error in

                    defer {
                        group.leave()
                    }

                    guard let posts = snapshot?.documents.compactMap({ Post(with: $0.data()) }),
                          error == nil else {
                        return
                    }

                    aggregatePosts.append(contentsOf: posts.compactMap({
                        (post: $0, user: user)
                    }))
                }
            }

            group.notify(queue: .main) {
                completion(aggregatePosts)
            }
        }
    }
    
}
