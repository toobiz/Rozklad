//
//  MainViewController.swift
//  Rozklad
//
//  Created by Michał Tubis on 28.06.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var firstStationButton: UIButton!
    @IBOutlet weak var lastStationButton: UIButton!
    
    var firstStation: Station?
    var lastStation: Station?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapFirstStation(_ sender: Any) {
        showPickerViewForStation(isFirst: true)
    }
    
    @IBAction func didTapLastStation(_ sender: Any) {
        showPickerViewForStation(isFirst: false)
    }
    
    func showPickerViewForStation(isFirst: Bool) {
        let pickerView = PickerViewController()
        pickerView.mainView = self
        pickerView.stationIsFirst = isFirst
        present(pickerView, animated: true) {}
    }
    
}

