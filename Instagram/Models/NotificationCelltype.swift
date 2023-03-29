//
//  NotificationCelltype.swift
//  Instagram
//
//  Created by Anıl Bürcü on 29.03.2023.
//

import Foundation

enum NotificationCelltype {
    case follow(viewModel: FollowNotificationCellViewModel)
    case like(viewModel: LikeNotificationCellViewModel)
    case comment(viewModel: CommentNotificationCellViewModel)
}
