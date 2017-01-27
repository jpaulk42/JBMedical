//
//  ProductsTableViewController.swift
//  J&B v1.0
//
//  Created by James Paulk on 5/3/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import UIKit

var products = [String]()

class ProductsTableViewController: UITableViewController
{
	//MARK: -Properties
	@IBOutlet weak var contentsView: UIView!
	@IBOutlet weak var headGearButton: ProductSelection!
	@IBOutlet weak var maskButton: ProductSelection!
	@IBOutlet weak var pillowsButton: ProductSelection!
	@IBOutlet weak var cushionsButton: ProductSelection!
	@IBOutlet weak var tubingButton: ProductSelection!
	@IBOutlet weak var chinstrapButton: ProductSelection!
	@IBOutlet weak var ndFilterButton: ProductSelection!
	@IBOutlet weak var dispFilterButton: ProductSelection!
	@IBOutlet weak var o2LineButton: ProductSelection!
	@IBOutlet weak var waterChamberButton: ProductSelection!

	@IBAction func requestAllEligibleProducts(_ sender: ProductSelection)
	{
		if sender.isNeeded
		{
			let alert = UIAlertController(title: "Please Confirm", message: "By selecting this option J&B will give you all supplies your insurance company will allow at this time.", preferredStyle: .alert)

			alert.addAction(UIAlertAction(title: "Continue", style: .default , handler: { (alert) in
				if products.count > 0
				{
					products.removeAll()
				}

				if listOfItemsToBeOrdered != nil
				{
					listOfItemsToBeOrdered = ""
				}
				products.append(sender.name!)
				self.performSegue(withIdentifier: "allEligible", sender: self)
			}))

			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [unowned self] (action) in
				self.dismiss(animated: true, completion: nil)
				sender.select()
			}))

			present(alert, animated: true, completion: nil)
		}
	}
	
	var productCheckBoxes = [ProductSelection]()

	@IBAction func changeSelection(_ sender: ProductSelection)
	{
		sender.select()
	}

    @IBAction func submitItems(_ sender: AnyObject)
    {
        var anyNeeded = false
        
        if products.count > 0
        {
            products.removeAll()
        }
        
        if listOfItemsToBeOrdered != nil
        {
            listOfItemsToBeOrdered = ""
        }
        for item in productCheckBoxes
        {
            if item.isNeeded
            {
                anyNeeded = true
                
                if let product = item.name
                {
                    products.append(product)
                }
            }
        }
        if anyNeeded
        {
            performSegue(withIdentifier: "add", sender: self)
        }
        else
        {
            presentNoneSelectedAlert()
        }
    }
    
	//MARK: -App Life Cycle
	override func viewDidLoad()
	{
		super.viewDidLoad()
		productCheckBoxes = [headGearButton, maskButton, pillowsButton, cushionsButton, tubingButton, chinstrapButton, ndFilterButton, dispFilterButton, o2LineButton, waterChamberButton]
	}
    
    fileprivate func presentNoneSelectedAlert()
    {
        let alert = UIAlertController(title: "Please select the items you need before proceeding.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { [unowned alert] (action) in

            alert.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true, completion: nil)
    }
}
