//
//  SSIndicatorThumbView.swift
//
//  Created by Sweta Sheth
//

import UIKit

class SSIndicatorThumbView: UIView {
    
    private var colorView:UIView!
    
    var color:UIColor = .clear {
        didSet {
            colorView.backgroundColor = color
        }
    }
    
    var inset:CGFloat = 0 {
        didSet {
            colorView.frame = self.bounds.insetBy(dx: inset, dy: inset)
            colorView.layer.cornerRadius = colorView.frame.width/2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        colorView = UIView(frame: self.bounds)
        addSubview(colorView)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tintColorDidChange() {
        self.backgroundColor = self.tintColor;
    }
}
