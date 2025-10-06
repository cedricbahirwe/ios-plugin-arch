//
//  Plugin.swift
//  PluginArchitecture
//
//  Created by Cédric Bahirwe on 06/10/2025.
//

import Foundation

/// Base protocol that all plugins must conform to
public protocol Plugin {
    /// Unique identifier for the plugin
    var identifier: String { get }
    
    /// Human-readable name of the plugin
    var name: String { get }
    
    /// Version of the plugin
    var version: String { get }
    
    /// Initialize the plugin with optional configuration
    /// - Parameter configuration: Dictionary containing configuration parameters
    func initialize(configuration: [String: Any])
    
    /// Start the plugin's operations
    func start()
    
    /// Stop the plugin's operations
    func stop()
    
    /// Check if the plugin is currently active
    var isActive: Bool { get }
}

/// Extension to provide default implementations
public extension Plugin {
    func initialize(configuration: [String: Any]) {
        // Default implementation - can be overridden
    }
}
