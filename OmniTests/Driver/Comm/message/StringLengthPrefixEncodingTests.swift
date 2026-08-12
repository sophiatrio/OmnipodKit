//
//  StringLengthPrefixEncodingTests.swift
//  OmniTests
//
//  From OmniBLE/OmniBLETests/Drive/Comm/message/StringLengthPrefixEncodingTests.swift
//  Created by Bill Gestrich on 12/11/21.
//  Copyright © 2021 LoopKit Authors. All rights reserved.
//

import XCTest
@testable import OmnipodKit

class StringLengthPrefixEncodingTests: XCTestCase {

    let p0Payload = Data(hexadecimalString: "50,30,3d,00,01,a5".replacingOccurrences(of: ",", with: ""))!
    let p0Content = Data(hexadecimalString:"a5")!

    func testFormatKeysP0() {
        let payload = StringLengthPrefixEncoding.formatKeys(keys: ["P0="], payloads: [p0Content])
        assert(p0Payload.hexadecimalString == payload.hexadecimalString)
    }

    func testParseKeysP0() {
        let parsed = try! StringLengthPrefixEncoding.parseKeys(["P0="], p0Payload)
        assert(parsed.count ==  1)
        assert(parsed[0].toHexString() == p0Content.toHexString())
    }

    // The length is measured after its two-byte prefix; counting the prefix as
    // payload previously allowed this truncated frame to reach an invalid slice.
    func testRejectsTruncatedValue() {
        let payload = Data([0x50, 0x30, 0x3d, 0x00, 0x04, 0xaa, 0xbb])
        XCTAssertThrowsError(try StringLengthPrefixEncoding.parseKeys(["P0="], payload))
    }
}
