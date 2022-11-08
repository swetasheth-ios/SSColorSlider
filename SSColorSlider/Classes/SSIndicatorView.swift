//
//  SSIndicatorView.swift
//
//  Created by Sweta Sheth
//

import UIKit

class SSIndicatorView: UIView {
    
    private var colorView:UIView!
    private var arrowView:UIView!
    
    var color:UIColor = .clear {
        didSet {
            colorView.backgroundColor = color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        colorView = UIView(frame: self.bounds.insetBy(dx: 3, dy: 3))
        colorView.layer.cornerRadius = colorView.frame.width/2
        addSubview(colorView)
        
        arrowView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        var rect:CGRect = arrowView.frame
        rect.origin.y = self.bounds.height - 15
        rect.origin.x = self.bounds.midX - round(arrowView.frame.width/2)
        
        arrowView.frame = rect
        arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2)/2)
//        arrowView.layer.cornerRadius = 4
        
        addSubview(arrowView)
        sendSubviewToBack(arrowView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tintColorDidChange() {
        self.backgroundColor = self.tintColor
        arrowView.backgroundColor = self.tintColor
    }
}
