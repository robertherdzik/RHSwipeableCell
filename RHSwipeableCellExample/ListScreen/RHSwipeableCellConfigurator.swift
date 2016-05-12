//
//  RHSwipableCellConfigurator.swift
//  TableSwapableCell
//
//  Created by Robert Herdzik on 24/04/16.
//  Copyright © 2016 Ro. All rights reserved.
//

import UIKit

struct RHSwipeableCellConfigurator: RHSwipeableCellButtonConfigProtocol {
    var bgColor: UIColor
    var title: String
    var titleFont: UIFont?
    
    init(bgColor: UIColor, title: String, titleFont: UIFont? = nil) {
        self.bgColor = bgColor
        self.title = title
        self.titleFont = titleFont
    }
}
