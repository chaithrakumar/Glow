//
//  NetworkManager.swift
//  DoorDash
//
//  Created by chaithra Kumar on 12/31/16.
//  Copyright  All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON


class NetworkManager: NSObject {
    static let sharedInstance = NetworkManager()
    internal typealias CallBackBlock = (_ responseDataArray  : [JSON], _ error : NSError?) -> Void //defining uniform response block 
    
    // Function to get list of assets bases on  search String
    
    func getAssetsBySearchString(_ CallBackBlockObject:@escaping CallBackBlock,searchString : String)
    {
        let reqURl = "\(BASE_URL)/\(searchString)"
        

        print(reqURl)
            Alamofire.request(reqURl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!).responseJSON { response in
                //Cache resonse for offline usage
//                let cachedURLResponse = CachedURLResponse(response: response.response!, data: (response.data! as NSData) as Data, userInfo: nil, storagePolicy: .allowed)
//                URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
                    print("error fetching data from url")
                    print(response.result.error!)
                    return
                    
                }
                print(response)
                //Ideally these should be parsed in to list of custom model objects forex: subclass of NSmanagedObject Subclass
                
                let json = JSON(data: response.data!)
                
              //  let dataDictionary = json.dictionary
               // print(dataDictionary?["data"])
                
                let dataArray = json["data"]
                print(dataArray)
                
                if dataArray.count == 0  {
                    print("0 Results")
                   let error = NSError(domain: "No results", code: 0, userInfo: nil)
                     CallBackBlockObject([],error)
                    return
                }
                
                CallBackBlockObject([dataArray],nil)
        }
      
      
    }
    
    //Get Menu categories
    
    
    func getMenuDetails(_ CallBackBlockObject:@escaping CallBackBlock,menuID : String)
    {
        
        let reqURl = "\(BASE_URL)\(MENU_DETAILS)\(menuID)/menu/"
        Alamofire.request(reqURl).responseJSON {response in
            //Cache resonse for offline usage
            let cachedURLResponse = CachedURLResponse(response: response.response!, data: (response.data! as NSData) as Data, userInfo: nil, storagePolicy: .allowed)
            URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
            guard response.result.error == nil else {
                return
                
            }
            //Ideally these should be parsed in to list of custom model objects forex: subclass of NSmanagedObject Subclass
            
            let json = JSON(data: cachedURLResponse.data)
            let responseDictionary = json.array
            
            CallBackBlockObject(responseDictionary!,nil)
        }
        
        
    }
    
    func userLogin(_ CallBackBlockObject:@escaping CallBackBlock,username : String, password : String)
    {
        
        let reqURl = "\(BASE_URL)\(LOGIN_URL)"
        //Alamofire.request("https://httpbin.org/post", method: .post)
        
        let parameters = ["email" : "chaithra8414@gmail.com","password":"tendulkar"]
        
        
        
        
        Alamofire.request(reqURl, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
            //Cache resonse for offline usage
            let cachedURLResponse = CachedURLResponse(response: response.response!, data: (response.data! as NSData) as Data, userInfo: nil, storagePolicy: .allowed)
            URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
            guard response.result.error == nil else {
                return
                
            }
            //Ideally these should be parsed in to list of custom model objects forex: subclass of NSmanagedObject Subclass
            
            let json = JSON(data: cachedURLResponse.data)
            print(json)
            
            
            //let responseDictionary = json.array
            let tokenDict = json.dictionary?["token"]
            print(tokenDict ?? 0)
            
            CallBackBlockObject([tokenDict!],nil)
        }
        
    }
    
    
    func authenticate(_ CallBackBlockObject:@escaping CallBackBlock,tokenstring : String)
    {
        
        let reqURl = "\(BASE_URL)\(TOKEN_REFRESH)"
        //Alamofire.request("https://httpbin.org/post", method: .post)
        
        let parameters = ["token" : tokenstring]
        
        Alamofire.request(reqURl, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response in
            //Cache resonse for offline usage
            let cachedURLResponse = CachedURLResponse(response: response.response!, data: (response.data! as NSData) as Data, userInfo: nil, storagePolicy: .allowed)
            URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
            guard response.result.error == nil else {
                return
                
            }
            //Ideally these should be parsed in to list of custom model objects forex: subclass of NSmanagedObject Subclass
            
            let json = JSON(data: cachedURLResponse.data)
            print(json)
            
            //let responseDictionary = json.array
            let tokenDict = json.dictionary?["token"]
            print(tokenDict ?? 0)
            
            CallBackBlockObject([tokenDict!],nil)
        }
        
    }
    
    
    
    func setUpTokenLife (token: String)
    {
        //keychain 
        //start a timer
        
    }
    
    func timeToRefreshToken() {
        // get the token 
        // refresh it
        
    }
    
    

    
    func getCustomerData(_ CallBackBlockObject:@escaping CallBackBlock,tokenId : String)
    {
        
        let headers = [
            "Authorization": "JWT \(tokenId)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
       
        let reqURl = "\(BASE_URL)\(USER_DETAILS)"
        Alamofire.request(reqURl, headers: headers).responseJSON {response in
            //Cache resonse for offline usage
            let cachedURLResponse = CachedURLResponse(response: response.response!, data: (response.data! as NSData) as Data, userInfo: nil, storagePolicy: .allowed)
            URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
            guard response.result.error == nil else {
                return
            }
            //Ideally these should be parsed in to list of custom model objects forex: subclass of NSmanagedObject Subclass
            let json = JSON(data: cachedURLResponse.data)
            let responseDictionary = json.array
            print(json)
            CallBackBlockObject(responseDictionary!,nil)
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
}
