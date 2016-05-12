//
//  RHSwipeableCellDelegate.swift
//  TableSwapableCell
//
//  Created by Robert Herdzik on 24/04/16.
//  Copyright © 2016 Ro. All rights reserved.
//

import UIKit

protocol RHSwipeableCellDelegate: class {
    func rightButtonTapped(tableView: UITableView, indexPath: NSIndexPath)
}