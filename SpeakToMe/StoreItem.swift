//
//  StoreItem.swift
//  DoorDash
//
//  Created by Chaithra Kumar on 1/2/17.
//  Copyright © 2017 DoorDash. All rights reserved.
//

import UIKit
import  SwiftyJSON

class Asset: NSObject, NSCoding {
    
    
//    title: "Heat",
//    year: "1981",
//    glowpoints: "100",
//    type: "movie",
//    genre: "Crime",
//    id: "46",
//    active: "1",
//    services: "Crunchyroll"
    
    var title : String?
    var year : String?
    var glowpoints : String?
    var type : String?
    var genre : String?
    var services : String?
    
    init(_ storeObject : JSON) {
        
        if let storeID = storeObject["title"].string {
            self.title = "\(storeID)"
        }
        if let storeName = storeObject["year"].string {
            self.year = storeName
        }
        if let storeTypeString = storeObject["glowpoints"].string {
            self.glowpoints = storeTypeString
        }
        if let deliverycharges = storeObject["type"].string{
            self.type = "\(deliverycharges)"
        }
        if let timetodeliver = storeObject["genre"].string {
            self.genre = "\(timetodeliver)"
        }
        
        if let coverImageUrlString = storeObject["services"].string {
            self.services = coverImageUrlString
        }
        
        
    }
    
    
    init( title : String  , year : String, glowpoints: String, type : String, genre : String, services : String) {
            self.title = title
            self.year = year
            self.glowpoints = glowpoints
            self.type = type
            self.genre = genre
            self.services = services
        
        
    }
    required convenience init(coder aDecoder: NSCoder) {
        let title  = aDecoder.decodeObject(forKey: "title") as! String
        let year  = aDecoder.decodeObject(forKey: "year") as! String
        let glowpoints  = aDecoder.decodeObject(forKey: "glowpoints") as! String
        let type  = aDecoder.decodeObject(forKey: "type") as! String
        let genre  = aDecoder.decodeObject(forKey: "genre") as! String
        let services  = aDecoder.decodeObject(forKey: "services") as! String
        
        //self.init(
        self.init( title : title  , year : year, glowpoints: glowpoints, type : type, genre : genre, services : services)
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(year, forKey: "year")
        aCoder.encode(glowpoints, forKey: "glowpoints")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(genre, forKey: "genre")
        aCoder.encode(services, forKey: "services")
    }

}
