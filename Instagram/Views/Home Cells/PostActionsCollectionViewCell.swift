//
//  PostActionsCollectionViewCell.swift
//  Instagram
//
//  Created by Anıl Bürcü on 24.03.2023.
//

import UIKit

protocol PostActionsCollectionViewCellDelegate:AnyObject {
    func postActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked:Bool,index: Int)
    func postActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell,index: Int)
    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell,index: Int)
}

class PostActionsCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostActionsCollectionViewCell"
    
    weak var delegate:PostActionsCollectionViewCellDelegate?
    
    private var isLiked = false
    
    private var index = 0
    
    private let likeButton:UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "suit.heart",withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let commentButton:UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "message",withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let shareButton:UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "paperplane",withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        
        // Actions
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapLike(){ // Like'a basınca beğenmesi veya geri alması için alttakı if-else bloğunu kullandık
        if self.isLiked {
            let image = UIImage(systemName: "suit.heart",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .label
        }
        else {
            let image = UIImage(systemName: "suit.heart.fill",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .systemRed
        }

        delegate?.postActionsCollectionViewCellDidTapLike(self,
                                                          isLiked: !isLiked, index: index
                                                          )
        self.isLiked = !isLiked
    }
    
    @objc func didTapComment(){
        delegate?.postActionsCollectionViewCellDidTapComment(self, index: index)
    }
    
    @objc func didTapShare(){
        delegate?.postActionsCollectionViewCellDidTapShare(self, index: index)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size:CGFloat = contentView.height/1.2
        likeButton.frame = CGRect(x: 10, y: (contentView.height-size), width: size+5, height: size)
        commentButton.frame = CGRect(x: likeButton.right+20, y: (contentView.height-size), width: size+2, height: size)
        shareButton.frame = CGRect(x: commentButton.right+20, y: (contentView.height-size), width: size+2, height: size)
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    func configure(
        with viewModel: PostActionsCollectionViewCellViewModel,
        index: Int) {
        self.index = index
        isLiked = viewModel.isLiked
        if viewModel.isLiked {
            let image = UIImage(systemName: "suit.heart.fill",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .systemRed
        }
    }
}
