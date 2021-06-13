//
//  ScanViewController.swift
//  BluetoothSwitch
//
//  Created by JHT on 19/05/2021.
//

import UIKit
import CoreBluetooth

class ScanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BluetoothSerialDelegate {
   
    // 검색된 기기들을 나타내는 TableView입니다.
    @IBOutlet weak var tableView: UITableView!
    
    // 현재 검색된 peripheralList입니다.
    var peripheralList : [(peripheral : CBPeripheral, RSSI : Float)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // scan 버튼을 눌러 기기 검색을 시작할 때마다 list를 초기화합니다.
        peripheralList = []
        // serial의 delegate를 ScanViewController로 설정합니다. serial에서 delegate의 메서드를 호출하면 이 클래스에서 정의된 메서드가 호출됩니다.
        serial.delegate = self
        // 뷰가 로드된 후 검색을 시작합니다.
        serial.startScan()
    }
    
    //MARK: 테이블 뷰 데이터 소스
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 몇 개의 셀을 보여줄 지 결정합니다. peripheralList의 개수만큼 셀을 보여줍니다.
        return peripheralList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀을 어떻게 표현할지 결정합니다.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScanTableViewCell", for: indexPath) as? ScanTableViewCell else {
            return UITableViewCell()
        }
        // peripheral의 이름을 cell에 나타나도록 합니다.
        let peripheralName = peripheralList[indexPath.row].peripheral.name
        cell.updatePeriphralsName(name: peripheralName)
        
        return cell
    }
    
    //MARK: 테이블 뷰 델리게이트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀을 클릭했을 때의 처리를 담당합니다.
        
        // 테이블 뷰의 셀을 선택했을 때 UI에 나타나는 효과입니다.
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 선택된 Pheripheral을 연결합니다. 검색을 중단하고, peripheralList에 저장된 peripheral 중 클릭된 것을 찾아 연결합니다.
        serial.stopScan()
        let selectedPeripheral = peripheralList[indexPath.row].peripheral
        // serial의 connectToPeripheral 함수에 선택된 peripheral을 연결하도록 요청합니다.
        serial.connectToPeripheral(selectedPeripheral)
    }
    
    //MARK: 시리얼에서 호출되는 딜리게이트 함수들
    func serialDidDiscoverPeripheral(peripheral : CBPeripheral, RSSI : NSNumber?)
    {
        // serial의 delegate에서 호출됩니다.
        // 이미 저장되어 있는 기기라면 return합니다.
        for existing in peripheralList {
            if existing.peripheral.identifier == peripheral.identifier {return}
        }
        // 신호의 세기에 따라 정렬하도록 합니다.
        let fRSSI = RSSI?.floatValue ?? 0.0
        peripheralList.append((peripheral : peripheral , RSSI : fRSSI))
        peripheralList.sort { $0.RSSI < $1.RSSI}
        // tableView를 다시 호출하여 검색된 기기가 반영되도록 합니다.
        tableView.reloadData()
    }
    
    func serialDidConnectPeripheral(peripheral : CBPeripheral)
    {
        // serial의 delegate에서 호출됩니다.
        // 연결 성공 시 alert를 띄우고, alert 확인 시 View를 dismiss합니다.
        let connectSuccessAlert = UIAlertController(title: "블루투스 연결 성공", message: "\(peripheral.name ?? "알수없는기기")와 성공적으로 연결되었습니다.", preferredStyle: .actionSheet)
        let confirm = UIAlertAction(title: "확인", style: .default, handler: { _ in self.dismiss(animated: true, completion: nil) } )
        connectSuccessAlert.addAction(confirm)
        serial.delegate = nil
        present(connectSuccessAlert, animated: true, completion: nil)
    } 
}
