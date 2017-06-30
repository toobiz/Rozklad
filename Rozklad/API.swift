//
//  API.swift
//  Rozklad
//
//  Created by Michał Tubis on 28.06.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import UIKit
import CoreData

class API: NSObject {

    var session: URLSession
    var stations = [Station]()
    
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
    
    // MARK: - Core Data
    
    lazy var sharedContext: NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()

    
    func downloadListOfStations(completionHandler: @escaping (_ success: Bool, _ stations: [Station], _ errorString: String?) -> Void) {
        
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
            
            guard let items = parsedResponse as? [[String:Any]] else {
                print("Cannot find keys 'items' in parsedResponse")
                return
            }
            
            self.stations.removeAll()
            
            for item in items {
                
                var idToAdd = NSNumber()
                var nameToAdd = String()
                var nameSlugToAdd = String()
                var latitudeToAdd = Double()
                var longitudeToAdd = Double()
                var hitsToAdd = NSNumber()
                var ibnrToAdd = NSNumber()
                
                if let id = item["id"] as? NSNumber {
                    idToAdd = id
                }
                
                if let name = item["name"] as? String {
                    nameToAdd = name
                }
                
                if let name_slug = item["name_slug"] as? String {
                    nameSlugToAdd = name_slug
                }
                
                if let latitude = item["latitude"] as? Double {
                    latitudeToAdd = latitude
                }
                
                if let longitude = item["longitude"] as? Double {
                    longitudeToAdd = longitude
                }
                
                if let hits = item["hits"] as? NSNumber {
                    hitsToAdd = hits
                }
                
                if let ibnr = item["ibnr"] as? NSNumber {
                    ibnrToAdd = ibnr
                }
                
                let stationDict: [String: AnyObject] = [
                    "id" : idToAdd as AnyObject,
                    "name" : nameToAdd as AnyObject,
                    "name_slug" : nameSlugToAdd as AnyObject,
                    "latitude" : latitudeToAdd as AnyObject,
                    "longitude" : longitudeToAdd as AnyObject,
                    "hits" : hitsToAdd as AnyObject,
                    "ibnr" : ibnrToAdd as AnyObject
                ]
                
                let stationToAdd = Station(dictionary: stationDict, context: self.sharedContext)
                self.stations.append(stationToAdd)
            }
            CoreDataStackManager.sharedInstance().saveContext()
            
            let date = Date()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let dateString = dateFormatter.string(from:date)
            
            UserDefaults.standard.setValue(date, forKey: "timestamp")
            completionHandler(true, self.stations, nil)
        }
        task.resume()
    }
    
}
