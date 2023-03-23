//
//  StorageManager.swift
//  Instagram
//
//  Created by Anıl Bürcü on 22.03.2023.
//

import FirebaseStorage
import Foundation


final class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    public func uploadProfilePicture(username:String,data: Data?,completion: @escaping (Bool)->Void){
        
        guard let data = data else {return}
        storage.child("\(username)/profile_picture.png").putData(data){_, error in
            completion(error == nil)
        }
    }
}

