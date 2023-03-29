//
//  NotificationCellViewModels.swift
//  Instagram
//
//  Created by Anıl Bürcü on 29.03.2023.
//

import Foundation

struct LikeNotificationCellViewModel {
    let username: String
    let profilePictureUrl: URL
    let postUrl: URL
}
struct FollowNotificationCellViewModel {
    let username: String
    let profilePictureUrl: URL
    let isCurrentUserFollowing: Bool
}
struct CommentNotificationCellViewModel {
    let username: String
    let profilePictureUrl: URL
    let postUrl: URL
    
}
