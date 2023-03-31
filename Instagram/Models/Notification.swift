//
//  Notification.swift
//  Instagram
//
//  Created by Anıl Bürcü on 22.03.2023.
//

import Foundation

struct IGNotification: Codable {
    let identifier: String
    let notificationType: Int // 1: like, 2: comment, 3: follow
    let profilePictureUrl: String
    let username: String
    let dateString: String
    // Follow/Unfollow
    let isFollowing: Bool?
    // Like/Comment
    let postId: String?
    let postUrl: String?
}

