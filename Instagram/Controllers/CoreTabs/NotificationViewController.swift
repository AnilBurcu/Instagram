//
//  NotificationViewController.swift
//  Instagram
//
//  Created by Anıl Bürcü on 20.02.2023.
//

import UIKit

enum UserNotificationType {
    case like(post:UserPost)
    case follow(state: FollowState)
}

struct UserNotification {
    let type: UserNotificationType
    let text: String
    let user: User
    
}

final class NotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(NotificationLikeEventViewTableViewCell.self, forCellReuseIdentifier: NotificationLikeEventViewTableViewCell.identifier)
        tableView.register(NotificationFollowEventTableViewCell.self, forCellReuseIdentifier: NotificationFollowEventTableViewCell.identifier)
        return tableView
    
    }()
    
    private let spinner:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    private lazy var noNotificationView = NoNotificationsView() // sadece çağırdığımızda geleceğinden optimizasyon için lazy kullandık
    
    
    private var models = [UserNotification]()
    //MARK: Lifecycle
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
    
        navigationItem.title = "Notification"
        view.backgroundColor = .systemBackground
        view.addSubview(spinner)
        //spinner.startAnimating()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
        }
    
    private func fetchNotifications() {
        for x in 0...100 {
            let user = User(username: "joe", bio: "", name: (first:"",last: ""), profilePhote: URL(string: "https://www.google.com")!, birthDate: Date(), gender: .male, count: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date())
            let post = UserPost(identifier: "",
                                postType: .photo,
                                thumbnailImage: URL(string: "https://www.google.com")!,
                                postURL: URL(string: "https://www.google.com")!,
                                caption: nil,
                                likeCount: [],
                                comments: [],
                                createdDate: Date(),
                                taggedUsers: [],owner: user)
            let model = UserNotification(type: x % 2 == 0 ? .like(post: post) : .follow(state: .not_following), text: "hello world", user: user)
            
            models.append(model)
        }
    }
    
    private func layoutNoNotificationView(){
        tableView.isHidden = true
        view.addSubview(tableView)
        noNotificationView.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/4)
        noNotificationView.center = view.center // merkezde göstermek için
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.type {
        case .like(_):
            // like cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventViewTableViewCell.identifier,for: indexPath) as! NotificationLikeEventViewTableViewCell
            
            cell.configure(with: model)
            cell.delegate = self
            return cell
            
        case .follow:
            // follow cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.identifier,for: indexPath) as! NotificationFollowEventTableViewCell
            //cell.configure(with: model)
            cell.delegate = self
            return cell
        }
        
    
     
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    


}
extension NotificationViewController:NotificationLikeEventViewTableViewCellDelegate{
    func didTapRelatedPPostButton(model: UserNotification) {
        
        switch model.type {
        case .like(let post):
            let vc = PostViewController(model: nil)
            vc.title = post.postType.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .follow(_):
            fatalError("Dev issue: Should never get called")
        }
        
        
    }
    
    
}

extension NotificationViewController:NotificationFollowEventTableViewCellDelegate{
    func didTapFollowUnfollowButton(model: UserNotification) {
        print("tapped button")
        // perform database update
    }
    
    
    
    
}
