//
//  ProfileInfoHeaderCollectionReusableView.swift
//  Instagram
//
//  Created by Anıl Bürcü on 22.02.2023.
//

import UIKit

class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue
        clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
