//
//  NetworkPlugin.swift
//  PluginArchitecture
//
//  Created by Cédric Bahirwe on 06/10/2025.
//

import Foundation

/// A plugin for handling network requests
public class NetworkPlugin: Plugin {
    public let identifier = "com.plugin.network"
    public let name = "Network Plugin"
    public let version = "1.0.0"
    
    public private(set) var isActive = false
    
    private var baseURL: String = ""
    private var timeout: TimeInterval = 30.0
    private var headers: [String: String] = [:]
    
    public init() {}
    
    public func initialize(configuration: [String: Any]) {
        if let url = configuration["baseURL"] as? String {
            baseURL = url
        }
        if let timeoutValue = configuration["timeout"] as? TimeInterval {
            timeout = timeoutValue
        }
        if let headersDict = configuration["headers"] as? [String: String] {
            headers = headersDict
        }
    }
    
    public func start() {
        isActive = true
        print("🌐 Network plugin started with base URL: \(baseURL)")
    }
    
    public func stop() {
        print("🌐 Network plugin stopped")
        isActive = false
    }
    
    /// Simulate a network request
    /// - Parameters:
    ///   - endpoint: The endpoint to request
    ///   - completion: Completion handler with result
    public func request(endpoint: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard isActive else {
            completion(.failure(NetworkError.pluginNotActive))
            return
        }
        
        let fullURL = baseURL + endpoint
        print("🌐 Making request to: \(fullURL)")
        print("🌐 Headers: \(headers)")
        
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            completion(.success("Response from \(fullURL)"))
        }
    }
    
    /// Add a header to all requests
    /// - Parameters:
    ///   - value: Header value
    ///   - key: Header key
    public func addHeader(value: String, forKey key: String) {
        headers[key] = value
    }
    
    /// Remove a header
    /// - Parameter key: Header key to remove
    public func removeHeader(forKey key: String) {
        headers.removeValue(forKey: key)
    }
    
    public enum NetworkError: Error, LocalizedError {
        case pluginNotActive
        case invalidURL
        case requestFailed
        
        public var errorDescription: String? {
            switch self {
            case .pluginNotActive:
                return "Network plugin is not active"
            case .invalidURL:
                return "Invalid URL"
            case .requestFailed:
                return "Network request failed"
            }
        }
    }
}
