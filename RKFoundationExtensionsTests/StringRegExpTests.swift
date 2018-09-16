import XCTest
@testable import RKFoundationExtensions

class StringRegExpTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testStringExtensionIsEmail() {
        XCTAssertTrue("a@a.ru".isEmail)
        XCTAssertTrue("a@a.com".isEmail)
        XCTAssertTrue("a@b.qwe.qwerr".isEmail)


        XCTAssertFalse("".isEmail)
        XCTAssertFalse("a".isEmail)
        XCTAssertFalse("a@".isEmail)
        XCTAssertFalse("@a".isEmail)
        XCTAssertFalse("@".isEmail)
        XCTAssertFalse("a@a".isEmail)
        XCTAssertFalse("a@a.".isEmail)
        XCTAssertFalse("a@.".isEmail)
        XCTAssertFalse("a @b.qwe.qwerr".isEmail)
        XCTAssertFalse("a@ b.qwe.qwerr".isEmail)
        XCTAssertFalse("a@b.qwe.qwerr ".isEmail)
        XCTAssertFalse(" a@b.qwe.qwerr ".isEmail)
    }

    func testStringExtensionIsNumber() {
        XCTAssertTrue("1".isNumber)
        XCTAssertTrue("3232323".isNumber)
        XCTAssertTrue("00".isNumber)


        XCTAssertFalse("".isNumber)
        XCTAssertFalse(" ".isNumber)
        XCTAssertFalse(" 0".isNumber)
        XCTAssertFalse("0 ".isNumber)
        XCTAssertFalse("  0 2 0".isNumber)
    }
}
