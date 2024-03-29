//
//  ProfileHeaderCollectionReusableView.swift
//  Instagram
//
//  Created by Anıl Bürcü on 31.03.2023.
//

import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate:AnyObject {
    func profileHeaderCollectionReusableViewDidTapProfilePicture(_ header:ProfileHeaderCollectionReusableView)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        
        return imageView
        
    }()
    

    weak var delegate:ProfileHeaderCollectionReusableViewDelegate?
    
    public let countContainerView = ProfileHeaderCountView()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "I'm coding IOS bitches."
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        
        addSubview(countContainerView)
        addSubview(imageView)
        addSubview(bioLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapImage(){
        delegate?.profileHeaderCollectionReusableViewDidTapProfilePicture(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = width/3.5
        imageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        imageView.layer.cornerRadius = imageSize/2
        countContainerView.frame = CGRect(
            x: imageView.right+5,
            y: 3,
            width: width-imageView.right-10,
            height: imageSize
        )
        let bioSize = bioLabel.sizeThatFits(
            bounds.size
        )
        bioLabel.frame = CGRect(
            x: 5,
            y: imageView.bottom+10,
            width: width-10,
            height: bioSize.height+50
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        bioLabel.text = nil
        
        
    }
    
    public func configure(with viewModel: ProfileHeaderViewModel) {
        imageView.sd_setImage(with: viewModel.profilePictureUrl, completed: nil)
        var text = ""
        if let name = viewModel.name {
            text = name + "\n"
        }
        text += viewModel.bio ?? "Welcome to my profile!"
        bioLabel.text = text
        // Container
        let containerViewModel = ProfileHeaderCountViewViewModel(
            followerCount: viewModel.followerCount,
            followingCount: viewModel.followingCount,
            postCount: viewModel.postCount,
            actionType: viewModel.buttonType
        )
        countContainerView.configure(with: containerViewModel)
    }
}
