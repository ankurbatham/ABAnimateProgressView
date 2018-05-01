//
//  ViewController.swift
//  ABProgressView
//
//  Created by Ankur Batham on 30/04/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let progressView = ABAnimateProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        progressView.imgLogoArray = [UIImage(named:"1-menu")!]
//        progressView.imgLogoArray = [UIImage(named:"2-menu")!,
//                                          UIImage(named:"1-menu")!,
//                                          UIImage(named:"3-menu")!]
        progressView.animateColor = [#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
        
        progressView.duration = 2.0
        progressView.lineWidth = 4.0
        progressView.widthProgressView = 80.0
        progressView.bgColor =  UIColor.clear
        progressView.logoBgColor = UIColor.clear
        self.view.backgroundColor = UIColor.white
        
        progressView.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

