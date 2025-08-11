import XCTest
@testable import EducationAI

final class BasicTests: XCTestCase {
    func testEducationAIInitialization() {
        let educationAI = EducationAI()
        XCTAssertNotNil(educationAI)
    }
}
