//
//  UIView.swift
//  iOS-Gesture-Draw
//
//  Created by Jakub Tlach on 11/29/17.
//  Copyright © 2017 Jakub Tlach. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
	
	var renderedImage: UIImage {
		
		UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, 0.0)
		self.layer.render(in: UIGraphicsGetCurrentContext()!)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage!
	}
	
}

