//
//  PickerViewController.swift
//  Rozklad
//
//  Created by Michał Tubis on 28.06.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var searchString: String?
    var api: API?
    var stations: [Station]?
    var mainView: MainViewController?
    var stationIsFirst: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.isHidden = true
        spinner.isHidden = true
        searchBar.becomeFirstResponder()
        stations = [Station]()
        
        API.sharedInstance().downloadListOfStations { (success, stations, error) in
            self.stations = stations
            self.tableView.reloadData()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: TableView delegate

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (stations?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "StationCell", bundle: nil), forCellReuseIdentifier: "StationCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationCell
        
        let station = stations?[indexPath.row]
        cell.stationName.text = station?.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let station = stations?[indexPath.row]
        
        if stationIsFirst == true {
            mainView?.firstStation = station
            mainView?.firstStationButton.titleLabel?.text = station?.name
        } else {
            mainView?.lastStation = station
            mainView?.lastStationButton.titleLabel?.text = station?.name
        }
        print(station?.name)

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
        print(searchText)
        searchString = searchText
        tableView.reloadData()
        search(searchText)
    }
    
    func search(_: String) {
//        tableView.isHidden = false

    }
}




