//
//  ImageCache.swift
//  Life Goals
//
//  Created by Hieu Vo on 2/24/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit

class ImageCache {
    fileprivate var inMemoryCache = NSCache<AnyObject, AnyObject>()
    
    class func sharedInstance() -> ImageCache{
        struct Static {
            static let instance = ImageCache()
        }
        return Static.instance
    }
    
    func pathForIdentifier(_ identifier : String) -> String {
        let directoryURL : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fullURL = directoryURL.appendingPathComponent(identifier)
        return fullURL.path
    }
    
    //get Image
    func getImageWithIdentifier(_ identifier : String?) ->UIImage? {
        if (identifier == nil) || (identifier == "") {
            return nil
        }
        
        let path = pathForIdentifier(identifier!)
        //get image from cache
        if let image = inMemoryCache.object(forKey: path as AnyObject) as? UIImage {
            return image
        }
        //get image from hard disk
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path)){
            return UIImage(data: data)
        }
        return nil
    }
    
    func storeImage(_ image : UIImage?, withIdentifier identifier:String){
        let path = pathForIdentifier(identifier)
        
        if image == nil {
            // remove from cache 
            inMemoryCache.removeObject(forKey: path as AnyObject)
            //remove from hard disk
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch{
                print(error)
                return
            }
        }
        // save image to cache
        inMemoryCache.setObject(image!, forKey: path as AnyObject)
        //save image to hard disk
        let data = UIImagePNGRepresentation(image!)!
        try? data.write(to: URL(fileURLWithPath :path) , options: [.atomic])
    }
    
    func setImageRetunPath(image : UIImage?, date : Date) -> String? {
        guard let image = image else {
            return nil
        }
        let calendar = Calendar.current
        let compoments = (calendar as NSCalendar).components([.year,.month,.day,.hour,.minute,.second], from: date)
        let nameFile = "\(compoments.year!)\(compoments.month!)\(compoments.day!)\(compoments.hour!)\(compoments.minute!)\(compoments.second!)"
        let identifier = "\(nameFile).jpg"       
        storeImage(image, withIdentifier: identifier)
        return identifier

    }
}
