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
    var stations: [AnyObject]?
    var mainView: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.isHidden = true
        spinner.isHidden = true
        searchBar.becomeFirstResponder()
        stations = [AnyObject]()
        
        API.sharedInstance().downloadListOfStations { (success, stationNames, error) in
            self.stations = stationNames
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
        
        cell.stationName.text = stations?[indexPath.row] as! String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TableView tapped")
        mainView?.firstStationButton.titleLabel?.text = stations?[indexPath.row] as! String
        view.endEditing(true)
        dismiss(animated: true) {
            print("Picker closed")
        }
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




