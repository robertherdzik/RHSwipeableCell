//
//  RHExampleListPresenter.swift
//  TableSwapableCell
//
//  Created by Robert Herdzik on 24/04/16.
//  Copyright © 2016 Ro. All rights reserved.
//

import Foundation

protocol RHExampleListPresenterProtocol {
    
    init(view: RHExampleListViewProtocol, model: [RHPersonProtocol])
    
    func numberOfElements() -> Int
    func titleAtIndex(index: Int) -> String?
    func subtitleAtIndex(index: Int) -> String?
}

class RHExampleListPresenter: RHExampleListPresenterProtocol {

    unowned var view: RHExampleListViewProtocol
    private let model: [RHPersonProtocol]
    
    required init(view: RHExampleListViewProtocol, model: [RHPersonProtocol]) {
        self.view = view
        self.model = model
    }

    private func getModelElementAtIndex(index: Int) -> RHPersonProtocol? {
        if index < model.count && index >= 0 { return model[index] }
        else { return nil }
    }
    
    func numberOfElements() -> Int {
        return model.count
    }
    
    func titleAtIndex(index: Int) -> String? {
        guard let person = getModelElementAtIndex(index) else { return "" }
        
        return person.name + person.surname
    }
    
    func subtitleAtIndex(index: Int) -> String? {
        guard let person = getModelElementAtIndex(index) else { return "" }
        
        return person.profession
    }
}