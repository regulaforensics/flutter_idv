import XCTest
import IDVSDK
import flutter_idv

class Tests: XCTestCase {
    // init
    
    func test_initConfig() {
        compare(name: "initConfig", fromJson: RISWJSONConstructor.initConfig, generate: RISWJSONConstructor.generateInitConfig)
    }
}
