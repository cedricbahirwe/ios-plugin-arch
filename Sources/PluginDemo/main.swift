import Foundation
import PluginArchitecture

print("=== iOS Plugin Architecture Demo ===\n")

// Create plugin instances
let loggerPlugin = LoggerPlugin()
let analyticsPlugin = AnalyticsPlugin()
let networkPlugin = NetworkPlugin()

// Get the plugin manager
let manager = PluginManager.shared

do {
    // Register plugins
    print("📦 Registering plugins...\n")
    try manager.register(loggerPlugin)
    try manager.register(analyticsPlugin)
    try manager.register(networkPlugin)
    
    print("\n--- Initializing Plugins ---\n")
    
    // Initialize plugins with configuration
    manager.initialize(plugin: loggerPlugin.identifier, configuration: ["logLevel": "info"])
    manager.initialize(plugin: analyticsPlugin.identifier, configuration: ["trackingEnabled": true])
    manager.initialize(plugin: networkPlugin.identifier, configuration: [
        "baseURL": "https://api.example.com",
        "timeout": 30.0,
        "headers": ["Authorization": "Bearer token123"]
    ])
    
    print("\n--- Starting All Plugins ---\n")
    
    // Start all plugins
    manager.startAll()
    
    print("\n--- Using Logger Plugin ---\n")
    
    // Use logger plugin
    loggerPlugin.info("Application started successfully")
    loggerPlugin.debug("Debug information")
    loggerPlugin.warning("This is a warning message")
    loggerPlugin.error("An error occurred")
    
    print("\n--- Using Analytics Plugin ---\n")
    
    // Use analytics plugin
    analyticsPlugin.track(event: "app_launched", properties: ["platform": "iOS", "version": "1.0"])
    analyticsPlugin.track(event: "user_login", properties: ["userId": "12345", "method": "email"])
    analyticsPlugin.track(event: "screen_view", properties: ["screen_name": "home"])
    
    print("Total events tracked: \(analyticsPlugin.eventCount)")
    
    print("\n--- Using Network Plugin ---\n")
    
    // Use network plugin
    let semaphore = DispatchSemaphore(value: 0)
    
    networkPlugin.request(endpoint: "/users/profile") { result in
        switch result {
        case .success(let response):
            print("✅ Request successful: \(response)")
        case .failure(let error):
            print("❌ Request failed: \(error.localizedDescription)")
        }
        semaphore.signal()
    }
    
    semaphore.wait()
    
    print("\n--- Listing All Registered Plugins ---\n")
    
    // List all plugins
    let allPlugins = manager.allPlugins()
    for plugin in allPlugins {
        print("• \(plugin.name) (v\(plugin.version)) - Identifier: \(plugin.identifier) - Active: \(plugin.isActive)")
    }
    
    print("\n--- Stopping All Plugins ---\n")
    
    // Stop all plugins
    manager.stopAll()
    
    print("\n=== Demo Complete ===")
    
} catch let error as PluginError {
    print("❌ Plugin Error: \(error.localizedDescription)")
} catch {
    print("❌ Unexpected error: \(error)")
}
