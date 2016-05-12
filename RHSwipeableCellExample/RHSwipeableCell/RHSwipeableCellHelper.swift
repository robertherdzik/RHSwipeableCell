//
//  RHSwipeableCellHelper.swift
//  TableSwapableCell
//
//  Created by Robert Herdzik on 24/04/16.
//  Copyright © 2016 Ro. All rights reserved.
//

import UIKit

struct RHSwipeableCellHelper {
    
    /**
     Methods search the nearest tableView in cellView hierarchy
     
     - parameter cell: cell which parent tableView is searching for
     
     - returns: related with given cell tableView or nil
     */
    static func findRelatedTableView(cell: UITableViewCell) -> UITableView? {
        var tableView: UITableView? = nil
        var view = cell.superview;
        
        repeat {
            if let view = view where view.isKindOfClass(UITableView) {
                tableView = view as? UITableView
                break;
            }
            
            view = view?.superview
        } while (view?.superview != nil)
        
        return tableView
    }
    
     /**
     Method change view background color with animation
     
     - parameter view:              view which has to change background color with animation
     - parameter originBgColor:     [not reqiured] origin view background color (as default: whiteColor())
     - parameter targetBgColor:     [not reqiured] color with which origin color will be exchanged during animation (as default: lightGrayColor())
     - parameter animationDuration: [not reqiured] duration of change bg color animation (as default: 0.3)
     */
    static func simulateCellTapEffect(view: UIView, originBgColor: UIColor = UIColor.whiteColor(), targetBgColor: UIColor = UIColor.lightGrayColor(), animationDuration: NSTimeInterval = 0.3) {
        view.backgroundColor = targetBgColor
        UIView.animateWithDuration(animationDuration) {
            view.backgroundColor = originBgColor
        }
    }
}