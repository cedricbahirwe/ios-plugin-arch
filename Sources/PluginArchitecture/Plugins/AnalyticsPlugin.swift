//
//  AnalyticsPlugin.swift
//  PluginArchitecture
//
//  Created by Cédric Bahirwe on 06/10/2025.
//

import Foundation

/// A plugin for tracking analytics events
public class AnalyticsPlugin: Plugin {
    public let identifier = "com.plugin.analytics"
    public let name = "Analytics Plugin"
    public let version = "1.0.0"
    
    public private(set) var isActive = false
    
    private var events: [(event: String, properties: [String: Any], timestamp: Date)] = []
    private var trackingEnabled = true
    
    public init() {}
    
    public func initialize(configuration: [String: Any]) {
        if let enabled = configuration["trackingEnabled"] as? Bool {
            trackingEnabled = enabled
        }
    }
    
    public func start() {
        isActive = true
        print("📊 Analytics plugin started")
    }
    
    public func stop() {
        print("📊 Analytics plugin stopped. Total events tracked: \(events.count)")
        isActive = false
    }
    
    /// Track an analytics event
    /// - Parameters:
    ///   - event: The name of the event
    ///   - properties: Additional properties associated with the event
    public func track(event: String, properties: [String: Any] = [:]) {
        guard isActive && trackingEnabled else { return }
        
        let timestamp = Date()
        events.append((event: event, properties: properties, timestamp: timestamp))
        print("📊 Event tracked: \(event) with properties: \(properties)")
    }
    
    /// Get all tracked events
    /// - Returns: Array of tracked events
    public func getAllEvents() -> [(event: String, properties: [String: Any], timestamp: Date)] {
        return events
    }
    
    /// Clear all tracked events
    public func clearEvents() {
        events.removeAll()
        print("📊 All events cleared")
    }
    
    /// Get count of tracked events
    public var eventCount: Int {
        return events.count
    }
}
