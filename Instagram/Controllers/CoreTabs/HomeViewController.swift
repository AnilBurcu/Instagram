//
//  ViewController.swift
//  Instagram
//
//  Created by Anıl Bürcü on 20.02.2023.
//

import FirebaseAuth
import UIKit

struct HomeFeedRenderViewModel {
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let action: PostRenderViewModel
    let comment: PostRenderViewModel
}

class HomeViewController: UIViewController {
    
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        // Register cells
        
        tableView.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionsTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMockModels()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    
    private func createMockModels(){
        let user = User(username: "@kanye_west71", bio: "", name: (first:"",last: ""), profilePhote: URL(string: "https://www.google.com")!, birthDate: Date(), gender: .male, count: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date())
        let post = UserPost(identifier: "",
                            postType: .photo,
                            thumbnailImage: URL(string: "https://www.google.com")!,
                            postURL: URL(string: "https://www.google.com")!,
                            caption: nil,
                            likeCount: [],
                            comments: [],
                            createdDate: Date(),
                            taggedUsers: [],owner: user)
        
        var comments = [PostComment]()
        for x in 0..<2 {
            comments.append(PostComment(identifier: "\(x)", username: "@jenny", text: "This is the best post I've ever seen", createdDate: Date(), likes: []))
        }
        
        for x in 0..<5 {
            
            let viewModel = HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: user)), post: PostRenderViewModel(renderType: .primaryContent(provider: post)), action: PostRenderViewModel(renderType: .actions(provider: "")), comment: PostRenderViewModel(renderType: .comments(comments: comments)))
            
            
            feedRenderModels.append(viewModel)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        handleNotAuthenticated()
        
        
    }
    
    
    private func handleNotAuthenticated(){
        
        // Check auth status
        if Auth.auth().currentUser == nil {
            // Show login
            
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
            
        }
        
    }
    
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return feedRenderModels.count * 4
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let x = section
        var model : HomeFeedRenderViewModel?
    
        if x == 0 {
             model = feedRenderModels[0]
        }else {
            let position = x % 4 == 0 ? x/4 : ((x % 4)/4)
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        if subSection == 0 {
            // header
            return 1
        }else if subSection == 1{
            // post
            return 1
        }else if subSection == 2{
            // action
            return 1
        }else if subSection == 3{
            // comment
            let commentsModel = model?.comment
            switch commentsModel?.renderType {
            case .comments(comments: let comments): return comments.count > 2 ? 2: comments.count
            case .header, .actions, .primaryContent: return 0
            default:
                print("amin")
            }
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let x = indexPath.section
        var model: HomeFeedRenderViewModel?
        
        if x == 0 {
             model = feedRenderModels[0]
        }else {
            let position = x % 4 == 0 ? x/4 : ((x % 4)/4)
            model = feedRenderModels[position]
        }
        let subSection = x % 4
        
        if subSection == 0 {
            // header
            
            switch model?.header.renderType{
            case .header(let user):
                
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
                cell.configure(with: user)
                cell.delegate = self
                return cell
            case .comments, .actions, .primaryContent: return UITableViewCell()
            default: print("    sdfgsdg")
                
            }
        }else if subSection == 1{
            // post
           
            
            switch model?.post.renderType{
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
                
                cell.configure(with: post)
                
                return cell
            case .comments, .actions, .header: return UITableViewCell()
            default: print("    sdfgsdg")
            }
        }else if subSection == 2{
            // action
            
            switch model?.action.renderType{
            case .actions(let provider):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier, for: indexPath) as! IGFeedPostActionsTableViewCell
                
                cell.delegate = self
                
                return cell
            case .comments, .header, .primaryContent: return UITableViewCell()
            default: print("    sdfgsdg")
            }
        }else if subSection == 3{
            
            // comment
       
            switch model?.comment.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
                return cell
            case .header, .actions, .primaryContent: return UITableViewCell()
            default: print("sdfgsdg")
            }
        }
        return UITableViewCell()
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let subSection = indexPath.section % 4
        
        if subSection == 0 {
            // Header
            return 70
        }else if subSection == 1{
            // Post
            return tableView.width
        }else if subSection == 2{
            // Action  (like/comment)
            return 60
        }else if subSection == 3{
            // Comment row
            return 50
        }else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let subsection = section % 4
        return subsection == 4 ? 70 : 0
    }
    
}
extension HomeViewController:IGFeedPostHeaderTableViewCellDelegate {
    func didTapMoreButton() {
        let actionSheet = UIAlertController(title: "Post Option", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report Post", style: .destructive,handler: {[weak self]_ in
            self?.reportPost()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        present(actionSheet,animated: true)
    }
    
    func reportPost(){
        
    }
    
    
}
extension HomeViewController:IGFeedPostActionsTableViewCellDelegate{
    func didTapLikeButton() {
        print("Like Button Clicked")
    }
    
    func didTapCommentButton() {
        print("Comment Button Clicked")
    }
    
    func didTapSendButton() {
        print("Send Button Clicked")
    }
    
    
}
