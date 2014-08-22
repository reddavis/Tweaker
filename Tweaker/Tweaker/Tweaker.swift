//
//  Tweaker.swift
//  Tweaker
//
//  Created by Red Davis on 09/08/2014.
//  Copyright (c) 2014 Red Davis. All rights reserved.
//

import Foundation
import UIKit
import MessageUI


typealias TweakerSliderChangeBlock = (value: Float) -> Void
typealias TweakerSwitchChangeBlock = (on: Bool) -> Void


protocol TweakerContructorProtocol: class
{
    var control: UIControl { get }
    var title: String? { get }
	
	// MARK: Initialization
	
    init(control: UIControl)
}


@objc class TweakerSliderControl: TweakerContructorProtocol
{
    var title: String?
    var control: UIControl
    var valueChangedBlock: TweakerSliderChangeBlock?
    
    var slider: UISlider {
        return self.control as UISlider
    }
    
    // MARK: Initialization
    
    required init(control: UIControl)
    {
        self.control = control as UISlider
    }
    
	// MARK: API
	
	func title(title: String) -> TweakerSliderControl
	{
		self.title = title
		return self
	}
	
	func value(value: NSNumber) -> TweakerSliderControl
	{
		self.slider.value = value.floatValue
		return self
	}
	
	func maxValue(value: NSNumber) -> TweakerSliderControl
	{
		self.slider.maximumValue = value.floatValue
		return self
	}
	
	func minValue(value: NSNumber) -> TweakerSliderControl
	{
		self.slider.minimumValue = value.floatValue
		return self
	}
    
    func valueChanged(block: TweakerSliderChangeBlock) -> TweakerSliderControl
    {
        self.valueChangedBlock = block
        return self
    }
}

@objc class TweakerSwitchControl: TweakerContructorProtocol
{
    var title: String?
    var control: UIControl
    var valueChangedBlock: TweakerSwitchChangeBlock?
    
    var switchControl: UISwitch {
        return self.control as UISwitch
    }
    
    // MARK: Initialization
    
    required init(control: UIControl)
    {
        self.control = control as UISwitch
    }
    
	// MARK: API
	
	func title(title: String) -> TweakerSwitchControl
	{
		self.title = title
		return self
	}
    
    func on() -> TweakerSwitchControl
    {
        self.switchControl.on = true
        return self
    }
    
    func off() -> TweakerSwitchControl
    {
        self.switchControl.on = false
        return self
    }
    
    func valueChanged(block: TweakerSwitchChangeBlock) -> TweakerSwitchControl
    {
        self.valueChangedBlock = block
        return self
    }
}


@objc class TweakerMaker: TweakerViewControllerDataSource
{
	enum TweakerControl
	{
		case Switch(TweakerSwitchControl)
		case Slider(TweakerSliderControl)
	}
	
	let tweakerViewController: TweakerViewController
	var controls = Dictionary<UIControl, TweakerControl>()
	
	// MARK: Initialization
	
	required init(tweakerViewController: TweakerViewController)
	{
		self.tweakerViewController = tweakerViewController;
		self.tweakerViewController.dataSource = self;
	}
	
	// MARK: API
	
	func slider() -> TweakerSliderControl
	{
		let slider = UISlider()
		slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: UIControlEvents.ValueChanged)

		let tweakerControl = TweakerSliderControl(control: slider)
		
		self.controls.updateValue(TweakerControl.Slider(tweakerControl), forKey: slider)
		
		return tweakerControl
	}
	
	// TODO: Segmented control
	// TODO: This name is nasty
	func switchControl() -> TweakerSwitchControl
	{
		let switchControl = UISwitch()
        switchControl.addTarget(self, action: "switchValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        let tweakerControl = TweakerSwitchControl(control: switchControl)
        self.controls.updateValue(TweakerControl.Switch(tweakerControl), forKey: switchControl)
        
        return tweakerControl
	}
	
	// MARK: Actions
	
	func sliderValueChanged(sender: AnyObject)
	{
		var slider = sender as UISlider
		if let tweakerControl = self.controls[slider]
		{
			switch tweakerControl {
			case .Slider(let s):
				if let block = s.valueChangedBlock
				{
					block(value: slider.value)
				}
			default: ()
			}
		}
	}
    
    func switchValueChanged(sender: AnyObject)
    {
        var switchControl = sender as UISwitch
		if let tweakerControl = self.controls[switchControl]
		{
			switch tweakerControl {
			case .Switch(let f):
				if let block = f.valueChangedBlock
				{
					block(on: switchControl.on)
				}
			default: ()
			}
		}
    }
	
	// MARK: TweakerViewControllerDataSource
	
	func numberOfControls(tweakerViewController: TweakerViewController!) -> Int
	{
		return self.controls.count
	}
	
	func tweakerViewController(tweakerViewController: TweakerViewController!, controlAtIndex index: Int) -> UIControl
	{
		var control = Array(self.controls.keys)[index]
		return control
	}
	
	func tweakerViewController(tweakerViewController: TweakerViewController!, titleAtIndex index: Int) -> String?
	{
		var control = Array(self.controls.keys)[index]
		var title: String?
		
		if let tweakerControl = self.controls[control]
		{
			switch tweakerControl {
				case .Switch(let f): // <- WTF?
					title = f.title
				case .Slider(let s):
					title = s.title
			}
		}
		
		return title
	}
	
	func tweakerViewController(tweakerViewController: TweakerViewController!, descriptiveValueForControlAtIndex index: Int) -> String?
	{
		var description: String?
		
		var control = Array(self.controls.keys)[index]
		if control.isKindOfClass(UISlider.self)
		{
			let slider = control as UISlider
			description = String(format: "%.2f", slider.value)
		}
		else if control.isKindOfClass(UISwitch.self)
		{
			let switchControl = control as UISwitch
			description = switchControl.on ? "On" : "Off"

		}
		
		return description
	}
}


protocol TweakerViewControllerDataSource
{
	func numberOfControls(tweakerViewController: TweakerViewController!) -> Int
	func tweakerViewController(tweakerViewController: TweakerViewController!, controlAtIndex index: Int) -> UIControl
	func tweakerViewController(tweakerViewController: TweakerViewController!, titleAtIndex index: Int) -> String?
	func tweakerViewController(tweakerViewController: TweakerViewController!, descriptiveValueForControlAtIndex index: Int) -> String?
}

class TweakerViewController: UITableViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate
{
	var dataSource: TweakerViewControllerDataSource?
	
	// MARK: View lifecycle
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.whiteColor()
		self.title = "Tweaks"
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonTapped:")
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Email", style: UIBarButtonItemStyle.Plain, target: self, action: "emailButtonTapped:")
	}
	
	override func viewDidLayoutSubviews()
	{
		
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
	}
	
	// MARK: API
	
	func build(block: (make: TweakerMaker) -> (Void))
	{
		block(make: TweakerMaker(tweakerViewController: self))
	}
	
	// MARK: Actions
	
	func doneButtonTapped(sender: AnyObject)
	{
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func emailButtonTapped(sender: AnyObject)
	{
		if MFMailComposeViewController.canSendMail()
		{
			let appName: String = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleNameKey as NSString) as String
			
			var emailBody = ""
			let numberOfControls: Int = self.dataSource!.numberOfControls(self) ?? 0
			for index in 0...(numberOfControls-1)
			{
				var title = self.dataSource?.tweakerViewController(self, titleAtIndex: index) ?? "No title"
				var value = self.dataSource?.tweakerViewController(self, descriptiveValueForControlAtIndex: index) ?? "N\\A"
				
				emailBody += String(format: "%@: %@\n", title, value)
			}
			
			let mailComposeViewController = MFMailComposeViewController()
			mailComposeViewController.mailComposeDelegate = self
			mailComposeViewController.setSubject(String(format: "Tweaker - %@", appName))
			mailComposeViewController.setMessageBody(emailBody, isHTML: false)
			self.presentViewController(mailComposeViewController, animated: true, completion: nil)
		}
	}
	
	func accessoryViewValueChanged(sender: AnyObject)
	{
		for cell in self.tableView.visibleCells()
		{
			let tableViewCell = cell as? UITableViewCell
			if cell.accessoryView == (sender as UIControl)
			{
				var indexPath = self.tableView.indexPathForCell(tableViewCell)
				tableViewCell?.detailTextLabel.text = self.dataSource?.tweakerViewController(self, descriptiveValueForControlAtIndex: indexPath.row)
			}
		}
	}
	
	// MARK: UITableViewDataSource
	
	override func numberOfSectionsInTableView(tableView: UITableView!) -> Int
	{
		return 1
	}
	
	override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
	{
		return self.dataSource?.numberOfControls(self) ?? 0
	}
	
	// MARK: UITableViewDataSource
	
	override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
	{
		let cellIdentifier = "cellIdentifier"
		var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
		if cell == nil
		{
			cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
		}
		
		cell?.selectionStyle = UITableViewCellSelectionStyle.None
		
		var accessoryView = self.dataSource!.tweakerViewController(self, controlAtIndex: indexPath.row);
		cell?.accessoryView = accessoryView
		accessoryView.addTarget(self, action: "accessoryViewValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
		
		var title = self.dataSource!.tweakerViewController(self, titleAtIndex: indexPath.row)
		cell?.textLabel.text = title
		
		cell?.detailTextLabel.text = self.dataSource!.tweakerViewController(self, descriptiveValueForControlAtIndex: indexPath.row)
		
		return cell
	}
	
	// MARK: MFMailComposeViewControllerDelegate
	
	func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!)
	{
		controller.dismissViewControllerAnimated(true, completion: nil)
	}
}
