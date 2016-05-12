//
//  RHPerson.swift
//  RHSwipeableCellExample
//
//  Created by Robert Herdzik on 12/05/16.
//  Copyright © 2016 Ro. All rights reserved.
//

protocol RHPersonProtocol {
    var name: String { get }
    var surname: String  { get }
    var profession: String  { get }
}

struct RHPerson: RHPersonProtocol {
    var name: String
    var surname: String
    var profession: String
}