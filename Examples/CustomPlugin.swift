//
//  CachePlugin.swift
//  PluginArchitecture
//
//  Created by Cédric Bahirwe on 06/10/2025.
//

import Foundation
import PluginArchitecture

/// Example of creating a custom plugin
/// This plugin demonstrates caching functionality
public class CachePlugin: Plugin {
    public let identifier = "com.plugin.cache"
    public let name = "Cache Plugin"
    public let version = "1.0.0"
    
    public private(set) var isActive = false
    
    private var cache: [String: Any] = [:]
    private var maxCacheSize = 100
    private let queue = DispatchQueue(label: "com.plugin.cache", attributes: .concurrent)
    
    public init() {}
    
    public func initialize(configuration: [String: Any]) {
        if let size = configuration["maxCacheSize"] as? Int {
            maxCacheSize = size
        }
    }
    
    public func start() {
        isActive = true
        print("💾 Cache plugin started with max size: \(maxCacheSize)")
    }
    
    public func stop() {
        cache.removeAll()
        isActive = false
        print("💾 Cache plugin stopped and cleared")
    }
    
    // MARK: - Cache Operations
    
    /// Store a value in the cache
    /// - Parameters:
    ///   - value: The value to store
    ///   - key: The cache key
    public func set(_ value: Any, forKey key: String) {
        guard isActive else { return }
        
        queue.async(flags: .barrier) {
            if self.cache.count >= self.maxCacheSize {
                // Simple eviction: remove first item
                if let firstKey = self.cache.keys.first {
                    self.cache.removeValue(forKey: firstKey)
                }
            }
            self.cache[key] = value
            print("💾 Cached value for key: \(key)")
        }
    }
    
    /// Retrieve a value from the cache
    /// - Parameter key: The cache key
    /// - Returns: The cached value if found
    public func get(forKey key: String) -> Any? {
        guard isActive else { return nil }
        
        return queue.sync {
            return cache[key]
        }
    }
    
    /// Remove a value from the cache
    /// - Parameter key: The cache key
    public func remove(forKey key: String) {
        guard isActive else { return }
        
        queue.async(flags: .barrier) {
            self.cache.removeValue(forKey: key)
            print("💾 Removed cached value for key: \(key)")
        }
    }
    
    /// Clear all cached values
    public func clearAll() {
        queue.async(flags: .barrier) {
            self.cache.removeAll()
            print("💾 Cache cleared")
        }
    }
    
    /// Get the current cache size
    public var cacheSize: Int {
        queue.sync {
            return cache.count
        }
    }
}

// MARK: - Usage Example
/*
 
 // Create and register the cache plugin
 let cachePlugin = CachePlugin()
 try PluginManager.shared.register(cachePlugin)
 
 // Configure
 PluginManager.shared.initialize(
     plugin: cachePlugin.identifier,
     configuration: ["maxCacheSize": 50]
 )
 
 // Start
 cachePlugin.start()
 
 // Use cache
 cachePlugin.set("John Doe", forKey: "username")
 if let username = cachePlugin.get(forKey: "username") as? String {
     print("Cached username: \(username)")
 }
 
 // Clear specific item
 cachePlugin.remove(forKey: "username")
 
 // Or clear all
 cachePlugin.clearAll()
 
 */
