//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Виктор on 04.05.2023.
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        let array = [1,1,2,3,4,5]
        
        let result = array[safe: 2]
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 2)
    }
    
    func testGetValueOutOfRange() throws {
        let array = [1,1,2,3,4,5]
        
        let result = array[safe: 20]
        
        XCTAssertNil(result)
    }
}
