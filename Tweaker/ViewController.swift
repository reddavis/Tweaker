//
//  ViewController.swift
//  Tweaker
//
//  Created by Red Davis on 09/08/2014.
//  Copyright (c) 2014 Red Davis. All rights reserved.
//

import UIKit


class ViewController: UIViewController
{
	var animationDuration: NSTimeInterval = 1.0
	var springDamping: CGFloat = 0.5
	var animationCurve: UIViewAnimationOptions = UIViewAnimationOptions.CurveEaseInOut
	
	var tweakerController: TweakerViewController?
	let square = UIView(frame: CGRectMake(135.0, 50.0, 50.0, 50.0))
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.edgesForExtendedLayout = UIRectEdge.None
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweak!", style: UIBarButtonItemStyle.Plain, target: self, action: "showTweakerButtonTapped:")
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Animate!", style: UIBarButtonItemStyle.Plain, target: self, action: "animateButtonTapped:")
		
		self.square.backgroundColor = UIColor.redColor()
		self.view.addSubview(self.square)
		
		self.tweakerController = TweakerViewController()
		self.tweakerController?.build({ (make: TweakerMaker) in
			make.slider().title("Duration").minValue(0.25).maxValue(	2.0).value(self.animationDuration).valueChanged({ (value) -> Void in
                self.animationDuration = NSTimeInterval(value)
            })
			
			make.slider().title("Spring Damping").minValue(0.0).maxValue(1.0).value(self.springDamping).valueChanged({ (value) -> Void in
				self.springDamping = CGFloat(value)
			})
			
			make.switchControl().title("Green?").off().valueChanged({ (on) -> Void in
				self.square.backgroundColor = on ? UIColor.greenColor() : UIColor.redColor()
			})
			
			make.segmentedControl().title("Curve").addSegment("Ease in out", selected: true).addSegment("Ease out").valueChanged({ (index) -> Void in
				switch index {
				case 0:
					self.animationCurve = UIViewAnimationOptions.CurveEaseInOut
				case 1:
					self.animationCurve = UIViewAnimationOptions.CurveEaseOut
				default: ()
				}
			})
		})
	}

	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
	}
	
	// MARK: Actions
	
	func showTweakerButtonTapped(sender: AnyObject)
	{
		var navigationController = UINavigationController(rootViewController: self.tweakerController!)
		self.presentViewController(navigationController, animated: true, completion: nil)
	}
	
	func animateButtonTapped(sender: AnyObject)
	{
		var originalFrame = self.square.frame
		
		var newFrame = self.square.frame
		newFrame.origin.y = 200.0
		
		UIView.animateWithDuration(self.animationDuration, delay: 0.0, usingSpringWithDamping: self.springDamping, initialSpringVelocity: 0.0, options: self.animationCurve, animations: ({
			self.square.frame = newFrame
		}), completion: {(complete: Bool) -> Void in
			UIView.animateWithDuration(self.animationDuration, delay: 0.0, usingSpringWithDamping: self.springDamping, initialSpringVelocity: 0.0, options: self.animationCurve, animations: ({
				self.square.frame = originalFrame
			}), completion: {(complete: Bool) -> Void in
				
			})
		})
	}
}
