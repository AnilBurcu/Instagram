//
//  ProfileTabsCollectionReusableView.swift
//  Instagram
//
//  Created by Anıl Bürcü on 22.02.2023.
//

import UIKit

protocol ProfileTabsCollectionReusableViewDelegate:AnyObject { // tag ve grid butona basınca bir şeyler olmasını istiyoruz o yüzden protokol oluşturduk
    
    func didTapGridButton()
    func didTapTaggedButton()
}

class ProfileTabsCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "ProfileTabsCollectionReusableView"
    
    public weak var delegate: ProfileTabsCollectionReusableViewDelegate? //protokol oluşturduğumuz için onun nesnesini oluşturuyoruz
    
    struct Constants {
        static let padding:CGFloat = 8
    }
    
    private let gridButton:UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .systemBlue
        button.setBackgroundImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
       
        return button
    }()
    
    private let taggedButton:UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .lightGray
        button.setBackgroundImage(UIImage(systemName: "tag"), for: .normal)
       
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(taggedButton)
        addSubview(gridButton)
        gridButton.addTarget(self, action: #selector(didTapGridButton), for: .touchUpInside)
        taggedButton.addTarget(self, action: #selector(didTapTaggedButton), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = height - (Constants.padding + 2) // kare olmasını istiyoruz o yüzden aşağıdaki frame tanımında width ve hight ' a size atayacağız
        
        let gridButtonX = ((width/2)-size)/2
        
        // kenarda duruyordu, ortalamak için yaptık
        
        gridButton.frame = CGRect(x: gridButtonX, y: Constants.padding, width: size, height: size)
        taggedButton.frame = CGRect(x: gridButtonX + (width/2), y: Constants.padding, width: size, height: size)
        
        
    }
    
    @objc private func didTapGridButton(){
        gridButton.tintColor = .systemBlue // tıklandığında bunu mavi diğerini gri (seçilmemiş) göstermek için
        taggedButton.tintColor = .lightGray
        delegate?.didTapGridButton()
    }
    
    @objc private func didTapTaggedButton(){
        gridButton.tintColor = .lightGray
        taggedButton.tintColor = .systemBlue
        delegate?.didTapTaggedButton()
    }
}
