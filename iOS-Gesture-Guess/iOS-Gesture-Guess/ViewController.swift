//
//  ViewController.swift
//  iOS-Gesture-Guess
//
//  Created by Jakub Tlach on 11/28/17.
//  Copyright © 2017 Jakub Tlach. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {

	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	// MARK: Variables
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	
	@IBOutlet weak var drawView: DrawView!
	@IBOutlet weak var predictLabel: UILabel!
	
	// Load the Core ML model
	let model = kerasGesturesModel()
	
	var inputImage: CGImage!
	
	

	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	// MARK: Init
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		predictLabel.text = " "
	}
	
	// Clear the predictiction label
	@IBAction func tappedClear(_ sender: Any) {
		drawView.lines = []
		drawView.setNeedsDisplay()
		predictLabel.text = " "
	}
	
	// Detect your drawing and predict
	@IBAction func tappedDetect(_ sender: Any) {
		
		// Get the image from drawView
		let context = drawView.getViewContext()
		inputImage = context?.makeImage()
		
		// Prepare picture for the model
		let pixelBuffer = UIImage(cgImage: inputImage).pixelBuffer()
		
		// Prediction from model
		let output = try? model.prediction(image: pixelBuffer!)
		predictLabel.text = output?.classLabel

		if output?.classLabel == "<3" {
			predictLabel.text = "❤️"
			//let image = UIImage(named: "heart")
		}
		if output?.classLabel == ":-)" {
			predictLabel.text = "🙂"
			//predictImage.image = UIImage(named: "smile")
		}
		if output?.classLabel == ":-(" {
			predictLabel.text = "😞"
			//predictImage.image = UIImage(named: "sad")
		}
		if output?.classLabel == "X" {
			predictLabel.text = "✘"
			//predictImage.image = UIImage(named: "X")
		}
		
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}




//////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: UIImage extension
//////////////////////////////////////////////////////////////////////////////////////////////////////

extension UIImage {
	func pixelBuffer() -> CVPixelBuffer? {
		let width = self.size.width
		let height = self.size.height
		let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
					 kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
		var pixelBuffer: CVPixelBuffer?
		let status = CVPixelBufferCreate(kCFAllocatorDefault,
										 Int(width),
										 Int(height),
										 kCVPixelFormatType_OneComponent8,
										 attrs,
										 &pixelBuffer)
		
		guard let resultPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
			return nil
		}
		
		CVPixelBufferLockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
		let pixelData = CVPixelBufferGetBaseAddress(resultPixelBuffer)
		
		let grayColorSpace = CGColorSpaceCreateDeviceGray()
		guard let context = CGContext(data: pixelData,
									  width: Int(width),
									  height: Int(height),
									  bitsPerComponent: 8,
									  bytesPerRow: CVPixelBufferGetBytesPerRow(resultPixelBuffer),
									  space: grayColorSpace,
									  bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
										return nil
		}
		
		context.translateBy(x: 0, y: height)
		context.scaleBy(x: 1.0, y: -1.0)
		
		UIGraphicsPushContext(context)
		self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
		UIGraphicsPopContext()
		CVPixelBufferUnlockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
		
		return resultPixelBuffer
	}
}
