//
//  ScanViewController.swift
//  BluetoothSwitch
//
//  Created by JHT on 19/05/2021.
//

import UIKit
import CoreBluetooth

class ScanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BluetoothSerialDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    
    var peripheralList : [(peripheral : CBPeripheral, RSSI : Float)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peripheralList = []
        serial.delegate = self
        serial.startScan()
    }
    
    //MARK: 테이블 뷰 데이터 소스
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 몇 개의 셀을 보여주나요?
        return peripheralList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 어떻게 셀을 표현하나요?
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScanTableViewCell", for: indexPath) as? ScanTableViewCell else {
            return UITableViewCell()
        }
        let peripheralName = peripheralList[indexPath.row].peripheral.name
        cell.updatePeriralsName(name: peripheralName)
        return cell
    }
    
    //MARK: 테이블 뷰 델리게이트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀을 클릭하면 어떻게 되나요?
        
        // 테이블 뷰의 셀을 선택했을 때 UI에 나타나는 효과
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 선택된 Pheripheral을 연결하기
        serial.stopScan()
        let selectedPeripheral = peripheralList[indexPath.row].peripheral
        serial.connectToPeripheral(selectedPeripheral)
    }
    
    
    //MARK: 시리얼에서 호출되는 함수들
    func serialDidDiscoverPeripheral(peripheral : CBPeripheral, RSSI : NSNumber?)
    {
        for existing in peripheralList {
            if existing.peripheral.identifier == peripheral.identifier {return}
        }
        let fRSSI = RSSI?.floatValue ?? 0.0
        peripheralList.append((peripheral : peripheral , RSSI : fRSSI))
        peripheralList.sort { $0.RSSI < $1.RSSI}
        tableView.reloadData()
    }
}
