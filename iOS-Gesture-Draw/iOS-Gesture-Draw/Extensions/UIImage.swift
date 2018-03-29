//
//  UIImage.swift
//  iOS-Gesture-Draw
//
//  Created by Jakub Tlach on 11/29/17.
//  Copyright © 2017 Jakub Tlach. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
	
	////////////////////////////////////////////////////////////////////////////
	// MARK: Resize the image
	////////////////////////////////////////////////////////////////////////////
	
	func aspectFillToSize(_ targetSize: CGSize) -> UIImage {
		
		let imageSize = self.size
		let width = imageSize.width
		let height = imageSize.height
		let targetWidth = targetSize.width
		let targetHeight = targetSize.height
		var scaleFactor: CGFloat = 0.0
		var scaledWidth: CGFloat = targetWidth
		var scaledHeight = targetHeight
		var thumbnailPoint = CGPoint(x: 0.0,y: 0.0)
		
		if (imageSize.equalTo(targetSize) == false) {
			let widthFactor = targetWidth / width
			let heightFactor = targetHeight / height
			
			if (widthFactor > heightFactor) {
				scaleFactor = widthFactor    // scale to fit height
			} else {
				scaleFactor = heightFactor    // scale to fit width
			}
			
			scaledWidth  = width * scaleFactor
			scaledHeight = height * scaleFactor
			
			// center the image
			if (widthFactor > heightFactor) {
				thumbnailPoint.y = (targetHeight - scaledHeight) * CGFloat(0.5)
			} else if (widthFactor < heightFactor) {
				thumbnailPoint.x = (targetWidth - scaledWidth) * CGFloat(0.5)
			}
		}
		
		
		guard let imageRef = self.cgImage else {
			print("ERROR @ ruAspectFillToSize: Can't create cgImage")
			return UIImage()
		}
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
		guard let context = CGContext(data: nil, width: Int(targetWidth), height: Int(targetHeight),
									  bitsPerComponent: imageRef.bitsPerComponent,
									  bytesPerRow: Int(targetWidth) * imageRef.bitsPerComponent,
									  space: imageRef.colorSpace!,
									  bitmapInfo: bitmapInfo.rawValue) else {
										print("ERROR @ ruAspectFillToSize: Can't create Context")
										return UIImage()
		}
		
		
		
		// Rotate Image to Orientation
		if (self.imageOrientation == UIImageOrientation.left) {
			thumbnailPoint = CGPoint(x: thumbnailPoint.y, y: thumbnailPoint.x)
			let oldScaledWidth = scaledWidth
			scaledWidth = scaledHeight
			scaledHeight = oldScaledWidth
			
			context.rotate(by: Tools.degToRadF(90.0))
			context.translateBy(x: 0, y: -targetHeight)
			
		} else if (self.imageOrientation == UIImageOrientation.right) {
			thumbnailPoint = CGPoint(x: thumbnailPoint.y, y: thumbnailPoint.x)
			let oldScaledWidth = scaledWidth
			scaledWidth = scaledHeight
			scaledHeight = oldScaledWidth
			
			context.rotate(by: Tools.degToRadF(-90))
			context.translateBy(x: -targetWidth, y: 0)
			
		} else if (self.imageOrientation == UIImageOrientation.up) {
			// DO NOTHING
		} else if (self.imageOrientation == UIImageOrientation.down) {
			context.translateBy(x: targetWidth, y: targetHeight)
			context.rotate(by: Tools.degToRadF(-180.0))
		}
		
		context.draw(imageRef, in: CGRect(x: thumbnailPoint.x, y: thumbnailPoint.y, width: scaledWidth, height: scaledHeight))
		if let ref = context.makeImage() {
			return UIImage(cgImage: ref)
		} else {
			print("ERROR @ ruAspectFillToSize: Can't create UIImage")
			return UIImage()
		}
	}
	
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// MARK: PixelBuffer
	////////////////////////////////////////////////////////////////////////////
	
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

