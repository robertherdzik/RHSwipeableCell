//
//  RHExampleListPresenter.swift
//  TableSwapableCell
//
//  Created by Robert Herdzik on 24/04/16.
//  Copyright © 2016 Ro. All rights reserved.
//

import Foundation

protocol RHExampleListPresenterProtocol {
    init(view: RHExampleListViewProtocol, model: Array<String>)
    func numberOfElements() -> Int
    func titleAtIndex(index: Int) -> String?
}

class RHExampleListPresenter: RHExampleListPresenterProtocol {
    
    unowned var view: RHExampleListViewProtocol
    private let model: Array<String>
    
    required init(view: RHExampleListViewProtocol, model: Array<String>) {
        self.view = view
        self.model = model
    }
    
    func numberOfElements() -> Int {
        return model.count
    }
    
    func titleAtIndex(index: Int) -> String? {
        return model[index] ?? ""
    }
}