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
    
    @IBOutlet weak var serialMessageLabel: UILabel!
    
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
        // 시리얼의 delegate를 SerialViewController로 설정합니다.
        serial.delegate = self
        // msg를 설정하고 이를 연결된 Peripheral에 전송하는 메서드를 호출합니다.
        let msg = "1"
        serial.sendMessageToDevice(msg)
        // 라벨의 텍스트를 변경하여 데이터를 기다리는 중이라는 것을 표현합니다.
        serialMessageLabel.text = "waiting for Peripheral's messege"
    }
    
    //MARK: 시리얼에서 호출되는 Delegate 함수들
    
    /// 데이터가 전송된 후 Peripheral로 부터 응답이 오면 호출되는 메서드입니다.
    func serialDidReceiveMessage(message : String)
    {
        // 응답으로 온 메시지를 라벨에 표시합니다. 
        serialMessageLabel.text = message
    }
}

