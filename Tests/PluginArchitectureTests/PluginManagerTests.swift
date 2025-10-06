import XCTest
@testable import PluginArchitecture

final class PluginManagerTests: XCTestCase {
    
    var manager: PluginManager!
    
    override func setUp() {
        super.setUp()
        manager = PluginManager.shared
        // Unregister all plugins before each test
        let allPlugins = manager.allPlugins()
        allPlugins.forEach { manager.unregister(identifier: $0.identifier) }
    }
    
    func testRegisterPlugin() throws {
        let plugin = LoggerPlugin()
        try manager.register(plugin)
        
        let retrievedPlugin = manager.plugin(for: plugin.identifier)
        XCTAssertNotNil(retrievedPlugin)
        XCTAssertEqual(retrievedPlugin?.identifier, plugin.identifier)
    }
    
    func testRegisterDuplicatePluginThrowsError() {
        let plugin1 = LoggerPlugin()
        let plugin2 = LoggerPlugin()
        
        XCTAssertNoThrow(try manager.register(plugin1))
        XCTAssertThrowsError(try manager.register(plugin2)) { error in
            XCTAssertTrue(error is PluginError)
            if case PluginError.duplicateIdentifier(let id) = error {
                XCTAssertEqual(id, plugin1.identifier)
            }
        }
    }
    
    func testUnregisterPlugin() throws {
        let plugin = LoggerPlugin()
        try manager.register(plugin)
        plugin.start()
        
        XCTAssertTrue(plugin.isActive)
        manager.unregister(identifier: plugin.identifier)
        
        let retrievedPlugin = manager.plugin(for: plugin.identifier)
        XCTAssertNil(retrievedPlugin)
    }
    
    func testGetAllPlugins() throws {
        let logger = LoggerPlugin()
        let analytics = AnalyticsPlugin()
        let network = NetworkPlugin()
        
        try manager.register(logger)
        try manager.register(analytics)
        try manager.register(network)
        
        let allPlugins = manager.allPlugins()
        XCTAssertEqual(allPlugins.count, 3)
    }
    
    func testStartAllPlugins() throws {
        let logger = LoggerPlugin()
        let analytics = AnalyticsPlugin()
        
        try manager.register(logger)
        try manager.register(analytics)
        
        manager.startAll()
        
        XCTAssertTrue(logger.isActive)
        XCTAssertTrue(analytics.isActive)
    }
    
    func testStopAllPlugins() throws {
        let logger = LoggerPlugin()
        let analytics = AnalyticsPlugin()
        
        try manager.register(logger)
        try manager.register(analytics)
        
        manager.startAll()
        XCTAssertTrue(logger.isActive)
        XCTAssertTrue(analytics.isActive)
        
        manager.stopAll()
        XCTAssertFalse(logger.isActive)
        XCTAssertFalse(analytics.isActive)
    }
}
