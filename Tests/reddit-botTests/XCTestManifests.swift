import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(reddit_botTests.allTests),
    ]
}
#endif