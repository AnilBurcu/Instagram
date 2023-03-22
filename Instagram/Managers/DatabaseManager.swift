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
    
}
