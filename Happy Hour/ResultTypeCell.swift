//
//  ResultTypeCell.swift
//  Happy Hour
//
//  Created by Shayne Longpre on 12/31/15.
//  Copyright © 2015 Shayne Longpre. All rights reserved.
//

import UIKit
//import AVFoundation

class ResultTypeCell: UITableViewCell {

  let client = Client.Instance.singleton

  // TODO: background for deal color coding (potentially)
  var background: UIView!
  var logo: UIImageView!
  var topLabel: UILabel!
  var midLabel: UILabel!
  var bottomLabel: UILabel!
  var topAnnotation: UIImageView!   // UIImage ?
  var midAnnotation: UIImageView!   // UIImage ?
  var bottomAnnotation: UILabel!
  
  private struct Dimensions {
    
    static let CellHeight = Constants.CellDimensions.Height.Triple
    static let ViewHeight = Dimensions.CellHeight - (2 * Dimensions.YInset) // Height of the cell minus the vertical padding
    
    static let XInset: CGFloat = 4.0 // Horizontal padding from walls
    static let YInset: CGFloat = 4.0 // Vertical padding from cells above and below
    static let XSeparation: CGFloat = 4.0 // Between elements
    
    static let LogoWidth: CGFloat = 76.0
    static let LogoHeight: CGFloat = Dimensions.CellHeight - (Dimensions.YInset * 2)
    
    static let TopElementHeight: CGFloat = Dimensions.ViewHeight * (1/3)
    static let MidElementHeight: CGFloat = Dimensions.ViewHeight * (1/3)
    static let BottomElementHeight: CGFloat = Dimensions.ViewHeight * (1/3)
    
    static let TopAnnotationWidth: CGFloat = 30.0
    static let MidAnnotationWidth: CGFloat = 30.0
    static let BottomAnnotationWidth: CGFloat = 45.0
    
    static let LabelXOrigin: CGFloat = Dimensions.XInset + Dimensions.LogoWidth + Dimensions.XSeparation
    
    static let TopYOrigin: CGFloat = Dimensions.YInset
    static let MidYOrigin: CGFloat = Dimensions.YInset + Dimensions.TopElementHeight
    static let BottomYOrigin: CGFloat = Dimensions.YInset + Dimensions.TopElementHeight + Dimensions.MidElementHeight
  }
  

  var dealID: Int? {
    didSet {
      if let deal = client.getDealByIndex(dealID!) {
        let logoImage = client.getLogoForVenue(deal.businessID, bType: deal.bType, encodedLogoOptional: deal.logo)!
        let imageFrame = CGRectMake(0, 0, Dimensions.LogoWidth, Dimensions.LogoHeight)
        logo.image = logoImage.resizeAndFrame(imageFrame, frameColor: Constants.Colours.White, borderWidth: 1.0, cornerRadius: 1.0)
        topLabel.text = client.fullDealLabel(dealID!)
        midLabel.text = deal.bName
        bottomLabel.text = deal.address
        // topAnnotation
        // midAnnotation
        bottomAnnotation.text = "1.8 km"
        // background.backgroundColor = 
        // background.alpha =
      }
    }
  }
  
  var venueID: Int? {
    didSet {
      if let venue = client.getVenueByIndex(venueID!) {
        let logoImage = client.getLogoForVenue(venueID!, bType: venue.bType, encodedLogoOptional: venue.logo)!
        let imageFrame = CGRectMake(0, 0, Dimensions.LogoWidth, Dimensions.LogoHeight)
        logo.image = logoImage.resizeAndFrame(imageFrame, frameColor: Constants.Colours.White, borderWidth: 1.0, cornerRadius: 1.0)
        topLabel.text = venue.bName
        midLabel.text = client.fullVenueDescription(venueID!, joiner: ", ")
        bottomLabel.text = venue.address
//        topAnnotation.image = getTopAnnotationImage(venue)
//        midAnnotation.image = getMidAnnotationImage(venue)
        bottomAnnotation.text = "1.8 km"
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Adjust frames of each imageview and label accordingly
    // For labels, adjust font style, size and color
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
  
  // NB: Can have different type of cell separation as shown at:
  // http://stackoverflow.com/questions/28999400/swift-uitableview-custom-cell-programatically-documentation
  
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = UIColor.clearColor()
    
    background = UIView(frame: CGRectZero)
    logo = UIImageView(frame: CGRectZero)
    topLabel = UILabel(frame: CGRectZero)
    midLabel = UILabel(frame: CGRectZero)
    bottomLabel = UILabel(frame: CGRectZero)
    topAnnotation = UIImageView(frame: CGRectZero)
    midAnnotation = UIImageView(frame: CGRectZero)
    bottomAnnotation = UILabel(frame: CGRectZero)
    
    background.alpha = 0.0
    
    topLabel.textAlignment = .Left
    topLabel.font = Constants.Fonts.Bold
    topLabel.textColor = Constants.Colours.Cyan
    
    midLabel.textAlignment = .Left
    midLabel.font = Constants.Fonts.Light
    midLabel.textColor = Constants.Colours.White
    
//    midLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
//    midLabel.numberOfLines = 0 // '0' means infinite number of lines
    
    bottomLabel.textAlignment = .Left
    bottomLabel.font = Constants.Fonts.LightItalic
    bottomLabel.textColor = Constants.Colours.White
    
    bottomAnnotation.textAlignment = .Right
    bottomAnnotation.font = Constants.Fonts.LightItalic
    bottomAnnotation.textColor = Constants.Colours.White
    
    contentView.addSubview(background)
    contentView.addSubview(logo)
    contentView.addSubview(topLabel)
    contentView.addSubview(midLabel)
    contentView.addSubview(bottomLabel)
    contentView.addSubview(topAnnotation)
    contentView.addSubview(midAnnotation)
    contentView.addSubview(bottomAnnotation)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let TopLabelWidth = frame.width - (2 * Dimensions.XInset) - (2 * Dimensions.XSeparation) - Dimensions.LogoWidth - Dimensions.TopAnnotationWidth
    let MidLabelWidth = frame.width - (2 * Dimensions.XInset) - (2 * Dimensions.XSeparation) - Dimensions.LogoWidth - Dimensions.MidAnnotationWidth
    let BottomLabelWidth = frame.width - (2 * Dimensions.XInset) - (2 * Dimensions.XSeparation) - Dimensions.LogoWidth - Dimensions.BottomAnnotationWidth
    
    let TopAnnotationXOrigin: CGFloat = Dimensions.XInset + Dimensions.LogoWidth + (2 * Dimensions.XSeparation) + TopLabelWidth
    let MidAnnotationXOrigin: CGFloat = Dimensions.XInset + Dimensions.LogoWidth + (2 * Dimensions.XSeparation) + MidLabelWidth
    let BottomAnnotationXOrigin: CGFloat = Dimensions.XInset + Dimensions.LogoWidth + (2 * Dimensions.XSeparation) + BottomLabelWidth
    
    logo.frame = CGRectMake(Dimensions.XInset, Dimensions.YInset, Dimensions.LogoWidth, Dimensions.LogoHeight)
    topLabel.frame = CGRectMake(Dimensions.LabelXOrigin, Dimensions.TopYOrigin, TopLabelWidth, Dimensions.TopElementHeight)
    midLabel.frame = CGRectMake(Dimensions.LabelXOrigin, Dimensions.MidYOrigin, MidLabelWidth, Dimensions.MidElementHeight)
    bottomLabel.frame = CGRectMake(Dimensions.LabelXOrigin, Dimensions.BottomYOrigin, BottomLabelWidth, Dimensions.BottomElementHeight)
    
    topAnnotation.frame = CGRectMake(TopAnnotationXOrigin, Dimensions.TopYOrigin, Dimensions.TopAnnotationWidth, Dimensions.TopElementHeight)
    midAnnotation.frame = CGRectMake(MidAnnotationXOrigin, Dimensions.MidYOrigin, Dimensions.MidAnnotationWidth, Dimensions.MidElementHeight)
    bottomAnnotation.frame = CGRectMake(BottomAnnotationXOrigin, Dimensions.BottomYOrigin, Dimensions.BottomAnnotationWidth, Dimensions.BottomElementHeight)
  }
  
  private func getTopAnnotationImage(venue: Venue) -> UIImage
  {
    let image = UIImage(named: "DrinkIcon")!.tint(Constants.Colours.White)
    let text = "\(venue.numDrinkDeals)"
    let textFont: UIFont = UIFont(name: "HelveticaNeue", size: 16)!
    let textAttributes = [NSFontAttributeName: textFont,
                          NSForegroundColorAttributeName: Constants.Colours.Cyan]
    
    let aspectWidth: CGFloat = (Dimensions.TopAnnotationWidth * (2/3)) / image.size.width;
    let aspectHeight: CGFloat = Dimensions.TopElementHeight / image.size.height;
    let aspectRatio: CGFloat = min(aspectWidth, aspectHeight)
    
    let iconSize = CGRectMake(0, 0, image.size.width * aspectRatio, image.size.height * aspectRatio)
    let frameSize: CGSize = CGSizeMake(Dimensions.TopAnnotationWidth, Dimensions.TopElementHeight)

    // Set up the new image context.
    UIGraphicsBeginImageContext(CGSize(width: frameSize.width, height: frameSize.height))
    
    text.drawInRect(CGRectMake(3, 3, frameSize.width, frameSize.height), withAttributes: textAttributes)
    image.drawInRect(CGRectMake(frameSize.width * (1/3), 0, iconSize.width, iconSize.height))
    
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    // Finished creating combination image.
    
    return newImage.addFrame(Constants.Colours.White, borderWidth: 1.0, cornerRadius: 1.0)

  }
  
  private func getMidAnnotationImage(venue: Venue) -> UIImage
  {
    let image = UIImage(named: "FoodIcon")!.tint(Constants.Colours.White)
    let text = "\(venue.numFoodDeals)"
    let textFont: UIFont = UIFont(name: "HelveticaNeue", size: 16)!
    let textAttributes = [NSFontAttributeName: textFont,
      NSForegroundColorAttributeName: Constants.Colours.Cyan]
    
    let aspectWidth: CGFloat = (Dimensions.MidAnnotationWidth * (2/3)) / image.size.width;
    let aspectHeight: CGFloat = Dimensions.MidElementHeight / image.size.height;
    let aspectRatio: CGFloat = min(aspectWidth, aspectHeight)
    
    let iconSize = CGRectMake(0, 0, image.size.width * aspectRatio, image.size.height * aspectRatio)
    let frameSize: CGSize = CGSizeMake(Dimensions.MidAnnotationWidth, Dimensions.MidElementHeight)
    
    // Set up the new image context.
    UIGraphicsBeginImageContext(CGSize(width: frameSize.width, height: frameSize.height))
    
    text.drawInRect(CGRectMake(3, 3, frameSize.width, frameSize.height), withAttributes: textAttributes)
    image.drawInRect(CGRectMake(frameSize.width * (1/3), 0, iconSize.width, iconSize.height))
    
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    // Finished creating combination image.
    
    return newImage.addFrame(Constants.Colours.White, borderWidth: 1.0, cornerRadius: 1.0)
  }
  


}

