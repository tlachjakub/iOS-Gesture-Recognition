//
//  ViewController.swift
//  iOS-Gesture-Draw
//
//  Created by Jakub Tlach on 11/29/17.
//  Copyright © 2017 Jakub Tlach. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {
	
	/////////////////////////////////////////////////////////////////////////////////////////
	// MARK: Variables
	/////////////////////////////////////////////////////////////////////////////////////////
	
	@IBOutlet weak var drawView: DrawView!
	@IBOutlet weak var counterLabel: UILabel!
	@IBOutlet weak var pickerView: UIPickerView!

	
	// Loads the counter everytime when we start the app
	var counter: [Int] = UserDefaults.standard.array(forKey: "counter") as? [Int] ?? [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	
	
	let symbols = ["🙂", "🙁", "😏", "😃", "😛", "😵",
				   "⭐️", "❤️", "✘", "✔︎", "❗️", "❓",
				   "💲", "⬅️", "➡️", "⬆️", "⬇️", "#️⃣"]
	
	
	// Check if the selectedRow in pickerView is between the real values
	var index: Int {
		return min(max(pickerView.selectedRow(inComponent: 0), 0), counter.count - 1)
	}
	
	
	/////////////////////////////////////////////////////////////////////////////////////////
	// MARK: Init
	/////////////////////////////////////////////////////////////////////////////////////////
	
	override func viewDidLoad() {
		super.viewDidLoad()

		update()
	}
	
	
	// Update of the the counter
	func update() {
		counterLabel.text = "\(counter[index])"
	}
	
	
	// Save the counter
	func save() {
		UserDefaults.standard.set(counter, forKey: "counter")
		UserDefaults.standard.synchronize()
	}
	
	
	// Clear the view
	@IBAction func tappedClear(_ sender: Any) {
		drawView.lines = []
		drawView.setNeedsDisplay()
	}
	
	
	// Save the image
	@IBAction func tappedSave(_ sender: Any) {
		
		// Check if drawView is empty
		if drawView.lines.capacity != 0 {
			
			// Resize the image
			let image = drawView.renderedImage.aspectFillToSize(CGSize(width: 28, height: 28))
			
			
			// Folder
			let folder = Tools.documentsURL.appendingPathComponent("\(index)")
			if !FileManager.default.fileExists(atPath: folder.path) {
				try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
			}


			// File Path
			let path = folder.appendingPathComponent("\(counter[index]).png")
			print(path)

			
			// Save the image
			if let data = UIImagePNGRepresentation(image) {
				try? data.write(to: path)
			}
			
			
			// Clear the view
			drawView.lines = []
			drawView.setNeedsDisplay()
			
			
			// Increase the counter
			counter[index] += 1
			
			
			// Update and save
			update()
			save()
			
		} else {
			
			// Show alert when drawView is empty
			self.alertMessageOk(title: "DrawView is empty❗️", message: "Draw something please 🙏")

		}
	}
}



/////////////////////////////////////////////////////////////////////////////////////////
// MARK: PickerView
/////////////////////////////////////////////////////////////////////////////////////////

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return symbols.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return symbols[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		update()
	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		
		let pickerLabel = UILabel()
		pickerLabel.text = symbols[row]
		pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 60)
		//pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 15) // In this use your custom font
		pickerLabel.textAlignment = NSTextAlignment.center
		
		return pickerLabel
	}
	
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 70.0
	}
}

























