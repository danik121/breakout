//
//  BallView.swift
//  Breakout
//
//  Created by Daniil Pimenau on 08-06-16.
//  Copyright (c) 2015 private. All rights reserved.
//  overgenomen van Jeroen Schonenberg  github https://github.com/JeroenSchonenberg/Breakout/tree/master/Breakout
//  ik ben niet zo goed in design 

import UIKit

class BallView: UIView {
    private struct Constants {
        static let backgroundColor = UIColor.whiteColor()
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        setAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setAppearance (){
        self.backgroundColor = Constants.backgroundColor
        self.layer.cornerRadius = self.frame.width / 2
    }
}
