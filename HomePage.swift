//
//  HomePage.swift
//  J&B
//
//  Created by James Paulk on 5/27/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import UIKit
import MessageUI

struct Email
{
	static let JB = "kim@jbmedical.org"
    static let JB2 = "kenn@jbmedical.org"
	static let Test = MCOAddress(displayName: "James", mailbox: "j.paulk_42@yahoo.com")
}

class HomePage: UIViewController, UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate
{
	@IBOutlet weak var aboutTV: UITextView!

	fileprivate var patientName: String?
	{
		get
		{
			if let savedName = UserDefaults.standard.object(forKey: "patientName") as? String
			{
				return savedName
			}
			return nil
		}
		set
		{
			UserDefaults.standard.set(newValue, forKey: "patientName")
		}
	}
	fileprivate var phoneNumber: String?
	{
		get
		{
			if let savedNum = UserDefaults.standard.object(forKey: "number") as? String
			{
				return savedNum
			}
			return nil
		}
		set
		{
			UserDefaults.standard.set(newValue, forKey: "number")
		}
	}

	override func viewWillLayoutSubviews()
	{
		super.viewWillLayoutSubviews()
		aboutTV.scrollRangeToVisible(NSMakeRange(0, 1))
	}
	@IBAction func displayEmailVC()
	{
		if patientName != nil && phoneNumber != nil 
		{
			displayEmailController()
		}
		else
		{
			displayQuestionsInfoAlert()
		}
	}

	fileprivate func displayEmailController()
	{
		let mvc = MFMailComposeViewController()

		mvc.mailComposeDelegate = self

		mvc.setToRecipients([Email.JB, Email.JB2])

		if patientName != "" && patientName != nil
		{
			mvc.setSubject("Questions/Concerns from iOS device")
			mvc.setMessageBody("Name: \(patientName!)\nPhone Number: \(phoneNumber!)", isHTML: false)
		}
		else if phoneNumber != ""
		{
			mvc.setSubject("Questions/Concerns from iOS device")
			mvc.setMessageBody("Call back number: \(phoneNumber!)", isHTML: false)
		}

		if MFMailComposeViewController.canSendMail()
		{
			self.present(mvc, animated: true, completion: nil)
		}
		else
		{
			self.sendEmailError()
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let identifier = segue.identifier
		{
			if identifier == "about"
			{
				if let vc = segue.destination as? LocationAndContact
				{
					if let ppc = vc.popoverPresentationController
					{
						ppc.delegate = self
					}
				}
			}
		}
	}

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
	{
		return UIModalPresentationStyle.none
	}

	fileprivate func sendEmailError()
	{
		let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
		sendMailErrorAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { [unowned sendMailErrorAlert] (alertAction) -> Void in
			sendMailErrorAlert.dismiss(animated: true, completion: nil)
		}))
		present(sendMailErrorAlert, animated: true, completion:  nil)
	}

	fileprivate func displayQuestionsInfoAlert()
	{
		let alert = UIAlertController(title: nil, message: "Please enter your first and last name and phone number.", preferredStyle: .alert)
		alert.addTextField { (tf) in tf.placeholder = "First and Last name" }
		alert.addTextField { (tff) in tff.placeholder = "Phone Number" }
		alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default )
		{ [unowned self] (action) in
			guard let tf1 = alert.textFields?[0] else { return }
			guard let tf2 = alert.textFields?[1] else { return }
			if tf1.text == "" && tf2.text == ""
			{
				self.displayQuestionsInfoAlert()
			}
			if tf1.text != "" && tf2.text != ""
			{
				self.patientName = tf1.text!
                self.phoneNumber = tf2.text!
			}
			
			if self.patientName != nil && self.phoneNumber != nil
			{
				self.displayEmailController()
			}
		})
		alert.addAction(UIAlertAction(title: "Cancel", style: .destructive , handler: { [unowned alert] (stuff) in
			alert.dismiss(animated: true, completion: nil)
		}))
		present(alert, animated: true, completion: nil)
	}

	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
	{
		controller.dismiss(animated: true, completion: nil)
	}
}
