//
//  ProductSelection.swift
//  J&B v1.0
//
//  Created by James Paulk on 5/3/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import UIKit

class ProductSelection: UIButton
{
	@IBInspectable
	var name: String?
	var isNeeded = false

	func select()
	{
		if !isNeeded
		{
			self.setTitle("✓", for: UIControlState())
			isNeeded = true
		}
		else if isNeeded
		{
			setTitle("", for: UIControlState())
			isNeeded = false
		}
	}
}
