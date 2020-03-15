//
//  Meal.swift
//  DemoAppBeenLoveMemoryLite
//
//  Created by dohien on 28/08/2018.
//  Copyright © 2018 dohien. All rights reserved.
//

import UIKit
import os.log
class Meal : NSObject ,NSCoding  {
    var header: String
    var detail: String
    var photo: UIImage?
    var rating: Int
    init?(header: String, detail: String, photo: UIImage? , rating: Int) {
        // String name must have a value
        guard !header.isEmpty else {
            return nil
        }
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        self.header = header
        self.detail = detail
        self.photo = photo
        self.rating = rating
        /*if name.isEmpty || rating < 0 {
            return nil
        }*/
    }
    struct PropertyKey {
        static let header = "name"
        static let detail = "detail"
        static let photo = "photo"
        static let rating = "rating"
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(header, forKey: PropertyKey.header)
        aCoder.encode(detail, forKey:PropertyKey.detail)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        guard let header = aDecoder.decodeObject(forKey: PropertyKey.header) as? String else {
            os_log("Unable to decode the header for object.", log: OSLog.default,type: .debug)
            return nil
        }
        
        var detail = aDecoder.decodeObject(forKey: PropertyKey.detail)
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        if detail == nil {
            detail = ""
        }
        self.init(header: header, detail: detail as! String, photo: photo, rating: rating)
    }
    // Storing path
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
}
