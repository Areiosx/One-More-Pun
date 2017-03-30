//
//  UIImage.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 3/30/17.
//  Copyright © 2017 Areios. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func getImageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    static func textToImage(_ drawText: NSString, inImage: UIImage, atPoint: CGPoint) -> UIImage {
        guard let font = UIFont(name: "CoolveticaRg-Regular", size: 100) else { return UIImage() }
        let textColor: UIColor = UIColor.white
        UIGraphicsBeginImageContext(inImage.size)
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: textColor,
            ]
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        let rect: CGRect = CGRect(x: atPoint.x, y: atPoint.y, width: inImage.size.width, height: inImage.size.height)
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
