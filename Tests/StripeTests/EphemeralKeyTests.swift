//
//  EphemeralKeyTests.swift
//  StripeTests
//
//  Created by Andrew Edwards on 10/17/17.
//

import XCTest
@testable import Stripe
@testable import Vapor

class EphemeralKeyTests: XCTestCase {
    let emphkeyString = """
    {
        "id": "eph_123456",
        "object": "ephemeral_key",
        "associated_objects": {
            "hello": "world"
        },
        "created": 1234567890,
        "expires": 1234567890,
        "livemode": true,
        "secret": "imasecret"
    }
"""
    
    func testEphemeralKeyParsedProperly() throws {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            let body = HTTPBody(string: emphkeyString)
            let futureKey = try decoder.decode(StripeEphemeralKey.self, from: body, maxSize: 65_536, on: EmbeddedEventLoop())
            
            futureKey.do { (key) in
                XCTAssertEqual(key.id, "eph_123456")
                XCTAssertEqual(key.object, "ephemeral_key")
                XCTAssertEqual(key.associatedObjects?["hello"], "world")
                XCTAssertEqual(key.created, Date(timeIntervalSince1970: 1234567890))
                XCTAssertEqual(key.expires, Date(timeIntervalSince1970: 1234567890))
                XCTAssertEqual(key.livemode, true)
                XCTAssertEqual(key.secret, "imasecret")
                
                }.catch { (error) in
                    XCTFail("\(error.localizedDescription)")
            }
        }
        catch {
            XCTFail("\(error.localizedDescription)")
        }
    }
}