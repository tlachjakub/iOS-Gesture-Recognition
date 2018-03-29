//
//  String.swift
//  iOS-Gesture-Draw
//
//  Created by Jakub Tlach on 11/29/17.
//  Copyright © 2017 Jakub Tlach. All rights reserved.
//

import Foundation
import UIKit


extension String {
	func appendingPathComponent(_ path: String) -> String {
		return (self as NSString).appendingPathComponent(path)
	}
	
}
