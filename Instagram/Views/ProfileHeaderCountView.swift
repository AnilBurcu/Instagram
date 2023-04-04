//
//  ProfileHeaderCountView.swift
//  Instagram
//
//  Created by Anıl Bürcü on 4.04.2023.
//

import UIKit

protocol ProfileHeaderCountViewDelegate:AnyObject {
    func profileHeaderCountDidTapFollowers(_ containerView: ProfileHeaderCountView)
    func profileHeaderCountDidTapFollowing(_ containerView: ProfileHeaderCountView)
    func profileHeaderCountDidTapPosts(_ containerView: ProfileHeaderCountView)
    func profileHeaderCountDidTapEditProfile(_ containerView: ProfileHeaderCountView)
    func profileHeaderCountDidTapFollow(_ containerView: ProfileHeaderCountView)
    func profileHeaderCountDidTapUnFollow(_ containerView: ProfileHeaderCountView)
}

class ProfileHeaderCountView: UIView {

    weak var delegate: ProfileHeaderCountViewDelegate?
    
    private var action = profileButtonType.edit
    
    // Count Buttons
    
    private let followerCountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.setTitle("-", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        
        return button
    }()
    
    private let followingCountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.setTitle("-", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        
        return button
    }()
    
    private let postCountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.setTitle("-", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        
        return button
    }()
    
    private let actionButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(followerCountButton)
        addSubview(actionButton)
        addSubview(followingCountButton)
        addSubview(postCountButton)
        addAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addAction(){
        followerCountButton.addTarget(self, action: #selector(didTapFollowers), for: .touchUpInside)
        followingCountButton.addTarget(self, action: #selector(didTapFollowing), for: .touchUpInside)
        postCountButton.addTarget(self, action: #selector(didTapPosts), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    // Actions
    
    @objc func didTapFollowers(){
        delegate?.profileHeaderCountDidTapFollowers(self)
    }
    
    @objc func didTapFollowing(){
        delegate?.profileHeaderCountDidTapFollowing(self)
    }
    
    @objc func didTapPosts(){
        delegate?.profileHeaderCountDidTapPosts(self)
    }
    
    @objc func didTapActionButton(){
        switch action {
        case .edit:
            delegate?.profileHeaderCountDidTapEditProfile(self)
        case .follow(let isFollowing):
            if isFollowing {
                // unfollow;
                delegate?.profileHeaderCountDidTapUnFollow(self)
            }else {
                // follow
                delegate?.profileHeaderCountDidTapFollow(self)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth:CGFloat = (width-15)/3
        followerCountButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: height/2)
        followingCountButton.frame = CGRect(x: followerCountButton.right + 5, y: 5, width: buttonWidth, height: height/2)
        postCountButton.frame = CGRect(x: followingCountButton.right + 5, y: 5, width: buttonWidth, height: height/2)
        actionButton.frame = CGRect(x: 5, y: height-42, width: width-10, height: 40)
    }
    
    func configure (with viewmodel: ProfileHeaderCountViewViewModel){
        followerCountButton.setTitle("\(viewmodel.followerCount)\nFollowers", for: .normal)
        followingCountButton.setTitle("\(viewmodel.followingCount)\nFollowing", for: .normal)
        postCountButton.setTitle("\(viewmodel.postCount)\nPosts", for: .normal)
        
        self.action = viewmodel.actionType
        
        switch viewmodel.actionType {
        case .edit:
            actionButton.backgroundColor = .systemBackground
            actionButton.setTitle("Edit Profile", for: .normal)
            actionButton.setTitleColor(.label, for: .normal)
            actionButton.layer.borderWidth = 0.5
            actionButton.layer.borderColor = UIColor.tertiaryLabel.cgColor
            
            
        case .follow(let isFollowing):
            actionButton.backgroundColor = isFollowing ? .systemBackground : .systemBlue
            actionButton.setTitle(isFollowing ? "Unfollow": "Follow", for: .normal)
            actionButton.setTitleColor(isFollowing ? .label : .white, for: .normal)
            
            if isFollowing {
                actionButton.layer.borderWidth = 0.5
                actionButton.layer.borderColor = UIColor.tertiaryLabel.cgColor
            }
            else {
                actionButton.layer.borderWidth = 0
            }
            
            
        }
    }
}
