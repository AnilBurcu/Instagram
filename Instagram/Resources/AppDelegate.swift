//
//  AppDelegate.swift
//  Instagram
//
//  Created by Anıl Bürcü on 22.03.2023.
//
import Firebase
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        
         //Add dummy notification for current user
//        let id = NotificationManager.newIdentifier()
//        let model = IGNotification(
//            identifier: id,
//            notificationType: 1,
//            profilePictureUrl: "https://iosacademy.io/assets/images/brand/icon.jpg",
//            username: "lebronJames",
//            dateString: String.date(from: Date()) ?? "Now",
//            isFollowing: true,
//            postId: "9989",
//            postUrl: "https://iosacademy.io/assets/images/brand/icon.jpg"
//        )
//        NotificationManager.shared.create(notification: model, for: "deneme")

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

