//
//  SpecialistRequest.swift
//  J&B
//
//  Created by James Paulk on 6/24/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import UIKit

class SpecialistRequest: UIViewController, UITextViewDelegate
{

    @IBOutlet weak var chooseSpecialistButton: UIButton!
    @IBOutlet weak var selectedSpecialistLabel: UILabel!
    @IBOutlet weak var additionalInfoTextField: UITextView!
    
    @IBAction func chooseSpecialist()
    {
        let actionSheet = UIAlertController(title: "Choose a Specialist", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Amy Schumer", style: .default, handler: { [unowned self] (action) in
            self.selectedSpecialistLabel.text = "Amy Schumer"
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { [unowned actionSheet] (action) in
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func sendAppointmentRequest()
    {
        print("Sending request...")
    }
    
    override func viewDidLoad()
    {
        additionalInfoTextField.delegate = self
        selectedSpecialistLabel.text = ""
        if UIScreen.main.bounds.size.width < 330
        {
            chooseSpecialistButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
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
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        additionalInfoTextField.text = ""
    }
    
}


