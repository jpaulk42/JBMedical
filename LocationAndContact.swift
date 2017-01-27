//
//  LocationAndContact.swift
//  J&B
//
//  Created by James Paulk on 3/5/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import UIKit
import MapKit

class LocationAndContact: UIViewController
{
	//MARK: -Properties
	@IBOutlet weak var contentView: UIView!

    fileprivate var openOrNot: String = "Open Now"

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var label: UILabel!

	fileprivate var calendar = Calendar(identifier: Calendar.Identifier.gregorian)

	//MARK: - App Life Cycle
    override func viewDidLoad()
	{
		super.viewDidLoad()
		let timeZone = TimeZone(abbreviation: "CST")
		print(timeZone!, terminator: "")
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(30.519991, -86.482561)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: false)

        let jbPin = MKPointAnnotation()
        jbPin.coordinate = location
        jbPin.title = "J&B Medical"
		let components = (calendar as NSCalendar).components(.weekday, from: Date())
		let weekday = components.weekday
		let calTime: DateComponents! = (calendar as NSCalendar?)?.components(.hour, from: Date())
		if weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5 || weekday == 6
		{
			if calTime.hour! >= 9 && calTime.hour! < 17
			{
				openOrNot = "Open until 5pm"
			}
			else
			{
				openOrNot = "Closed Now"
			}
		}
		else
		{
			openOrNot = "Closed Today"
		}

        jbPin.subtitle = openOrNot
        mapView.addAnnotation(jbPin)

		mapView.selectedAnnotations = [jbPin]
		createMapViewWithAnnotationAndInfo()
		mapView.isUserInteractionEnabled = false
    }

	//MARK: -Other
	override var preferredContentSize: CGSize
	{
		get
		{
			return contentView.sizeThatFits(contentView.bounds.size)
		}
		set
		{
			super.preferredContentSize = newValue
		}
	}

	fileprivate func createMapViewWithAnnotationAndInfo()
	{
		let span:MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
		let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(30.519991, -86.482561)
		let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
		mapView.setRegion(region, animated: false)

		let jbPin = MKPointAnnotation()
		jbPin.coordinate = location
		jbPin.title = "J&B Medical"
		let components = (calendar as NSCalendar).components(.weekday, from: Date())
		let weekday = components.weekday
		let calTime: DateComponents! = (calendar as NSCalendar?)?.components(.hour, from: Date())
		if weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5 || weekday == 6
		{
			if calTime.hour! >= 9 && calTime.hour! <= 17
			{
				openOrNot = "Open until 5pm"
			}
			else
			{
				openOrNot = "Closed Now"
			}
		}
		else
		{
			openOrNot = "Closed Today"
		}

		jbPin.subtitle = openOrNot
		mapView.addAnnotation(jbPin)
		mapView.selectedAnnotations = [jbPin]
	}

}
