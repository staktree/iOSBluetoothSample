//
//  ScanTableViewCell.swift
//  BluetoothSwitch
//
//  Created by JHT on 19/05/2021.
//

import UIKit

class ScanTableViewCell: UITableViewCell {

    @IBOutlet weak var peripheralName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updatePeriralsName(name : String?)
    {
        guard name != nil else { return }
        peripheralName.text = name
    }
}
