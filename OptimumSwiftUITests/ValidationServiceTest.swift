//
//  ValidationServiceTest.swift
//  OptimumSwiftUITests
//
//  Created by Jonzo Jimenez on 4/29/22.
//

import XCTest
@testable import OptimumSwiftUI

class ValidationServiceTest: XCTestCase {
    var validation: ValidationService!
    
    override func setUp() {
        super.setUp()
        validation = ValidationService()
    }
    
    override func tearDown() {
        validation = nil
        super.tearDown()
        
    }
    
    
    func test_is_valid_username() throws {
        XCTAssertNoThrow(try validation.validateUsername("Jonoz Jimenez"))
    }
    
    func test_username_is_nil() throws {
        let expectedError = ValidationError.invalidValue
        var error: ValidationError?
        XCTAssertThrowsError(try validation.validateUsername(nil)) { thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    func test_username_too_short() throws {
        let expectedError = ValidationError.usernameTooShort
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validateUsername("th"))  { thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    func test_username_too_Long() throws {
        let expectedError = ValidationError.usernameTooLong
        var error: ValidationError?
        let username = "UserName that is to long"
        
        XCTAssertThrowsError(try validation.validateUsername(username)) { thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    
    func test_is_valid_password() throws {
        XCTAssertNoThrow(try validation.validatePassword("Password"))
    }
    
    func test_is_password_is_nil() throws {
        let expectedError = ValidationError.invalidValue
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validatePassword(nil)) { thrownError in
            error = thrownError as? ValidationError
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_is_password_too_short() throws {
        let expectedError = ValidationError.passwordTooShort
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validatePassword("toshort")) { thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_is_password_too_long() throws {
        let expectedError = ValidationError.passwordTooLong
        var error: ValidationError?
        let password = "Password is way to long"
        XCTAssertThrowsError(try validation.validatePassword(password)) { thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
}
