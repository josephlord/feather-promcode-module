import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(feather_promocode_moduleTests.allTests),
    ]
}
#endif
