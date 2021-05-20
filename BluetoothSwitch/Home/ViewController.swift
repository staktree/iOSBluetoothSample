//
//  ViewController.swift
//  BluetoothSwitch
//
//  Created by JHT on 19/05/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        serial = BluetoothSerial.init()
    }
    
    @IBAction func scanButton(_ sender: Any) {
        performSegue(withIdentifier: "ScanViewController", sender: nil)
    }
}

