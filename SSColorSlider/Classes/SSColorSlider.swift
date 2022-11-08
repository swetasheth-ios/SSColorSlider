//
//  SSColorSlider.swift
//
//  Created by Sweta Sheth
//

import UIKit

public class SSColorSlider: UISlider {
    
    public var color:UIColor {
        get {
            return UIColor(hue: CGFloat(self.value), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        set {
            var hue:CGFloat = 0
            newValue.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
            self.value = Float(hue)
        }
    }
    
    public override var value:Float {
        didSet {
            self.removeIndicator()
        }
    }
    
    @IBInspectable public var sliderBackgroundColor:UIColor = .clear {
        didSet {
            colorTrackImageView.backgroundColor = sliderBackgroundColor
        }
    }
    
    @IBInspectable public var indicatorHeight:CGFloat = 0 {
        didSet {
            self.setIndicatorRect()
        }
    }
    
    @IBInspectable public var colorTrackHeight:Int = 0 {
        didSet {
            self.layoutSubviews()
        }
    }
    
    @IBInspectable public var isColorSlider:Bool = false {
        didSet {
            if self.isColorSlider {
                let containerBundle = Bundle(for: SSColorSlider.self)
                let path = containerBundle.path(forResource: "SSColorSlider", ofType: "bundle")
                guard let bundle = Bundle(path: path ?? ""), let imagePath = bundle.path(forResource: "slider-color", ofType: "png") else { return }
                
                self.colorTrackImageView.image = UIImage(contentsOfFile: imagePath)
            }
            self.updateIndicatorRect()
        }
    }
    
    @IBInspectable public var thumbColor:UIColor = .clear {
        didSet {
            self.updateIndicatorRect()
        }
    }
    
    private var colorTrackImageView: UIImageView!
    private var indicatorThumbView: SSIndicatorThumbView!
    private var indicatorView: SSIndicatorView!
    
    private let indicatorApprearAnimationDuration: TimeInterval = 0.07
    private let indicatorDismissAnimationDuration: TimeInterval = 0.06
    
    private let defaultColor: UIColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        
        self.minimumTrackTintColor = .clear
        self.maximumTrackTintColor = .clear
        self.thumbTintColor = .clear
        
        colorTrackImageView = UIImageView()
        addSubview(colorTrackImageView)
        sendSubviewToBack(colorTrackImageView)
        
        var newRect:CGRect = currentThumbRect().insetBy(dx: -1, dy: -1)
        newRect.origin.x = currentThumbRect().midX - newRect.width/2;
        indicatorThumbView = previewViewWithFrame(frame: newRect, color: self.color)
        addSubview(indicatorThumbView)
        
        if self.isColorSlider {
            indicatorThumbView.color = self.color
        } else {
            indicatorThumbView.color = self.thumbColor
        }
        
        let rect:CGRect = currentThumbRect().insetBy(dx: -1, dy: -1).offsetBy(dx: 0, dy: -50)
        self.indicatorView = previewIndicatorViewWithFrame(frame: rect, color: self.color)
        addSubview(indicatorView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        colorTrackImageView.frame = trackRect(forBounds: self.bounds)
        
        let center:CGPoint = colorTrackImageView.center
        var rect:CGRect = colorTrackImageView.frame
        rect.size.height = CGFloat(colorTrackHeight)
        
        colorTrackImageView.frame = rect
        colorTrackImageView.center = center
        colorTrackImageView.clipsToBounds = true
        colorTrackImageView.layer.cornerRadius = colorTrackImageView.frame.size.height / 2
    }
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let tracking:Bool = super.beginTracking(touch, with: event)
        self.updateIndicatorRect()
        return tracking
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let cont:Bool = super.continueTracking(touch, with: event)
        self.updateIndicatorRect()
        return cont
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        self.removeIndicator()
    }
    
    public override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        self.removeIndicator()
    }
    
    private func setIndicatorRect() {
        let inset: CGFloat = max(12, abs(indicatorHeight - 31))
        
        var newRect:CGRect = currentThumbRect().insetBy(dx: -1, dy: -1).offsetBy(dx: 0, dy: -inset/2)
        newRect.origin.x = currentThumbRect().midX - newRect.width/2;
        newRect.size.width = indicatorHeight
        newRect.size.height = indicatorHeight
        self.indicatorThumbView.frame = newRect
        
        self.indicatorThumbView.layer.cornerRadius = self.indicatorThumbView.frame.width/2
        self.indicatorThumbView.inset = abs(inset/2)
        
        let rect:CGRect = currentThumbRect().insetBy(dx: -1, dy: -1).offsetBy(dx: 0, dy: -indicatorHeight)
        self.indicatorView.frame = rect
        self.indicatorView.alpha = 0
    }
    
    private func updateIndicatorRect() {
        var thumbRect:CGRect = self.indicatorThumbView.frame
        thumbRect.origin.x = currentThumbRect().midX - thumbRect.width/2;
        indicatorThumbView.frame = thumbRect
        
        if self.isColorSlider {
            self.indicatorThumbView.color = self.color
            
            var rect:CGRect = self.indicatorView.frame
            rect.origin.x = currentThumbRect().midX - rect.width/2;
            indicatorView.frame = rect
            indicatorView.color = self.color
            
            UIView.animate(withDuration: indicatorApprearAnimationDuration, animations: {
                self.indicatorView.alpha = 1
            })
        } else {
            self.indicatorThumbView.color = self.thumbColor
            self.indicatorView.alpha = 0
        }
    }
    
    private func currentThumbRect() -> CGRect {
        return thumbRect(forBounds: self.bounds, trackRect: trackRect(forBounds: self.bounds), value: self.value)
    }
    
    private func removeIndicator() {
        self.updateIndicatorRect()
        
        self.indicatorThumbView.color = self.isColorSlider ? self.color : self.thumbColor
        UIView.animate(withDuration: indicatorDismissAnimationDuration, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.indicatorView.alpha = 0.0
        })
    }
    
    private func previewIndicatorViewWithFrame(frame:CGRect?, color:UIColor) -> SSIndicatorView {
        let indicator:SSIndicatorView = SSIndicatorView(frame: frame!)
        indicator.tintColor = self.defaultColor
        indicator.layer.cornerRadius = indicator.frame.width/2
        indicator.alpha = 1
        indicator.color = color
        return indicator
    }
    
    private func previewViewWithFrame(frame:CGRect?, color:UIColor) -> SSIndicatorThumbView {
        let indicator:SSIndicatorThumbView = SSIndicatorThumbView(frame: frame!)
        indicator.tintColor = UIColor.white
        indicator.layer.cornerRadius = indicator.frame.width/2
        indicator.alpha = 1
        indicator.isUserInteractionEnabled = false
        indicator.color = color
        return indicator
    }
}
