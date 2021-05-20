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
    var discoveredPeripherals : CBPeripheral?
    var connectedPeripheral : CBPeripheral?
    
    // uuid
    var serviceUUID = CBUUID(string: "FFE0") // "815BF1BA-69FE-784A-4390-C69A56849000"
    var characteristic = CBUUID(string : "FFE1")
    
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
    func startScan()
    {
        print(bluetoothIsReady)
        guard centralManager.state == .poweredOn else { return }
        
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil) // withServices : nil로 하면 모든 서비스 다 나옴.
    }
    
    //MARK: central, peripheral Source
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if(bluetoothIsReady) {
            print("Bluetooth is Ready!")
        }
        discoveredPeripherals = nil
        connectedPeripheral = nil
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        delegate?.serialDidDiscoverPeripheral(peripheral: peripheral, RSSI: RSSI)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        //delegate?.serialDidReadRSSI(RSSI)
    }
}
