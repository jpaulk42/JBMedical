//
//  ShoppingCart.swift
//  J&B
//
//  Created by James Paulk on 5/24/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import UIKit

class ShoppingCart: UIViewController
{
	@IBOutlet weak var contentsView: UIView!

	override var preferredContentSize: CGSize
	{
		get
		{
			return contentsView.sizeThatFits(contentsView.bounds.size)
		}
		set
		{
			super.preferredContentSize = newValue
		}
	}
	@IBOutlet weak var itemsList: UITextView!

	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		itemsList.text = products.joined(separator: "\n")
	}
}
