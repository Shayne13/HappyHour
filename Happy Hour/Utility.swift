//
//  Utility.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 9/11/15.
//  Copyright (c) 2015 Shayne Longpre. All rights reserved.
//

// This file contains all utility functions to be used across the app:

import UIKit


// MARK: - Global Constants

struct Constants
{
  
  struct TextStyles {
//    static var Title: = //
  }
  
  struct Colours {
    static let DarkBlue = UIColor(red: 0.04, green: 0.04, blue: 0.12, alpha: 1.0) // app delegate
    static let OtherColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0) //results map
    static let OtherColor2 = UIColor(red: 124/255, green: 201/255, blue: 224/255, alpha: 1.0) // location 'cancel' button
    static let TranslucentWhite = UIColor.whiteColor().colorWithAlphaComponent(0.5)
    static let Gray = UIColor.grayColor()
    static let Cyan = UIColor.cyanColor()
    static let White = UIColor.whiteColor()
    static let Black = UIColor.blackColor()
    static let Green = UIColor.greenColor()
    static let Yellow = UIColor.yellowColor()
    static let Red = UIColor.redColor()
  }
  
  struct Fonts {
    static let PageTitle = UIFont(name: "HelveticaNeue-Light", size: 20)
    static let TableHeader = UIFont(name: "HelveticaNeue-Light", size: 16)
    
    static let Bold = UIFont(name: "HelveticaNeue-Bold", size: 16)
    static let Regular = UIFont(name: "HelveticaNeue", size: 14)
    static let Light = UIFont(name: "HelveticaNeue-Light", size: 14)
    static let LightItalic = UIFont(name: "HelveticaNeue-LightItalic", size: 12)
    // TODO: Add the DTVC Styles
  }
  
  struct CellDimensions {
    struct Height {
      static let Header: CGFloat = 30.0
      static let Single: CGFloat = 32.0 // One row
      static let Double: CGFloat = 56.0 // Two rows
      static let Triple: CGFloat = 80.0 // Three rows
    }
    struct Inset {
      static let VSmall: CGFloat = 4.0
      static let Small: CGFloat = 8.0
      static let Medium: CGFloat = 12.0
      static let Large: CGFloat = 16.0
    }
  }
  
  struct SegueIdentifiers {
    static let Results = "EG: Results View Controller"
  }
  
  struct FontSizes {
    static let VSmall: CGFloat = 12.0
    static let Small: CGFloat = 14.0
    static let Medium: CGFloat = 16.0
    static let Large: CGFloat = 18.0
    static let VLarge: CGFloat = 20.0
  }
  
}

// Font Size
// Font Style
// Font Color

// Table Header Color

// Navigation Item Header Color

// Cell Dimensions:
// Height and 
// Inset

// Animation Durations

// Segue Identifiers

// STATIC EGS:  

//struct Point {
//  let x: Double
//  let y: Double
//  
//  // Store property
//  static let zero = Point(x: 0, y: 0)
//  
//  // Calculate property
//  static var ones: [Point] {
//    return [Point(x: 1, y: 1),
//      Point(x: -1, y: 1),
//      Point(x: 1, y: -1),
//      Point(x: -1, y: -1)]
//  }
//  
//  // Type method
//  static func add(p1: Point, p2: Point) -> Point {
//    return Point(x: p1.x + p2.x, y: p1.y + p2.y)
//  }
//}


func imageWithSize(imageName: String, size: CGSize) -> UIImage {
  UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
  let largeImg = UIImage(named: imageName)
  let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
  largeImg?.drawInRect(rect)
  let img = UIGraphicsGetImageFromCurrentImageContext()
  UIGraphicsEndImageContext()
  return img
}

// MARK: - Convenience Extensions

extension Dictionary
{
  
  // Convert (k, v) pairs in dictionary into HTTP Parameter string:
  func getHTTPRequestParamsAsString() -> String {
    var parameters = [String]()
    for (k, v) in self {
      parameters.append("\(k as! String)=\(v as! String)")
    }
    return parameters.joinWithSeparator("&")
  }
  
}

extension UIView
{
  
  func addBackground(image: UIImage) {
    // screen width and height:
    let width = UIScreen.mainScreen().bounds.size.width
    let height = UIScreen.mainScreen().bounds.size.height
    
    let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
    imageViewBackground.image = image
    imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
    
    self.addSubview(imageViewBackground)
    self.sendSubviewToBack(imageViewBackground)
  }
  
}


extension UIViewController
{
  
  var contentViewController: UIViewController {
    if let navcon = self as? UINavigationController {
      return navcon.visibleViewController!
    } else {
      return self
    }
  }
  
}

extension UIImage
{
  
//  func resizeImageToScale(targetSize: CGSize) -> UIImage {
//    let size = self.size
//    
//    let widthRatio  = targetSize.width  / self.size.width
//    let heightRatio = targetSize.height / self.size.height
//    
//    // Figure out what our orientation is, and use that to form the rectangle
//    var newSize: CGSize
//    if(widthRatio > heightRatio) {
//      newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
//    } else {
//      newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
//    }
//    
//    // This is the rect that we've calculated out and this is what is actually used below
//    let rect = CGRectMake(0, 0, newSize.width, newSize.height)
//    
//    // Actually do the resizing to the rect using the ImageContext stuff
//    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//    self.drawInRect(rect)
//    let newImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    
//    return newImage
//  }
  
  func addFrame(frameColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) -> UIImage
  {
    let imgFrame = CGRectMake(0, 0, self.size.width, self.size.height)
    return self.resizeAndFrame(imgFrame, frameColor: frameColor, borderWidth: borderWidth, cornerRadius: cornerRadius)
  }
  
  // Resizes the image and adds a colored frame of the given width and roundedness:
  func resizeAndFrame(size: CGRect, frameColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) -> UIImage
  {
    
    UIGraphicsBeginImageContextWithOptions(size.size, false, 0)
    
    let path = UIBezierPath(roundedRect: CGRectInset(size, borderWidth / 2, borderWidth / 2), cornerRadius: cornerRadius)
    
    // Set up the new image context.
    let context = UIGraphicsGetCurrentContext()
    
    CGContextSaveGState(context)
    // Clip the drawing area to the path
    path.addClip()
    
    // Draw the image into the context
    self.drawInRect(size)
    CGContextRestoreGState(context)
    
    // Configure the stroke
    frameColor.setStroke()
    path.lineWidth = borderWidth
    
    // Stroke the border
    path.stroke()
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    
    return newImage
  }
  
  // Modifies the alpha (transparency) of the image
  func alpha(value:CGFloat) -> UIImage
  {
    UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
    
    let ctx = UIGraphicsGetCurrentContext();
    let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, CGBlendMode.Multiply);
    CGContextSetAlpha(ctx, value);
    CGContextDrawImage(ctx, area, self.CGImage);
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
  }
  
  
  // colorize image with given tint color
  // this is similar to Photoshop's "Color" layer blend mode
  // this is perfect for non-greyscale source images, and images that have both highlights and shadows that should be preserved
  // white will stay white and black will stay black as the lightness of the image is preserved
  func tint(tintColor: UIColor) -> UIImage {
    
    return modifiedImage { context, rect in
      // draw black background - workaround to preserve color of partially transparent pixels
      CGContextSetBlendMode(context, .Normal)
      UIColor.blackColor().setFill()
      CGContextFillRect(context, rect)
      
      // draw original image
      CGContextSetBlendMode(context, .Normal)
      CGContextDrawImage(context, rect, self.CGImage)
      
      // tint image (loosing alpha) - the luminosity of the original image is preserved
      CGContextSetBlendMode(context, .Color)
      tintColor.setFill()
      CGContextFillRect(context, rect)
      
      // mask by alpha values of original image
      CGContextSetBlendMode(context, .DestinationIn)
      CGContextDrawImage(context, rect, self.CGImage)
    }
  }
  
  // fills the alpha channel of the source image with the given color
  // any color information except to the alpha channel will be ignored
  func fillAlpha(fillColor: UIColor) -> UIImage {
    
    return modifiedImage { context, rect in
      // draw tint color
      CGContextSetBlendMode(context, .Normal)
      fillColor.setFill()
      CGContextFillRect(context, rect)
      
      // mask by alpha values of original image
      CGContextSetBlendMode(context, .DestinationIn)
      CGContextDrawImage(context, rect, self.CGImage)
    }
  }
  
  private func modifiedImage(@noescape draw: (CGContext, CGRect) -> ()) -> UIImage {
    
    // using scale correctly preserves retina images
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    let context: CGContext! = UIGraphicsGetCurrentContext()
    assert(context != nil)
    
    // correctly rotate image
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    let rect = CGRectMake(0.0, 0.0, size.width, size.height)
    
    draw(context, rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
}