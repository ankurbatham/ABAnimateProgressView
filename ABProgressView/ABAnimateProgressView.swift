//
//  ABProgressView.swift
//  ABProgressView
//
//  Created by Ankur Batham on 30/04/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

class ABAnimateProgressView: UIView {
    
    struct ScreenSize  {
        static let Width         = UIScreen.main.bounds.size.width
        static let Height        = UIScreen.main.bounds.size.height
        static let Max_Length    = max(ScreenSize.Width, ScreenSize.Height)
        static let Min_Length    = min(ScreenSize.Width, ScreenSize.Height)
    }
    
    //MARK: - Public Functions, Properties
    //MARK: -
    
    public var imgLogoArray = [UIImage]()
    public var animateColor = [UIColor]()
    public var duration: CGFloat = 5.0
    public var lineWidth: CGFloat = 4.0
    public var bgColor = UIColor.clear
    public var logoBgColor = UIColor.clear
    public var widthProgressView : CGFloat = 100.0
    
    public func show() {
        self.setupABAnimateProgressView()
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.alpha = 1.0
            self.startAnimating()
            
        }, completion: {(finished: Bool) -> Void in })
    }
    
    public func hide() {
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.alpha = 0.0
        }, completion: {(finished: Bool) -> Void in
            self.stopAnimating()
            self.removeFromSuperview()
        })
    }
    
    //MARK: - Private Functions, Properties
    //MARK: -
    private var progressView = UIView()
    private var shapeLayer = CAShapeLayer()
    private var imgViewLogo = UIImageView()
    
    private func setupABAnimateProgressView() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if (appDelegate.window?.subviews.contains(progressView))! {
            appDelegate.window?.bringSubview(toFront:progressView)
            print("already there")
        }else{
            appDelegate.window?.addSubview(progressView)
            appDelegate.window?.bringSubview(toFront: progressView)
        }
        progressView.backgroundColor = UIColor.clear
        progressView.frame = UIScreen.main.bounds
        progressView.layer.zPosition = 1
        
        self.backgroundColor = bgColor
        self.frame = UIScreen.main.bounds
        
        let innerLoaderView = UIView()
        innerLoaderView.frame = CGRect(x: (ScreenSize.Width - widthProgressView)/2, y: (ScreenSize.Height - widthProgressView)/2, width: widthProgressView, height: widthProgressView)
        innerLoaderView.backgroundColor = logoBgColor
        innerLoaderView.layer.cornerRadius = 10.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = animateColor.count > 0 ? animateColor.first?.cgColor : UIColor.clear.cgColor
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1
        shapeLayer.lineWidth = lineWidth
        let center = CGPoint(x: innerLoaderView.bounds.size.width / 2.0, y: innerLoaderView.bounds.size.height / 2.0)
        let radius = min(innerLoaderView.bounds.size.width, innerLoaderView.bounds.size.height)/2.0 - self.shapeLayer.lineWidth*2
        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.frame = innerLoaderView.bounds
        innerLoaderView.layer.addSublayer(shapeLayer)
        self.addSubview(innerLoaderView)
        
        if imgLogoArray.count > 0 {
            if imgLogoArray.count == 1 {
                imgViewLogo.image = imgLogoArray.first
            }else {
                imgViewLogo.animationImages = imgLogoArray
                imgViewLogo.animationDuration = 2.0
            }
            imgViewLogo.contentMode = .scaleAspectFit
            imgViewLogo.backgroundColor = UIColor.clear
            imgViewLogo.clipsToBounds = true
            imgViewLogo.frame = CGRect(x: 0, y: 0, width: widthProgressView * 0.4, height: widthProgressView * 0.4)
            self.addSubview(imgViewLogo)
            imgViewLogo.center = innerLoaderView.center
        }
        progressView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        let xConstraint = NSLayoutConstraint(item: progressView, attribute: .centerX, relatedBy: .equal, toItem: appDelegate.window!, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: progressView, attribute: .centerY, relatedBy: .equal, toItem: appDelegate.window!, attribute: .centerY, multiplier: 1, constant: 0)
        appDelegate.window?.addConstraint(xConstraint)
        appDelegate.window?.addConstraint(yConstraint)
        
        self.centerXAnchor.constraint(equalTo: progressView.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: progressView.centerYAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        self.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
    }
    
    private func animateStrokeEnd() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.beginTime = 0
        animation.duration = CFTimeInterval(duration / 2.0)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return animation
    }
    
    private func animateStrokeStart() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = CFTimeInterval(duration / 2.0)
        animation.duration = CFTimeInterval(duration / 2.0)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return animation
    }
    
    private func animateRotation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = Float.infinity
        return animation
    }
    
    private func animateColors() -> CAKeyframeAnimation {
        let colors = configureColors()
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.duration = CFTimeInterval(duration)
        animation.keyTimes = configureKeyTimes(colors: colors)
        animation.values = colors
        animation.repeatCount = Float.infinity
        return animation
    }
    
    private func animateGroup() {
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animateStrokeEnd(), animateStrokeStart(), animateRotation(), animateColors()]
        animationGroup.duration = CFTimeInterval(duration)
        animationGroup.fillMode = kCAFillModeBoth
        animationGroup.isRemovedOnCompletion = false
        animationGroup.repeatCount = Float.infinity
        shapeLayer.add(animationGroup, forKey: "loading")
    }
    
    private func startAnimating() {
        animateGroup()
        if imgLogoArray.count > 0 {
            if imgLogoArray.count == 1 {
            }else {
                imgViewLogo.startAnimating()
            }
        }
    }
    
    private func stopAnimating() {
        shapeLayer.removeAllAnimations()
        if imgLogoArray.count > 0 {
            if imgLogoArray.count == 1 {
            }else {
                imgViewLogo.stopAnimating()
            }
        }
    }
    
    private func configureColors() -> [CGColor] {
        var colors = [CGColor]()
        if animateColor.count > 0 {
            for color in animateColor {
                colors.append(color.cgColor)
            }
        }else {
            colors.append(UIColor.clear.cgColor)
        }
        return colors
    }
    
    private func configureKeyTimes(colors: [CGColor]) -> [NSNumber] {
        switch colors.count {
        case 1:
            return [0]
        case 2:
            return [0, 1]
        default:
            return [0, 0.5, 1]
        }
    }
}
