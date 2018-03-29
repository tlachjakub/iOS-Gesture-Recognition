//
//  PickerView.swift
//  iOS-Gesture-Draw
//
//  Created by Jakub Tlach on 11/29/17.
//  Copyright © 2017 Jakub Tlach. All rights reserved.
//

import Foundation
import UIKit

class PickerView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
	
	let counter = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	let symbols = ["🙂", "🙁", "😏", "😃", "😛", "😵",
				   "⭐️", "❤️", "✘", "✔︎", "❗️", "❓",
				   "💲", "⬅️", "➡️", "⬆️", "⬇️", "#️⃣"]
	
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
		return
	}
	
}
