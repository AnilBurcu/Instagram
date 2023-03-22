//
//  AnalyticsManager.swift
//  Instagram
//
//  Created by Anıl Bürcü on 22.03.2023.
//

import FirebaseAnalytics
import Foundation

final class AnalyticsManager {
    
    static let shared = AnalyticsManager()
    
    private init() {}
    
    func logEvent() {
        Analytics.logEvent("", parameters: [:])
    }
    
}

