//
//  CommentNotificationTableViewCell.swift
//  Instagram
//
//  Created by Anıl Bürcü on 29.03.2023.
//

import UIKit

class CommentNotificationTableViewCell: UITableViewCell {

    static let identifier = "CommentNotificationTableViewCell"

    private let profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.clipsToBounds = true
        contentView.addSubview(profilePictureImageView)
        contentView.addSubview(label)
        contentView.addSubview(postImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height/1.5
        profilePictureImageView.frame = CGRect(
            x: 10,
            y: (contentView.height-imageSize)/2,
            width: imageSize,
            height: imageSize
        )
        profilePictureImageView.layer.cornerRadius = imageSize/2

        let postSize: CGFloat = contentView.height - 6
        postImageView.frame = CGRect(
            x: contentView.width-postSize-10,
            y: 3,
            width: postSize,
            height: postSize
        )

        let labelSize = label.sizeThatFits(
            CGSize(
                width: contentView.width-profilePictureImageView.right-25-postSize,
                height: contentView.height
            )
        )
        label.frame = CGRect(
            x: profilePictureImageView.right+10,
            y: 0,
            width: labelSize.width,
            height: contentView.height
        )
        
        
        
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        profilePictureImageView.image = nil
        postImageView.image = nil
        
    }
    
    public func configure(with viewModel: CommentNotificationCellViewModel){
        profilePictureImageView.sd_setImage(
            with: viewModel.profilePictureUrl)
        postImageView.sd_setImage(with: viewModel.postUrl)
        label.text = viewModel.username + " commented on your post"
        
    }

}