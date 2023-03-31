//
//  NotificationCellViewModels.swift
//  Instagram
//
//  Created by Anıl Bürcü on 29.03.2023.
//

import Foundation

struct LikeNotificationCellViewModel:Equatable {
    let username: String
    let profilePictureUrl: URL
    let postUrl: URL
    let date: String
}
struct FollowNotificationCellViewModel:Equatable {
    let username: String
    let profilePictureUrl: URL
    let isCurrentUserFollowing: Bool
    let date: String
}
struct CommentNotificationCellViewModel:Equatable {
    let username: String
    let profilePictureUrl: URL
    let postUrl: URL
    let date: String
    
}
