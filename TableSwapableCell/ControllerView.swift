//
//  ControllerView.swift
//  TableSwapableCell
//
//  Created by Robert Herdzik on 8/25/15.
//  Copyright (c) 2015 Ro. All rights reserved.
//

import UIKit

class ControllerView: UIView {

    let tableView = UITableView(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(tableView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
}
