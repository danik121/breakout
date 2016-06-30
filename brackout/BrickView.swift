//
//  BrickView.swift
//  Breakout
//
//  Created by Daniil Pimenau on 08-06-16.
//  Copyright (c) 2015 private. All rights reserved.
//  overgenomen van Jeroen Schonenberg  github https://github.com/JeroenSchonenberg/Breakout/tree/master/Breakout
//  ik ben niet zo goed in design 

import UIKit

class BrickView: UIView {
    private struct Constants {
        static let cornerRadius: CGFloat = 2.0
        static let defaultBackgroundColor = UIColor.whiteColor()
    }
    
    var hue : CGFloat {
        set {
            self.backgroundColor = UIColor(hue: newValue, saturation: CGFloat(0.65), brightness: CGFloat(0.9), alpha: CGFloat(1.0))
        } get {
            var hue: CGFloat = 0.0
            var saturation: CGFloat = 0.0
            var brightness: CGFloat = 0.0
            var alpha: CGFloat = 0.0
            self.backgroundColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            return hue
        }
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        self.layer.cornerRadius = Constants.cornerRadius
        self.backgroundColor = Constants.defaultBackgroundColor
    }
    
    convenience init (frame: CGRect, hue: CGFloat) {
        self.init(frame: frame)
        self.hue = hue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}
