//
//  RHExampleListPresenterTests.swift
//  RHSwipeableCellExample
//
//  Created by Robert Herdzik on 12/05/16.
//  Copyright © 2016 Ro. All rights reserved.
//

import XCTest

class RHExampleListPresenterTests: XCTestCase {

    var model: [RHPersonProtocol]!
    
    override func setUp() {
        super.setUp()
     
        model = [
            RHPerson(name: "Robert", surname: "Herdzik", profession: "iOS Dev"),
            RHPerson(name: "John", surname: "Doe", profession: "Android Dev")
        ]
    }
    
    func testNumberOfElements() {
        model = [
            RHPerson(name: "Robert", surname: "Herdzik", profession: "iOS Dev")
        ]
        
        let presenter = RHExampleListPresenter(view: MockedView(), model: model)
        let expectedNumberOfElements = 1
        
        XCTAssertEqual(expectedNumberOfElements, presenter.numberOfElements())
    }
    
    func testTitleAtCorrectIndex() {
        let index = 0
        let presenter = RHExampleListPresenter(view: MockedView(), model: model)
        
        let person = model[index]
        let expectedTitle = person.name + person.surname
        
        XCTAssertEqual(expectedTitle, presenter.titleAtIndex(index))
    }
    
    func testTitleAtIncorrectIndex() {
        let index = model.count + 1
        let presenter = RHExampleListPresenter(view: MockedView(), model: model)
        
        let expectedTitle = ""
        XCTAssertEqual(expectedTitle, presenter.titleAtIndex(index))
    }
    
    func testSubtitleAtCorrectIndex() {
        let index = 0
        let presenter = RHExampleListPresenter(view: MockedView(), model: model)
        
        let person = model[index]
        let expectedSubtitle = person.profession
        
        XCTAssertEqual(expectedSubtitle, presenter.subtitleAtIndex(index))
    }
    
    func testSubtitleAtIncorrectIndex() {
        let index = model.count + 1
        let presenter = RHExampleListPresenter(view: MockedView(), model: model)
        
        let expectedSubtitle = ""
        XCTAssertEqual(expectedSubtitle, presenter.subtitleAtIndex(index))
    }
    
    
}

class MockedView: RHExampleListViewProtocol {}
