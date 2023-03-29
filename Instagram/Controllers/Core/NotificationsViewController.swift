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
    
    private var viewModel: [NotificationCelltype] = []
    
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
//        NotificationManager.shared.getNotification {notification in
//
//        }
        mockData()
        
    }
    private func mockData(){
        
        tableView.isHidden = false
        guard let postUrl = URL(string: "https://iosacademy.io/assets/images/courses/swiftui.png") else {
            return
        }
        guard let iconUrl = URL(string: "https://iosacademy.io/assets/images/brand/icon.jpg") else {
            return
        }
        
        viewModel = [
            .like(viewModel: LikeNotificationCellViewModel(
                username: "kylieJenner",
                profilePictureUrl: iconUrl,
                postUrl: postUrl)),
            .comment(viewModel: CommentNotificationCellViewModel(
                username: "lebronjames",
                profilePictureUrl: iconUrl,
                postUrl: postUrl)),
            .follow(viewModel: FollowNotificationCellViewModel(
                username: "elonMusk",
                profilePictureUrl: iconUrl,
                isCurrentUserFollowing: true))
            
        ]
        tableView.reloadData()
    }
    
    // MARK: - Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel[indexPath.row]
        switch cellType {
        case .follow(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowNotificationTableViewCell.identifier, for: indexPath) as? FollowNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
            
        case .like(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeNotificationTableViewCell.identifier, for: indexPath) as? LikeNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
            
        case .comment(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentNotificationTableViewCell.identifier, for: indexPath) as? CommentNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    


}
