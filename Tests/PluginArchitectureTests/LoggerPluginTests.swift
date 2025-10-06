import XCTest
@testable import PluginArchitecture

final class LoggerPluginTests: XCTestCase {
    
    var plugin: LoggerPlugin!
    
    override func setUp() {
        super.setUp()
        plugin = LoggerPlugin()
    }
    
    func testPluginMetadata() {
        XCTAssertEqual(plugin.identifier, "com.plugin.logger")
        XCTAssertEqual(plugin.name, "Logger Plugin")
        XCTAssertEqual(plugin.version, "1.0.0")
    }
    
    func testPluginStartStop() {
        XCTAssertFalse(plugin.isActive)
        
        plugin.start()
        XCTAssertTrue(plugin.isActive)
        
        plugin.stop()
        XCTAssertFalse(plugin.isActive)
    }
    
    func testPluginInitialization() {
        plugin.initialize(configuration: ["logLevel": "debug"])
        plugin.start()
        XCTAssertTrue(plugin.isActive)
    }
}
