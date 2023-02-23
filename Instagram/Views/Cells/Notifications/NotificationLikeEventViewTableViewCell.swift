//
//  NotificationLikeEventViewTableViewCell.swift
//  Instagram
//
//  Created by Anıl Bürcü on 23.02.2023.
//

import UIKit


    protocol NotificationLikeEventViewTableViewCellDelegate:AnyObject{
        func didTapRelatedPPostButton(model:String)
    }

    class NotificationLikeEventViewTableViewCell: UITableViewCell {

        static let identifier = "NotificationLikeEventViewTableViewCell"
        
        weak var delegate:NotificationFollowEventTableViewCellDelegate?
        
        private let profileImageView:UIImageView = {
            let imageView = UIImageView()
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        private let label:UILabel = {
            let label = UILabel()
            label.textColor = .label
            label.numberOfLines = 1
            return label
        }()
        
        private let postButton:UIButton = {
           let button = UIButton()
            
            return button
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.clipsToBounds = true
            contentView.addSubview(profileImageView)
            contentView.addSubview(label)
            contentView.addSubview(postButton)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public func configure(with model:String){
            
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            postButton.setTitle(nil, for: .normal)
            label.text = nil
            profileImageView.image = nil
        }
        override func layoutSubviews() {
            super.layoutSubviews()
        }
            
            
       
    }
