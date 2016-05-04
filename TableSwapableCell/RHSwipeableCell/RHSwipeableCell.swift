//
//  RHSwipeableCell.swift
//  TableSwapableCell
//
//  Created by Robert Herdzik on 24/05/15.
//  Copyright © 2016 Ro. All rights reserved.
//

import UIKit

class RHSwipeableCell: UITableViewCell {
    
    private let collapse_notif_key = "RHSwipeableCell_collapse_key"
    
    enum RHCellState: Int {
        case Normal
        case Expanded
    }
    
    private let rightBttnWidth = CGFloat(100)
    
    private let scrollView = UIScrollView(frame: CGRectZero)
    private var relatedTableView: UITableView?
    private var rightButton = RHSwipeableCellButton(frame: CGRectZero)
    
    /// Until there is only one scroll view we can use in scrollView delegate methods this property
    private var scrollViewContentOffsetX: CGFloat {
        get {
            return scrollView.contentOffset.x
        }
        set {
            scrollView.contentOffset.x = newValue
        }
    }
    
    var state: RHCellState {
        set {
            adjustCellComponents(newValue)
        }
        get {
            return scrollViewContentOffsetX == 0 ? .Normal : .Expanded
        }
    }
    
    private var rightButtonActualWidth: CGFloat { // TODO: Very the same things do as "targetRightButtonWidth"
        get {
            return rightButton.bounds.width
        }
    }
    
    private var targetRightButtonWidth: CGFloat {
        let actualRightButtonSize = rightButton.sizeThatFits(CGSize(width: bounds.width, height: bounds.height))
        let maxCalculatedWidht = max(actualRightButtonSize.width, rightBttnWidth)
        let halfOfAvailableSpaceForButton = bounds.width/2
        
        return maxCalculatedWidht > halfOfAvailableSpaceForButton ? halfOfAvailableSpaceForButton : maxCalculatedWidht
    }
    
    weak var delegate: RHSwipeableCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    deinit { // TODO: not called
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Right Button
        var rightButtonFrame = CGRectZero
        rightButtonFrame = CGRect(x: bounds.size.width - targetRightButtonWidth, y: 0, width: targetRightButtonWidth, height: bounds.height)
        rightButton.frame = rightButtonFrame
        
        // Content View
        contentView.frame = bounds
        
        // Scroll View
        scrollView.frame = bounds
        scrollView.contentSize = CGSize(width: bounds.width + rightButtonFrame.width, height: bounds.height)
        scrollView.contentOffset.x = 0 // TODO: Rotation not supported yet
    }
    
    override func didMoveToSuperview() {
        relatedTableView = RHSwipeableCellHelper.findRelatedTableView(self);
    }
    
    private func setup() {
        contentView.backgroundColor = UIColor.whiteColor()
        
        // TODO: remove observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RHSwipeableCell.collapse), name: collapse_notif_key, object: nil)
        
        setupScrollView()
        setupRightButton()
        addTapGestureForContainerView()
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        contentView.addSubview(scrollView)
    }
    
    private func setupRightButton() {
        // Right button should be placet right below 'contentView'
        insertSubview(rightButton, belowSubview: contentView)
        
        rightButton.addTarget(self, action: #selector(RHSwipeableCell.rightButtonTapped(_:)), forControlEvents: .TouchUpInside)
    }
    
    private func adjustCellComponents(state: RHCellState) {
        switch state {
        case .Normal:
            hideRightBttnWithAnimation()
        case .Expanded:
            showRightBttnWithAnimation()
        }
    }
    
    private func addTapGestureForContainerView() {
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(RHSwipeableCell.handleContainerTap(_:)))
        scrollView.addGestureRecognizer(recognizer)
    }
    
    // TODO: change method name
    func collapse() {
        state = .Normal
    }
    
    private func showRightBttnWithAnimation(aniamtion: Bool = true) {
        setScrollViewContentOffsetX(rightButtonActualWidth)
    }
    
    private func hideRightBttnWithAnimation(aniamtion: Bool = true) {
        setScrollViewContentOffsetX(0)
    }
    
    private func setScrollViewContentOffsetX(contentOffsetX: CGFloat, animation: Bool = true) {
        scrollView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: animation)
    }
    
    private func adjustRightButton(contentOffsetX: CGFloat) {
        rightButton.transformTitle(contentOffsetX)
    }
    
    private func updateContentViewOffsetX(contentOffsetX: CGFloat) {
        contentView.frame = CGRect(x: -contentOffsetX, y: 0, width: contentView.bounds.width, height: contentView.bounds.height)
    }
    
    private func sendCollapseNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(collapse_notif_key, object: nil)
    }
    
    func handleContainerTap(recognizer: UITapGestureRecognizer) {
        sendCollapseNotification()
        
        if state == .Normal { // Tap action should be passed throught only when cell is in normal state
            RHSwipeableCellHelper.simulateCellTapEffect(scrollView)
            
            if let tableView = relatedTableView {
                if let cellIndxPath = tableView.indexPathForCell(self) {
                    tableView.delegate?.tableView?(tableView, didSelectRowAtIndexPath: cellIndxPath)
                }
            }
        }
        
        state = .Normal
    }
    
    func rightButtonTapped(button: UIButton) {
        guard let relatedTableView = relatedTableView, indexPath = relatedTableView.indexPathForCell(self)  else { return }
        
        sendCollapseNotification()
        
        state = .Normal
        delegate?.rightButtonTapped(relatedTableView, indexPath: indexPath)
    }
    
    /**
     Right button configuration bridge method
     
     - parameter config: Object which have to implement 'SwipableCellButtonConfigProtocol' protocol 🤘
     */
    func customizeButton(config: RHSwipeableCellButtonConfigProtocol) {
        rightButton.customize(config)
    }
}

extension RHSwipeableCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollViewContentOffsetX >= rightButtonActualWidth {
            scrollViewContentOffsetX = rightButtonActualWidth
        } else if scrollViewContentOffsetX <= 0 {
            scrollViewContentOffsetX = 0
        }
        
        adjustRightButton(scrollViewContentOffsetX)
        updateContentViewOffsetX(scrollViewContentOffsetX)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollViewContentOffsetX < 0 { return }
        
        var contentOffsetX = CGFloat(0)
        if scrollViewContentOffsetX >= rightButtonActualWidth/2 {
            contentOffsetX = rightButtonActualWidth
        }
        
        setScrollViewContentOffsetX(contentOffsetX)
    }
}