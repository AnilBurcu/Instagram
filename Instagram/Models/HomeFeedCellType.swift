//
//  HomeFeedCellType.swift
//  Instagram
//
//  Created by Anıl Bürcü on 24.03.2023.
//

import Foundation

enum HomeFeedCellType {
    case poster(viewModel:PosterCollectionViewCellViewModel)
    case post(viewModel:PostCollectionViewCellViewModel)
    case actions(viewModel:PostActionsCollectionViewCellViewModel)
    case likeCouunt(viewModel:PostLikesCollectionViewCellViewModel)
    case caption(viewModel:PostCaptionCollectionViewCellViewModel)
    case timestamp(viewModel:PostDatetimeCollectionViewCellViewModel)
}
