import XCTest
@testable import PluginArchitecture

final class NetworkPluginTests: XCTestCase {
    
    var plugin: NetworkPlugin!
    
    override func setUp() {
        super.setUp()
        plugin = NetworkPlugin()
    }
    
    func testPluginMetadata() {
        XCTAssertEqual(plugin.identifier, "com.plugin.network")
        XCTAssertEqual(plugin.name, "Network Plugin")
        XCTAssertEqual(plugin.version, "1.0.0")
    }
    
    func testInitializationWithConfiguration() {
        plugin.initialize(configuration: [
            "baseURL": "https://api.test.com",
            "timeout": 60.0,
            "headers": ["Authorization": "Bearer test"]
        ])
        
        plugin.start()
        XCTAssertTrue(plugin.isActive)
    }
    
    func testRequestWhenInactive() {
        let expectation = self.expectation(description: "Request should fail")
        
        plugin.request(endpoint: "/test") { result in
            switch result {
            case .success:
                XCTFail("Request should not succeed when plugin is inactive")
            case .failure(let error):
                if let networkError = error as? NetworkPlugin.NetworkError {
                    XCTAssertEqual(networkError, .pluginNotActive)
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    func testSuccessfulRequest() {
        plugin.initialize(configuration: ["baseURL": "https://api.test.com"])
        plugin.start()
        
        let expectation = self.expectation(description: "Request should succeed")
        
        plugin.request(endpoint: "/users") { result in
            switch result {
            case .success(let response):
                XCTAssertTrue(response.contains("https://api.test.com/users"))
                expectation.fulfill()
            case .failure:
                XCTFail("Request should succeed")
            }
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    func testAddAndRemoveHeaders() {
        plugin.addHeader(value: "test-value", forKey: "X-Test-Header")
        plugin.removeHeader(forKey: "X-Test-Header")
        plugin.start()
        XCTAssertTrue(plugin.isActive)
    }
}
