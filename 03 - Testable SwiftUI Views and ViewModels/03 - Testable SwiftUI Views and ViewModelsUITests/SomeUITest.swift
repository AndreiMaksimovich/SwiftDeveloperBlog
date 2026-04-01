import XCTest

final class SomeUITest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    @MainActor
    func testExample() throws {
        let app = getConfiguredXCUIApplicationInstance()
        app.launch()
        app.activate()
        
        let element = app.buttons["Custom UITesting Button"].firstMatch
        element.tap()
    }
}
