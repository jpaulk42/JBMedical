//
//  SecondViewController.swift
//  J&B
//
//  Created by James Paulk on 2/29/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import UIKit
import MessageUI

var listOfItemsToBeOrdered: String? 

class RequestViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIPopoverPresentationControllerDelegate
{
	//MARK: -Property
	fileprivate var name: String?
	{
		get
		{
			if let savedName = UserDefaults.standard.object(forKey: "name") as? String
			{
				return savedName
			}
			return nil
		}
		set
		{
			UserDefaults.standard.set(newValue, forKey: "name")
		}
	}
	
	fileprivate var number: String?
	{
		get
		{
			if let savedNumber = UserDefaults.standard.object(forKey: "number") as? String
			{
				return savedNumber
			}
			return nil
		}
		set
		{
			UserDefaults.standard.set(newValue, forKey: "number")
		}
	}
	fileprivate var birthDate: String?
	{
		get
		{
			if let savedBirth = UserDefaults.standard.object(forKey: "birth") as? String
			{
				return savedBirth
			}
			return nil
		}
		set
		{
			UserDefaults.standard.set(newValue, forKey: "birth")
		}
	}
	fileprivate var supplyAmount: String?
	fileprivate var suppliesRequested: String?
	fileprivate var hasSuppliesOnHand: String?
	fileprivate var theSSN: String?
	fileprivate var pickupDate: String?
	fileprivate var comments: String?

	@IBOutlet weak var customerName: UITextField!
	@IBOutlet weak var customerSSN: UITextField!
	@IBOutlet weak var phoneNumber: UITextField!
	//@IBOutlet weak var suppliesRequestedList: UITextView!
	@IBOutlet weak var hasUnusedSuppliesSegment: UISegmentedControl!
	@IBOutlet weak var sendRequestIndicator: UIActivityIndicatorView!
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var dateOfBirth: UITextField!
	@IBOutlet weak var thankYouPage: UIView!
	@IBOutlet weak var pickUpDate: UILabel!
    @IBOutlet weak var DatePickerContainer: UIView!
    @IBOutlet weak var DatePickerView: UIDatePicker!
    
//MARK: - App Model Functions
    
    //displays alert to call store
    
    @IBAction func displayDatePickerContainer(_ sender: UITextField)
    {
        DatePickerContainer.isHidden = false
        sendButton.isHidden = true
        sender.isUserInteractionEnabled = false
    }
   
    
    @IBAction func DatePickerDoneButton()
    {
        DatePickerContainer.isHidden = true
        sendButton.isHidden = false
        dateOfBirth.isUserInteractionEnabled = true
        dateOfBirth.resignFirstResponder()
        DatePickerView.resignFirstResponder()
    }

	@IBAction func displayUnusedSuppliesAlert(_ sender: UISegmentedControl)
	{
		if hasUnusedSuppliesSegment.selectedSegmentIndex == 0
		{
			displayNeedToCallAlert()
		}
	}

	//send email of info
	@IBAction func sendRequest(_ sender: AnyObject)
	{
		if phoneNumber.text == "" || customerName.text == "" || customerSSN.text == "" || dateOfBirth.text == nil
		{
            print("phone: \(phoneNumber.text)\n name: \(customerName.text!)\n ssn: \(customerSSN.text!)\n birth: \(dateOfBirth.text)")
			displayCompleteFormAlert()
			return
		}
		if customerSSN.text?.characters.count != 4
		{
			displayIncorrectSSNAlert()
			return
		}
		for c in (customerSSN.text?.characters)!
		{
			if c > "9" || c < "0"
			{
				displayIncorrectSSNAlert()
				return
			}
		}
		if phoneNumber.text?.characters.count != 10
		{
			displayIncorrectPhoneNumberFormatAlert()
			return
		}
		/*if dateOfBirth.text?.characters.count != 8
		{
			displayCompleteFormAlert()
			return
		}*/
		for c in (phoneNumber.text?.characters)!
		{
			if c > "9" || c < "0"
			{
				displayIncorrectPhoneNumberFormatAlert()
				return
			}
		}

		displayCommentsAlert()
	}

	fileprivate func sendEmail()
	{
		guard setInfo() != nil else { return }

		createLocalNotifcation()

		self.navigationController?.navigationBar.isUserInteractionEnabled = false
		sendRequestIndicator.startAnimating()

		let smtpSession = MCOSMTPSession()
		smtpSession.hostname = "smtp.gmail.com"
		smtpSession.username = "jbAppiOS@gmail.com"
		smtpSession.password = "B#101995"
		smtpSession.port = 465
		smtpSession.authType = MCOAuthType.saslPlain
		smtpSession.connectionType = MCOConnectionType.TLS
        
        let kim = MCOAddress(displayName: "Kim", mailbox: "j.paulk_42@yahoo.com")
        let ken = MCOAddress(displayName: "Ken", mailbox: "j.paulk42@gmail.com")

		let builder = MCOMessageBuilder()
        builder.header.to = [Email.Test]//[kim, ken]
		builder.header.from = MCOAddress(displayName: "J&B iOS App", mailbox: "jbAppiOS@gmail.com")
		builder.header.subject = "Pick-up request from PID#: \(name!)"
		builder.htmlBody = "Patient ID Number is: \(name!).\rDOB: \(birthDate!).\rLast 4-Digits of SSN: \(theSSN!).\rPick-up date: 12:00pm \(pickupDate!).\rCall back number: \(number!).\rRequesting a \(supplyAmount!) day supply of: \(suppliesRequested!).\r I have no unused supplies on hand.\rComments: \(comments!).\r"

		let emailData = builder.data()
		let sendOperation = smtpSession.sendOperation(with: emailData)
		sendOperation?.start { [unowned self] (error) -> Void in
			if error != nil
			{
                print("email not sent")
				self.sendEmailError()
				self.sendRequestIndicator.stopAnimating()
			}
			else
			{
                print("it worked mother fucker")
				self.sendRequestIndicator.stopAnimating()
				self.displayRequestSentView()
			}
			self.sendButton.isHidden = false
			self.navigationController?.navigationBar.isUserInteractionEnabled = true
		}

	}

	func createLocalNotifcation()
	{
		if UIApplication.shared.currentUserNotificationSettings == .none
		{
			return
		}
		let notificaiton = UILocalNotification()
		notificaiton.alertTitle = "Running low on supplies?"
		notificaiton.alertBody = "It's been a while since you last ordered supplies. Would you like to request more?"
		notificaiton.alertLaunchImage = "AppIcon"
		notificaiton.soundName = UILocalNotificationDefaultSoundName
		var dateToFire = Date()
		
        let time: TimeInterval = 24 * 60 * 60 * 90
        dateToFire = Date(timeIntervalSinceNow: time)
        notificaiton.fireDate = dateToFire
		
		UIApplication.shared.scheduleLocalNotification(notificaiton)

	}

	//called when their is an error in sending an email
	fileprivate func sendEmailError()
	{
		let sendMailErrorAlert = UIAlertController(title: "Could Not Send Request!", message: "Check network connection and try again.", preferredStyle: .alert)

		sendMailErrorAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler:
		{ [unowned sendMailErrorAlert](alertAction) -> Void in

				sendMailErrorAlert.dismiss(animated: true, completion: nil)
		}))

		present(sendMailErrorAlert, animated: true, completion:  nil)
	}

	fileprivate func displayIncorrectPhoneNumberFormatAlert()
	{
		let theAlert = UIAlertController(title: "Incorrect Phone Number Format", message: "Please enter a valid 10-digit phone number and try again.", preferredStyle: .alert)
		theAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { [unowned theAlert] (action) in
			theAlert.dismiss(animated: true, completion: nil)
		}))
		present(theAlert, animated: true, completion: nil)
	}

	fileprivate func displayIncorrectSSNAlert()
	{
		let theAlert = UIAlertController(title: "Incorrect SSN Format", message: "Please enter the last 4 Digits of your SSN.", preferredStyle: .alert)
		theAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { [unowned theAlert] (action) in
			theAlert.dismiss(animated: true, completion: nil)
		}))
		present(theAlert, animated: true, completion: nil)
	}

	//set variables that will be interpolated into email body
	fileprivate func setInfo() -> Int?
	{
		name = customerName.text
		number = phoneNumber.text
		suppliesRequested = products.joined(separator: ", ")
		theSSN = customerSSN.text
		birthDate = dateOfBirth.text

		let date = Date()

		var cal = Calendar(identifier: Calendar.Identifier.gregorian)
		cal.locale = Locale.current

		var secInDay: TimeInterval = 60 * 60 * 24

		let comp = (cal as NSCalendar).components(.weekday, from: date)
		let weekday = comp.weekday

		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none

		if weekday == 7
		{
			secInDay = secInDay * 2
		}
		else if weekday == 6
		{
			secInDay = secInDay * 3
		}
		print(secInDay)
		let nextDay = Date(timeInterval: secInDay, since: date)

		let pickupComp = (cal as NSCalendar).component(.day, from: nextDay)
		print(pickupComp)

		dateFormatter.locale = Locale.current

		let s = dateFormatter.string(from: nextDay)
		pickupDate = s

		supplyAmount = "90"
		
		return 1
	}

	fileprivate func displayNeedToCallAlert()
	{
		let needToCallAlert = UIAlertController(title: "You will need to speak to a J&B representative.", message: "Please call J&B Medical now to complete your request", preferredStyle: .alert)

		needToCallAlert.addAction(UIAlertAction(title: "Call Now", style: UIAlertActionStyle.default , handler:
		{ [unowned self] (action) in
			self.hasUnusedSuppliesSegment.selectedSegmentIndex = 1
			UIApplication.shared.openURL(URL(string: "tel:8507292559")!)
		}))

		needToCallAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler:
		{ [unowned self] (alert) in
			self.hasUnusedSuppliesSegment.selectedSegmentIndex = 1
			needToCallAlert.dismiss(animated: true, completion: nil)
		}))

		present(needToCallAlert, animated: true, completion: nil)
	}

	fileprivate func displayCommentsAlert()
	{
		sendButton.isHidden = true
		let commentsAlert = UIAlertController(title: nil, message: "Any additional information we need to know about your request?", preferredStyle: .alert)

		commentsAlert.addAction(UIAlertAction(title: "Skip", style: .default , handler: { [unowned self] (action) in
			self.comments = "No Additional Information Supplied"
			self.sendEmail()
		}))

		commentsAlert.addAction(UIAlertAction(title: "Done" , style: .default , handler: { [unowned self] (action) in
			//send request with comments here
			guard let textField: UITextField = commentsAlert.textFields?.first else {return}
			if textField.text == ""
			{
				self.comments = "No Additional Information Supplied"
			}
			self.comments = textField.text
			textField.resignFirstResponder()
			self.sendEmail()
			}))

		commentsAlert.addTextField { (textField) in
			textField.placeholder = "Comments..."
		}
		present(commentsAlert, animated: true, completion: nil)
	}

	fileprivate func displayRequestSentView()
	{
		UIView.animate(withDuration: 0.6, animations: {
			self.pickUpDate.text = "12:00PM \(self.pickupDate!)"
			//self.view.backgroundColor = UIColor(red: 0.227, green: 0.373, blue: 0.804, alpha: 0.90)
			self.thankYouPage.alpha = 1.0
		})
		
	}

	fileprivate func displayCompleteFormAlert()
	{
		let completeItAlert = UIAlertController(title: "Incomplete Form Submission", message: "Please fill in all information and try again.", preferredStyle: .alert)
		completeItAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { [unowned completeItAlert] (action) in
			completeItAlert.dismiss(animated: true, completion: nil)
		}))
		present(completeItAlert, animated: true, completion: nil)
	}
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        thankYouPage.alpha = 0.0
        hasUnusedSuppliesSegment.selectedSegmentIndex = 1
        //self.view.layer.cornerRadius = 0.0
        
        customerName.delegate = self
        phoneNumber.delegate = self
        //suppliesRequestedList.delegate = self
        customerSSN.delegate = self
        dateOfBirth.delegate = self
        navigationController?.navigationBar.isHidden = false
        DatePickerView.addTarget(self, action: #selector(RequestViewController.datePickerValueChanged(_:)), for: .valueChanged)
        
        if name != nil
        {
            customerName.text = name
        }
        if number != nil
        {
            phoneNumber.text = number
        }
        if birthDate != nil
        {
            dateOfBirth.text = birthDate
        }
    }

	//MARK: -App Life Cycle

	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
	}

	//MARK: -TextField Methods
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		textField.resignFirstResponder()
		return true
	}

	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
	{
		if text.contains("\n")
		{
			textView.resignFirstResponder()
			return false
		}
		return true
	}
	//MARK: -Popover Presentation Methods
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let identifier = segue.identifier
		{
			if identifier == "cart"
			{
				if let vc = segue.destination as? ShoppingCart
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
    
    func datePickerValueChanged(_ sender: UIDatePicker)
    {
        let dateForm = DateFormatter()
        dateForm.dateStyle = .short
        dateForm.timeStyle = .none
        dateOfBirth.text = dateForm.string(from: sender.date)
    }
}
