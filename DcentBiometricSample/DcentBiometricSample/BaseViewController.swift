//
//  ViewController.swift
//  DcentBiometricSample
//
//  Created by iotrustMac01 on 29/05/2019.
//  Copyright © 2019 IoTrust Co., Ltd. All rights reserved.
//

import UIKit
import CoreBluetooth
import DcentBiometric

public let DcentMgr:DcentManager = DcentManager()
var ViewControllerInitialize:Bool = false
public let alertController = UIAlertController(title: nil, message: "progressing...", preferredStyle: UIAlertController.Style.alert)

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ViewControllerInitialize == false {
            ViewControllerInitialize = true
            view.addSubview(testLog)
            PickerView.dataSource = self
            PickerView.delegate = self
        }
    }
    
    open func setupView() {
        
    }

    @IBAction func DeviceDisconnect(_ sender: Any) {
        let current = DcentMgr.connectedDevice()
        if current != nil {
            DcentMgr.disconnectDevice(from: current!)
        }
    }
    
    @IBOutlet weak var testLog: UITextView!
 
    func GetDeviceInfoTest() {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> GetDeviceInfo <<< \n")
        let DevInfo = DcentMgr.getDeviceInfo()
        if let devInfo = DevInfo {
        //print(DevInfo.deviceUUID)
            print(devInfo.label)
            print(devInfo.deviceID)
            print(devInfo.fwVersion)
            print(devInfo.ksmVersion)
            print(devInfo.state)
            print(devInfo.coinList)
        
            
            self.dismiss(animated: true, completion: nil)
            
            var tempString : String
            self.testLog.text.removeAll()
            tempString = "\n >>> GetDeviceInfo <<< \n"
            //tempString += DevInfo.deviceUUID + "\n"
            tempString += devInfo.label + "\n"
            tempString += devInfo.deviceID + "\n"
            tempString += devInfo.fwVersion + "\n"
            tempString += devInfo.ksmVersion + "\n"
            tempString += devInfo.state + "\n"
            for i in 0..<devInfo.coinList.count {
                tempString += devInfo.coinList[i] + "\n"
            }
            self.testLog.text += tempString
        }
    }
    
    func SetLabelTest() {
        self.present(alertController, animated: true, completion: nil)
        
        print("\n>>> SetLabel <<< \n")
        DcentMgr.setDeviceLabel(newLabel: "Label"){ (Result)  in
            
            self.dismiss(animated: true, completion: nil)
            
            if Result == false {
                print("SetLabel closure")
                print("FAIL !!!")
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> SetLabel <<< \n"
                tempString += "\n FAIL !!! \n"
                self.testLog.text += tempString
            }else{
                // reload DeviceInfo
                let DevInfo = DcentMgr.getDeviceInfo()!
                print("SetLabelN closure")
                print(DevInfo.label)
                print(Result)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> SetLabel <<< \n"
                tempString += DevInfo.label + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func SetLabelNTest() {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> SetLabelN <<< \n")
        DcentMgr.setDeviceLabel(newLabel: "LabelN"){ (Result)  in
            self.dismiss(animated: true, completion: nil)
            if Result == false {
                print("SetLabelN closure")
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> SetLabelN <<< \n"
                tempString += "\n FAIL !!! \n"
                self.testLog.text += tempString
            }else{
                // reload DeviceInfo
                let DevInfo = DcentMgr.getDeviceInfo()!
                print("SetLabelN closure")
                print(DevInfo.label)
                print(Result)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> SetLabelN <<< \n"
                tempString += DevInfo.label + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    var SavedAccountInfo:[Account] = []
    
    func GetAccountInfoTest() {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> GetAccountInfo <<< \n")
        
        DcentMgr.getAccountInfo(){ (Result, AccountInfos) in
            self.dismiss(animated: true, completion: nil)
            
            var tempString : String
            self.testLog.text.removeAll()
            tempString = "\n >>> GetAccountInfo <<< \n"
            
            if Result == false {
                print("\n No Data  \n")
                tempString += " No Data \n"
                self.testLog.text += tempString
            }else{
                print("accountInfo.count: ", AccountInfos.count)
                for index in 0..<AccountInfos.count {
                    print(AccountInfos[index].coinGroup)
                    print(AccountInfos[index].coinName)
                    print(AccountInfos[index].label)
                    print(AccountInfos[index].addressPath)
                    
                    tempString += AccountInfos[index].coinGroup + "\n"
                    tempString += AccountInfos[index].coinName + "\n"
                    tempString += AccountInfos[index].label + "\n"
                    tempString += AccountInfos[index].addressPath + "\n"
                }
                self.testLog.text += tempString
                
                self.SavedAccountInfo = AccountInfos
            }
        }
    }
    
    func SyncAccountTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Sync Account <<< \n")
//        print(self.SavedAccountInfo[0].label)
//
//        if SavedAccountInfo.count == 0{
//            print("\n>>> No Saved Account <<< \n")
//
//            var tempString : String
//            self.testLog.text.removeAll()
//            tempString = "\n >>> Sync Account <<< \n"
//            tempString += "No Saved Account !!\n"
//            self.testLog.text += tempString
//            return
//        }
        
        let syncAccount:SyncAccount = SyncAccount(coinGroup: CoinType.COREUM.properties.name!, coinName: CoinType.COREUM.properties.name!, label: "core-1", addressPath: "m/44'/990'/0'/0/0", balance: "0")!
        
//        let syncAccount:SyncAccount = SyncAccount(coinGroup: "ABC", coinName: "ABC", label: "core-1", addressPath: "m/44'/990'/0'/0/0", balance: "0")!
        
        DcentMgr.syncAccount(account: syncAccount){ (Result)  in
            self.dismiss(animated: true, completion: nil)
            print("SyncAccount closure")
            if Result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Sync Account <<< \n"
                tempString += "\n FAIL !!! \n"
                self.testLog.text += tempString
            }else{
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Sync Account <<< \n"
                tempString += "SUCCESS !!\n"
                self.testLog.text += tempString
            }
        }
    }

    func GetExtractPublicKeyTest() {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Get ExtractPublicKey <<< \n")
        
        let keyPath = "m/44'/0'/0'"
        let bip32Name = "Bitcoin seed"
        DcentMgr.requestExtractPublicKey(bip32Name: bip32Name, KeyPath: keyPath) { (result, pubKey) in
            self.dismiss(animated: true, completion: nil)
            print("Get ExtractPublicKey closure")
            if result {
                print("success")
                print(pubKey)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> get ExtractPublicKey <<< \n"
                tempString += pubKey + "\n"
                self.testLog.text += tempString
            }
            else {
                print("fail")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> get ExtractPublicKey <<< \n"
                tempString += "\n FAIL !!! \n"
                self.testLog.text += tempString
            }
        }
    }

    func GetAddressTest() {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> get Address (Bitcoin) <<< \n")
        
        let keyPath = "m/44'/0'/0'/0/0/"
        DcentMgr.getAddress(coinType: .BITCOIN, addressPath: keyPath) { (result, address, pubkey) in
            self.dismiss(animated: true, completion: nil)
            print("Get Address closure")
            if result {
                print("success")
                print(address)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> get Address <<< \n"
                tempString += address + "\n"
                self.testLog.text += tempString
            }
            else {
                print("fail")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> get Address <<< \n"
                tempString += "\n FAIL !!! \n"
                self.testLog.text += tempString
            }
        }
    }
    
    func GetAddressCoreumTest() {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> get Address (Coreum) <<< \n")
        
        let keyPath = "m/44'/990'/0'/0/0"
        
//        let AccountInfo:Account = Account( coinGroup: "ABC", coinName:"ABC", label:"core-1", addressPath:"m/44'/990'/0'/0/0")!
//
//        DcentMgr.deleteAccount(account: AccountInfo) { (result)  in
//            self.dismiss(animated: true, completion: nil)
//            print("Delete Account closure")
//            if result == false {
//                print("FAIL !!!")
//                var tempString : String
//                self.testLog.text.removeAll()
//                tempString = "\n >>> Delete Account <<< \n"
//                tempString += "\n FAIL !!! \n"
//                self.testLog.text += tempString
//            }else{
//
//                var tempString : String
//                self.testLog.text.removeAll()
//                tempString = "\n >>> Delete Account <<< \n"
//                tempString += "SUCCESS !!\n"
//                self.testLog.text += tempString
//            }
//        }
        
        DcentMgr.getAddress(coinType: .COREUM, addressPath: keyPath) { (result, address, pubkey) in
            self.dismiss(animated: true, completion: nil)
            print("Get Address closure")
            if result {
                print("success")
                print(address)

                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> get Address <<< \n"
                tempString += address + "\n"
                self.testLog.text += tempString
            }
            else {
                print("fail")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> get Address <<< \n"
                tempString += "\n FAIL !!! \n"
                self.testLog.text += tempString
            }
        }
    }
    
    func GetAddressTezosTest() {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> get Address (Tezos) <<< \n")
        
        let keyPath = "m/44'/1729'/0'/0'"
        DcentMgr.getAddress(coinType: .TEZOS, addressPath: keyPath) { (result, address, pubkey) in
            self.dismiss(animated: true, completion: nil)
            print("Get Address closure")
            if result {
                print("success")
                print(address)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> get Address <<< \n"
                tempString += "address: " + address + "\n"
                tempString += "pubkey: " + pubkey + "\n"
                self.testLog.text += tempString
            }
            else {
                print("fail")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> get Address <<< \n"
                tempString += "\n FAIL !!! \n"
                self.testLog.text += tempString
            }
        }
    }
    
    
    func BitcoinTransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Bitcoin Transaction <<< \n")
        
        let transactionOutput : TransactionOutput = TransactionOutput()
        let unspentTransactionOutput : UnspentTransactionOutput = UnspentTransactionOutput()
        var unspenttxOut : [UnspentTransactionOutput] = [UnspentTransactionOutput()]
        
        unspenttxOut.append(unspentTransactionOutput)
        
        let BtcTxData : BitcoinTransaction = BitcoinTransaction(version: 0, input: unspenttxOut, output: [transactionOutput], locktime: 0)
        
        // test data
        BtcTxData.version = 1
        BtcTxData.input[1].prev_tx = "0100000001001355540aa694ddde95548de76168666f33d8fad420fab6c554180846676df1000000006a47304402205089f4b1bdb1f96786f4750af3c16a23c73b60de0fe3cfec0da906a181eea645022078047d56dded692477d35052e9179ac71f79c6ec6b5f49941056c03663255be9012103ac2a317f777d63a6bac857ba07e30920a0f2ebd3f99f15a92b8d295791a971f6ffffffff0230750000000000001976a914848d227771119767a8c08ee0b105633cbff2d6b688ac77180000000000001976a9145dadfc1f7c4548336912f23311b424310d6533c088ac00000000"
        BtcTxData.input[1].type = BtcTxtype.p2Pkh
        BtcTxData.input[1].utxo_idx = 1
        BtcTxData.input[1].key = "m/44'/0'/0'/1/4"
        BtcTxData.input[0].prev_tx = "0100000001076524b52baf87fe521e5b8a910fadd91c944f952520677def057e346a96380d000000006a473044022045a30be5dc493c36a3a55fd522b4aa2d795f49bb8b61507e1fca1c15819142c1022010846e11893840e521b277f31c1ca835d352fb582633e5ac95106d0ed52d1654012103b72bcab65c4ea43f4b700220729bdde9638c3bb70cc66b7a0de30738e8241382ffffffff0210270000000000001976a9149189ffd2039f1824de14562e592dc4bccaa57d6e88ac6a290000000000001976a9147046ed0f139552ada485f925e74f6576016fc55e88ac00000000"
        BtcTxData.input[0].type = BtcTxtype.p2Pkh
        BtcTxData.input[0].utxo_idx = 0
        BtcTxData.input[0].key = "m/44'/0'/0'/0/2"
        BtcTxData.output[0].to[0] = "1K8EfJgWR16Wo3Ejb3AtMk2mfoeAjmMtDL"
        BtcTxData.output[0].type = BtcTxtype.p2Pkh
        BtcTxData.output[0].value = 10000
        BtcTxData.locktime = 0
        
        DcentMgr.getBitcoinSignedTransaction(coinType: .BITCOIN, bitcoinTransaction: BtcTxData){ (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Bitcoin Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Bitcoin Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Bitcoin Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func EthereumMessageSignTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Ethereum Message Sign <<< \n")
        let messageSign : MessageSign = MessageSign(message: "", key: "")
        
        messageSign.key = "m/44'/60'/0'/0/0"
        messageSign.message = "sign TEST!!"
        DcentMgr.getMessageSign(coinType: .ETHEREUM, messageSign: messageSign) { result, addr, sign in
            self.dismiss(animated: true, completion: nil)
            print("Ethereum Message Sign closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Ethereum Message Sign <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += addr + "\n"
                self.testLog.text += tempString
            }else{
                print("addr: " + addr + ", sign: " + sign)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Ethereum Message Sign <<< \n"
                tempString += "addr: "
                tempString += addr + "\n"
                tempString += "sign: "
                tempString += sign + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    //
    //    Ethereum
    //    {"request":{"header":{"version":"1.0","request_to":"ethereum"},"body":{"command":"transaction","parameter":{"nonce":"14","gas_price":"6000000000","gas_limit":"21000","to":"0xe5c23dAa6480e45141647E5AeB321832150a28D4","value":"500000000000000","data":"0x","chain_id":"1","key":"m/44'/60'/0'/0/0"}}}}
    
    func EthereumTransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Ethereum Transaction <<< \n")
        
        let ethereumTransaction : EthereumTransaction = EthereumTransaction( addressPath:"", nonce:"", to:"", amount:"", gasLimit:"", gasPrice:"", data:"", chainId:"0" )
        
        // test data
        ethereumTransaction.addressPath = "m/44'/60'/0'/0/0"
        ethereumTransaction.nonce = "14"
        ethereumTransaction.to = "0xe5c23dAa6480e45141647E5AeB321832150a28D4"
        ethereumTransaction.amount = "500000000000000"
        ethereumTransaction.gasLimit = "21000"
        ethereumTransaction.gasPrice = "6000000000"
        ethereumTransaction.data = "0x"
        ethereumTransaction.chainId = "1"
        
        DcentMgr.getEthereumSignedTransaction(coinType:.ETHEREUM , ethereumTransaction:ethereumTransaction){ (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Ethereum Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Ethereum Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Ethereum Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    //
    //    Ripple
    //
    //    mTransaction = {RippleTransactionVO@11357}
    //    mAccount = {RippleAccountVO@11370} "SyncAccountVO{dongleId='47900503821163515B0272230034540744470100000011591837000000000000', coinGroup='ripple', coinName='ripple', label='myXRP', balance='29.9973 XRP', receivingAddressPath='m/44'/144'/0'/0/0', address='rsHXBk5vnswg5SZxUQCEPYVnmrd4PaZ7Ah', isSyncToDongle=false}"
    //    address = "rsHXBk5vnswg5SZxUQCEPYVnmrd4PaZ7Ah"
    //    balance = "29.9973 XRP"
    //    coinGroup = "ripple"
    //    coinName = "ripple"
    //    dongleId = "47900503821163515B0272230034540744470100000011591837000000000000"
    //    isSyncToDongle = false
    //    label = "myXRP"
    //    receivingAddressPath = "m/44'/144'/0'/0/0"
    //    shadow$_klass_ = {Class@7616} "class com.iotrust.dcent.wallet.network.vo.RippleAccountVO"
    //    shadow$_monitor_ = -2077477887
    //    mAmount = 2
    //    mDestinationAddress = "rsHXBk5vnswg5SZxUQCEPYVnmrd4PaZ7Ah"
    //    mDestinationTag = -1
    //    mFee = 10
    //    mSequence = 11
    //    mSourceAddress = "rsHXBk5vnswg5SZxUQCEPYVnmrd4PaZ7Ah"
    //    shadow$_klass_ = {Class@9245} "class com.iotrust.dcent.wallet.network.vo.RippleTransactionVO"
    //    shadow$_monitor_ = -2123167418
    
    func XrpTransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Xrp Transaction <<< \n")
        DcentMgr.getAddress(coinType: .XRP, addressPath: "m/44'/144'/0'/0/0") { (result, address, pubkey) in
            print("XRP getAddress closure")
            if result == false {
                print("FAIL !!!")
                return
            }
            let xrpTransaction : XrpTransaction = XrpTransaction(addressPath: "", sourceAddress: "", destinationAddress: "", amount: 0, fee: 0, sequence: 0, destinationTag: 0 )
            
            xrpTransaction.addressPath = "m/44'/144'/0'/0/0"
            xrpTransaction.sourceAddress = address
            xrpTransaction.destinationAddress = "rsHXBk5vnswg5SZxUQCEPYVnmrd4PaZ7Ah"
            xrpTransaction.amount = 2
            xrpTransaction.fee = 10
            xrpTransaction.sequence = 11
            xrpTransaction.destinationTag = 0
            
            DcentMgr.getXrpSignedTransaction(coinType:.XRP, xrpTransaction:xrpTransaction){ (result, txData) in
                self.dismiss(animated: true, completion: nil)
                print("XRP Transaction closure")
                if result == false {
                    print("FAIL !!!")
                    var tempString : String
                    self.testLog.text.removeAll()
                    tempString = "\n >>> XRP Transaction <<< \n"
                    tempString += "\n FAIL !!! \n"
                    tempString += txData + "\n"
                    self.testLog.text += tempString
                }else{
                    print(txData)
                    
                    var tempString : String
                    self.testLog.text.removeAll()
                    tempString = "\n >>> XRP Transaction <<< \n"
                    tempString += txData + "\n"
                    self.testLog.text += tempString
                }
            }
        }
        
    }
    
    func MonacoinTransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Monacoin Transaction <<< \n")
        
        let transactionOutput : TransactionOutput = TransactionOutput()
        let unspentTransactionOutput : UnspentTransactionOutput = UnspentTransactionOutput()
        var txOut : [TransactionOutput] = [TransactionOutput()]
        txOut.append(transactionOutput)
        
        let BtcTxData : BitcoinTransaction = BitcoinTransaction(version: 0, input: [unspentTransactionOutput], output: txOut, locktime: 0)
        
        // test data
        BtcTxData.version = 1
        BtcTxData.input[0].prev_tx = "0100000001ac9aa66bb2a2298c0551d0abce64c87011478e314a3cd02c14ec3d10d9a7fdef000000006a473044022002c0774d92a510c03894d3b719830c2c5152bcdb0aed44ae1ade8601c2dddf0802201d4e9a3c7f20be0950c6824516b0bb585553dcdca9b0d4505c392c475f8d09f60121032323ea47022a2f079e1515c05bca65c01e2f319eff88ba6de157d0471360e206ffffffff02c09ee605000000001976a914adf0f8b303265bce9cf06e0dd6865de2e6fc7c0a88ac68cb4a36000000001976a91457765ae98c002d6ae2e27e275f0353c2af0602cc88ac00000000"
        BtcTxData.input[0].type = BtcTxtype.p2Pkh
        BtcTxData.input[0].utxo_idx = 1
        BtcTxData.input[0].key = "m/44'/22'/0'/1/2"
        BtcTxData.output[0].to[0] = "m/44'/22'/0'/1/1"
        BtcTxData.output[0].type = BtcTxtype.change
        BtcTxData.output[0].value = 410836251
        BtcTxData.output[1].to[0] = "MFjJjkwpsXdtYwpuwtqhuvEAYkSpGJcJsN"
        BtcTxData.output[1].type = BtcTxtype.p2Pkh
        BtcTxData.output[1].value = 500000000
        BtcTxData.locktime = 0
        
        DcentMgr.getBitcoinSignedTransaction(coinType:.MONACOIN, bitcoinTransaction: BtcTxData){ (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Monacoin Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Monacoin Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Monacoin Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    //
    //    RSK
    //    {"request":{"header":{"version":"1.0","request_to":"rsk"},"body":{"command":"transaction","parameter":{"nonce":"4","gas_price":"65164000","gas_limit":"21000","to":"0x31f9eac21857d55efCebaE8234BE08B4940D3954","value":"49000000000","chain_id":"30","key":"m/44'/137'/0'/0/0"}}}}
    
    func RSKTransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> RSK Transaction <<< \n")
        
        let rskTransaction : EthereumTransaction = EthereumTransaction( addressPath:"", nonce:"", to:"", amount:"", gasLimit:"", gasPrice:"", data:"", chainId:"0" )
        
        // test data
        rskTransaction.addressPath = "m/44'/137'/0'/0/0"
        rskTransaction.nonce = "4"
        rskTransaction.to = "0x31f9eac21857d55efCebaE8234BE08B4940D3954"
        rskTransaction.amount = "49000000000"
        rskTransaction.gasLimit = "21000"
        rskTransaction.gasPrice = "65164000"
        rskTransaction.data = ""
        rskTransaction.chainId = "30"
        
        DcentMgr.getEthereumSignedTransaction(coinType:.RSK, ethereumTransaction:rskTransaction){ (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("RSK Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> RSK Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> RSK Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    //
    //    RRC20 RIF
    //    request = {"request":{"header":{"version":"1.0","request_to":"rrc20"},"body":{"command":"transaction","parameter":{"nonce":"4","gas_price":"65164000","gas_limit":"70000","chain_id":"30","contract":{"name":"RIF","address":"0x2acc95758f8b5f583470ba265eb685a8f45fc9d5","to":"0x31f9eac21857d55efCebaE8234BE08B4940D3954","decimals":"18","value":"46000000000000000000","symbol":"RIF"},"key":"m/44'/137'/0'/0/0"}}}}
    
    func RRC20TransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> RRC20 Transaction <<< \n")
        
        let rrc20Transaction : TokenTransaction = TokenTransaction(addressPath: "", nonce: "", to: "", amount: "", gasLimit: "", gasPrice: "", data: "", tokenName: "", contractAddress: "", decimals: "", tokenSymbol: "")
        
        // test data
        rrc20Transaction.addressPath = "m/44'/137'/0'/0/0"
        rrc20Transaction.nonce = "4"
        rrc20Transaction.to = "0x31f9eac21857d55efCebaE8234BE08B4940D3954"
        rrc20Transaction.amount = "46000000000000000000"
        rrc20Transaction.gasLimit = "70000"
        rrc20Transaction.gasPrice = "65164000"
        rrc20Transaction.data = ""
        rrc20Transaction.chainId = "30"
        rrc20Transaction.tokenName = "RIF"
        rrc20Transaction.contractAddress = "0x2acc95758f8b5f583470ba265eb685a8f45fc9d5"
        rrc20Transaction.decimals = "18"
        rrc20Transaction.tokenSymbol = "RIF"
        
        DcentMgr.getTokenSignedTransaction(coinType:.RRC20, tokenTransaction:rrc20Transaction){ (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("RRC20 Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> RRC20 Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> RRC20 Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    //
    //    ERC 20
    //    {"request":{"header":{"version":"1.0","request_to":"erc20"},"body":{"command":"transaction","parameter":{"nonce":"14","gas_price":"3000000000","gas_limit":"70000","chain_id":"1","contract":{"name":"OmiseGO","address":"0xd26114cd6ee289accf82350c8d8487fedb8a0c07","to":"0xe5c23dAa6480e45141647E5AeB321832150a28D4","decimals":"18","value":"60000000000000000","symbol":"OMG"},"key":"m/44'/60'/0'/0/0"}}}}
    
    func ERC20TransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> ERC20 Transaction <<< \n")
        
        let erc20Transaction : TokenTransaction = TokenTransaction(addressPath: "", nonce: "", to: "", amount: "", gasLimit: "", gasPrice: "", data: "", tokenName: "", contractAddress: "", decimals: "", tokenSymbol: "")
        
        // test data
        erc20Transaction.addressPath = "m/44'/60'/0'/0/0"
        erc20Transaction.nonce = "14"
        erc20Transaction.to = "0xe5c23dAa6480e45141647E5AeB321832150a28D4"
        erc20Transaction.amount = "60000000000000000"
        erc20Transaction.gasLimit = "70000"
        erc20Transaction.gasPrice = "3000000000"
        erc20Transaction.data = ""
        erc20Transaction.chainId = "1"
        erc20Transaction.tokenName = "OmiseGO"
        erc20Transaction.contractAddress = "0xd26114cd6ee289accf82350c8d8487fedb8a0c07"
        erc20Transaction.decimals = "18"
        erc20Transaction.tokenSymbol = "OMG"
        
        DcentMgr.getTokenSignedTransaction(coinType:.ERC20, tokenTransaction:erc20Transaction){ (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("ERC20 Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> ERC20 Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> ERC20 Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func KRC20TransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> KRC20 Transaction <<< \n")
        
        let krc20Transaction : KlaytnTokenTransaction = KlaytnTokenTransaction(addressPath: "", nonce: "", to: "", amount: "", gasLimit: "", gasPrice: "", data: "", chainId: 0, tokenName: "", decimals: 0, tokenSymbol: "")
        
        // test data
        krc20Transaction.addressPath = "m/44'/8217'/0'/0/0"
        krc20Transaction.nonce = "6"
        krc20Transaction.to = "0x92c1b39556d5322dac96e9e13d35a146297fcf43"
        krc20Transaction.amount = "100000000"
        krc20Transaction.gasLimit = "100000"
        krc20Transaction.gasPrice = "25000000000"
        krc20Transaction.data = "0xa9059cbb000000000000000000000000732E035fBdb9E5AB5Ef80c08f6aA081d029984dc"
        krc20Transaction.chainId = "1001"
        krc20Transaction.tx_type = KlaytnType.SMART_CONTRACT_EXECUTION.rawValue
        krc20Transaction.fromAddr = "0x689dfa2C77335722f333EeA102ba8A5E13d2AD1a"
        krc20Transaction.fee_ratio = 0
        krc20Transaction.tokenName = "BAOBABTOKEN"
        krc20Transaction.decimals = 8
        krc20Transaction.tokenSymbol = "BAO"
        
        DcentMgr.getKlaytnBasedTokenTransaction(coinType: .KLAYTN_ERC20, tokenTransaction: krc20Transaction){ (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("KRC20 Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> KRC20 Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> KRC20 Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func KlaytnTransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Klaytn Legacy Transaction <<< \n")

        
        let klaytnTransaction : KlaytnTransaction = KlaytnTransaction(addressPath: "0", nonce: "", to: "", amount: "", gasLimit: "", gasPrice: "", data: "", chainId: 0)

        // test data
        klaytnTransaction.addressPath = "m/44'/8217'/0'/0/0"
        klaytnTransaction.nonce = "8"
        klaytnTransaction.to = "0xe5c23dAa6480e45141647E5AeB321832150a28D4"
        klaytnTransaction.amount = "60000000000000000"
        klaytnTransaction.gasLimit = "25000"
        klaytnTransaction.gasPrice = "25000000000"
        klaytnTransaction.data = ""
        klaytnTransaction.chainId = "1001"
        // klaytnTransaction.fromAddr = ""
        //klaytnTransaction.tx_type = KlaytnType.LEGACY.rawValue
        //klaytnTransaction.fee_ration =

        DcentMgr.getKlaytnSignedTransaction(coinType:.KLAYTN, klaytnTransaction:klaytnTransaction){ (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Kalytn Legacy Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Klaytn Lagecy Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)

                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Klaytn Legacy Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func BinanceTransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Binance Transaction <<< \n")

        let binanceTransaction : BinanceTransaction = BinanceTransaction(std_sign_doc: "", key: "", fee: "")
        
        // test data
        binanceTransaction.std_sign_doc = "7b226163636f756e745f6e756d626572223a22343834303237222c22636861696e5f6964223a2242696e616e63652d436861696e2d546967726973222c2264617461223a6e756c6c2c226d656d6f223a22222c226d736773223a5b7b22696e70757473223a5b7b2261646472657373223a22626e62317a7a34647634767235687a3076647161686334707371797a39676a303974703775646d673273222c22636f696e73223a5b7b22616d6f756e74223a313030303030302c2264656e6f6d223a22424e42227d5d7d5d2c226f757470757473223a5b7b2261646472657373223a22626e6231796d33377164616e76716b72686139636b70686a6b3067336d6630367068656d33787a393437222c22636f696e73223a5b7b22616d6f756e74223a31303030303030303030302c2264656e6f6d223a22424e42227d5d7d5d7d5d2c2273657175656e6365223a2230222c22736f75726365223a2230227d"
        binanceTransaction.key = "m/44'/714'/0'/0/0"
        binanceTransaction.fee = "375000"
        
        DcentMgr.getBinanceSignedTransaction(coinType: .BINANCE, binanceTransaction: binanceTransaction){ (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Binance Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Binance Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)

                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Binance Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func StellarTransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Stellar Transaction <<< \n")

        let stellarTransaction : StellarTransaction = StellarTransaction(txXDR: "7ac33997544e3175d266bd022439b22cdb16508c01163f26e5cb2a3e1045a9790000000200000000d147b20efbeb51a8f8eea50f4ce1ad549796a509236c3cad056e22cf3e3e6f0b000000640005821d00000004000000010000000000000000000000005ec76b4a00000000000000010000000000000000000000005e3deafcf4bee3bf40a85e4f93bdf7d94e62a05e811ed787f9d04bc983ec207b0000000049504f8000000000", key: "m/44'/148'/0'")
    
        
        DcentMgr.getStellarSignedTransaction(coinType: .STELLAR, stellarTransaction: stellarTransaction){ (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Stellar Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Stellar Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)

                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Stellar Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func EtherCahinTransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> EtherCahin Transaction <<< \n")

        let etherChainTransaction : EthereumTransaction = EthereumTransaction( addressPath:"", nonce:"", to:"", amount:"", gasLimit:"", gasPrice:"", data:"", chainId:"0" )
        
        // test data
        etherChainTransaction.addressPath = "m/44'/60'/0'/0/0"
        etherChainTransaction.nonce = "74"
        etherChainTransaction.to = "0xe5c23dAa6480e45141647E5AeB321832150a28D4"
        etherChainTransaction.amount = "500000000000000"
        etherChainTransaction.gasLimit = "21000"
        etherChainTransaction.gasPrice = "9000000000"
        etherChainTransaction.data = ""
        etherChainTransaction.chainId = "42"
        etherChainTransaction.symbol = "kETH"
        
        DcentMgr.getEthereumSignedTransaction(coinType: .CHAN, ethereumTransaction: etherChainTransaction){ (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("EtherChain Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> EtherChain Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)

                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> EtherChain Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func XDCTransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> XDC Transaction <<< \n")

        let xdcTransaction : EthereumTransaction = EthereumTransaction( addressPath:"", nonce:"", to:"", amount:"", gasLimit:"", gasPrice:"", data:"", chainId:"0" )
        
        // test data
        xdcTransaction.addressPath = "m/44'/550'/0'/0/0"
        xdcTransaction.nonce = "0"
        xdcTransaction.to = "0xe5c23dAa6480e45141647E5AeB321832150a28D4"
        xdcTransaction.amount = "1000"
        xdcTransaction.gasLimit = "100000"
        xdcTransaction.gasPrice = "20000000000"
        xdcTransaction.data = "0xc0de"
        xdcTransaction.chainId = "50"
        
        DcentMgr.getEthereumSignedTransaction(coinType: .XDC, ethereumTransaction: xdcTransaction){ (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("XDC Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> XDC Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)

                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> XDC Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func CardanoTransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Cardano Transaction <<< \n")

        let cardanoTransaction : CardanoTransaction = CardanoTransaction(unsigned: "a400818258209087b68d8f59dca2a29a3f5c03db7b162ba2607fa930f95996d12b1a570a84ef01018182583901b552fcf04820629ec73d54cd8cac3fccb4902d81f7801b65c654a490f122908efcb7fc3b457a83c4a1a50a7e7e919694fdc195d55c1a1b961a00297398021a00028911031a0185c2df", key: "m/44'/1815'/0'/0/0")

        
        DcentMgr.getCardanoSignedTransaction(coinType: .CARDANO, cardanoTransaction: cardanoTransaction){ (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Cardano Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Cardano Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)

                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Cardano Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func PolygonTransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Polygon Transaction <<< \n")

        let polygonTransaction : EthereumTransaction = EthereumTransaction(addressPath: "", nonce: "", to: "", amount: "", gasLimit: "", gasPrice: "", chainId: "0")
       
        // test data
        polygonTransaction.addressPath = "m/44'/60'/0'/0/0"
        polygonTransaction.nonce = "0"
        polygonTransaction.to = "0xe5c23dAa6480e45141647E5AeB321832150a28D4"
        polygonTransaction.amount = "1000"
        polygonTransaction.gasLimit = "100000"
        polygonTransaction.gasPrice = "20000000000"
        polygonTransaction.data = "0xc0de"
        polygonTransaction.chainId = "137"
        
        DcentMgr.getEthereumSignedTransaction(coinType: .POLYGON, ethereumTransaction: polygonTransaction){ (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Polygon Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Polygon Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)

                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Polygon Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func EthereumTypedTransactionTest(){
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Ethereum Typed Transaction <<< \n")

        let etherTypedTransaction : EthereumTransaction = EthereumTransaction(addressPath: "", nonce: "", to: "", amount: "", gasLimit: "", gasPrice: "")
       
        // test data
        etherTypedTransaction.addressPath = "m/44'/60'/0'/0/0"
        etherTypedTransaction.nonce = "0"
        etherTypedTransaction.to = "0x59B1e729B5c65D2c25F6A16164cF0Db0E9fA5754"
        etherTypedTransaction.amount = "0"
        etherTypedTransaction.gasLimit = "100000"
        etherTypedTransaction.gasPrice = "6000000000"
        etherTypedTransaction.data = "0xc0de"
        etherTypedTransaction.chainId = "11155111"
        etherTypedTransaction.symbol = "ETH"
        etherTypedTransaction.txType = "2"
        etherTypedTransaction.maxPriorityFpg = "1000000000"
        etherTypedTransaction.maxFeePerGas = "10000000000"
        etherTypedTransaction.accessList = "c0"
        
        DcentMgr.getEthereumSignedTypedTransaction(coinType: .ETHEREUM, ethereumTransaction: etherTypedTransaction){ (result, sign) in
            self.dismiss(animated: true, completion: nil)
            print("Ethereum Typed Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Ethereum Typed Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += sign["msg"] ?? "" + "\n"
                self.testLog.text += tempString
            }else{
                print(sign)

                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Ethereum Typed Transaction <<< \n"
                for (key, value) in sign {
                    tempString += key + ": " + value + "\n"
                }
                self.testLog.text += tempString
            }
        }
    }
    
    func StacksTransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Stacks Transaction <<< \n")
        let stacksTransaction : StacksTransaction = StacksTransaction(key: "m/44'/5757'/0'/0/0", sigHash: "00000000010400b8d4c2dbab9a59837ca0892080d9395199b3fa9d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000302000000000005166c717c6701374d0db48dac262d1a85f906ae2d1e000000001ad2748031303638343134333900000000000000000000000000000000000000000000000000", authType: 4, fee: "0.12", nonce: "000000000000006c", symbol: "STX", decimals: 6, optionParam: "")
        
        // test data
        
        DcentMgr.getStacksSignedTransaction(coinType: .STACKS, stacksTransaction: stacksTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Stacks Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Stacks Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Stacks Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func SIP010TransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> SIP010 Transaction <<< \n")
        let stacksTransaction : StacksTransaction = StacksTransaction(key: "m/44'/5757'/0'/0/0", sigHash: "0000000001040027b586cbbbd0902773c2faafb2c511b130c3610800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030200000000021608633eac058f2e6ab41613a0a537c7ea1a79cdd20f6d69616d69636f696e2d746f6b656e087472616e736665720000000401000000000000000000000000000f4240051627b586cbbbd0902773c2faafb2c511b130c361080516e3d94a92b80d0aabe8ef1b50de84449cd61ad6370a0200000006313130343239", authType: 4, fee: "0.0025", nonce: "000000000000006c", symbol: "MIAMI", decimals: 6, optionParam: "01") // assert transfer
        
        // test data
        
        DcentMgr.getStacksSignedTransaction(coinType: .SIP010, stacksTransaction: stacksTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("SIP010 Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> SIP010 Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> SIP010 Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func SolanaTransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Solana Transaction <<< \n")
        let solanaTransaction : SolanaTransaction = SolanaTransaction(key: "m/44'/501'/0'", sigHash: "0100010350d8ec411526b2704c9e730e1b59a2fe128cd9b5b2939a5918c54a660612177d480cc32970400e125ed89752129793ab63d351326e0d5af0aed644233955e59c0000000000000000000000000000000000000000000000000000000000000000d87cf02a1cea0c26fe671ee2ca0cf8c1fa7db58f18ae158c5808eac974d855f601020200010c0200000000e1f50500000000", fee: "0.0000506", symbol: "SOL", decimals: 9, optionParam: "")
        // test data
        DcentMgr.getSolanaSignedTransaction(coinType: .SOLANA, solanaTransaction: solanaTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Solana Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Solana Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Solana Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func SPLTokenTransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> SPL-Token Transaction <<< \n")
        let splTokenTranasction : SolanaTransaction = SolanaTransaction(key: "m/44'/501'/0'", sigHash: "010002052d5b413c6540de150c9373144d5133ca4cb830ba0f756716acea0e50d79435e51e3cd6284380940e08624cb8338b77dc332575d15fa39a0f1df15ee08fb823ee69d4ed8cec4206311d580c84b4682382b3031c5ccebc9b34e8cccc11f7047dc10f1e6b1421c04a070431265c19c5bbee1992bae8afd1cd078ef8af7047dc11f706ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a90000000000000000000000000000000000000000000000000000000000000000010404010302000a0c220000000000000009", fee: "0.00024"/*"00000000000001FA"*/, symbol: "DCT", decimals: 9, optionParam: "01")
        // test data
        DcentMgr.getSolanaSignedTransaction(coinType: .SPL_TOKEN, solanaTransaction: splTokenTranasction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("SPL-Token Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> SPL-Token Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> SPL-Token Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func ConfluxTransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Conflux Transaction <<< \n")
        let confluxTransaction : ConfluxTransaction = ConfluxTransaction(nonce: "0", gasPrice: "1", gas: "53000", to: "cfx:aath39ukgygwae5jnhuj1z02vkkc68wsu62j5spdng", amount: "499993640000000000000", storageLimit: "0", epochHeight: "57744640", chainId: "1029", addressPath: "m/44'/60'/0'/0/0")
        
        // test data
        
        DcentMgr.getConfluxSignedTransaction(coinType: .CONFLUX, confluxTransaction: confluxTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Conflux Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Conflux Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Conflux Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func CRC20TransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> CRC20 Transaction <<< \n")
        let crc20Transaction : CRC20TokenTransaction = CRC20TokenTransaction(nonce: "0", gasPrice: "1", gas: "53000", to: "cfx:acdeewzdr3cv7hvc12kdwp7gzysjaexz9jw7s1uaft", amount: "0", storageLimit: "0", epochHeight: "58463079", chainId: "1029", addressPath: "m/44'/60'/0'/0/0", tokenName: "IoTestCoin", contractAddress: "cfx:acdeewzdr3cv7hvc12kdwp7gzysjaexz9jw7s1uaft", toAddress: "cfx:aath39ukgygwae5jnhuj1z02vkkc68wsu62j5spdng", decimals: "18", value: "5000000000000000000", tokenSymbol:"ITC")
        
        // test data
        DcentMgr.getCRC20TokenSignedTransaction(coinType: .CFX_CRC20, tokenTransaction: crc20Transaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("CRC20 Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> CRC20 Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> CRC20 Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func HederaTransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Hedera Transaction <<< \n")
        let hederaTransaction : HederaTransaction = HederaTransaction(unsigned: "", key: "", symbol: "", decimals: "")
        
        // test data
        hederaTransaction.unsigned = "0a1a0a0c088dfbbc9006108885e6a90112080800100018d6c0151800120608001000180318c0843d22020878320072260a240a100a080800100018d6c01510ef8de29a030a100a080800100018f6a72810f08de29a03"
        hederaTransaction.key = "m/44'/3030'/0'"
        hederaTransaction.symbol = "HBAR"
        hederaTransaction.decimals = "8"
        
        DcentMgr.getHederaSignedTransaction(coinType: .HEDERA, hederaTransaction: hederaTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Hedera Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Hedera Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Hedera Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func TronTransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Tron Transaction <<< \n")
        let tronTransaction : TronTransaction = TronTransaction(txData: "0a02610a220838507457b79561a740e8dd8fefaf2e5a65080112610a2d747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e5472616e73666572436f6e747261637412300a15418f2d2dfaa81af60f5a3ac4ca5597e795aff7abae121541c27dcd7d914fd6aa8fec3c8a41cb2e90883bc6f0187f70dd978cefaf2e", key: "m/44'/195'/0'/0/0", fee: "0.00262")
        
        
        DcentMgr.getTronSignedTransaction(coinType: .TRON, tronTransaction: tronTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Tron Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Tron Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Tron Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func PolkadotTransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Polkadot Transaction <<< \n")
        let polkadotTransaction : PolkadotTransaction = PolkadotTransaction(sigHash: "040000163a5ee36b1243ce5241c0a45010dd1717869e9918c040bf5d305be4a5af9e7a0b00407a10f35a003400a223000007000000e143f23803ac50e8f6f8e62695d1ce9e4e1d68aa36c1cd2cfd15340213f3423ee143f23803ac50e8f6f8e62695d1ce9e4e1d68aa36c1cd2cfd15340213f3423e", key: "m/44'/354'/0'/0/0", fee: "0.0000000005", decimals: 12, symbol: "DOT", optionParam: "")
        
        // test data
        
        DcentMgr.getPolkadotSignedTransaction(coinType: .POLKADOT, polkadotTransaction: polkadotTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Polkadot Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Polkadot Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Polkadot Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func CosmosTransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Cosmos Transaction <<< \n")
        let cosmosTransaction : CosmosTransaction = CosmosTransaction(sigHash: "0a94010a8f010a1c2f636f736d6f732e62616e6b2e763162657461312e4d736753656e64126f0a2d636f736d6f73317235763573726461377866746833686e327332367478767263726e746c646a756d74386d686c122d636f736d6f733138766864637a6a7574343467707379383034637266686e64356e713030336e7a306e663230761a0f0a057561746f6d1206313030303030120012670a500a460a1f2f636f736d6f732e63727970746f2e736563703235366b312e5075624b657912230a21ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff12040a020801180a12130a0d0a057561746f6d12043530303010c09a0c1a0b636f736d6f736875622d34208f3a", key: "m/44'/118'/0'/0/0", fee: "0.00025", decimals: 6, symbol: "ATOM", optionParam: "")
        
        // test data
        
        DcentMgr.getCosmosSignedTransaction(coinType: .COSMOS, cosmosTransaction: cosmosTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Cosmos Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Cosmos Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Cosmos Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func CoreumTransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Coreum Transaction <<< \n")
        let coreumTransaction : CosmosTransaction = CosmosTransaction(sigHash: "0a90010a8b010a1c2f636f736d6f732e62616e6b2e763162657461312e4d736753656e64126b0a2b636f7265317432656d347a6b77346161716d7139373939656e756b66366538343577656671776e63667a78122b636f726531666c343876736e6d73647a637638357135643271347a35616a646861387975337834333537761a0f0a057561746f6d1206313030303030120012670a500a460a1f2f636f736d6f732e63727970746f2e736563703235366b312e5075624b657912230a21ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff12040a020801180012130a0d0a057561746f6d12043530303010c09a0c1a0b636f736d6f736875622d342000", key: "m/44'/990'/0'/0/0", fee: "0.000251", decimals: 6, symbol: "CORE", optionParam: "")
        
        // test data
        
        DcentMgr.getCosmosSignedTransaction(coinType: .COREUM, cosmosTransaction: coreumTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Coreum Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Coreum Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Coreum Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func TezosTransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Tezos Transaction <<< \n")
        let tezoseTransaction : TezosTransaction = TezosTransaction(sigHash: "032923211dc76b05a644c88df7507c6f2fd5100cb6ed11c236a270d97dbd53937c6c0021298384724bff62370492fbb56f408bf6f77bcfb905b8d6f804f51219a0e7010000678a5cb8807767a9d900311890526ad77bffbb3900", key: "m/44'/1729'/0'/0/0", fee: "0.000697", decimals: 6, symbol: "XTZ", optionParam: "")

        // test data
        DcentMgr.getTezosSignedTransaction(coinType: .TEZOS, tezosTransaction: tezoseTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Tezos Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Tezos Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Tezos Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func XtzFaTransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> XTZ-FA Transaction <<< \n")
        let xtzFaTransaction : TezosTransaction = TezosTransaction(sigHash: "03151ca887e6eda35fa2a169fda1b45bb0d3b47333b238b158481831b15a4161cd6c0021298384724bff62370492fbb56f408bf6f77bcfa907cdd6f804de22480001a91dcdedf09a5bf550e561e7eb4e00d5a6372c3d00ffff087472616e736665720000005907070100000024747a314e664e6973683565785351723146474563734b786b4c66454b347177616175696e07070100000024747a3156355733543845696176796252655166664e454c526f39334437663166506f575600a90f", key: "m/44'/1729'/0'/0/0", fee: "0.00314", decimals: 9, symbol: "GOLD", optionParam: "")

        // test data
        DcentMgr.getTezosSignedTransaction(coinType: .XTZ_FA, tezosTransaction: xtzFaTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("XTZ-FA Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> XTZ-FA Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> XTZ-FA Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func VechainTransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Vechain Transaction <<< \n")
        let vechainTransaction : VechainTransaction = VechainTransaction(sigHash: "f83b2787c6143a04c08fe18202d0e1e094a57105e43efa47e787d84bb6dfedb19bdcaa8a908908e3f50b173c100001808082520880860152671166bdc0", key: "m/44'/818'/0'/0/0", fee: "0.21", decimals: 18, symbol: "VET", optionParam: "")

        // test data
        DcentMgr.getVechainSignedTransaction(coinType: .VECHAIN, vechainTransaction: vechainTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Vechain Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Vechain Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Vechain Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func VechainERC20TransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Vechain ERC20 Transaction <<< \n")
        let vechainErc20Transaction : VechainTransaction = VechainTransaction(sigHash: "f8762787c4c9aecf5782e910f85ef85c940000000000000000000000000000456e6572677980b844a9059cbb0000000000000000000000001f6a5679de62414e4e6f2d7ea7a68d577687480a0000000000000000000000000000000000000000000000000de0b6b3a764000080825a988085a87ddd6b7bc0", key: "m/44'/818'/0'/0/0", fee: "0.409", decimals: 18, symbol: "VTHO", optionParam: "")

        // test data
        DcentMgr.getVechainSignedTransaction(coinType: .VECHAIN_ERC20, vechainTransaction: vechainErc20Transaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Vechain ERC20 Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Vechain ERC20 Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Vechain ERC20 Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func NearTransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Near Transaction <<< \n")
        let nearTransaction : NearTransaction = NearTransaction(sigHash: "4000000033666164666339326631633631643261303138626166333738383566376633363331313439616331356163303438613263303137316566316661356139633366003fadfc92f1c61d2a018baf37885f7f3631149ac15ac048a2c0171ef1fa5a9c3f41b15753844300004000000033666164666339326631633631643261303138626166333738383566376633363331313439616331356163303438613263303137316566316661356139633366d5e91d9515257370e4763c0da089ca544c1292bd188ad3fee466e17024e941f40100000003000000a1edccce1bc2d3000000000000", key: "m/44'/397'/0'", fee: "0.000860039223625", decimals: 24, symbol: "NEAR", optionParam: "")

        // test data
        DcentMgr.getNearSignedTransaction(coinType: .NEAR, nearTransaction: nearTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Near Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Near Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Near Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func NearTokenTransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Near Token Transaction <<< \n")
        let nearTransaction : NearTransaction = NearTransaction(sigHash: "400000006364663837313939386530343164333037383432383063636530313362666435633764653339643264333236373262623239666163636530363333373066333200cdf871998e041d30784280cce013bfd5c7de39d2d32672bb29facce063370f32c25215a29572000014000000757364632e7370696e2d66692e746573746e6574a37a00484ecbde6e6c436dece0ce845369657857deff857a2acb645e0a20799e02000000020f00000073746f726167655f6465706f7369746a0000007b226163636f756e745f6964223a2230626238343733363130336633336265623330356432316262333235396464653666646437313764616432656562336366356137666232323730666362353866222c22726567697374726174696f6e5f6f6e6c79223a747275657d00e057eb481b00000000485637193cc34300000000000000020b00000066745f7472616e73666572610000007b2272656365697665725f6964223a2230626238343733363130336633336265623330356432316262333235396464653666646437313764616432656562336366356137666232323730666362353866222c22616d6f756e74223a22313530227d00f0ab75a40d000001000000000000000000000000000000", key: "m/44'/397'/0'", fee: "0.123", decimals: 24, symbol: "NEAR", optionParam: "02") //function call

        // test data
        DcentMgr.getNearSignedTransaction(coinType: .NEAR_TOKEN, nearTransaction: nearTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Near Token Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Near Token Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Near Token Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func HavahTransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> Havah Transaction <<< \n")
        let havahTransaction : HavahTransaction = HavahTransaction(sigHash: "", key: "", fee: "", decimals: 0, symbol: "", optionParam: "")
        havahTransaction.sigHash = "6963785f73656e645472616e73616374696f6e2e66726f6d2e6878316531333433353935303532383335613064396137643064396533353839633433323831623262642e6e69642e30783130302e6e6f6e63652e3078312e737465704c696d69742e307831616462302e74696d657374616d702e3078356661316631343633666161302e746f2e6878353833323164313731633833393465613434303638376562623462353832623037353739356663352e76616c75652e307833636235396163376237353734652e76657273696f6e2e307833"
        havahTransaction.key = "m/44'/858'/0'/0/0"
        havahTransaction.fee = "0.001375"
        havahTransaction.decimals = 18
        havahTransaction.symbol = "HVH"
        havahTransaction.optionParam = ""

        // test data
        DcentMgr.getHavahSignedTransaction(coinType: .HAVAH, havahTransaction: havahTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("Havah Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Havah Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> Havah Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func HSP20TransactionTest () {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> HSP20 Transaction <<< \n")
        let havahTransaction : HavahTransaction = HavahTransaction(sigHash: "", key: "", fee: "", decimals: 0, symbol: "", optionParam: "")

        // test data
        havahTransaction.sigHash = "6963785f73656e645472616e73616374696f6e2e646174612e7b6d6574686f642e7472616e736665722e706172616d732e7b5f746f2e6878656337623030666563623033393132333037306334633330383130636438636439666465623662392e5f76616c75652e30786465306236623361373634303030307d7d2e64617461547970652e63616c6c2e66726f6d2e6878653165396634626466623461316562363332323266366535653338396237386461663533323639612e6e69642e30783130312e6e6f6e63652e3078312e737465704c696d69742e30786534653163302e74696d657374616d702e3078356638663564303562623763382e746f2e6378333235313963366331316234373166663632396138656661333665633764303439393630616639382e76657273696f6e2e307833"
        havahTransaction.key = "m/44'/858'/0'/0/0"
        havahTransaction.fee = "0.001375"
        havahTransaction.decimals = 18
        havahTransaction.symbol = "HVH"
        havahTransaction.optionParam = "01"
        
        DcentMgr.getHavahSignedTransaction(coinType: .HAVAH_HSP20, havahTransaction: havahTransaction) { (result, txData) in
            self.dismiss(animated: true, completion: nil)
            print("HSP20 Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> HSP20 Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }else{
                print(txData)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> HSP20 Transaction <<< \n"
                tempString += txData + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    func XRPWithUnsigedTxTest() {
        self.present(alertController, animated: true, completion: nil)
        print("\n>>> XRP with unsigedTx Transaction <<< \n")
        let xrpTransaction : XrpTransactionWithUnsigedTx = XrpTransactionWithUnsigedTx(addressPath: "m/44'/144'/0'/0/0", unsigned: "1200002280000000240238634E2E00000000201B023863E161400000000098968068400000000000000A8114FD970F4612987680F4008BA53ED6FD87BE0DAAF983141DEE2154B117FB47FCF4F19CD983D9FCBB894FF7")
    
        DcentMgr.getXrpSignedTransactionWithUnsignedTx(coinType: .XRP, xrpTransaction: xrpTransaction)  { (result, coinType, sign, pubkey, accoutId)  in
            self.dismiss(animated: true, completion: nil)
            print("XRP with unsignedTx Transaction closure")
            if result == false {
                print("FAIL !!!")
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> XRP with unsignedTx Transaction <<< \n"
                tempString += "\n FAIL !!! \n"
                tempString += coinType + "\n"
                self.testLog.text += tempString
            }else{
                print(sign)
                
                var tempString : String
                self.testLog.text.removeAll()
                tempString = "\n >>> XRP with unsignedTx Transaction <<< \n"
                tempString += "coinType: " + coinType + "\n"
                tempString += "sign: " + sign + "\n"
                tempString += "pubkey: " + pubkey + "\n"
                tempString += "accountId: " + accoutId + "\n"
                self.testLog.text += tempString
            }
        }
    }
    
    //
    // PickerView
    @IBOutlet weak var PickerView: UIPickerView!

//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return PickerViewArray[row]
//    }
//
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: PickerViewArray[row], attributes: [.foregroundColor:UIColor.black])
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PickerViewArray.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelectedCmdIdx = row
    }

    var pickerSelectedCmdIdx = 0
    let PickerViewArray = [
        /* 00 */"Get DeviceInfo"
        /* 01 */, "Set Label"
        /* 02 */, "Set LabelN"
        /* 03 */, "Get Account Info"
        /* 04 */, "Sync Account"
        /* 05 */, "Get ExtractPublicKey"
        /* 06 */, "Get Address(Bitcoin)"
        /* 07 */, "Get Address(Coreum)"
        /* 08 */, "Get Address(Tezos)"
        /* 09 */, "Ethereum Message Sign(Personal Sign)"
        /* 10 */, "Bitcoin Transaction"
        /* 11 */, "Ethereum Transaction"
        /* 12 */, "XRP Transaction"
        /* 13 */, "Monacoin Transaction"
        /* 14 */, "RSK Transaction"
        /* 15 */, "RRC20 Transaction"
        /* 16 */, "ERC20 Transaction"
        /* 17 */, "Klaytn Transaction"
        /* 18 */, "Binance Transaction"
        /* 19 */, "Stellar Transaction"
        /* 20 */, "EtherChain Transaction"
        /* 21 */, "XDC Transaction"
        /* 22 */, "Cardano Transaction"
        /* 23 */, "Polygon Transaction"
        /* 24 */, "Ethereum typed Transaction"
        /* 25 */, "Stacks Transaction"
        /* 26 */, "Stacks Token SIP010 Transaction"
        /* 27 */, "Solana Transaction"
        /* 28 */, "Solana Token SPL-Token Transaction"
        /* 29 */, "Conflux Transaction"
        /* 30 */, "Conflux CRC20 Transaction"
        /* 31 */, "HEDARA Transaction"
        /* 32 */, "TRON Transaction"
        /* 33 */, "POLKADOT Transaction"
        /* 34 */, "COSMOS Transaction"
        /* 35 */, "COREUM Transaction"
        /* 36 */, "TEZOS Transaction"
        /* 37 */, "XTZ-FA Transaction"
        /* 38 */, "VECHAIN Transaction"
        /* 39 */, "VECHAIN ERC20 Transaction"
        /* 40 */, "NEAR Transaction"
        /* 41 */, "NEAR Token Transaction"
        /* 42 */, "HAVAH Transaction"
        /* 43 */, "HSP20 Transaction"
        /* 44 */, "XRP with unsigned Tx Transaction"
        /* 45 */, "KLAY Token(KRC20) Transaction"
    ]
    
    @IBAction func SendCommand(_ sender: Any) {
        // Check Device State
        let current = DcentMgr.connectedDevice()
        if current == nil {
            print("Device Disconnected !!")
            return
        }

        switch pickerSelectedCmdIdx {
            case 0: GetDeviceInfoTest(); break
            case 1: SetLabelTest(); break
            case 2: SetLabelNTest(); break
            case 3: GetAccountInfoTest(); break
            case 4: SyncAccountTest(); break
            case 5: GetExtractPublicKeyTest(); break
            case 6: GetAddressTest(); break
            case 7: GetAddressCoreumTest(); break
            case 8: GetAddressTezosTest(); break
            case 9: EthereumMessageSignTest(); break
            case 10: BitcoinTransactionTest(); break
            case 11: EthereumTransactionTest(); break
            case 12: XrpTransactionTest(); break
            case 13: MonacoinTransactionTest(); break
            case 14: RSKTransactionTest(); break
            case 15: RRC20TransactionTest(); break
            case 16: ERC20TransactionTest(); break
            case 17: KlaytnTransactionTest(); break
            case 18: BinanceTransactionTest(); break
            case 19: StellarTransactionTest(); break
            case 20: EtherCahinTransactionTest(); break
            case 21: XDCTransactionTest(); break
            case 22: CardanoTransactionTest(); break
            case 23: PolygonTransactionTest(); break
            case 24: EthereumTypedTransactionTest(); break
            case 25: StacksTransactionTest(); break
            case 26: SIP010TransactionTest(); break
            case 27: SolanaTransactionTest(); break
            case 28: SPLTokenTransactionTest(); break
            case 29: ConfluxTransactionTest(); break
            case 30: CRC20TransactionTest(); break
            case 31: HederaTransactionTest(); break
            case 32: TronTransactionTest(); break
            case 33: PolkadotTransactionTest(); break
            case 34: CosmosTransactionTest(); break
            case 35: CoreumTransactionTest(); break
            case 36: TezosTransactionTest(); break
            case 37: XtzFaTransactionTest(); break
            case 38: VechainTransactionTest(); break
            case 39: VechainERC20TransactionTest(); break
            case 40: NearTransactionTest(); break
            case 41: NearTokenTransactionTest(); break
            case 42: HavahTransactionTest(); break
            case 43: HSP20TransactionTest(); break
            case 44: XRPWithUnsigedTxTest(); break
            case 45: KRC20TransactionTest(); break
            default: break
        }
    }
}
