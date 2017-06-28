//
//  API.swift
//  Rozklad
//
//  Created by Michał Tubis on 28.06.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import UIKit

class API: NSObject {

    var session: URLSession
    var stations = [AnyObject]()
    
    override init() {
        session = URLSession.shared
        super.init()
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> API {
        struct Singleton {
            static var sharedInstance = API()
        }
        return Singleton.sharedInstance
    }
    
    func downloadListOfStations(completionHandler: @escaping (_ success: Bool, _ stations: [AnyObject], _ errorString: String?) -> Void) {
        
        let urlString = "https://koleo.pl/api/android/v1/stations.json"
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard (error == nil) else {
                print("Connection Error")
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            let parsedResponse = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            
//            self.stations = parsedResponse as! [AnyObject]
//            print(self.stations)
            
            guard let items = parsedResponse as? [[String:Any]] else {
                print("Cannot find keys 'items' in parsedResponse")
                return
            }
            
//            print(items)
            
            var stations = [AnyObject]()
            
            for item in items {
//                print(item["name"])
                stations.append(item["name"] as AnyObject)
            }
            print(stations)
            completionHandler(true, stations, nil)
        }
        task.resume()
    }
    
}
