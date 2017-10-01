//
//  ArtExpandingMenuButton.swift
//  ArtExpandingMenu
//
//  Created by Laurens Biesheuvel on 30-09-17.
//  Copyright © 2017 Artapps. All rights reserved.
//

import UIKit

//Don't forget to set backgroundcolor to clear and opaque to off

@IBDesignable class ArtExpandingMenu : UIView
{
    private var mainButton : ArtExpandingMenuButton!
    private var outerCircleView : UIVisualEffectView!
    private var open : Bool = false
    
    //These variables need to be set before drawing, not after
    @IBInspectable var buttonRadius : CGFloat = 25
    @IBInspectable var menuRadius : CGFloat = 150
    //These variables need to be set before drawing, not after
    
    @IBInspectable var buttonColor : UIColor = .red {
        didSet (newValue) {
            if(mainButton != nil)
            {
                if(!open)
                {
                    mainButton.color = newValue
                }
            }
        }
    }
    
    @IBInspectable var selectedButtonColor : UIColor = .blue {
        didSet (newValue) {
            if(mainButton != nil)
            {
                if(open)
                {
                    mainButton.color = newValue
                }
            }
        }
    }
    
    func fullExpand() {
        let middleCenterPoint = self.middleButtonRect.centerPoint()
        let radius = sqrt((middleCenterPoint.x * middleCenterPoint.x) + (middleCenterPoint.y * middleCenterPoint.y))
        expandToRadius(radius: radius)
    }
    
    func optionsExpand() {
        let middleCenterPoint = self.middleButtonRect.centerPoint()
        let radius = middleCenterPoint.y - 50
        expandToRadius(radius: radius)
    }
    
    func expandToRadius(radius : CGFloat) { //This function is not used in touchedupinside of mainbutton, because the animation and startingpoint needs to be different
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.allowUserInteraction], animations: {
            self.mainButton.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
            self.mainButton.color = self.selectedButtonColor
            self.mainButton.center = self.middleButtonRect.centerPoint()
            self.outerCircleView.center = self.middleButtonRect.centerPoint()
        })
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseInOut], animations: {
            
            self.outerCircleView.frame = self.middleButtonRect.adjustSizeWhileCentered(newWidth: radius*2, newHeight: radius*2)
            self.outerCircleView.layer.cornerRadius = radius
        })
        open = true
    }
    
    @objc private func touchedUpInside() {
        if(open)
        {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction], animations: {
                self.mainButton.transform = .identity
                self.mainButton.center = self.initialButtonRect.centerPoint()
                self.outerCircleView.frame = self.initialButtonRect
                self.outerCircleView.layer.cornerRadius = self.buttonRadius
                self.mainButton.color = self.buttonColor
            })
        }
        else
        {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction], animations: {
                
                
            })
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.allowUserInteraction], animations: {
                self.mainButton.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
                
                self.mainButton.color = self.selectedButtonColor
                self.outerCircleView.frame = self.initialButtonRect.adjustSizeWhileCentered(newWidth: self.menuRadius*2, newHeight: self.menuRadius*2)
                self.outerCircleView.layer.cornerRadius = self.menuRadius
            })
            
        }
        open = !open
    }
    
    private var middleButtonRect : CGRect {
        return CGRect(x: bounds.size.width/2-buttonRadius, y: bounds.size.height-20-buttonRadius*2, width: buttonRadius*2, height: buttonRadius*2)
    }
    
    private var initialButtonRect : CGRect {
        return CGRect(x: bounds.size.width-16-buttonRadius*2, y: bounds.size.height-20-buttonRadius*2, width: buttonRadius*2, height: buttonRadius*2)
    }
    override func draw(_ rect: CGRect) {
        clipsToBounds = true
        let mainButtonRect = initialButtonRect
        
        let blurEffect = UIBlurEffect.init(style: .dark)
        outerCircleView = UIVisualEffectView.init(frame: mainButtonRect)
        outerCircleView.effect = blurEffect
        outerCircleView.clipsToBounds = true
        //outerCircleView.backgroundColor = menuColor
        outerCircleView.layer.cornerRadius = buttonRadius
        addSubview(outerCircleView)
        mainButton = ArtExpandingMenuButton(frame: mainButtonRect)
        let plusImage = UIImage(named: "plus")
        mainButton.image = plusImage
        mainButton.tintColor = .white
        mainButton.color = buttonColor
        mainButton.addTarget(self, action: #selector(touchedUpInside), for: .touchUpInside)
        addSubview(mainButton)
        
    }
    
    
}
@IBDesignable class ArtExpandingMenuButton: UIControl {
    private var circleView : UIView!
    private var highlightedCircleView : UIView!
    private var imageView : UIImageView?
    @IBInspectable var image : UIImage?
    {
        didSet {
            if (imageView != nil)
            {
                imageView?.image = image
                let centerPoint = CGPoint(x: bounds.size.width*0.5,y: bounds.size.height*0.5)
                let imageRect = CGRect(x: centerPoint.x - image!.size.width/2, y: centerPoint.y - image!.size.height/2, width: image!.size.width, height: image!.size.height)
                imageView?.frame = imageRect
            }
        }
    }
    
    @IBInspectable var color : UIColor = .red {
        didSet {
            if (circleView != nil)
            {
                circleView.backgroundColor = color
            }
        }
    }

    override func draw(_ rect: CGRect) {
        
        layer.cornerRadius = rect.width/2
        clipsToBounds = true
        circleView = UIView.init(frame: rect)
        circleView.backgroundColor = color
        circleView.isUserInteractionEnabled = false
        addSubview(circleView)
        if(image != nil) {
            //let centerPoint = CGPoint(x: bounds.size.width*0.5,y: bounds.size.height*0.5)
            let centerPoint = bounds.centerPoint()
            let imageRect = CGRect(x: centerPoint.x - image!.size.width/2, y: centerPoint.y - image!.size.height/2, width: image!.size.width, height: image!.size.height)
            imageView = UIImageView.init(frame: imageRect)
            imageView?.image = image
        }
        else
        {
            imageView = UIImageView.init(frame: CGRect.zero)
        }
        addSubview(imageView!)
        // Drawing code
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

extension CGPoint {
    func centeredCGRectForSize(width : CGFloat, height : CGFloat) -> CGRect {
        let newX = self.x - width/2
        let newY = self.y - height/2
        return CGRect(x: newX, y: newY, width: width, height: height)
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
