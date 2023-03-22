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
    
    let storage = Storage.storage()
    
}

