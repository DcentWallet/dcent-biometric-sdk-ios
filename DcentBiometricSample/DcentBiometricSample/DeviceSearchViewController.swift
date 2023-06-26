//
//  DeviceSearchViewController.swift
//  Dcent
//
//  Created by iotrustMac01 on 24/05/2019.
//  Copyright © 2019년 iotrustMac01. All rights reserved.
//

import UIKit
import CoreBluetooth
import DcentBiometric

class DeviceSearchViewController: PopupBaseViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var connectButton: UIButton!
    
    var deviceList:[BleDeviceInfo] = []
    var selectedDevice:BleDeviceInfo? = nil
    
    override func setupView() {
        super.setupView()
        DcentMgr.searchDeviceStart()
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentView.layer.cornerRadius = 6.0
        contentView.layer.masksToBounds = true
        DcentMgr.delegate = self
        connectButton.isEnabled = false
    }

    @IBAction func didConnectDevice(_ sender: UIButton) {
        if DcentMgr.connectedDevice() !== selectedDevice {
            let current:BleDeviceInfo?
            current = DcentMgr.connectedDevice()
                
            if current != nil {
                DcentMgr.disconnectDevice(from: current!)
            }
        }
        if selectedDevice != nil {
            if selectedDevice?.peripheral.state == .connected {
                DcentMgr.disconnectDevice(from: selectedDevice!)
            }
            else {
                DcentMgr.connectDevice(to: selectedDevice!)
                
            }
        }
        
        closeAction()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DeviceSearchViewController:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! DeviceListTableViewCell
        
        let info = deviceList[indexPath.row]
        
        cell.setInfo(info)
        
//        if info.peripheral.state == .connected {
//            cell.accessoryType = .checkmark
////            tableView.allowsSelection = false
//        }
//        else {
//            cell.accessoryType = .none
//        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = deviceList[indexPath.row]
        
        selectedDevice = info
        connectButton.isEnabled = true
//        if DcentMgr.connectedDevice() !== info {
//            let current:BleDeviceInfo?
//            current = DcentMgr.connectedDevice()
//            if current != nil {
//                DcentMgr.disconnectDevice(from: current!)
//            }
//        }
//        if info.peripheral.state == .connected {
//            DcentMgr.disconnectDevice(from: info)
//        }
//        else {
//            DcentMgr.connectDevice(to: info)
//        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .none
            selectedDevice = nil
        }
    }
}

extension DeviceSearchViewController:DcentBLEManagerDelegate {
    func dcentBleManager(didDiscover device: BleDeviceInfo) {
        self.deviceList = DcentMgr.getDeviceList()
        tableView.reloadData()
    }
    
    func dcentBleManager(didConnect device: BleDeviceInfo) {
        tableView.reloadData()
        if let resultHandler = self.popupResultHandler {
            self.selectedButtonIndex = self.firstOtherButtonIndex
            resultHandler(self, self.selectedButtonIndex)
        }
    }
    
    func dcentBleManager(didDisconnect device: BleDeviceInfo?) {
        tableView.reloadData()
    }
    
    func dcentBleManager(didFailToConnect device: BleDeviceInfo?) {
    }
    
    func dcentBleManager(didUpdate status: DcentBleManagerState) {
        if status == .poweredOn {
            DcentMgr.searchDeviceStart()
        }
        else if status == .poweredOff {
            DcentMgr.searchDeviceStop()
        }
    }
}
