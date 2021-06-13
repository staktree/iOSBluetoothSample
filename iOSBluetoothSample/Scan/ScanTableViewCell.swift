//
//  ScanTableViewCell.swift
//  BluetoothSwitch
//
//  Created by JHT on 19/05/2021.
//

import UIKit

class ScanTableViewCell: UITableViewCell {

    // Peripheral의 이름을 표시할 Label입니다. ScanViewController뷰의 셀 내의 Label과 연결합니다.
    @IBOutlet weak var peripheralName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// peripheral의 이름을 파라미터로 입력받아 Cell을 update합니다.
    func updatePeriphralsName(name : String?)
    {
        guard name != nil else { return }
        peripheralName.text = name
    }
}
