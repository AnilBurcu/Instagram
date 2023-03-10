//
//  ProfileInfoHeaderCollectionReusableView.swift
//  Instagram
//
//  Created by Anıl Bürcü on 22.02.2023.
//

import UIKit

protocol ProfileInfoHeaderCollectionReusableViewDelegate:AnyObject {
    func profileHeaderDidTapPostsButton(_ header:ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowersButton(_ header:ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowingButton(_ header:ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapEditProfileButton(_ header:ProfileInfoHeaderCollectionReusableView)
}

final class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    
    public weak var delegate:ProfileInfoHeaderCollectionReusableViewDelegate?
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    
    private let profilePhotoImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let postButton:UIButton = {
        let button = UIButton()
        button.setTitle("Posts", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private let followingButton:UIButton = {
        let button = UIButton()
        button.setTitle("Following", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private let followersButton:UIButton = {
        let button = UIButton()
        button.setTitle("Followers", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private let editProfileButton:UIButton = {
        let button = UIButton()
        button.setTitle("Edit Your Profile", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.text = "Joe Smith"
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let bioLabel:UILabel = {
        let label = UILabel()
        label.text = "This is the first accont!"
        label.textColor = .label
        label.numberOfLines = 0 // line wrap
        return label
    }()
    // MARK: Init
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        addButtonActions()
        backgroundColor = .systemBackground
        clipsToBounds = true
        
    }
    
    private func addSubViews(){
        addSubview(profilePhotoImageView)
        addSubview(postButton)
        addSubview(followingButton)
        addSubview(followersButton)
        addSubview(editProfileButton)
        addSubview(nameLabel)
        addSubview(bioLabel)
        
        
    }
    
    private func addButtonActions(){
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
        postButton.addTarget(self, action: #selector(didTapPostsButton), for: .touchUpInside)
        editProfileButton.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Layout işlemleri
        
        let profilePhotoSize = width/4
        profilePhotoImageView.frame = CGRect(x: 5,
                                             y: 5,
                                             width: profilePhotoSize,
                                             height: profilePhotoSize).integral // integral komutu değerleri en yakın 'int' sayıya yuvarlamak için
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoSize/2
        
        let buttonHeigh = profilePhotoSize/2
        let countButtonWidth = (width-10-profilePhotoSize)/3
        
        postButton.frame = CGRect(x: profilePhotoImageView.right,
                                             y: 5,
                                             width: countButtonWidth,
                                             height: buttonHeigh).integral
        
        followingButton.frame = CGRect(x: postButton.right,
                                             y: 5,
                                             width: countButtonWidth,
                                             height: buttonHeigh).integral
        followersButton.frame = CGRect(x: followingButton.right,
                                             y: 5,
                                             width: countButtonWidth,
                                             height: buttonHeigh).integral
        editProfileButton.frame = CGRect(x: profilePhotoImageView.right,
                                             y: 5 + buttonHeigh,
                                             width: countButtonWidth*3,
                                             height: buttonHeigh).integral
        nameLabel.frame = CGRect(x: 5,
                                 y: 5 + profilePhotoImageView.bottom,
                                             width: width-10,
                                             height: 50).integral
        let bioLabelSize = bioLabel.sizeThatFits(self.frame.size)
        
        bioLabel.frame = CGRect(x: 5,
                                 y: 5 + nameLabel.bottom,
                                             width: width-10,
                                height: bioLabelSize.height).integral
    }
    
    // MARK: Actions
    
    
    @objc private func didTapFollowersButton(){
        delegate?.profileHeaderDidTapFollowersButton(self)
    }
    
    @objc private func didTapFollowingButton(){
        delegate?.profileHeaderDidTapFollowingButton(self)
    }
    
    @objc private func didTapPostsButton(){
        delegate?.profileHeaderDidTapPostsButton(self)
    }
    
    @objc private func didTapEditProfileButton(){
        delegate?.profileHeaderDidTapEditProfileButton(self)
    }
    
    
}


