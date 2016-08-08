//
//  UIImageView+Extensions.swift
//  QuizApp
//
//  Created by ITK developer User on 27.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {	[unowned self] in
            self.loadImageFromCache(urlString)
        }
    }
    
    private func loadImageFromCache(urlString: String) {
        
        if let imageName = getImageNameFromUrl(urlString) {
            guard loadImageFromLocalDir(imageName) != nil else {
                return loadImageFromUrlAndSave(urlString, imageName: imageName)
            }
        } else {
            
        }
    }
    
    private func getImageNameFromUrl(urlString: String) -> String? {
        let imageName = urlString.componentsSeparatedByString("/").joinWithSeparator("-")
        
        if imageName.isEmpty {
            return nil
        }

        return imageName
    }
    
    private func loadImageFromLocalDir(imageName: String) -> UIImage? {
        let imagePath: String = imageInDocumentsDirectory(imageName)
        let image: UIImage? = UIImage(contentsOfFile: imagePath)
        self.setImage(image)
        
        return image
    }
    
    private func loadImageFromUrlAndSave(urlString: String, imageName: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data)
                    self.setImage(image)
                    let imagePathToSave: String = self.imageInDocumentsDirectory(imageName)
                    self.saveImage(image!, path: imagePathToSave)
                }
            }
        }
    }
    
    private func imageInDocumentsDirectory(imageName: String) -> String {
        let imageURL = getDocumentsURL().URLByAppendingPathComponent(imageName)
        return imageURL.path!
    }
    
    private func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    private func saveImage(image: UIImage, path: String) {
        let pngImageData = UIImagePNGRepresentation(image)
        pngImageData!.writeToFile(path, atomically: true)
    }
    
    private func setImage(image: UIImage?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let image = image {
                self.image = image
            }
        })
    }
}