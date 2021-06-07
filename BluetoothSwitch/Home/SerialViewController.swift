//
//  ViewController.swift
//  BluetoothSwitch
//
//  Created by JHT on 19/05/2021.
//

import UIKit

class SerialViewController: UIViewController, BluetoothSerialDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        // BluetoothSerial.swift 파일에 있는 Bluetooth Serial인 serial을 초기화합니다.
        serial = BluetoothSerial.init()
    }
    
    /// scan 버튼이 클릭되면 호출되는 메서드입니다.
    @IBAction func scanButton(_ sender: Any) {
        // 세그웨이를 호출하여 Scan 뷰를 로드합니다.
        performSegue(withIdentifier: "ScanViewController", sender: nil)
    }
    
    /// 주변기기에 데이터를 전송합니다.
    @IBAction func onButton(_ sender: Any) {
        if !serial.bluetoothIsReady {
            print("시리얼이 준비되지 않음")
            return
        }
        serial.delegate = self
        let msg = "1"
        serial.sendMessageToDevice(msg)
    }
}

