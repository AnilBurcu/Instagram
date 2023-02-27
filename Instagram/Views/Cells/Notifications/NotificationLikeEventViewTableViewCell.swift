//
//  NotificationLikeEventViewTableViewCell.swift
//  Instagram
//
//  Created by Anıl Bürcü on 23.02.2023.
//

import UIKit
import SDWebImage


    protocol NotificationLikeEventViewTableViewCellDelegate:AnyObject{
        func didTapRelatedPPostButton(model:UserNotification)
    }

    class NotificationLikeEventViewTableViewCell: UITableViewCell {

        static let identifier = "NotificationLikeEventViewTableViewCell"
        
        weak var delegate:NotificationLikeEventViewTableViewCellDelegate?
        
        private var model: UserNotification?
        
        private let profileImageView:UIImageView = {
            let imageView = UIImageView()
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .tertiarySystemBackground
            return imageView
        }()
        
        private let label:UILabel = {
            let label = UILabel()
            label.textColor = .label
            label.numberOfLines = 0
            label.text = "joe liked your photo"
            return label
        }()
        
        private let postButton:UIButton = {
           let button = UIButton()
            button.setBackgroundImage(UIImage(named: "test"), for: .normal)
            
            return button
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.clipsToBounds = true
            contentView.addSubview(profileImageView)
            contentView.addSubview(label)
            contentView.addSubview(postButton)
            postButton.addTarget(self, action: #selector(didTapPostsButton), for: .touchUpInside)
            
            selectionStyle = .none
        }
        
        @objc private func didTapPostsButton(){
            guard let model = model else{
                return
            }
            delegate?.didTapRelatedPPostButton(model: model)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public func configure(with model:UserNotification){
            self.model = model
            
            
            switch model.type {
            case .like(let post):
                
                let thumbnail = post.thumbnailImage
                
                guard !thumbnail.absoluteString.contains("google.com") else {
                    return
                }
                postButton.sd_setBackgroundImage(with: thumbnail, for: .normal)
                
                
            case .follow:
                break
                
            }
            label.text = model.text
            profileImageView.sd_setImage(with: model.user.profilePhote)
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            postButton.setTitle(nil, for: .normal)
            label.text = nil
            profileImageView.image = nil
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            
            // photo, text, post button
            
            profileImageView.frame = CGRect(x: 3, y: 3, width: contentView.height-6, height: contentView.height-6)
            profileImageView.layer.cornerRadius = profileImageView.height / 2
            
            let size = contentView.height-4
            postButton.frame = CGRect(x: contentView.width-5-size, y: 2, width: size, height: size)
            
            label.frame = CGRect(x: profileImageView.right + 5,
                                 y: 0,
                                 width: contentView.width-size-profileImageView.width-16,
                                 height: contentView.height)
        }
        
            
            
       
    }
