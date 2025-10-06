# iOS Plugin Architecture

A comprehensive demonstration of plugin architecture in Swift, showing how to build modular, extensible iOS applications using protocol-oriented programming and dependency injection patterns.

## 🎯 Overview

This project demonstrates a clean, production-ready plugin architecture that allows for:
- **Modular Design**: Easily add or remove functionality without affecting core code
- **Loose Coupling**: Plugins are independent and communicate through well-defined interfaces
- **Thread Safety**: Plugin manager uses concurrent queues for safe multi-threaded access
- **Lifecycle Management**: Proper initialization, starting, and stopping of plugins
- **Type Safety**: Leverages Swift's strong type system and protocols

## 🏗️ Architecture

You can read more about the architecture [here](ARCHITECTURE.md)

### Core Components

1. **Plugin Protocol**: Base interface that all plugins must implement
2. **PluginManager**: Singleton that manages plugin lifecycle and registration
3. **Sample Plugins**: Three example implementations (Logger, Analytics, Network)

### Plugin Interface

```swift
public protocol Plugin {
    var identifier: String { get }
    var name: String { get }
    var version: String { get }
    var isActive: Bool { get }
    
    func initialize(configuration: [String: Any])
    func start()
    func stop()
}
```

## 🚀 Getting Started

### Requirements

- Swift 5.7 or later
- iOS 13.0+ / macOS 10.15+

### Installation

Clone the repository:

```bash
git clone https://github.com/cedricbahirwe/ios-plugin-arch.git
cd ios-plugin-arch
```

### Building

Build the package:

```bash
swift build
```

### Running Tests

Run all tests:

```bash
swift test
```

### Running the Demo

Execute the demo application:

```bash
swift run PluginDemo
```

## 📦 Included Plugins

### 1. Logger Plugin

Provides structured logging with different log levels (DEBUG, INFO, WARNING, ERROR).

```swift
let logger = LoggerPlugin()
logger.start()
logger.info("Application started")
logger.error("An error occurred")
```

### 2. Analytics Plugin

Tracks events with properties for analytics purposes.

```swift
let analytics = AnalyticsPlugin()
analytics.start()
analytics.track(event: "user_login", properties: ["userId": "12345"])
```

### 3. Network Plugin

Handles network requests with configurable base URL and headers.

```swift
let network = NetworkPlugin()
network.initialize(configuration: ["baseURL": "https://api.example.com"])
network.start()
network.request(endpoint: "/users") { result in
    // Handle response
}
```

## 💡 Usage Example

```swift
import PluginArchitecture

// Get the plugin manager
let manager = PluginManager.shared

// Create and register plugins
let logger = LoggerPlugin()
let analytics = AnalyticsPlugin()

try manager.register(logger)
try manager.register(analytics)

// Initialize with configuration
manager.initialize(plugin: logger.identifier, 
                   configuration: ["logLevel": "debug"])

// Start all plugins
manager.startAll()

// Use plugins
logger.info("Hello from plugin architecture!")
analytics.track(event: "app_started")

// Stop all plugins when done
manager.stopAll()
```

## 🔧 Creating Custom Plugins

To create your own plugin:

1. Create a new class that conforms to the `Plugin` protocol:

```swift
public class MyCustomPlugin: Plugin {
    public let identifier = "com.plugin.mycustom"
    public let name = "My Custom Plugin"
    public let version = "1.0.0"
    public private(set) var isActive = false
    
    public init() {}
    
    public func initialize(configuration: [String: Any]) {
        // Setup configuration
    }
    
    public func start() {
        isActive = true
        // Start plugin operations
    }
    
    public func stop() {
        // Cleanup
        isActive = false
    }
}
```

2. Register and use your plugin:

```swift
let myPlugin = MyCustomPlugin()
try PluginManager.shared.register(myPlugin)
myPlugin.start()
```

## 🧪 Testing

The project includes comprehensive tests covering:
- Plugin registration and lifecycle
- Thread-safe operations
- Error handling
- Individual plugin functionality

All tests use XCTest framework and can be run via `swift test`.

## 📁 Project Structure

```
ios-plugin-arch/
├── Package.swift
├── Sources/
│   ├── PluginArchitecture/
│   │   ├── Plugin.swift              # Core protocol
│   │   ├── PluginManager.swift       # Plugin manager
│   │   └── Plugins/
│   │       ├── LoggerPlugin.swift
│   │       ├── AnalyticsPlugin.swift
│   │       └── NetworkPlugin.swift
│   └── PluginDemo/
│       └── main.swift                # Demo application
└── Tests/
    └── PluginArchitectureTests/
        ├── PluginManagerTests.swift
        ├── LoggerPluginTests.swift
        ├── AnalyticsPluginTests.swift
        └── NetworkPluginTests.swift
```

## 🎓 Key Concepts Demonstrated

- **Protocol-Oriented Programming**: Using protocols to define plugin interfaces
- **Singleton Pattern**: Centralized plugin management
- **Thread Safety**: Concurrent queue for safe multi-threaded access
- **Dependency Injection**: Plugins receive configuration at initialization
- **Lifecycle Management**: Clear start/stop semantics
- **Error Handling**: Type-safe error handling with Swift enums

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Add new example plugins
- Improve documentation
- Add more tests
- Report issues

## 📄 License

This project is available for educational and demonstration purposes.

## 👤 Author

Created by [Cédric Bahirwe](https://github.com/cedricbahirwe)
