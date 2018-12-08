//
//  HepsiburadaTests.swift
//  HepsiburadaTests
//
//  Created by macbookair on 20.09.2018.
//  Copyright © 2018 Erim Kurt. All rights reserved.
//

import XCTest
@testable import Hepsiburada

class HepsiburadaTests: XCTestCase {

    func testSquareItemsWidth(){
        let allWidth: CGFloat = 400.0
        let numberOfEachItemsPerRow: CGFloat = 3.0
        let minimumLineSpacing: CGFloat = 5.0
        
        var itemWidth: CGFloat = allWidth
        itemWidth.calculateSquared(numberOfEachItemsPerRow: CGFloat(numberOfEachItemsPerRow))
        
        XCTAssertEqual(itemWidth, ((allWidth - minimumLineSpacing) / numberOfEachItemsPerRow))
    }

}
