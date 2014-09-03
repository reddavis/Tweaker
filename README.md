# Tweaker

Tweaker is a library that makes it easy to play around with values (e.g. animation speed) without having to rebuild your application.

> 1. Person who constantly stays up cleaning, washing, organizing, powertooling, sorting or otherwise keeping themself busy doing menial tasks. 
> 2. Someone who constantly makes slight alterations on (usually a very specific) object, i.e. computer, software, automobile, etc. 
> 3. A compulsive liar, thief, or both. 
> 4. A methamphetamine ("tweak"), or other form of speed, addict (who displays all of the above in an obsessive-compulsive manner).”

> **- Urban Dictionary**

## Overview
![](https://www.dropbox.com/s/m1y4dg1r1anqfuw/tweaker%20%282%29.gif?dl=1)

## Example
```swift
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
```

## Note
This is experimental at the moment, so expect the API to change.

## License 
Copyright (c) Forever and ever Red Davis
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

