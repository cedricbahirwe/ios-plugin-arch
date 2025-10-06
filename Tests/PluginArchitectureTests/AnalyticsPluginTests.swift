import XCTest
@testable import PluginArchitecture

final class AnalyticsPluginTests: XCTestCase {
    
    var plugin: AnalyticsPlugin!
    
    override func setUp() {
        super.setUp()
        plugin = AnalyticsPlugin()
    }
    
    func testPluginMetadata() {
        XCTAssertEqual(plugin.identifier, "com.plugin.analytics")
        XCTAssertEqual(plugin.name, "Analytics Plugin")
        XCTAssertEqual(plugin.version, "1.0.0")
    }
    
    func testTrackEvent() {
        plugin.start()
        
        plugin.track(event: "test_event", properties: ["key": "value"])
        XCTAssertEqual(plugin.eventCount, 1)
        
        plugin.track(event: "another_event")
        XCTAssertEqual(plugin.eventCount, 2)
    }
    
    func testClearEvents() {
        plugin.start()
        
        plugin.track(event: "test_event")
        plugin.track(event: "another_event")
        XCTAssertEqual(plugin.eventCount, 2)
        
        plugin.clearEvents()
        XCTAssertEqual(plugin.eventCount, 0)
    }
    
    func testTrackingWhenInactive() {
        XCTAssertFalse(plugin.isActive)
        
        plugin.track(event: "test_event")
        XCTAssertEqual(plugin.eventCount, 0)
    }
    
    func testInitializationWithConfiguration() {
        plugin.initialize(configuration: ["trackingEnabled": false])
        plugin.start()
        
        plugin.track(event: "test_event")
        XCTAssertEqual(plugin.eventCount, 0)
    }
}
