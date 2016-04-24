//
//  RHSwipeableCell.swift
//  TableSwapableCell
//
//  Created by Robert Herdzik on 24/05/15.
//  Copyright © 2016 Ro. All rights reserved.
//

import UIKit

class RHSwipeableCell: UITableViewCell {
    
    enum RHCellState: Int {
        case Normal
        case Expanded
    }
    
    private let rightBttnWidth = CGFloat(100)
    
    private let scrollView = UIScrollView(frame: CGRectZero)
    private var containerView = UIView(frame: CGRectZero)
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
            switch newValue {
            case .Normal:
                hideRightBttnWithAnimation()
            case .Expanded:
                showRightBttnWithAnimation()
            }
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
    
    var titleLabel = UILabel()
    override var textLabel: UILabel {
        get {
            return titleLabel
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Right Button
        var rightButtonFrame = CGRectZero
        rightButtonFrame = CGRect(x: bounds.size.width - targetRightButtonWidth, y: 0, width: targetRightButtonWidth, height: bounds.height)
        rightButton.frame = rightButtonFrame
        
        // Scroll View
        scrollView.frame = bounds
        scrollView.contentSize = CGSize(width: bounds.width + rightButtonFrame.width, height: bounds.height)
        scrollView.contentOffset.x = 0 // TODO: Rotation not supported yet
        
        // Container View
        containerView.frame = scrollView.bounds
        
        // Text Label
        let labelHorizontalPadding = CGFloat(15)
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: labelHorizontalPadding, y: 0, width: containerView.bounds.width - 2*labelHorizontalPadding, height: containerView.bounds.height)
    }
    
    override func didMoveToSuperview() {
        relatedTableView = RHSwipeableCellHelper.findRelatedTableView(self);
    }
    
    private func setup() {
        setupScrollView()
        setupContainerView()
        setupRightButton()
        addTapGestureForContainerView()
    }

    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        contentView.addSubview(scrollView)
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.addSubview(titleLabel)
        scrollView.addSubview(containerView)
    }
    
    private func setupRightButton() {
        // rightButton button should be placed below containerView in view hierarchy
        scrollView.insertSubview(rightButton, belowSubview: containerView)
        rightButton.addTarget(self, action: #selector(RHSwipeableCell.rightButtonTapped(_:)), forControlEvents: .TouchUpInside)
    }
    
    private func addTapGestureForContainerView() {
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(RHSwipeableCell.handleContainerTap(_:)))
        recognizer.delegate = self
        containerView.addGestureRecognizer(recognizer)
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
        setupRightButotnPositionX(contentOffsetX)
        rightButton.transformTitle(contentOffsetX)
    }
    
    /**
     Right button should be always possitioned according to scrollView offset X
     
     - parameter contentOffsetX: scrollView content offset X
     */
    private func setupRightButotnPositionX(contentOffsetX: CGFloat) {
        let buttonPosX = bounds.width - targetRightButtonWidth + contentOffsetX
        rightButton.frame = CGRect(x: buttonPosX, y: 0, width: targetRightButtonWidth, height: bounds.height)
    }
    
    func handleContainerTap(recognizer: UITapGestureRecognizer) {
        if state == .Normal { // Tap action should be passed throught only when cell is in normal state
            RHSwipeableCellHelper.simulateCellTapEffect(containerView)
            
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
        adjustRightButton(scrollViewContentOffsetX)
        
        if scrollViewContentOffsetX >= rightButtonActualWidth {
            scrollViewContentOffsetX = rightButtonActualWidth
        } else if scrollViewContentOffsetX <= 0 {
            scrollViewContentOffsetX = 0
        }
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