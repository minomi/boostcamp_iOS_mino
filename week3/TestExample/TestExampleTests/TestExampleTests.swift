//
//  TestExampleTests.swift
//  TestExampleTests
//
//  Created by 오민호 on 2017. 7. 20..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import XCTest
@testable import TestExample

class TestExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testCEO() {
        
        let ceo = CEO()
        
        print(ceo.write("swift"))
        ceo.goTo("seoul")
        
        let delegate = DelegateObject()
        ceo.delegate = delegate
        
        print(ceo.write("swift"))
        ceo.goTo("seoul")
        
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}






















