//
//  Post.swift
//  Instagram
//
//  Created by Anıl Bürcü on 22.03.2023.
//

import Foundation

struct Post: Codable {
    let id: String
    let caption: String
    let postedDate: String
    let postUrlString: String
    var likers: [String]

//    var date: Date {
//        guard let date = DateFormatter.formatter.date(from: postedDate) else { fatalError() }
//        return date
//    }
    
    var date: Date {
        return DateFormatter.formatter.date(from: postedDate) ?? Date()
    }

    var storageReference: String? {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return nil }
        return "\(username)/posts/\(id).png"
    }
}
