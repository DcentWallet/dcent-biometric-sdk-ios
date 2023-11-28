[![Swift 5](https://img.shields.io/badge/Swift-5-blue.svg)](https://developer.apple.com/swift/)

# dcent-biometric-sdk-ios

This is D'CENT Biometric iOS SDK. This SDK allows your application to quickly create an wallet application using D'CENT biometric wallet.

## Requirements

* Xcode 12.0 or later
* iOS 12.0 or later
* Swift 5.0 or later

**Permission**

To use DcentBiometric, you must add blutooth permission to the 'info.plist'

![image](https://github.com/IotrustGitHub/dcent-biometric-sdk-ios/assets/96401185/56512eed-5116-40aa-836a-ab266b51582c)

**Note: External Library**

> [SwiftProtobuf](https://cocoapods.org/pods/SwiftProtobuf), [BigInt](https://cocoapods.org/pods/BigInt)

To install external library, simply add the following line to your Podfile:

```ruby
# Pods for DcentBiometric
pod 'SwiftProtobuf'
pod 'BigInt', '~> 5.0'
```

# User Start Guide

## Setup

Developers can develop wallet application using our iOS sdk. The wam.framework is our sdk framework file.

1. Copy DcentBiometric.framework to your iOS application project
2. Click on Project Navigator ( 1 in the below image).
3. Select Targets ( 2 in the below image).
4. Select General ( 3 in the below image).
5. Click on '+'' Button (4 in below image).
6. Select framework DcentBiometric.framework
   ![image](https://github.com/DcentWallet/dcent-biometric-sdk-ios/assets/96401185/9bb4fabf-2f4a-49b3-9863-ee47609658d5)

8. Including Frameworks in Your Project

```swift
import DcentBiometric
```

## Usage

Please Refer to the `DcentBiometricSample` directory to learn more about how to use the SDK APIs. There is an iOS project using our iOS SDK.

### DcentManager initialize

class DcentManager provides functions for using D'CENT Biometric Wallet. First, you must initialize DcentManager. D'CENT Biometric will be connected with your iOS application using BLE. Your application implements DcentBLEManagerDelegate protocol for receiving BLE connect/disconnect event.

```swift
extension DeviceSearchViewController:DcentBLEManagerDelegate {

    func dcentBleManager(didDiscover device: BleDeviceInfo) {
        // TODO: add your code
    }

    func dcentBleManager(didConnect device: BleDeviceInfo) {
        // TODO: add your code
    }

    func dcentBleManager(didDisconnect device: BleDeviceInfo?) {
        // TODO: add your code
    }

    func dcentBleManager(didFailToConnect device: BleDeviceInfo?) {
        // TODO: add your code
    }

    func dcentBleManager(didUpdate status: DcentBleManagerState) {
        // TODO: add your code
    }
}
```

Call func delegate(delegate:DcentBLEManagerDelegate) function for register delegate implements DcentBLEManagerDelegate protocol.

```swift
  let dcentMgr:DcentManager = DcentManager()
  dcentMgr.delegate = self
```

DcentManager provides(for ble connection):

- `public func searchDeviceStart()`
- `public func searchDeviceStop()`
- `public func getDeviceList() -> BleDeviceInfo`
- `public func connectDevice(to device: BleDeviceInfo)`
- `public func disconnectDevice(from device: BleDeviceInfo)`
- `public func connectedDevice() -> BleDeviceInfo?`

ios app developers can connect DCENT dongle through bluetooth using these functions. ( Please refer to the sample application to learn more details )


### getDeviceInfo

Get the information about the current connected D'CENT biometric wallet device.

**Parmeters**

* None

**Returns**

- deviceId : device unique identifier
- label : label of the device
- fwVersion : firmware version of the device
- ksmVersion : KSM(software running on SE) version of the device
- coinList : the list of coin which the device supported

**Example**

```swift
// Get connected dcent device information
let DevInfo = DcentMgr.getDeviceInfo()
if let deviceInfo = DevInfo {
    print(deviceInfo.label)
    print(deviceInf.deviceID)
    print(deviceInf.fwVersion)
    print(deviceInf.ksmVersion)
    print(deviceInfo.state)
    print(deviceInfo.coinList)
}
```

### setDeviceLabel

Set the label name to the D'CENT biometric wallet.(If you reboot your D'CENT, you can see the label name.)

After execute above code, you can see the modified label on your device when reboot the device.

**Parmeters**

* newLabel : (String) the label name of D'CENT biometric wallet

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred

**Example**

```swift
DcentMgr.setDeviceLabel(newLabel: "Label"){ (result)  in
  if result {
    ///
    print("Success !!!")
  } else {
    ///
    print("Fail !!!")
  }
}
```

### SyncAccount

Create or update accounts on the network. You can create an account by specifying the coin type and key path of the account you want to add.
If you want to add token type coin account, you must specify the coin name as the first 14 digits of contract address.
If the account of the specified key path is already exist, the syncAccount() method do not create account just sync the account information. For example, if you want to change the label of account or modify the balance, you can use the syncAccount() method.

But the `syncAccount()` method is not used only for creating account. If the account of the specified key path is already exist, the `syncAccount()` method do not create account just sync the account information. For example, if you want to change the label of account or modify the balance, you can use the `syncAccount()` method.

**(※ As of firmware version 2.9.2 or later, the D'CENT biometric wallet device does not support updating the balance.)**

**Parmeters**

* account: SynAccount object to be synced (The SynAccount object is configured as follows.)
  * coinGroup: account coin group
  * coinName: account coin name
  * label: account label
  * addressPath: key path of account
  * balance: balance of account

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred

**Example**

```swift
// account label
let labelOfAccount = "bitcoin_1"
// balance of account. This string will be displayed on device.
let balanceOfAccount = "0 BTC"
// key path of the account
let keyPath = "m/44'/0'/0'/0/0/"

// Bitcoin account will be created.
if let syncAccount = SyncAccount( coinGroup: "BITCOIN", coinName:"BITCOIN", label:labelOfAccount, addressPath:keyPath, balance: balanceOfAccount ) {
  dcentMgr.syncAccount(account: syncAccount){ (result)  in
    if result {
      ///
      print("Success !!!")
    } else {
      ///
      print("Fail !!!")
    }
  }

}
```

### getAccountInfo

Get the list of current accounts in the D'CENT biometric wallet.

**Paremeters**

* None

**Returns**

- result: (Bool) `true` if successful, `false` if error occurred
- accountInfos: Account object list (The Account object is configured as follows.)
  - label : label of account
  - coinGroup : coin group name of account
  - coinName : coin name of account
  - receivingAddressPath : address path of account

**Example**

```swift
DcentMgr.getAccountInfo(){ (result, accountInfos) in   
  if result {
    ///
    print("Success !!!")
    if let accounts = accountInfos {

    }
  } else {
    ///
    print("Fail !!!")
  }
}
```

### getAddress

Get the address of CoinType and BIP44 Key Path.

**Parameters**

* coinType: coin type
* addressPath: key path to get address

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* address: address
* pubkey: public key value(pubkey exists only when the coinType is `.TEZOS` , `.XTZ_FA`, `.TEZOS_TESTNET` and `.XTZ_FA_TESTNET`)

**Example**

```swift
// key path of the account
let keyPath = "m/44'/0'/0'/0/0/"
DcentMgr.getAddress(coinType: .BITCOIN, addressPath: keyPath) { (result, address, pubkey) in
    if result {
        ///
        print("success")
        print("address >> " + address)
    }
    else {
        print("fail")
    }
}
```

### requestExtractPublicKey

Get a extract public key of BIP44 Key Path or BIP0032 master key

**Parameters**

* KeyPath: key path to extract public key

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* publickey: extract public key

**Example**

```swift
// Hardened key path
let keyPath = "m/44'/0'"
DcentMgr.requestExtractPublicKey( KeyPath: keyPath) { (result, publickey) in
    if result {
        ///
        print("success")
        print("public key  >> " + publickey)
    }
    else {
        print("fail")
    }
}
```

### getMessageSign

Get the sign value of "EVM" message sign(personal_sign & signTypedData).

**This Function for:**

* `.ETHEREUM` - ethereum (ETH)
* `.ETH_CLASSIC` - ethereum classic (ETC). ??
* `.ETH_KOVAN` - ethereum kovan (ETHt)
* `.ETH_ROPSTEN` - ethereum ropsten (ETHt)
* `.ETH_GOERLI` - ethereum goerli (ETHt)
* `.ETH_RINKEBY` - ethereum rinkeby (ETHt)
* `.FLR_COSTON` - flare network coston (CFLR) ??
* `.RSK` - rsk smart bitcoin (RBTC)
* `.RSK_TESTNET` - rsk smart bitcoin testnet (RBTCt)
* `.XDC` - xcd network (XDC)
* `.XDC_APOTHEM` - xdc apothem (XDCt)
* `.BSC` - binance smart chain (BNB)
* `.BSC_TESTNET` - binance smart chain testnet (BNBt)
* `.POLYGON` - polygon (MATIC)
* `.POLYGON_TESTNET` - polygon testnet (MATICt)
* `.CHAN` - other evm networks
* `.KLAYTN` - klaytn mainnet (KLAY)
* `.KLAYTN_TESTNET` - klaytn baobab (KLAYt)

**Parameters**

* coinType: EVM coin type
* messageSign: ([MessageSign](./Doc/00_MessageSign.md#messagesign))evm message sign data parameter
* isFull: (Bool) `true` for personal sign or the_sign of EVM  / `false` for signTypedDatt(EIP-721) of EVM

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* addr: the address used to sign the data
* sign: signed data

**Example**

```swift
let messageSign : MessageSign = MessageSign(message: "sign TEST!!", key: "m/44'/60'/0'/0/0")
DcentMgr.getMessgaeSign(coin: .ETHEREUM, messageSign: messageSign, isFull: false) { (result, addr, sign) in
    if result == false {
        print("FAIL !!!")
    }else{
        print(addr)
	print(sign)
    }
}
```

### Sign Transaction

The D'CENT iOS SDK provides functions for signing transaction of coins.

#### getBitcoinSignedTransaction

**This Function for:**

* `.BITCOIN` - bitcoin (BTC)
* `.BITCOIN_SV` - bitcoin sv (BSV)
* `.BTC_SEGWIT` - bitcoin segwit (BTC)
* `.MONACOIN` - monacoin (MONA)
* `.LITECOIN` - litecoin (LTC)
* `.LTC_SEGWIT` - litecoin segwit (LTC)
* `.ZCASH` - zcash (ZEC)
* `.HORIZEN` - horizen (ZEN)
* `.BITCOINCASH` - bitcoin cash (BCH)
* `.DOGECOIN` - dogecoin (DOGE)
* `.BCH_ABC` - bitcoin cash abc (BCHA)
* `.ECASH` - ecash (XEC)
* `.DASH` - dash (DASH)
* `.BITCOIN_GOLD` - bitcoin gold (BTG)
* `.DIGIBYTE` - digibyte (DGB)
* `.DGB_SEGWIT` - digibyte segwit (DGB)
* `.RAVENCOIN` - ravencoin (RVN)
* `.BTC_TESTNET` - bitcoin testnet (BTCt)
* `.BTC_SEGWIT_TESTNET` - bitcoin segwit testnet (BTCt)
* `.MONA_TESTNET` - monacoin testnet (MONAt)
* `.LITE_TESTNET` - litecoin testnet (tLTC)
* `.LTC_SEGWIT_TESTNET` - litecoin segwit testnet (tLTC)
* `.ZCASH_TESTNET` - zcash testnet (TAZ)
* `.BCH_TESTNET` - bitcoin cash testnet (tBCH)
* `.DASH_TESTNET` - dash testnet (tDASH)
* `.BTG_TESTNET` - bitcoin gold testnet (tBTG)
* `.DIGIBYTE_TESTNET` - digibyte testnet (tDGB)
* `.DGB_SEGWIT_TESTNET` - digibyte segwit testnet (tDGB)
* `.RVN_TESTNET` - ravencoin testnet (tRVN)

**Parameters**

* coinType: bitcoin networks coin type
* bitcoinTransaction: ([BitcoinTransation](./Doc/01_BitcoinTransaction.md#bitcointransaction))bitcoin transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Example**

```swift
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
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getEthereumSignedTransaction

**This Function for:**

* `.ETHEREUM` - ethereum (ETH)
* `.ETH_CLASSIC` - ethereum classic (ETC)
* `.ETH_KOVAN` - ethereum kovan (ETHt)
* `.ETH_ROPSTEN` - ethereum ropsten (ETHt)
* `.ETH_GOERLI` - ethereum goerli (ETHt)
* `.ETH_RINKEBY` - ethereum rinkeby (ETHt)
* `.FLR_COSTON` - flare network coston (CFLR)
* `.RSK` - rsk smart bitcoin (RBTC)
* `.RSK_TESTNET` - rsk smart bitcoin testnet (RBTCt)
* `.XDC` - xcd network (XDC)
* `.XDC_APOTHEM` - xdc apothem (XDCt)
* `.BSC` - binance smart chain (BNB)
* `.BSC_TESTNET` - binance smart chain testnet (BNBt)
* `.POLYGON` - polygon (MATIC)
* `.POLYGON_TESTNET` - polygon testnet (MATICt)
* `.CHAN` - other evm networks

**Parameters**

* coinType: ethereum networks coin type
* ethereumTransaction: ([EthereumTransation](./Doc/02_EthereumTransaction.md#ethereumtransaction))ethereum transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* Refer to "[D`CENT Firmware Update History]()" to determine which D'CENT Biometric Wallet Versions ar supported on each network.

**Example**

```swift
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
    print("Ethereum Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getKlaytnSignedTransaction

**This Function for:**

* `.KLAYTN` - klaytn (KLAY)
* `.KLAYTN_TESTNET` - kalytn baobab (KLAYt)

**Parameters**

* coinType: klaytn networks coin type
* kalytnTransaction: ([KlaytnTransation](./Doc/04_KlaytnTransaction.md#klaytntransaction))klaytn transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Example**

```swift
let klaytnTransaction : KlaytnTransaction = KlaytnTransaction(addressPath: "0", nonce: "", to: "", amount: "", gasLimit: "", gasPrice: "", data: "", chainId: 0)
  
// test data (legacy)
klaytnTransaction.addressPath = "m/44'/8217'/0'/0/0"
klaytnTransaction.nonce = "8"
klaytnTransaction.to = "0xe5c23dAa6480e45141647E5AeB321832150a28D4"
klaytnTransaction.amount = "60000000000000000"
klaytnTransaction.gasLimit = "25000"
klaytnTransaction.gasPrice = "25000000000"
klaytnTransaction.data = ""
klaytnTransaction.chainId = "1001"
  
DcentMgr.getKlaytnSignedTransaction(coinType:.KLAYTN, klaytnTransaction:klaytnTransaction){ (result, txData) in
    print("Klaytn Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getTokenSignedTransaction

**This Function for:**

* `.ERC20` - ethereum erc20 token
* `.ETC_ERC20` - ethereum classic erc20 token
* `.ERC20_KOVAN` - ethereum kovan erc20 token(ETH
* `.ERC20_ROPSTEN` - ethereum ropsten erc20 token
* `.ERC20_GOERLI` - ethereum goerli erc20 token
* `.ERC20_RINKEBY` - ethereum rinkeby erc20 token
* `.FLR20_COSTON` - flare network coston token
* `.RRC20` - rsk smart bitcoin rrc20 token
* `.RRC20_TESTNET` - rsk smart bitcoin testnet rrc20 token
* `.XRC20` - xcd network xrc20 token
* `.XRC20_APOTHEM` - xdc apothem xrc20 token
* `.BEP20` - binance smart chain bep20 token
* `.BEP20_TESTNET` - binance smart chain testnet bep20 token
* `.POLYGON_ERC20` - polygon erc20 token
* `.POLY_ERC20_TEST` - polygon testnet erc20 token
* `.CH20` - other evm networks erc20 token

**Parameters**

* coinType: erc20 type
* tokenTransaction: ([TokenTransation](./Doc/03_TokenTransaction.md#tokentransaction))erc20 token transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* Refer to "[D`CENT Firmware Update History]()" to determine which D'CENT Biometric Wallet Versions ar supported on each network.

**Example**

```swift
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
  
DDcentMgr.getTokenSignedTransaction(coinType:.ERC20, tokenTransaction:erc20Transaction){ (result, txData) in
    print("ERC20 Token Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getKlaytnBasedTokenTransaction

**This Function for:**

* `.KLAYTN_ERC20` - klaytn erc20 token (krc20)
* `.KRC20_TESTNET` - kalytn testnet erc20 token

**Parameters**

* coinType: ethereum networks coin type
* tokenTransaction: ([KlaytnTokenTransation](./Doc/05_KlaytnTokenTransaction.md#klaytntokentransaction))klaytn token transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Example**

```swift
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
krc20Transaction.tx_type = KlaytnType.FEE_DELEGATED_SMART_CONTRACT_EXECUTION.rawValue
krc20Transaction.fromAddr = "0x689dfa2C77335722f333EeA102ba8A5E13d2AD1a"
krc20Transaction.fee_ratio = 0
krc20Transaction.tokenName = "BAOBABTOKEN"
krc20Transaction.decimals = 8
krc20Transaction.tokenSymbol = "BAO"  

DcentMgr.getKlaytnBasedTokenTransaction(coinType: .KLAYTN_ERC20, tokenTransaction: krc20Transaction){ (result, txData) in
    print("Klaytn token Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getXrpSignedTransaction

**This Function for:**

* `.XRP` - xrpl (XRP)
* `.XRP_TA` - xrp ta
* `.XRP_TESTNET` - xrpl testnet (XRPt)
* `.XRP_TA_TESTNET` - xrp ta testnet

**Parameters**

* coinType: xrp networks coin type
* xrpTransaction: ([XrpTransation](./Doc/06_XrpTransaction.md#xrptransaction))xrp transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Example**

```swift
let xrpTransaction : XrpTransaction = XrpTransaction(addressPath: "", sourceAddress: "", destinationAddress: "", amount: 0, fee: 0, sequence: 0, destinationTag: 0 )
  
// test data
xrpTransaction.addressPath = "m/44'/144'/0'/0/0"
xrpTransaction.sourceAddress = "rsHXBk5vnswg5SZxUQCEPYVnmrd4PaZ7Ah"
xrpTransaction.destinationAddress = "rsHXBk5vnswg5SZxUQCEPYVnmrd4PaZ7Ah"
xrpTransaction.amount = 2
xrpTransaction.fee = 10
xrpTransaction.sequence = 11
xrpTransaction.destinationTag = 0
  
DcentMgr.getXrpSignedTransaction(coinType:.XRP, xrpTransaction:xrpTransaction){ (result, txData) in
    print("XRP Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getXrpSignedTransactionWithUnsignedTx

**This Function for:**

* `.XRP` - xrpl (XRP)
* `.XRP_TA` - xrp ta
* `.XRP_TESTNET` - xrpl testnet (XRPt)
* `.XRP_TA_TESTNET` - xrp ta testnet

**Parameters**

* coinType: xrp networks coin type
* xrpTransaction: ([XrpTransationWithUnsigedTx](./Doc/07_XrpTransactionWithUnsigndTx.md))xrp transaction with unsiged tx parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* coinType: xrp networks coin type
* sign: signed transaction
* pubkey: public key used to signed transaction
* accountId: xrp transaction accountId

**Example**

```swift
let xrpTransaction : XrpTransactionWithUnsigedTx = XrpTransactionWithUnsigedTx(addressPath: "m/44'/144'/0'/0/0", unsigned: "1200002280000000240238634E2E00000000201B023863E161400000000098968068400000000000000A8114FD970F4612987680F4008BA53ED6FD87BE0DAAF983141DEE2154B117FB47FCF4F19CD983D9FCBB894FF7")
  
DcentMgr.getXrpSignedTransactionWithUnsignedTx(coinType: .XRP, xrpTransaction: xrpTransaction)  { (result, coinType, sign, pubkey, accoutId)  in
    print("XRP Transaction with unsigned Tx closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(coinType)
	print(sign)
	print(pubkey)
	print(accountId)
    }
}
```

#### getBinanceSignedTransaction

**This Function for:**

* `.BINANCE` - binance (BNB)
* `.BEP2` - binacne token
* `.BNB_TESTNET` - binance testnet (BNB)
* `.BEP2_TESTNET` - binacne testnet token

**Parameters**

* coinType: binance networks coin type
* binacneTransaction: ([BinanceTransation](./Doc/08_BinanceTransaction.md))binacne transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* D'CENT Biometric Wallet Version 1.9.2 or higher is required.

**Example**

```swift
let binanceTransaction : BinanceTransaction = BinanceTransaction(std_sign_doc: "", key: "", fee: "")
  
// test data
binanceTransaction.std_sign_doc = "7b226163636f756e745f6e756d626572223a22343834303237222c22636861696e5f6964223a2242696e616e63652d436861696e2d546967726973222c2264617461223a6e756c6c2c226d656d6f223a22222c226d736773223a5b7b22696e70757473223a5b7b2261646472657373223a22626e62317a7a34647634767235687a3076647161686334707371797a39676a303974703775646d673273222c22636f696e73223a5b7b22616d6f756e74223a313030303030302c2264656e6f6d223a22424e42227d5d7d5d2c226f757470757473223a5b7b2261646472657373223a22626e6231796d33377164616e76716b72686139636b70686a6b3067336d6630367068656d33787a393437222c22636f696e73223a5b7b22616d6f756e74223a31303030303030303030302c2264656e6f6d223a22424e42227d5d7d5d7d5d2c2273657175656e6365223a2230222c22736f75726365223a2230227d"
binanceTransaction.key = "m/44'/714'/0'/0/0"
binanceTransaction.fee = "375000"
  
DcentMgr.getBinanceSignedTransaction(coinType: .BINANCE, binanceTransaction: binanceTransaction){ (result, txData) in
    print("Binance Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getStellarSignedTransaction

**This Function for:**

* `.STELLAR` - stellar (XLM)
* `.STELLAR_TA`
* `.XLM_TESTNET` - stellar testnet (XLMt)
* `.XLM_TA_TESTNET`

**Parameters**

* coinType: stellar networks coin type
* stellarTransaction: ([StellarTransation](./Doc/09_StellarTransaction.md))stellar transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* D'CENT Biometric Wallet Version 2.1.0 or higher is required.

**Example**

```swift
let stellarTransaction : StellarTransaction = StellarTransaction(txXDR: "7ac33997544e3175d266bd022439b22cdb16508c01163f26e5cb2a3e1045a9790000000200000000d147b20efbeb51a8f8eea50f4ce1ad549796a509236c3cad056e22cf3e3e6f0b000000640005821d00000004000000010000000000000000000000005ec76b4a00000000000000010000000000000000000000005e3deafcf4bee3bf40a85e4f93bdf7d94e62a05e811ed787f9d04bc983ec207b0000000049504f8000000000", key: "m/44'/148'/0'")

DcentMgr.getStellarSignedTransaction(coinType: .STELLAR, stellarTransaction: stellarTransaction){ (result, txData) in
    print("stellar Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getTronSignedTransaction

**This Function for:**

* `.TRON` - tron (TRX)
* `.TRC_TOKEN` - tron token
* `.TRX_TESTNET` - tron testnet (tTRX)
* `.TRC_TESTNET` - tron testnet token

**Parameters**

* coinType: tron networks coin type
* tronTransaction: ([TronTransation](./Doc/10_TronTransaction.md))tron transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* D'CENT Biometric Wallet Version 2.2.2 or higher is required.

**Example**

```swift
let tronTransaction : TronTransaction = TronTransaction(txData: "0a02610a220838507457b79561a740e8dd8fefaf2e5a65080112610a2d747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e5472616e73666572436f6e747261637412300a15418f2d2dfaa81af60f5a3ac4ca5597e795aff7abae121541c27dcd7d914fd6aa8fec3c8a41cb2e90883bc6f0187f70dd978cefaf2e", key: "m/44'/195'/0'/0/0", fee: "0.00262")
  
  
DcentMgr.getTronSignedTransaction(coinType: .TRON, tronTransaction: tronTransaction) { (result, txData) in
    print("Tron Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getCardanoSignedTransaction

**This Function for:**

* `.CARDANO` - cardano (ADA)
* `.CARDANO_TESTNET` - cardano testnet (ADAt)

**Parameters**

* coinType: cardano networks coin type
* cardanoTransaction: ([CardanoTransation](./Doc/11_CardanoTransaction.md))cardano transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* D'CENT Biometric Wallet Version 2.7.0 or higher is required.

**Example**

```swift
let cardanoTransaction : CardanoTransaction = CardanoTransaction(unsigned: "a400818258209087b68d8f59dca2a29a3f5c03db7b162ba2607fa930f95996d12b1a570a84ef01018182583901b552fcf04820629ec73d54cd8cac3fccb4902d81f7801b65c654a490f122908efcb7fc3b457a83c4a1a50a7e7e919694fdc195d55c1a1b961a00297398021a00028911031a0185c2df", key: "m/44'/1815'/0'/0/0")

  
DcentMgr.getCardanoSignedTransaction(coinType: .CARDANO, cardanoTransaction: cardanoTransaction){ (result, txData) in
    print("Cardano Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getHederaSignedTransaction

**This Function for:**

* `.HEDERA` - hedera (HBAR)
* `.HEDERA_HTS` - hedera token
* `.HEDERA_TESTNET` - hedera testnet (HBARt)
* `.HTS_TESTNET` - hedera testnet token

**Parameters**

* coinType: hedera networks coin type
* hederaTransaction: ([HederaTransation](./Doc/12_HederaTransaction.md))hedera transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* D'CENT Biometric Wallet Version 2.13.0 or higher is required.

**Example**

```swift
let hederaTransaction : HederaTransaction = HederaTransaction(unsigned: "", key: "", symbol: "", decimals: "")
  
// test data
hederaTransaction.unsigned = "0a1a0a0c088dfbbc9006108885e6a90112080800100018d6c0151800120608001000180318c0843d22020878320072260a240a100a080800100018d6c01510ef8de29a030a100a080800100018f6a72810f08de29a03"
hederaTransaction.key = "m/44'/3030'/0'"
hederaTransaction.symbol = "HBAR"
hederaTransaction.decimals = "8"
  
DcentMgr.getHederaSignedTransaction(coinType: .HEDERA, hederaTransaction: hederaTransaction) { (result, txData) in
    print("Hedera Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getStacksSignedTransaction

**This Function for:**

* `.STACKS` - stacks (STX)
* `.SIP010` - stacks token
* `.STACKS_TESTNET` - stacks testnet (STXt)
* `.SIP010_TESTNET` - stacks testnet token

**Parameters**

* coinType: stacks networks coin type
* stacksTransaction: ([StacksTransation](./Doc/13_StacksTransaction.md))stacks transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* D'CENT Biometric Wallet Version 2.14.1 or higher is required.
  * (for SIP010) 2.16.7 or higher is required.

**Example**

```swift
let stacksTransaction : StacksTransaction = StacksTransaction(key: "m/44'/5757'/0'/0/0", sigHash: "00000000010400b8d4c2dbab9a59837ca0892080d9395199b3fa9d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000302000000000005166c717c6701374d0db48dac262d1a85f906ae2d1e000000001ad2748031303638343134333900000000000000000000000000000000000000000000000000", authType: 4, fee: "0.12", nonce: "000000000000006c", symbol: "STX", decimals: 6, optionParam: "")
  
DcentMgr.getStacksSignedTransaction(coinType: .STACKS, stacksTransaction: stacksTransaction) { (result, txData) in
    print("Stacks Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getSolanaSignedTransaction

**This Function for:**

* `.SOLANA` - solana (SOL)
* `.SPL_TOKEN` - solana token

**Parameters**

* coinType: solana networks coin type
* solanaTransaction: ([SolanaTransation](./Doc/14_SolanaTransaction.md))solana transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* D'CENT Biometric Wallet Version 2.16.5 or higher is required.
  * (for spl-token) 2.17.1 or higher is required.

**Example**

```swift
let solanaTransaction : SolanaTransaction = SolanaTransaction(key: "m/44'/501'/0'", sigHash: "0100010350d8ec411526b2704c9e730e1b59a2fe128cd9b5b2939a5918c54a660612177d480cc32970400e125ed89752129793ab63d351326e0d5af0aed644233955e59c0000000000000000000000000000000000000000000000000000000000000000d87cf02a1cea0c26fe671ee2ca0cf8c1fa7db58f18ae158c5808eac974d855f601020200010c0200000000e1f50500000000", fee: "0.0000506", symbol: "SOL", decimals: 9, optionParam: "")

DcentMgr.getSolanaSignedTransaction(coinType: .SOLANA, solanaTransaction: solanaTransaction) { (result, txData) in
    print("Solana Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getConfluxSignedTransaction

**This Function for:**

* `.CONFLUX` - conflux (CRX)

**Parameters**

* coinType: conflux network coin type
* confluxTransaction: ([ConfluxTransation](./Doc/15_ConfluxTransaction.md))conflux transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* D'CENT Biometric Wallet Version 2.18.3 or higher is required.

**Example**

```swift
let confluxTransaction : ConfluxTransaction = ConfluxTransaction(nonce: "0", gasPrice: "1", gas: "53000", to: "cfx:aath39ukgygwae5jnhuj1z02vkkc68wsu62j5spdng", amount: "499993640000000000000", storageLimit: "0", epochHeight: "57744640", chainId: "1029", addressPath: "m/44'/60'/0'/0/0")
  
DcentMgr.getConfluxSignedTransaction(coinType: .CONFLUX, confluxTransaction: confluxTransaction) { (result, txData) in
    print("Conflux Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getCRC20TokenSignedTransaction

**This Function for:**

* `.CFX_CRC20` - conflux token

**Parameters**

* coinType: conflux token coin type
* tokenTransaction: ([ConfluxCrc20Transation](./Doc/16_CRC20Transaction.md))conflux token transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* D'CENT Biometric Wallet Version 2.18.3 or higher is required.

**Example**

```swift
let crc20Transaction : CRC20TokenTransaction = CRC20TokenTransaction(nonce: "0", gasPrice: "1", gas: "53000", to: "cfx:acdeewzdr3cv7hvc12kdwp7gzysjaexz9jw7s1uaft", amount: "0", storageLimit: "0", epochHeight: "58463079", chainId: "1029", addressPath: "m/44'/60'/0'/0/0", tokenName: "IoTestCoin", contractAddress: "cfx:acdeewzdr3cv7hvc12kdwp7gzysjaexz9jw7s1uaft", toAddress: "cfx:aath39ukgygwae5jnhuj1z02vkkc68wsu62j5spdng", decimals: "18", value: "5000000000000000000", tokenSymbol:"ITC")
  
DcentMgr.getCRC20TokenSignedTransaction(coinType: .CFX_CRC20, tokenTransaction: crc20Transaction) { (result, txData) in
    print("Conflux token CRC20 Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getPolkadotSignedTransaction

**This Function for:**

* `.POLKADOT` - polkadot (DOT)

**Parameters**

* coinType: polkadot networks coin type
* polkadotTransaction: ([PolkadotTransation](./Doc/17_PolkadotTransaction.md))polkadot transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* D'CENT Biometric Wallet Version 2.19.1 or higher is required.

**Example**

```swift
let polkadotTransaction : PolkadotTransaction = PolkadotTransaction(sigHash: "040000163a5ee36b1243ce5241c0a45010dd1717869e9918c040bf5d305be4a5af9e7a0b00407a10f35a003400a223000007000000e143f23803ac50e8f6f8e62695d1ce9e4e1d68aa36c1cd2cfd15340213f3423ee143f23803ac50e8f6f8e62695d1ce9e4e1d68aa36c1cd2cfd15340213f3423e", key: "m/44'/354'/0'/0/0", fee: "0.0000000005", decimals: 12, symbol: "DOT", optionParam: "")
  
DcentMgr.getPolkadotSignedTransaction(coinType: .POLKADOT, polkadotTransaction: polkadotTransaction) { (result, txData) in
    print("Polkadot Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getCosmosSignedTransaction

**This Function for:**

* `.COSMOS` - cosmos (ATOM)
* `.COREUM` - coreum (CORE)

**Parameters**

* coinType: cosmos networks coin type
* cosmosTransaction: ([CosmosTransation](./Doc/18_CosmosTransaction.md))cosmos transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* D'CENT Biometric Wallet Version 2.21.0 or higher is required.
  * (for COREUM) 2.25.0 or higher is required.

**Example**

```swift
let cosmosTransaction : CosmosTransaction = CosmosTransaction(sigHash: "0a94010a8f010a1c2f636f736d6f732e62616e6b2e763162657461312e4d736753656e64126f0a2d636f736d6f73317235763573726461377866746833686e327332367478767263726e746c646a756d74386d686c122d636f736d6f733138766864637a6a7574343467707379383034637266686e64356e713030336e7a306e663230761a0f0a057561746f6d1206313030303030120012670a500a460a1f2f636f736d6f732e63727970746f2e736563703235366b312e5075624b657912230a21ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff12040a020801180a12130a0d0a057561746f6d12043530303010c09a0c1a0b636f736d6f736875622d34208f3a", key: "m/44'/118'/0'/0/0", fee: "0.00025", decimals: 6, symbol: "ATOM", optionParam: "")
  
DcentMgr.getCosmosSignedTransaction(coinType: .COSMOS, cosmosTransaction: cosmosTransaction) { (result, txData) in
    print("Binance Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getTezosSignedTransaction

**This Function for:**

* `.TEZOS` - tezos (XTZ)
* `.XTZ_FA` - tezos token
* `.TEZOS_TESTNET` - tezos testnet (XTZ)
* `.XTZ_FA_TESTNET` - tezos testnet token

**Parameters**

* coinType: tezos networks coin type
* tezosTransaction: ([TezosTransation](./Doc/19_TezosTransaction.md))tezos transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* D'CENT Biometric Wallet Version 2.23.1 or higher is required.
  * (for testnet) 2.24.1 or higher is required.

**Example**

```swift
let tezoseTransaction : TezosTransaction = TezosTransaction(sigHash: "032923211dc76b05a644c88df7507c6f2fd5100cb6ed11c236a270d97dbd53937c6c0021298384724bff62370492fbb56f408bf6f77bcfb905b8d6f804f51219a0e7010000678a5cb8807767a9d900311890526ad77bffbb3900", key: "m/44'/1729'/0'/0/0", fee: "0.000697", decimals: 6, symbol: "XTZ", optionParam: "")

DcentMgr.getTezosSignedTransaction(coinType: .TEZOS, tezosTransaction: tezoseTransaction) { (result, txData) in
    print("Binance Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getVechainSignedTransaction

**This Function for:**

* `.VECHAIN` - vechain (VET)
* `.VECHAIN_ERC20` - vechain token

**Parameters**

* coinType: vechain networks coin type
* vechainTransaction: ([VechainTransation](./Doc/20_VechainTransaction.md))vechain transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* D'CENT Biometric Wallet Version 2.23.2 or higher is required.

**Example**

```swift
let vechainTransaction : VechainTransaction = VechainTransaction(sigHash: "f83b2787c6143a04c08fe18202d0e1e094a57105e43efa47e787d84bb6dfedb19bdcaa8a908908e3f50b173c100001808082520880860152671166bdc0", key: "m/44'/818'/0'/0/0", fee: "0.21", decimals: 18, symbol: "VET", optionParam: "")

DcentMgr.getVechainSignedTransaction(coinType: .VECHAIN, vechainTransaction: vechainTransaction) { (result, txData) in
    print("Vechain Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getNearSignedTransaction

**This Function for:**

* `.NEAR` - near (NEAR)
* `.NEAR_TOKEN` - near token
* `.NEAR_TESTNET` - near testnet (NEARt)

**Parameters**

* coinType: near networks coin type
* nearTransaction: ([NearTransation](./Doc/21_NearTransaction.md))near transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* D'CENT Biometric Wallet Version 2.24.0 or higher is required.
  * (for near-token) 2.27.1 or higher is required.

**Example**

```swift
let nearTransaction : NearTransaction = NearTransaction(sigHash: "4000000033666164666339326631633631643261303138626166333738383566376633363331313439616331356163303438613263303137316566316661356139633366003fadfc92f1c61d2a018baf37885f7f3631149ac15ac048a2c0171ef1fa5a9c3f41b15753844300004000000033666164666339326631633631643261303138626166333738383566376633363331313439616331356163303438613263303137316566316661356139633366d5e91d9515257370e4763c0da089ca544c1292bd188ad3fee466e17024e941f40100000003000000a1edccce1bc2d3000000000000", key: "m/44'/397'/0'", fee: "0.000860039223625", decimals: 24, symbol: "NEAR", optionParam: "")

DcentMgr.getNearSignedTransaction(coinType: .NEAR, nearTransaction: nearTransaction) { (result, txData) in
    print("Near Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getHavahSignedTransaction

**This Function for:**

* `.HAVAH` - havah (HVH)
* `.HAVAH_HSP20` - havha token (HSP20)
* `.HAVAH_TESTNET` - havha testnet (HVH)
* `.HSP20_TESTNET` - binacne testnet token

**Parameters**

* coinType: havah networks coin type
* havahTransaction: ([HavahTransation](./Doc/23_HavahTransaction.md))havah transaction parameter

**Returns**

* result: (Bool) `true` if successful, `false` if error occurred
* txData: signed transaction

**Requirements**

* D'CENT Biometric Wallet Version 2.26.0 or higher is required.

**Example**

```swift
let havahTransaction : HavahTransaction = HavahTransaction(sigHash: "", key: "", fee: "", decimals: 0, symbol: "", optionParam: "")

// test data
havahTransaction.sigHash = "6963785f73656e645472616e73616374696f6e2e66726f6d2e6878316531333433353935303532383335613064396137643064396533353839633433323831623262642e6e69642e30783130302e6e6f6e63652e3078312e737465704c696d69742e307831616462302e74696d657374616d702e3078356661316631343633666161302e746f2e6878353833323164313731633833393465613434303638376562623462353832623037353739356663352e76616c75652e307833636235396163376237353734652e76657273696f6e2e307833"
havahTransaction.key = "m/44'/858'/0'/0/0"
havahTransaction.fee = "0.001375"
havahTransaction.decimals = 18 
havahTransaction.symbol = "HVH"
havahTransaction.optionParam = ""

DcentMgr.getHavahSignedTransaction(coinType: .HAVAH, havahTransaction: havahTransaction) { (result, txData) in
    print("Havah Transaction closure")
    if result == false {
        print("FAIL !!!")
    }else{
        print(txData)
    }
}
```

#### getAlgorandSignedTransaction
**This fuction for :**
* `ALGORAND`(ALGO)
* `ALGORAND_TESTNET`(ALGO)
* `ALGORAND_ASSET`
* `ALGORAND_ASSET_TESTNET`
* `ALGORAND_APP`
* `ALGORAND_APP_TESTNET`
**Parameters**
| Parameter   | Type                                                                                                              | Description                   |
| :---------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| coinType    | `CoinType`                                                                                                      | algorand coin type.              |
| transaction | [AlgorandTransaction](./doc/AlgorandTransaction.md) | algorand transaction parameters. |
**Returns**
* `String` - signed transaction.
**Requirements**
* D'CENT Biometric Wallet version 2.29.1 or higher is required.
**Example**
```java
String keyPath = "m/44'/283'/0'/0/0";
AlgorandTransaction algorandTransaction;
algorandTransaction = new AlgorandTransaction.Builder()
                    .keyPath(Bip44KeyPath.valueOf(keyPath))
                    .sigHash("54588aa3616d74cf000000174876e800a3666565cd03e8a26676ce01f60f1ca367656eac746573746e65742d76312e30a26768c4204863b518a4b3c84ec810f22d4f1081cb0f71f059a7ac20dec62f7f70e5093a22a26c76ce01f61304a46e6f7465c4084669727374205478a3726376c420568d5f7efc21a0928e50234dfa58764a84128d1c127971f6a26f350500d0ce24a3736e64c420302be92b2e5fb14e540554f3b652c0350fcc77ea53488fed81c97555179040c8a474797065a3706179")
                    .fee("0.001")
                    .decimals(6)
                    .symbol("ALGO")
                    .build();
String response = mDcentmanager.getAlgorandSignedTransaction(CoinType.ALGORAND, algorandTransaction);
```
