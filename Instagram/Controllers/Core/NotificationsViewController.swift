//
//  NotificationsViewController.swift
//  Instagram
//
//  Created by Anıl Bürcü on 22.03.2023.
//

import UIKit

class NotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private let noActivityLabel: UILabel = {
        let label = UILabel()
        label.text = "No Notification for now"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isHidden = true
        tableView.register(LikeNotificationTableViewCell.self, forCellReuseIdentifier: LikeNotificationTableViewCell.identifier)
        tableView.register(FollowNotificationTableViewCell.self, forCellReuseIdentifier: FollowNotificationTableViewCell.identifier)
        tableView.register(CommentNotificationTableViewCell.self, forCellReuseIdentifier: CommentNotificationTableViewCell.identifier)
        
        
        return tableView
    }()
    
    private var viewModels: [NotificationCelltype] = []
    private var models: [IGNotification] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notifications"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(noActivityLabel)
        
        fetchNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noActivityLabel.sizeToFit()
        noActivityLabel.center = view.center
    }
    
    private func fetchNotification()  {
        
        NotificationManager.shared.getNotifications {[weak self] models in
            DispatchQueue.main.async {
                self?.models = models
                self?.createViewModels()
                
            }}
    }
    /// Creates viewModels from models
    private func createViewModels() {
        models.forEach { model in
            guard let type = NotificationManager.IGType(rawValue: model.notificationType) else {
                return
            }
            let username = model.username
            guard let profilePictureUrl = URL(string: model.profilePictureUrl) else {
                return
            }

            // Derive

            switch type {
            case .like:
                guard let postUrl = URL(string: model.postUrl ?? "") else {
                    return
                }
                viewModels.append(
                    .like(
                        viewModel: LikeNotificationCellViewModel(
                            username: username,
                            profilePictureUrl: profilePictureUrl,
                            postUrl: postUrl,
                            date: model.dateString
                        )
                    )
                )
            case .comment:
                guard let postUrl = URL(string: model.postUrl ?? "") else {
                    return
                }
                viewModels.append(
                    .comment(
                        viewModel: CommentNotificationCellViewModel(
                            username: username,
                            profilePictureUrl: profilePictureUrl,
                            postUrl: postUrl,
                            date: model.dateString
                        )
                    )
                )
            case .follow:
                guard let isFollowing = model.isFollowing else {
                    return
                }
                viewModels.append(
                    .follow(
                        viewModel: FollowNotificationCellViewModel(
                            username: username,
                            profilePictureUrl: profilePictureUrl,
                            isCurrentUserFollowing: isFollowing,
                            date: model.dateString
                        )
                    )
                )
            }
        }

        if viewModels.isEmpty {
            noActivityLabel.isHidden = false
            tableView.isHidden = true
        }
        else {
            noActivityLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    private func mockData() {
        tableView.isHidden = false
        guard let postUrl = URL(string: "https://iosacademy.io/assets/images/courses/swiftui.png") else {
            return
        }
        guard let iconUrl = URL(string: "https://iosacademy.io/assets/images/brand/icon.jpg") else {
            return
        }

        viewModels = [
            .like(
                viewModel: LikeNotificationCellViewModel(
                    username: "kyliejenner",
                    profilePictureUrl: iconUrl,
                    postUrl: postUrl,
                    date: "March 12"
                )
            ),
            .comment(
                viewModel: CommentNotificationCellViewModel(
                    username: "jeffbezos",
                    profilePictureUrl: iconUrl,
                    postUrl: postUrl,
                    date: "March 12"
                )
            ),
            .follow(
                viewModel: FollowNotificationCellViewModel(
                    username: "zuck21",
                    profilePictureUrl: iconUrl,
                    isCurrentUserFollowing: true,
                    date: "March 12"
                )
            )
        ]

        tableView.reloadData()
    }
    
    // MARK: - Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModels[indexPath.row]
        switch cellType {
        case .follow(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowNotificationTableViewCell.identifier, for: indexPath) as? FollowNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
            
        case .like(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeNotificationTableViewCell.identifier, for: indexPath) as? LikeNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            
            return cell
            
        case .comment(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentNotificationTableViewCell.identifier, for: indexPath) as? CommentNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = viewModels[indexPath.row]
        let username:String
        switch cellType {
        case .follow(let viewModel):
            username = viewModel.username
        case .like(let viewModel):
            username = viewModel.username
        case .comment(let viewModel):
            username = viewModel.username
            
        }
        
        
        
        // FIXmE : Update function to use username (the one below is for an email)
        DatabaseManager.shared.findUser(username: username) {[weak self] user in
            guard let user else {
                
                // Show error alert
                return
            }
            DispatchQueue.main.async {
                let vc = ProfileViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}


// MARK: - Actions

extension NotificationsViewController:LikeNotificationTableViewCellDelegate,CommentNotificationTableViewCellDelegate,FollowNotificationTableViewCellDelegate {
    
    func likeNotificationTableViewCell(_ cell: LikeNotificationTableViewCell,
                                       didTapPostWith viewModel: LikeNotificationCellViewModel) {
        guard let index = viewModels.firstIndex(where: {
            switch $0 {
            case .comment, .follow:
                return false
            case .like(let current):
                return current == viewModel
            }
        }) else {
            return
        }

        openPost(with: index, username: viewModel.username)
    }
    
    
    
    func commentNotificationTableViewCell(_ cell: CommentNotificationTableViewCell,
                                          didTapPostWith viewModel: CommentNotificationCellViewModel) {
        guard let index = viewModels.firstIndex(where: {
            switch $0 {
            case .like, .follow:
                return false
            case .comment(let current):
                return current == viewModel
            }
        }) else {
            return
        }

        openPost(with: index, username: viewModel.username)
    }
    
    func followNotificationTableViewCell(_ cell: FollowNotificationTableViewCell, didTapButton isFollowing: Bool, viewModel: FollowNotificationCellViewModel) {
        
        let username = viewModel.username
        
        print("\n\n Request follow =\(isFollowing) of user=\(username)")
        
        DatabaseManager.shared.updateRelationship(state: isFollowing ? .follow : .unfollow, for: username ) {
                    [weak self]success in
                    
                    if !success {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Woops", message: "Unable to perform action", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                            self?.present(alert,animated: true)
                        }
                    }
        
                }
        
    }
    
    func openPost(with index: Int,username: String){
        guard index < models.count else {
            return
            
        }
        let model = models[index]
        let username = username
        guard let postID = model.postId else {
            return
        }
        
        // Find post by id from target user
        DatabaseManager.shared.getPost(with: postID,
                                       from: username) { [weak self]post in
            guard let post = post else {
                let alert = UIAlertController(title: "Oops", message: "We are unable to open this post.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                self?.present(alert,animated: true)
                return
            }
            let vc = PostViewController(post: post, owner: username)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
