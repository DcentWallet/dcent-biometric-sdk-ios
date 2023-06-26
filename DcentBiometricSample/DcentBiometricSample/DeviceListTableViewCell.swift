//
//  DeviceListTableViewCell.swift
//  Dcent
//
//  Created by iotrustMac01 on 24/05/2019.
//  Copyright © 2019년 iotrustMac01. All rights reserved.
//

import UIKit
import CoreBluetooth
import DcentBiometric

class DeviceListTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        self.accessoryType = selected ? .checkmark : .none
        selectedBackgroundView?.backgroundColor = .white
    }

    func setInfo(_ info:BleDeviceInfo) {
        nameLabel.text = info.deviceName
//        self.accessoryType = ( info.peripheral.state == CBPeripheralState.connected ? .checkmark : .none )

    }
}
