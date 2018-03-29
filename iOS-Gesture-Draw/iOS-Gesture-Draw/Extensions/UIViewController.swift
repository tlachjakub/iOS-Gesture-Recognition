//
//  UIViewController.swift
//  iOS-Gesture-Draw
//
//  Created by Jakub Tlach on 11/29/17.
//  Copyright © 2017 Jakub Tlach. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	
	func alertMessageOk(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
}
