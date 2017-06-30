//
//  PickerViewController.swift
//  Rozklad
//
//  Created by Michał Tubis on 28.06.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import UIKit
import CoreData

class PickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var searchString: String?
    var api: API?
    var stations: [Station]?
    var filteredData: [Station]?
    var mainView: MainViewController?
    var stationIsFirst: Bool?
    
    // MARK: - Core Data
    
    lazy var sharedContext: NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    func fetchAllStations() -> [Station] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        
        do {
            return try sharedContext.fetch(fetchRequest) as! [Station]
        } catch  let error as NSError {
            print("Error in fetchAllQuizzes(): \(error)")
            return [Station]()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.isHidden = true
//        spinner.isHidden = true
        spinner.startAnimating()
        searchBar.becomeFirstResponder()
        stations = [Station]()
        filteredData = [Station]()
        
        var timeInterval = Int()
        let date = Date()

        if let timeStamp = UserDefaults.standard.value(forKey: "timestamp") as? Date {
            timeInterval = timeStamp.secondsBetweenDate(toDate: date)
        }
        
        if timeInterval > 86400 || timeInterval == 0 {
            API.sharedInstance().downloadListOfStations { (success, stations, error) in
                self.stations?.removeAll()
                self.stations = stations.sorted(by: {$0.name < $1.name })
                DispatchQueue.main.async(execute: {
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                });
            }
        } else {
            stations?.removeAll()
            stations = fetchAllStations().sorted(by: {$0.name < $1.name })
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: TableView delegate

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != "" {
            return (filteredData?.count)!
        }
        return (stations?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "StationCell", bundle: nil), forCellReuseIdentifier: "StationCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationCell
        
        let station: Station
        if searchBar.text != "" {
            station = (filteredData?[indexPath.row])!
        } else {
            station = (stations?[indexPath.row])!
        }
        
        cell.stationName.text = station.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let station: Station
        if searchBar.text != "" {
            station = (filteredData?[indexPath.row])!
        } else {
            station = (stations?[indexPath.row])!
        }
        
        if stationIsFirst == true {
            mainView?.firstStation = station
            mainView?.firstStationTextField.text = station.name
        } else {
            mainView?.lastStation = station
            mainView?.lastStationTextField.text = station.name
        }

        view.endEditing(true)
        dismiss(animated: true) {}
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: SearchBar delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button clicked")
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let scope: String = "All"
        filteredData = stations?.filter({(station : Station) -> Bool in
            let categoryMatch = (scope == "All") || (station.name == scope)
            return categoryMatch && station.name.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
    func search(_: String) {
//        tableView.isHidden = false

    }
}

extension Date {
    func secondsBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.second], from: self, to: toDate)
        return components.second ?? 0
    }
}



