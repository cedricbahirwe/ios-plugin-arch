//
//  PluginConfiguration.swift
//  PluginArchitecture
//
//  Created by Cédric Bahirwe on 06/10/2025.
//

import Foundation
import PluginArchitecture

/// Example configuration setup for plugins
struct PluginConfiguration {
    
    /// Configure Logger Plugin
    static func configureLogger() -> [String: Any] {
        return [
            "logLevel": "debug",
            "outputToFile": false,
            "maxFileSize": 1024 * 1024 * 10 // 10MB
        ]
    }
    
    /// Configure Analytics Plugin
    static func configureAnalytics() -> [String: Any] {
        return [
            "trackingEnabled": true,
            "anonymousTracking": false,
            "batchSize": 20,
            "flushInterval": 60.0
        ]
    }
    
    /// Configure Network Plugin
    static func configureNetwork(environment: Environment) -> [String: Any] {
        let baseURL: String
        
        switch environment {
        case .development:
            baseURL = "https://dev-api.example.com"
        case .staging:
            baseURL = "https://staging-api.example.com"
        case .production:
            baseURL = "https://api.example.com"
        }
        
        return [
            "baseURL": baseURL,
            "timeout": 30.0,
            "headers": [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "User-Agent": "iOS-App/1.0"
            ]
        ]
    }
    
    enum Environment {
        case development
        case staging
        case production
    }
}

/// Example usage:
///
/// ```swift
/// let manager = PluginManager.shared
/// let logger = LoggerPlugin()
///
/// try manager.register(logger)
/// manager.initialize(
///     plugin: logger.identifier,
///     configuration: PluginConfiguration.configureLogger()
/// )
/// logger.start()
/// ```
