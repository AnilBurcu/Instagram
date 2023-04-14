//
//  SinglePostCellType.swift
//  Instagram
//
//  Created by Anıl Bürcü on 13.04.2023.
//

import Foundation

enum SinglePostCellType {
    case poster(viewModel: PosterCollectionViewCellViewModel)
    case post(viewModel: PostCollectionViewCellViewModel)
    case actions(viewModel: PostActionsCollectionViewCellViewModel)
    case likeCount(viewModel: PostLikesCollectionViewCellViewModel)
    case caption(viewModel: PostCaptionCollectionViewCellViewModel)
    case timestamp(viewModel: PostDatetimeCollectionViewCellViewModel)
    case comment(viewModel: Comment)
}
