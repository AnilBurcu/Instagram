//
//  ProfileHeaderViewModel.swift
//  Instagram
//
//  Created by Anıl Bürcü on 31.03.2023.
//

import Foundation

enum profileButtonType {
    case edit
    case follow(isFollowing: Bool)
}

struct ProfileHeaderViewModel {
    let profilePictureUrl: URL?
    let followerCount:Int
    let followingCount:Int
    let postCount:Int
    let buttonType:profileButtonType
    let name:String?
    let bio:String?
}
