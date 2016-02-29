//
//  RootViewController.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 1/2/16.
//  Copyright © 2016 Shayne Longpre. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

  let client = Client.Instance.singleton
  
  private struct Dimensions {
    static let ResultsButtonHeight: CGFloat = 50.0
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let screenWidth = self.view.bounds.size.width
    let screenHeight = self.view.bounds.size.height
    self.view.addBackground(UIImage(named: "bg3")!) // TODO: Optimize this image ie 'bg5'
    
    let resultsButtonTitle = "Find Your Happy Hour"
    let textFont = Constants.Fonts.PageTitle!
    let textColour = Constants.Colours.TranslucentWhite
    let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
    textStyle.alignment = NSTextAlignment.Center
    let textFontAttributes = [
      NSFontAttributeName: textFont,
      NSForegroundColorAttributeName: textColour,
      NSParagraphStyleAttributeName: textStyle
    ]
    
    

    let resultsButtonText: NSAttributedString = NSAttributedString(string: resultsButtonTitle, attributes: textFontAttributes)
    

    let resultsButton = UIButton(frame: CGRectMake(20.0, screenHeight - 300.0, screenWidth - 40.0, Dimensions.ResultsButtonHeight))
    resultsButton.setAttributedTitle(resultsButtonText, forState: UIControlState.Normal)
    resultsButton.backgroundColor = UIColor.clearColor()
    resultsButton.layer.cornerRadius = 6.0
    resultsButton.layer.borderWidth = 2.0
    resultsButton.layer.borderColor = Constants.Colours.TranslucentWhite.CGColor
    
    let locationLabel = UILabel(frame: CGRectMake(20.0, screenHeight - 400.0, screenWidth - 40.0, 50.0))
    locationLabel.text = "Location"
    
    self.view.addSubview(resultsButton)
    self.view.addSubview(locationLabel)
    
  }

  override func viewDidAppear(animated: Bool) {
    navigationItem.title = "Happy Hour"
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
