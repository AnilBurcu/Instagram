//
//  PosterCollectionViewCell.swift
//  Instagram
//
//  Created by Anıl Bürcü on 24.03.2023.
//

import UIKit
import SDWebImage

protocol PosterCollectionViewCellDelegate:AnyObject {
    func posterCollectionViewCellDidTapMore(_ cell: PosterCollectionViewCell,index:Int)
    func posterCollectionViewCellDidTapUsername(_ cell: PosterCollectionViewCell,index:Int)
}

final class PosterCollectionViewCell: UICollectionViewCell {
    static let identifier = "PosterCollectionViewCell"
    
    private var index = 0
    
    weak var delegate:PosterCollectionViewCellDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let usernameLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        
        return label
    }()
    
    private let moreButton:UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "ellipsis",withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(imageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(moreButton)
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapUsername))
        usernameLabel.isUserInteractionEnabled = true
        usernameLabel.addGestureRecognizer(tap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapUsername(){
        delegate?.posterCollectionViewCellDidTapUsername(self,index:index)
    }
    
    @objc func didTapMore(){
        delegate?.posterCollectionViewCellDidTapMore(self,index:index)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imagePadding:CGFloat = 4
        let imageSize:CGFloat = contentView.height-(imagePadding*2)
        
        imageView.frame = CGRect(x: imagePadding, y: imagePadding, width: imageSize, height: imageSize)
        imageView.layer.cornerRadius = imageSize/2
        
        usernameLabel.sizeToFit()
        usernameLabel.frame = CGRect(x: imageView.right+10, y: 0, width: usernameLabel.width, height: contentView.height)
        
        moreButton.frame = CGRect(x: contentView.width-55, y: (contentView.height-50)/2, width: 50, height: 50)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        imageView.image = nil
    }
    func configure(with viewModel: PosterCollectionViewCellViewModel,index:Int){
        self.index = index
        usernameLabel.text = viewModel.username
        imageView.sd_setImage(with: viewModel.profilePictureURL)
    }
}
