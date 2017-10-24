//
//  ArtExpandingMenu.swift
//  ArtExpandingMenu
//
//  Created by Laurens Biesheuvel on 02-10-17.
//  Copyright © 2017 Artapps. All rights reserved.
//

import UIKit

/*
 Tutorial:
 Don't forget the plus image asset!
 First, you can set the appearance using these variables:
 subButtonRatio
 mainButtonRadius
 menuRadius
 backgroundAlpha
 menuColor
 selectedButtonColor
 
 then, set the options, for example like this:
 menu.options = [("icon1", "First option"), ("icon2", "Second option"), ("icon3", "Third option")]
 
 Monitor valueChanged to find out when an option has been pressed. lastSelectedOption will be changed.
 */
@IBDesignable class ArtExpandingMenu : UIControl {
    
    private var backgroundButton : UIButton!
    private var mainButton : ArtExpandingMenuButton!
    private var outerCircle : UIView!
    private var isExpanded : Bool = false
    
    private var subButtons : [UIButton] = []
    private var titleLabels : [UILabel] = []
    
    var options : [(imagename: String, title: String)] = [] {
        didSet {
            setSubButtons()
        }
    }
    @IBInspectable var subButtonRatio : CGFloat = 0.75 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var mainButtonRadius : CGFloat = 25
    {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var menuRadius : CGFloat = 120
    {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var backgroundAlpha : CGFloat = 0.6 {
        didSet {
            if(isExpanded)
            {
                backgroundColor = UIColor.black.withAlphaComponent(backgroundAlpha)
            }
        }
    }
    
    @IBInspectable var menuColor : UIColor = #colorLiteral(red: 0.2980392157, green: 0.8196078431, blue: 0.7058823529, alpha: 1) {
        didSet {
            if(!isExpanded)
            {
                mainButton.color = menuColor
            }
            outerCircle.backgroundColor = menuColor
        }
    }
    
    @IBInspectable var selectedButtonColor : UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5) {
        didSet {
            if(isExpanded)
            {
                mainButton.color = selectedButtonColor
            }
        }
    }
    
    var lastSelectedOption : Int? {
        didSet {
            sendActions(for: .valueChanged)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        collectedInit()
    }
    
    override func layoutSubviews() {
        backgroundButton.frame = frame
        mainButton.transform = .identity
        mainButton.frame = initialButtonRect
        if(isExpanded)
        {
            mainButton.transform = CGAffineTransform(rotationAngle: -135 * (.pi / 180))
            outerCircle.frame = self.initialButtonRect.adjustSizeWhileCentered(newWidth: self.menuRadius*2, newHeight: self.menuRadius*2)
            outerCircle.layer.cornerRadius = self.menuRadius
            for (index, subButton) in subButtons.enumerated() {
                subButton.center = centerPointForSubButton(index: index)
            }
        } else {
            outerCircle.frame = initialButtonRect
            outerCircle.layer.cornerRadius = mainButtonRadius
            for subButton in subButtons {
                subButton.center = initialButtonRect.centerPoint()
            }
        }
        for (index, titleLabel) in titleLabels.enumerated() {
            let rightAnchorPoint = rightAnchorPointForTitleLabel(index: index)
            let correctedPoint = CGPoint(x: rightAnchorPoint.x-titleLabel.frame.width, y: rightAnchorPoint.y-titleLabel.frame.height/2)
            titleLabel.frame.origin = correctedPoint
        }
        
    }
    
    private func collectedInit() {
        backgroundColor = .clear
        clipsToBounds = true
        backgroundButton = UIButton(type: .custom)
        backgroundButton.alpha = 0
        backgroundButton.addTarget(self, action: #selector(closeMenu), for: .touchDown)
        addSubview(backgroundButton)
        outerCircle = UIView()
        outerCircle.backgroundColor = menuColor
        //outerCircle.clipsToBounds = true
        addSubview(outerCircle)
        setSubButtons()
        mainButton = ArtExpandingMenuButton()
        let plusImage = UIImage(named: "plus")
        mainButton.image = plusImage
        mainButton.color = menuColor
        mainButton.tintColor = tintColor
        mainButton.addTarget(self, action: #selector(touchedUpInside), for: .touchUpInside)
        addSubview(mainButton)
        
    }
    
    @objc private func subButtonPressed(sender: UIButton)
    {
        
        for (index, button) in subButtons.enumerated() {
            if(button==sender)
            {
                lastSelectedOption = index
                closeMenu()
            }
        }
    }
    
    private func setSubButtons() {
        for subButton in subButtons {
            subButton.removeFromSuperview()
        }
        for titleLabel in titleLabels {
            titleLabel.removeFromSuperview()
        }
        subButtons = []
        for option in options {
            let subButton = UIButton(type: .custom)
            let image = UIImage(named: option.imagename)
            //subButton.frame.size = CGSize(width: 30, height: 30)
            subButton.frame.size = image!.size
            subButton.alpha = 0
            subButton.setImage(image, for: .normal)
            subButton.tintColor = tintColor
            subButton.addTarget(self, action: #selector(subButtonPressed(sender:)), for: .touchUpInside)
            subButtons.append(subButton)
            addSubview(subButton)
            
            let titleLabel = UILabel()
            titleLabel.text = option.title
            titleLabel.font = UIFont(name: "Avenir-Roman", size: 16)
            titleLabel.textColor = .white
            titleLabel.sizeToFit()
            titleLabel.alpha = 0
            titleLabels.append(titleLabel)
            addSubview(titleLabel)
            
        }
    }
    
//    private var middleButtonRect : CGRect {
//        return CGRect(x: bounds.size.width/2-buttonRadius, y: bounds.size.height-20-buttonRadius*2, width: buttonRadius*2, height: buttonRadius*2)
//    }
    
    private var initialButtonRect : CGRect {
        return CGRect(x: frame.size.width-16-mainButtonRadius*2, y: frame.size.height-20-mainButtonRadius*2, width: mainButtonRadius*2, height: mainButtonRadius*2)
    }
    
    private func centerPointForSubButton(index : Int) -> CGPoint {
        let buttonsRadius = subButtonRatio * menuRadius
        let radiansBetweenButtons = (0.5 * CGFloat.pi) / CGFloat(options.count-1)
        let x = menuRadius - buttonsRadius * cos(radiansBetweenButtons * CGFloat(index)) + outerCircle.frame.origin.x
        let y = menuRadius - buttonsRadius * sin(radiansBetweenButtons * CGFloat(index)) + outerCircle.frame.origin.y
        return CGPoint(x: x, y: y)
    }
    
    private func rightAnchorPointForTitleLabel(index : Int) -> CGPoint {
        let labelRadius = menuRadius+12
        let radiansBetweenButtons = (0.5 * CGFloat.pi) / CGFloat(options.count-1)
        let outerCircleOrigin = self.initialButtonRect.adjustSizeWhileCentered(newWidth: self.menuRadius*2, newHeight: self.menuRadius*2).origin
        let x = menuRadius - labelRadius * cos(radiansBetweenButtons * CGFloat(index)) + outerCircleOrigin.x
        let y = menuRadius - labelRadius * sin(radiansBetweenButtons * CGFloat(index)) + outerCircleOrigin.y
        return CGPoint(x: x, y: y)
    }
    
    @objc private func closeMenu() {
        UIView.animate(withDuration: 0.2, delay: 0.05 * Double(options.count), options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.mainButton.transform = .identity
            self.mainButton.center = self.initialButtonRect.centerPoint()
            self.outerCircle.frame = self.initialButtonRect
            self.outerCircle.layer.cornerRadius = self.mainButtonRadius
            self.mainButton.color = self.menuColor
            self.backgroundColor = .clear
            for titleLabel in self.titleLabels {
                titleLabel.alpha = 0
            }
        })
        for (index, subButton) in self.subButtons.enumerated() {
            
            
            UIView.animate(withDuration: 0.2, delay: 0.05*Double(index), options: [.allowUserInteraction, .curveEaseInOut], animations: {
                subButton.center = self.initialButtonRect.centerPoint()
            })
            UIView.animate(withDuration: 0.1, delay: 0.05*Double(index), options: [.allowUserInteraction, .curveEaseInOut], animations: {
                subButton.alpha = 0
            })
        }
        backgroundButton.alpha = 0
        isExpanded = false
    }
    @objc private func touchedUpInside() {
        if(isExpanded)
        {
            closeMenu()
        }
        else
        {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.backgroundColor = UIColor.black.withAlphaComponent(self.backgroundAlpha)
            })
            UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseInOut], animations: {
                for titleLabel in self.titleLabels {
                    titleLabel.alpha = 1
                }
            })
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.allowUserInteraction], animations: {
                self.mainButton.transform = CGAffineTransform(rotationAngle: -135 * (.pi / 180))
                self.mainButton.color = self.selectedButtonColor
                self.outerCircle.frame = self.initialButtonRect.adjustSizeWhileCentered(newWidth: self.menuRadius*2, newHeight: self.menuRadius*2)
                self.outerCircle.layer.cornerRadius = self.menuRadius
                
                
            })
            
            for (index, subButton) in self.subButtons.enumerated() {
                UIView.animate(withDuration: 0.6, delay: 0.05*Double(index), usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.allowUserInteraction], animations: {
                    subButton.center = self.centerPointForSubButton(index: index)
                })
                UIView.animate(withDuration: 0.3, delay: 0.05+0.05*Double(index), options: [.allowUserInteraction, .curveEaseInOut], animations: {
                    subButton.alpha = 1
                })
            }
            backgroundButton.alpha = 1
            isExpanded = true
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            let tapIsinsideView = subview.hitTest(convert(point, to: subview), with: event) != nil
            if(tapIsinsideView)
            {
                return true
            }
        }
        return false
    }
}

@IBDesignable class ArtExpandingMenuButton: UIControl {
    
    var circleView : UIView!
    var imageView : UIImageView!
    @IBInspectable var image : UIImage? {
        didSet {
            setImage()
        }
    }
    
    @IBInspectable var color : UIColor = #colorLiteral(red: 0.7843137255, green: 0, blue: 0, alpha: 1) {
        didSet {
            setColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        collectedInit()
    }
    
    private func collectedInit() {
        circleView = UIView()
        circleView.backgroundColor = color
        circleView.isUserInteractionEnabled = false
        addSubview(circleView)
        imageView = UIImageView()
        imageView.contentMode = .center
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        circleView.frame = bounds
        circleView.layer.cornerRadius = bounds.width/2
        imageView.frame = bounds
    }
    
    func setImage() {
        imageView.image = image
    }
    
    func setColor() {
        circleView.backgroundColor = color
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
            self.alpha = 0.4
        })
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        UIView.animate(withDuration: 0.35, delay: 0, options: .allowUserInteraction, animations: {
            self.alpha = 1
        })
    }
}

extension CGRect {
    func adjustSizeWhileCentered(newWidth : CGFloat, newHeight : CGFloat) -> CGRect {
        let x = self.origin.x
        let y = self.origin.y
        let w = self.width
        let h = self.height
        
        let oldCenterPoint = CGPoint(x: x + w/2, y: y + h/2)
        
        let newX = oldCenterPoint.x - newWidth/2
        let newY = oldCenterPoint.y - newHeight/2
        
        return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
    }
    
    func centerPoint() -> CGPoint {
        return CGPoint(x: self.origin.x + width/2, y: self.origin.y + height/2)
    }
}
