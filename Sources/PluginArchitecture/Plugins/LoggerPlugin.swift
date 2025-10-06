//
//  LoggerPlugin.swift
//  PluginArchitecture
//
//  Created by Cédric Bahirwe on 06/10/2025.
//

import Foundation

/// A plugin for logging messages
public class LoggerPlugin: Plugin {
    public let identifier = "com.plugin.logger"
    public let name = "Logger Plugin"
    public let version = "1.0.0"
    
    public private(set) var isActive = false
    
    private var logLevel: LogLevel = .info
    
    public enum LogLevel: String {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
    }
    
    public init() {}
    
    public func initialize(configuration: [String: Any]) {
        if let level = configuration["logLevel"] as? String {
            switch level.lowercased() {
            case "debug": logLevel = .debug
            case "info": logLevel = .info
            case "warning": logLevel = .warning
            case "error": logLevel = .error
            default: logLevel = .info
            }
        }
    }
    
    public func start() {
        isActive = true
        log("Logger plugin started", level: .info)
    }
    
    public func stop() {
        log("Logger plugin stopped", level: .info)
        isActive = false
    }
    
    /// Log a message with a specific level
    /// - Parameters:
    ///   - message: The message to log
    ///   - level: The log level
    public func log(_ message: String, level: LogLevel = .info) {
        guard isActive else { return }
        
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        print("[\(timestamp)] [\(level.rawValue)] \(message)")
    }
    
    /// Convenience methods for different log levels
    public func debug(_ message: String) {
        log(message, level: .debug)
    }
    
    public func info(_ message: String) {
        log(message, level: .info)
    }
    
    public func warning(_ message: String) {
        log(message, level: .warning)
    }
    
    public func error(_ message: String) {
        log(message, level: .error)
    }
}
