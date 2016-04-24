//
//  RHSwipeableCellButton.swift
//  TableSwapableCell
//
//  Created by Robert Herdzik on 23/04/16.
//  Copyright © 2016 Ro. All rights reserved.
//

import UIKit

class RHSwipeableCellButton: UIButton, RHSwipeableCellButtonConfigProtocol {

    private let horizontalPadding = CGFloat(15)
    
    private var titleLabelTransform: CGAffineTransform?
    
    var title: String = "" {
        didSet {
            setTitle(title, forState: .Normal)
        }
    }
    
    var bgColor: UIColor = UIColor.whiteColor() {
        didSet {
            backgroundColor = bgColor
        }
    }
    
    var titleFont: UIFont? {
        didSet {
            titleLabel?.font = titleFont
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        titleLabel?.sizeToFit()
        var widht = titleLabel?.bounds.width ?? 0
        widht += 2*horizontalPadding
    
        return CGSize(width: widht, height: size.height)
    }
    
    private func setup() {
        titleLabelTransform = titleLabel?.transform
        titleLabel?.lineBreakMode = .ByTruncatingTail
        titleLabel?.numberOfLines = 1
    }
    
    // TODO: Maybe move it to different class it can be more generic
    func transformTitle(contentOffsetX: CGFloat) {
        guard let titleLabel = titleLabel, titleLabelTransform = titleLabelTransform else { return }
        
        var scale = abs(1 - ((1/100) * ((bounds.width - 2*horizontalPadding) - contentOffsetX)))
        if scale >= 1 {
            scale = 1
        } else if scale <= CGFloat.min {
            scale = 0.1 // Preventing "CGAffineTransformInvert: singular matrix." error
        }
        
        titleLabel.transform = CGAffineTransformScale(titleLabelTransform, scale, scale)
    }
    
    func customize(config: RHSwipeableCellButtonConfigProtocol) {
        setTitle(config.title, forState: .Normal)
        backgroundColor = config.bgColor
        titleFont = config.titleFont
    }
}
