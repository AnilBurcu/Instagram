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
    
    private var observer: NSObjectProtocol?
    
    /// All post models
    private var allPosts: [(post: Post, owner: String)] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Instagram"
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        fetchPosts()
        
        observer = NotificationCenter.default.addObserver(forName: .didPostNotification, object: nil, queue: .main) {[weak self] _ in
            self?.viewModels.removeAll()
            self?.fetchPosts()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func fetchPosts() {
        // mock data
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        let userGroup = DispatchGroup()
        userGroup.enter()

        var allPosts: [(post: Post, owner: String)] = []

        DatabaseManager.shared.following(for: username) { usernames in
            defer {
                userGroup.leave()
            }

            let users = usernames + [username]
            for current in users {
                userGroup.enter()
                DatabaseManager.shared.post(for: current) { result in
                    DispatchQueue.main.async {
                        defer {
                            userGroup.leave()
                        }

                        switch result {
                        case .success(let posts):
                            allPosts.append(contentsOf: posts.compactMap({
                                (post: $0, owner: current)
                            }))

                        case .failure:
                            break
                        }
                    }
                }
            }
        }

        userGroup.notify(queue: .main) {
            let group = DispatchGroup()
            self.allPosts = allPosts
            allPosts.forEach { model in
                group.enter()
                self.createViewModel(
                    model: model.post,
                    username: model.owner,
                    completion: { success in
                        defer {
                            group.leave()
                        }
                        if !success {
                            print("failed to create VM")
                        }
                    }
                )
            }

            group.notify(queue: .main) {
                self.sortData()
                self.collectionView?.reloadData()
            }
        }
    }
    
    private func sortData() {
        allPosts = allPosts.sorted(by: { first, second in
            let date1 = first.post.date
            let date2 = second.post.date
            return date1 > date2
        })

        viewModels = viewModels.sorted(by: { first, second in
            var date1: Date?
            var date2: Date?
            first.forEach { type in
                switch type {
                case .timestamp(let vm):
                    date1 = vm.date
                default:
                    break
                }
            }
            second.forEach { type in
                switch type {
                case .timestamp(let vm):
                    date2 = vm.date
                default:
                    break
                }
            }

            if let date1 = date1, let date2 = date2 {
                return date1 > date2
            }

            return false
        })

    }
    
    private func createViewModel(
        model: Post,
        username: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else { return }
        StorageManager.shared.profilePictureURL(for: username) { [weak self] profilePictureURL in
            guard let postUrl = URL(string: model.postUrlString),
                  let profilePhotoUrl = profilePictureURL else {
                return
            }

            let isLiked = model.likers.contains(currentUsername)

            let postData: [HomeFeedCellType] = [
                .poster(
                    viewModel: PosterCollectionViewCellViewModel(
                        username: username,
                        profilePictureURL: profilePhotoUrl
                    )
                ),
                .post(
                    viewModel: PostCollectionViewCellViewModel(
                        postURL: postUrl
                    )
                ),
                .actions(viewModel: PostActionsCollectionViewCellViewModel(isLiked: isLiked)),
                .likeCouunt(viewModel: PostLikesCollectionViewCellViewModel(likers: model.likers)),
                .caption(
                    viewModel: PostCaptionCollectionViewCellViewModel(
                        username: username,
                        caption: model.caption)),
                .timestamp(
                    viewModel: PostDatetimeCollectionViewCellViewModel(
                        date: DateFormatter.formatter.date(from: model.postedDate) ?? Date()
                    )
                )
            ]
            self?.viewModels.append(postData)
            completion(true)
        }
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
            cell.configure(with: viewModel,index:indexPath.section)
            return cell
        case .post(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCollectionViewCell.identifier,
                for: indexPath) as? PostCollectionViewCell else {
                    fatalError()
             }
            cell.configure(with: viewModel, index: indexPath.section)
            cell.delegate = self
            return cell
        case .actions(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostActionsCollectionViewCell.identifier,
                for: indexPath) as? PostActionsCollectionViewCell else {
                    fatalError()
             }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section) // row yerine section kullanmamızın sebebi her bir section vir post'u temsil ediyor
            
            return cell
        case .likeCouunt(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostLikesCollectionViewCell.identifier,
                for: indexPath) as? PostLikesCollectionViewCell else {
                    fatalError()
             }
            cell.configure(with: viewModel, index: indexPath.section)
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
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell,index: Int) {
        print("Tapped Likers Count")
    }
    
    
}
extension HomeViewController:PostCaptionCollectionViewCellDelegate{
    func postCaptionCollectionViewCellDidTapCaptioon(_ cell: PostCaptionCollectionViewCell) {
        let vc = ListViewController(type: .likers(usernames: []))
        vc.title = "Liked By"
        navigationController?.pushViewController(vc, animated: true)
        
    }

    
    
}

extension HomeViewController:PostActionsCollectionViewCellDelegate{
    
    func postActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked: Bool, index: Int) {
        
        // Call DB to update like state
        print("Liked")
    }
    
    func postActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell, index: Int) {
//        AnalyticsManager.shared.logFeedInteraction(.comment)
        let tuple = allPosts[index]
//        HapticManager.shared.vibrateForSelection()
        let vc = PostViewController(post: tuple.post, owner: tuple.owner)
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
                
    }
    
    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell, index: Int) {
        //        AnalyticsManager.shared.logFeedInteraction(.share)
        let section = viewModels[index]
        section.forEach { cellType in
            switch cellType {
            case .post(let viewModel):
                let vc = UIActivityViewController(
                    activityItems: ["Check out this cool post!", viewModel.postURL],
                    applicationActivities: []
                )
                present(vc, animated: true)
                
            default:
                break
            }
        }
    }}

extension HomeViewController:PostCollectionViewCellDelegate {
    func postCollectionViewCellDidLike(_ cell: PostCollectionViewCell,index: Int) {
        print("Did Tap to Like")
    }
    
    
}

extension HomeViewController: PosterCollectionViewCellDelegate {
    func posterCollectionViewCellDidTapMore(_ cell: PosterCollectionViewCell, index: Int) {
        let sheet = UIAlertController(
            title: "Post Actions",
            message: nil,
            preferredStyle: .actionSheet
        )
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Share Post", style: .default, handler: { [weak self]  _ in
            DispatchQueue.main.async {
                let section = self?.viewModels[index] ?? []
                section.forEach { cellType in
                    switch cellType {
                    case .post(let viewModel):
                        let vc = UIActivityViewController(
                            activityItems: ["Check out this cool post!", viewModel.postURL],
                            applicationActivities: []
                        )
                        self?.present(vc, animated: true)

                    default:
                        break
                    }
                }
            }
        }))
        sheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { _ in
            // Report
//            AnalyticsManager.shared.logFeedInteraction(.reported)
        }))
        present(sheet, animated: true)
    }

    func posterCollectionViewCellDidTapUsername(_ cell: PosterCollectionViewCell, index: Int) {
        let username = allPosts[index].owner
        DatabaseManager.shared.findUser(username: username) { [weak self] user in
            DispatchQueue.main.async {
                guard let user = user else {
                    return
                }
                let vc = ProfileViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
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

