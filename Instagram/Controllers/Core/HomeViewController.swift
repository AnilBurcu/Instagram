//
//  HomeViewController.swift
//  Instagram
//
//  Created by Anıl Bürcü on 22.03.2023.
//

import UIKit
class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    private var collectionView:UICollectionView?
    
    private var viewModels = [[HomeFeedCellType]]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Instagram"
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        fethPosts()
 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func fethPosts(){
        // mock data
        let postData:[HomeFeedCellType] = [
            .poster(viewModel: PosterCollectionViewCellViewModel(
                username: "iosAcademy",
                profilePictureURL: URL(string: "https://iosacademy.io/assets/images/brand/icon.jpg")!
                
            )
            ),
            .post(viewModel: PostCollectionViewCellViewModel(
                postURL: URL(string: "https://iosacademy.io/assets/images/courses/swiftui.png")!
            )),
            .actions(viewModel: PostActionsCollectionViewCellViewModel(
                isLiked: true)),
            .likeCouunt(viewModel: PostLikesCollectionViewCellViewModel(
                likers: ["kanyewest"])),
            .caption(viewModel: PostCaptionCollectionViewCellViewModel(
                username: "iosAcademy",
                caption: "This is an awesome first post!")),
            .timestamp(viewModel: PostDateTimeCollectionViewCellViewModel(date: Date()))
        ]
        
        viewModels.append(postData)
        collectionView?.reloadData()
    }
    
    
    // CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModels[indexPath.section][indexPath.row]
        switch cellType{
            
        case .poster(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterCollectionViewCell.identifier,
                for: indexPath) as? PosterCollectionViewCell else {
                    fatalError()
             }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .post(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCollectionViewCell.identifier,
                for: indexPath) as? PostCollectionViewCell else {
                    fatalError()
             }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        case .actions(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostActionsCollectionViewCell.identifier,
                for: indexPath) as? PostActionsCollectionViewCell else {
                    fatalError()
             }
            cell.delegate = self
            cell.configure(with: viewModel)
            
            return cell
        case .likeCouunt(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostLikesCollectionViewCell.identifier,
                for: indexPath) as? PostLikesCollectionViewCell else {
                    fatalError()
             }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        case .caption(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCaptionCollectionViewCell.identifier,
                for: indexPath) as? PostCaptionCollectionViewCell else {
                    fatalError()
             }
            cell.delegate = self
            cell.configure(with: viewModel)
            
            return cell
        case .timestamp(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostDateTimeCollectionViewCell.identifier,
                for: indexPath) as? PostDateTimeCollectionViewCell else {
                    fatalError()
             }
            cell.configure(with: viewModel)
            
            return cell
        }
    
    }


}
extension HomeViewController:PostLikesCollectionViewCellDelegate{
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell) {
        print("Tapped Likers Count")
    }
    
    
}
extension HomeViewController:PostCaptionCollectionViewCellDelegate{
    func PostCaptionCollectionViewCellDidTapCaption(_ cell: PostCaptionCollectionViewCell) {
        let vc = ListViewController()
        vc.title = "Liked By"
        navigationController?.pushViewController(vc, animated: true)
        print("Tapped Caption")
    }
    
    
}

extension HomeViewController:PostActionsCollectionViewCellDelegate{
    
    func postActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked: Bool) {
        
        // Call DB to update like state
        print("Liked")
    }
    
    func postActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell) {
        let vc = PostViewController()
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
        print("Comment")
    }
    
    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell) {
        let vc = UIActivityViewController(activityItems: ["Sharing from instagram"], applicationActivities: [])
        present(vc,animated: true)
        print("Share")
    }
    
    
}

extension HomeViewController:PostCollectionViewCellDelegate {
    func postCollectionViewCellDidLike(_ cell: PostCollectionViewCell) {
        print("Did Tap to Like")
    }
    
    
}

extension HomeViewController:PosterCollectionViewCellDelegate {
    func posterCollectionViewCellDidTapMore(_ cell: PosterCollectionViewCell) {
        let sheet = UIAlertController(title: "Post Action", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.addAction(UIAlertAction(title: "Share Post", style: .default,handler: { _ in
            
        }))
        sheet.addAction(UIAlertAction(title: "Report Post", style: .destructive,handler: { _ in
            
        }))
        present(sheet,animated: true)
    }
    
    func posterCollectionViewCellDidTapUsername(_ cell: PosterCollectionViewCell) {
        print("Tapped username")
        let vc = ProfileViewController(user: User(username: "kanyewest", email: "kanye@gmail.com"))
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
}

extension HomeViewController {
    func configureCollectionView(){
        
        let sectionHeight: CGFloat = 240 + view.width
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in

                // Item
                let posterItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )

                let postItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalWidth(1)
                    )
                )

                let actionsItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(40)
                    )
                )

                let likeCountItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(40)
                    )
                )

                let captionItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )

                let timestampItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(40)
                    )
                )

                // Group
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(sectionHeight)
                    ),
                    subitems: [
                        posterItem,
                        postItem,
                        actionsItem,
                        likeCountItem,
                        captionItem,
                        timestampItem
                    ]
                )

                // Section
                let section = NSCollectionLayoutSection(group: group)

                if index == 0 {
                    section.boundarySupplementaryItems = [
                        NSCollectionLayoutBoundarySupplementaryItem(
                            layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1),
                                heightDimension: .fractionalWidth(0.3) // tepeye bolşuk bırakma
                            ),
                            elementKind: UICollectionView.elementKindSectionHeader,
                            alignment: .top
                        )
                    ]
                }

                section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)

                return section
            })
        )
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            PosterCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        collectionView.register(
            PostCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        collectionView.register(
            PostActionsCollectionViewCell.self,
            forCellWithReuseIdentifier: PostActionsCollectionViewCell.identifier)
        collectionView.register(
            PostLikesCollectionViewCell.self,
            forCellWithReuseIdentifier: PostLikesCollectionViewCell.identifier)
        collectionView.register(
            PostCaptionCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCaptionCollectionViewCell.identifier)
        collectionView.register(
            PostDateTimeCollectionViewCell.self,
            forCellWithReuseIdentifier: PostDateTimeCollectionViewCell.identifier)
        
        self.collectionView = collectionView
    }
}

