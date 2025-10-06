//
//  PluginManager.swift
//  PluginArchitecture
//
//  Created by Cédric Bahirwe on 06/10/2025.
//

import Foundation

/// Manages the lifecycle and registration of plugins
public class PluginManager {
    /// Shared singleton instance
    public static let shared = PluginManager()
    
    /// Dictionary of registered plugins keyed by their identifier
    private var plugins: [String: Plugin] = [:]
    
    /// Thread-safe access to plugins
    private let queue = DispatchQueue(label: "com.pluginarchitecture.manager", attributes: .concurrent)
    
    private init() {}
    
    /// Register a new plugin
    /// - Parameter plugin: The plugin to register
    /// - Throws: PluginError if a plugin with the same identifier already exists
    public func register(_ plugin: Plugin) throws {
        try queue.sync(flags: .barrier) {
            guard plugins[plugin.identifier] == nil else {
                throw PluginError.duplicateIdentifier(plugin.identifier)
            }
            plugins[plugin.identifier] = plugin
            print("✅ Plugin registered: \(plugin.name) (v\(plugin.version))")
        }
    }
    
    /// Unregister a plugin by its identifier
    /// - Parameter identifier: The identifier of the plugin to unregister
    public func unregister(identifier: String) {
        queue.sync(flags: .barrier) {
            if let plugin = plugins.removeValue(forKey: identifier) {
                plugin.stop()
                print("🗑️  Plugin unregistered: \(plugin.name)")
            }
        }
    }
    
    /// Get a plugin by its identifier
    /// - Parameter identifier: The identifier of the plugin
    /// - Returns: The plugin if found, nil otherwise
    public func plugin(for identifier: String) -> Plugin? {
        queue.sync {
            return plugins[identifier]
        }
    }
    
    /// Get all registered plugins
    /// - Returns: Array of all registered plugins
    public func allPlugins() -> [Plugin] {
        queue.sync {
            return Array(plugins.values)
        }
    }
    
    /// Start all registered plugins
    public func startAll() {
        queue.sync {
            plugins.values.forEach { $0.start() }
            print("🚀 All plugins started")
        }
    }
    
    /// Stop all registered plugins
    public func stopAll() {
        queue.sync {
            plugins.values.forEach { $0.stop() }
            print("⏹️  All plugins stopped")
        }
    }
    
    /// Initialize a plugin with configuration
    /// - Parameters:
    ///   - identifier: The plugin identifier
    ///   - configuration: Configuration dictionary
    public func initialize(plugin identifier: String, configuration: [String: Any]) {
        queue.sync {
            plugins[identifier]?.initialize(configuration: configuration)
        }
    }
}

/// Errors that can occur during plugin management
public enum PluginError: Error, LocalizedError {
    case duplicateIdentifier(String)
    case pluginNotFound(String)
    
    public var errorDescription: String? {
        switch self {
        case .duplicateIdentifier(let id):
            return "A plugin with identifier '\(id)' is already registered"
        case .pluginNotFound(let id):
            return "Plugin with identifier '\(id)' not found"
        }
    }
}
