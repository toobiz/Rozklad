//
//  MainViewController.swift
//  Rozklad
//
//  Created by Michał Tubis on 28.06.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var firstStationTextField: UITextField!
    @IBOutlet weak var lastStationTextField: UITextField!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var firstStation: Station?
    var lastStation: Station?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if ((firstStation?.latitude) != nil) && ((firstStation?.longitude) != nil) && ((lastStation?.latitude) != nil) && lastStation?.longitude != nil {
            
            let firstStationCoordinate = CLLocation(latitude: (firstStation?.latitude)!, longitude: (firstStation?.longitude)!)
            let lastStationCoordinate = CLLocation(latitude: (lastStation?.latitude)!, longitude: (lastStation?.longitude)!)
            
            let distance = lastStationCoordinate.distance(from: firstStationCoordinate) / 1000
            distanceLabel.text = String(Int(distance)) + " km"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPickerViewForStation(isFirst: Bool) {
        let pickerView = PickerViewController()
        pickerView.mainView = self
        pickerView.stationIsFirst = isFirst
        present(pickerView, animated: true) {}
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == firstStationTextField {
            showPickerViewForStation(isFirst: true)
        } else {
            showPickerViewForStation(isFirst: false)
        }
        return false
    }
}

