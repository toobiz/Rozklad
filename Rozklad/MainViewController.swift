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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapFirstStation(_ sender: Any) {
        let pickerView = PickerViewController()
        
//        navigationController?.pushViewController(pickerView, animated: true)
        present(pickerView, animated: true) {
            
        }
    }
    
    @IBAction func didTapLastStation(_ sender: Any) {
        
    }
    
    
}

