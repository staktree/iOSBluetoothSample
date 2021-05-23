//
//  BluetoothSerial.swift
//  BluetoothSwitch
//
//  Created by JHT on 19/05/2021.
//

import UIKit
import CoreBluetooth

var serial : BluetoothSerial!

protocol BluetoothSerialDelegate : AnyObject {
    func serialDidDiscoverPeripheral(peripheral : CBPeripheral, RSSI : NSNumber?)
}

class BluetoothSerial: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
     
    //MARK: variable
    // delegate
    var delegate : BluetoothSerialDelegate?
    
    // centralManager
    var centralManager : CBCentralManager!
    
    // peripheral
    var pendingPeripheral : CBPeripheral?
    var connectedPeripheral : CBPeripheral?
    
    
    weak var writeCharacteristic: CBCharacteristic?
    private var writeType: CBCharacteristicWriteType = .withoutResponse
    
    // uuid
    var serviceUUID = CBUUID(string: "FFE0")
    var characteristicUUID = CBUUID(string : "FFE1")
    
    var bluetoothIsReady:  Bool  {
        get {
            return centralManager.state == .poweredOn
        }
    }

    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    //MARK: functions
    func startScan() {
        guard centralManager.state == .poweredOn else { return }
        
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil) // withServices : nil로 하면 모든 서비스 다 나옴.
    }
    
    func stopScan() {
        centralManager.stopScan()
    }
    
    func connectToPeripheral(_ peripheral : CBPeripheral)
    {
        pendingPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }
    
    //MARK: central, peripheral Source
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if(bluetoothIsReady) {
            print("Bluetooth is Ready!")
        }
        pendingPeripheral = nil
        connectedPeripheral = nil
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        delegate?.serialDidDiscoverPeripheral(peripheral: peripheral, RSSI: RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        pendingPeripheral = nil
        connectedPeripheral = peripheral
        
        print("주변기기 연결 성공")
        
        peripheral.discoverServices([serviceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // 서비스를 검색하는데 성공하면 호출되는 함수
        print("서비스 연결 성공")
        print(peripheral.services!)
        
        for service in peripheral.services! {
            peripheral.discoverCharacteristics([characteristicUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // 캐리터리스틱을 연결하면 호출되는 함수
        print("캐리터리스틱 연결 성공")
        print(service.characteristics!)
        for characteristic in service.characteristics! {
            peripheral.setNotifyValue(true, for: characteristic)
            
            writeCharacteristic = characteristic
            
            writeType = characteristic.properties.contains(.write) ? .withResponse : .withResponse
            
            print("연결됨")
            print(writeType)
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
    }
}
