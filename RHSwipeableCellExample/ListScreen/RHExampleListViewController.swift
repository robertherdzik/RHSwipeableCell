//
//  RHExampleListViewController.swift
//  TableSwapableCell
//
//  Created by Robert Herdzik on 8/25/15.
//  Copyright (c) 2015 Ro. All rights reserved.
//

import UIKit

protocol RHExampleListViewProtocol: class {}

class RHExampleListViewController: UIViewController {
    
    private let rhSwipeableCellIdentifier = "rh_swipeable_cell"
    
    var presenter: RHExampleListPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func loadView() {
        self.view = RHExampleListView(frame: CGRectZero)
    }
    
    private func castView() -> RHExampleListView {
        return self.view as! RHExampleListView
    }
    
    private func setup() {
        self.castView().tableView.delegate = self
        self.castView().tableView.dataSource = self
    }
    
    private func customizeRightCellButton(cell: RHSwipeableCell) {
        let rightButtonFont = UIFont(name: "Helvetica", size: 40)
        let butomConfiguration = RHSwipeableCellConfigurator(bgColor: UIColor.cyanColor(), title: "Add", titleFont: rightButtonFont)
        cell.customizeButton(butomConfiguration)
    }
}

extension RHExampleListViewController: RHExampleListViewProtocol {}

extension RHExampleListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfElements()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: RHSwipeableCell! = tableView.dequeueReusableCellWithIdentifier(rhSwipeableCellIdentifier) as? RHSwipeableCell
        if cell == nil {
            cell = RHSwipeableCell(style: .Subtitle, reuseIdentifier: "rhSwipeableCellIdentifier")
        }
        
        customizeRightCellButton(cell)
        cell.delegate = self
        cell.textLabel?.text = presenter.titleAtIndex(indexPath.row)
        cell.detailTextLabel?.text = presenter.subtitleAtIndex(indexPath.row)
        
        return cell
    }
}

extension RHExampleListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        print("😨 indx tapped: %d", indexPath.row)
    }
}

extension RHExampleListViewController: RHSwipeableCellDelegate {
    
    func rightButtonTapped(tableView: UITableView, indexPath: NSIndexPath) {
        print("🦄 RIGHT button was tapped: index: \(indexPath.row)")
    }
}