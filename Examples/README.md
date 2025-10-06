# Examples

This directory contains additional examples and templates for using the plugin architecture.

## Files

### PluginConfiguration.swift
Demonstrates best practices for configuring plugins with environment-specific settings.

**Features:**
- Environment-based configuration (dev, staging, production)
- Structured configuration objects
- Type-safe configuration values

**Usage:**
```swift
let config = PluginConfiguration.configureNetwork(environment: .production)
manager.initialize(plugin: networkPlugin.identifier, configuration: config)
```

### CustomPlugin.swift
A complete example of building a custom plugin from scratch.

**Demonstrates:**
- Full Plugin protocol implementation
- Thread-safe operations using GCD
- Cache management with eviction policies
- Proper lifecycle management
- Public API design

**Usage:**
```swift
let cache = CachePlugin()
try manager.register(cache)
cache.start()

cache.set("value", forKey: "key")
let value = cache.get(forKey: "key")
```

## Creating Your Own Plugin

Follow these steps to create a custom plugin:

### 1. Define Your Plugin Class

```swift
public class MyPlugin: Plugin {
    public let identifier = "com.yourcompany.myplugin"
    public let name = "My Custom Plugin"
    public let version = "1.0.0"
    public private(set) var isActive = false
    
    public init() {}
}
```

### 2. Implement Lifecycle Methods

```swift
public func initialize(configuration: [String: Any]) {
    // Parse and store configuration
}

public func start() {
    isActive = true
    // Initialize resources
}

public func stop() {
    // Clean up resources
    isActive = false
}
```

### 3. Add Your Custom Functionality

```swift
public func doSomething() {
    guard isActive else { return }
    // Your plugin logic
}
```

### 4. Register and Use

```swift
let plugin = MyPlugin()
try PluginManager.shared.register(plugin)
plugin.start()
plugin.doSomething()
```

## Common Plugin Patterns

### Observer Pattern
Plugins can observe and react to events:
```swift
public protocol ObserverPlugin: Plugin {
    func onEvent(_ event: String, data: [String: Any])
}
```

### Provider Pattern
Plugins can provide services to other plugins:
```swift
public protocol ServiceProvider: Plugin {
    func getService() -> SomeService
}
```

### Decorator Pattern
Plugins can enhance or modify behavior:
```swift
public protocol DecoratorPlugin: Plugin {
    func decorate(_ input: String) -> String
}
```

## Best Practices

1. **Single Responsibility**: Each plugin should do one thing well
2. **Thread Safety**: Use appropriate synchronization for shared state
3. **Error Handling**: Gracefully handle errors and edge cases
4. **Configuration**: Make plugins configurable rather than hardcoded
5. **Documentation**: Document your plugin's API and configuration options
6. **Testing**: Write unit tests for your plugin's functionality
7. **Lifecycle**: Properly implement start/stop for resource management

## Advanced Topics

### Plugin Dependencies
If a plugin depends on another:
```swift
public func start() {
    guard let dependency = PluginManager.shared.plugin(for: "dependency.id") else {
        print("⚠️  Dependency not found")
        return
    }
    isActive = true
}
```

### Async Operations
For async plugin operations:
```swift
public func performAsync(completion: @escaping (Result<Data, Error>) -> Void) {
    guard isActive else {
        completion(.failure(PluginError.notActive))
        return
    }
    
    DispatchQueue.global().async {
        // Async work
        completion(.success(data))
    }
}
```

### Plugin Communication
Plugins can communicate through the manager:
```swift
if let analytics = PluginManager.shared.plugin(for: "analytics.id") as? AnalyticsPlugin {
    analytics.track(event: "custom_action")
}
```
