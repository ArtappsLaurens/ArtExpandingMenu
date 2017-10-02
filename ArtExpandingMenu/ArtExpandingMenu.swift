//
//  ArtExpandingMenu.swift
//  ArtExpandingMenu
//
//  Created by Laurens Biesheuvel on 02-10-17.
//  Copyright © 2017 Artapps. All rights reserved.
//


//Verwijder extensions/functies hierin om te kijken of je ze wel nodig hebt
import UIKit

@IBDesignable class ArtExpandingMenu : UIView {
    
    private var mainButton : ArtExpandingMenuButton!
    private var outerCircle : UIVisualEffectView!
    private var isExpanded : Bool = false
    @IBInspectable var buttonRadius : CGFloat = 25
    {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var menuRadius : CGFloat = 150
    {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var buttonColor : UIColor = #colorLiteral(red: 0.7843137255, green: 0, blue: 0, alpha: 1) {
        didSet {
            if(!isExpanded)
            {
                mainButton.color = buttonColor
            }
        }
    }
    
    @IBInspectable var selectedButtonColor : UIColor = #colorLiteral(red: 0.7058823529, green: 0.1491314173, blue: 0, alpha: 1) {
        didSet {
            if(isExpanded)
            {
                mainButton.color = selectedButtonColor
            }
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
        mainButton.transform = .identity
        mainButton.frame = initialButtonRect
        if(isExpanded)
        {
            mainButton.transform = CGAffineTransform(rotationAngle: -135 * (.pi / 180))
            outerCircle.frame = self.initialButtonRect.adjustSizeWhileCentered(newWidth: self.menuRadius*2, newHeight: self.menuRadius*2)
            outerCircle.layer.cornerRadius = self.menuRadius
        } else {
            outerCircle.frame = initialButtonRect
            outerCircle.layer.cornerRadius = buttonRadius
        }
        
    }
    func collectedInit() {
        
        let blurEffect = UIBlurEffect(style: .dark)
        outerCircle = UIVisualEffectView.init(effect: blurEffect)
        outerCircle.clipsToBounds = true
        addSubview(outerCircle)
        mainButton = ArtExpandingMenuButton()
        let plusImage = UIImage(named: "plus")
        mainButton.image = plusImage
        mainButton.color = buttonColor
        mainButton.tintColor = tintColor
        mainButton.addTarget(self, action: #selector(touchedUpInside), for: .touchUpInside)
        addSubview(mainButton)
        
    }
    
//    private var middleButtonRect : CGRect {
//        return CGRect(x: bounds.size.width/2-buttonRadius, y: bounds.size.height-20-buttonRadius*2, width: buttonRadius*2, height: buttonRadius*2)
//    }
    
    private var initialButtonRect : CGRect {
        return CGRect(x: bounds.size.width-16-buttonRadius*2, y: bounds.size.height-20-buttonRadius*2, width: buttonRadius*2, height: buttonRadius*2)
    }
    
    @objc private func touchedUpInside() {
        if(isExpanded)
        {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
                self.mainButton.transform = .identity
                self.mainButton.center = self.initialButtonRect.centerPoint()
                self.outerCircle.frame = self.initialButtonRect
                self.outerCircle.layer.cornerRadius = self.buttonRadius
                self.mainButton.color = self.buttonColor
            })
        }
        else
        {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.allowUserInteraction], animations: {
                self.mainButton.transform = CGAffineTransform(rotationAngle: -135 * (.pi / 180))
                self.mainButton.color = self.selectedButtonColor
                self.outerCircle.frame = self.initialButtonRect.adjustSizeWhileCentered(newWidth: self.menuRadius*2, newHeight: self.menuRadius*2)
                self.outerCircle.layer.cornerRadius = self.menuRadius
            })
            
        }
        isExpanded = !isExpanded
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
    
    func collectedInit() {
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
