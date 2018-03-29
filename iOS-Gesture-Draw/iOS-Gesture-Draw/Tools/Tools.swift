//
//  Tools.swift
//  iOS-Gesture-Draw
//
//  Created by Jakub Tlach on 11/29/17.
//  Copyright © 2017 Jakub Tlach. All rights reserved.
//

import Foundation
import UIKit


class Tools {
	
	////////////////////////////////////////////////////////////////////////////
	// MARK: Math
	////////////////////////////////////////////////////////////////////////////
	
	class func radToDeg(_ value: Double) -> Double {
		return value * 57.295779513082320876798154814105170332405472466564321549160
	}
	
	class func degToRad(_ value: Double) -> Double {
		return value * 0.0174532925199432957692369076848861271344287188854172545609
	}
	
	class func radToDegF(_ value: CGFloat) -> CGFloat {
		return value * 57.295779513082320876798154814105170332405472466564321549160
	}
	
	class func degToRadF(_ value: CGFloat) -> CGFloat {
		return value * 0.0174532925199432957692369076848861271344287188854172545609
	}
	
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// MARK: Paths
	////////////////////////////////////////////////////////////////////////////
	
	static var mDocumentsURL : URL? = nil
	class var documentsURL: URL {
		if mDocumentsURL == nil {
			let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
			mDocumentsURL = urls[urls.endIndex-1]
		}
		return mDocumentsURL!
	}
	class var documentsPath: String {
		return Tools.documentsURL.path
	}
	
	class var tempURL: URL {
		return URL(fileURLWithPath: tempPath, isDirectory: true)
	}
	
	class var tempPath: String {
		return NSTemporaryDirectory()
	}
	
	class var bundlePath: String {
		return Bundle.main.bundlePath
	}
	
}

