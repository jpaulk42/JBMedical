//
//  ThirdViewController.swift
//  J&B
//
//  Created by James Paulk on 3/3/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import UIKit

var products = [String]()

class ProductsViewController: UIViewController, UIPopoverPresentationControllerDelegate
{
//MARK: -Properties
	@IBOutlet weak var contentsView: UIView!

//	@IBOutlet weak var headgearSegment: YesOrNo!
//	@IBOutlet weak var maskSegment: YesOrNo!
//	@IBOutlet weak var pillowsSegment: YesOrNo!
//	@IBOutlet weak var cushionsSegment: YesOrNo!
//	@IBOutlet weak var tubingSegment: YesOrNo!
//	@IBOutlet weak var chinstrapSegment: YesOrNo!
//	@IBOutlet weak var ndFilterSegment: YesOrNo!
//	@IBOutlet weak var dispFilterSegment: YesOrNo!
//	@IBOutlet weak var waterChamberSegment: YesOrNo!
//	@IBOutlet weak var o2LineAdaptorSegment: YesOrNo!

//MARK: -App Life Cycle
	override func viewDidLoad()
	{
//		headgearSegment.title = "Headgear"
//		maskSegment.title = "Mask"
//		pillowsSegment.title = "Pillows"
//		cushionsSegment.title = "Cushions"
//		tubingSegment.title = "Tubing"
//		chinstrapSegment.title = "Chinstrap"
//		ndFilterSegment.title = "ND Filter"
//		dispFilterSegment.title = "Disp Filter"
//		waterChamberSegment.title = "Water Chamber"
//		o2LineAdaptorSegment.title = "O2 Line Adaptor"
	}
//MARK: -Other
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if let identifier = segue.identifier
		{print(identifier)
			switch identifier
			{
				case "about":
					if let vc = segue.destinationViewController as? LocationAndContact
					{
						if let ppc = vc.popoverPresentationController
						{
							ppc.delegate = self
						}
					}
				case "add":
					if products.count > 0
					{
						products.removeAll()
					}

					if listOfItemsToBeOrdered != nil
					{
						listOfItemsToBeOrdered = ""
					}

					contentsView.subviews.forEach
					{ (view) -> () in

						/*if let myView = view as? YesOrNo
						{
							if myView.selectedSegmentIndex == 0
							{
								let product = myView.title
								products.append(product)
							}
						}*/
					}
				default: print("switch case failed"); break
			}
		}

	}

	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
	{
		return UIModalPresentationStyle.None
	}

}

