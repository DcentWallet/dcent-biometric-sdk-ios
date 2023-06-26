# KlaytnTransaction

**Parameter**

| Name        | Type       | Description                                                                                    |
| ----------- | ---------- | ---------------------------------------------------------------------------------------------- |
| addressPath | `String` | sign key path for klaytn transaction                                                           |
| nonce       | `String` | account nonce for klaytn transaction                                                          |
| to          | `String` | recipient's address of klaytn transaction                                                      |
| amount      | `String` | amount of ether to be sent. ( wei unit value )                                                |
| gasLimit    | `String` | gas limit value of klaytn transaction                                                         |
| gasPrice    | `String` | gas price for klaytn transaction                                                               |
| data        | `String` | transaction data of klaytn transaction                                                         |
| chainId     | `UInt32` | chain id                                                                                       |
| from        | `String` | (optional) Signer's Address of klaytn transaction                                              |
| tx_type     | `UInt8`  | (optional) Type of klaytn transaction<br />The default value is `KlaytnType.LEGACY.rawValue` |
| fee_ratio   | `UInt32` | (optional)Fee Ratio of klaytn transaction                                                      |



# KlatytnType

Defines Transaction type of Klaytn (refer to [klaytn doc](https://docs.klaytn.foundation/content/dapp/json-rpc/api-references/klay/transaction/transaction-type-support))

* `LEGACY`
* `VALUE_TRANSFER`
* `FEE_DELEGATED_VALUE_TRANSFER`
* `FEE_DELEGATED_VALUE_TRANSFER_WITH_RATIO`
* `VALUE_TRANSFER_MEMO`
* `FEE_DELEGATED_VALUE_TRANSFER_MEMO`
* `FEE_DELEGATED_VALUE_TRANSFER_MEMO_WITH_RATIO`
* `SMART_CONTRACT_DEPLOY`
* `FEE_DELEGATED_SMART_CONTRACT_DEPLOY`
* `FEE_DELEGATED_SMART_CONTRACT_DEPLOY_WITH_RATIO`
* `SMART_CONTRACT_EXECUTION`
* `FEE_DELEGATED_SMART_CONTRACT_EXECUTION`
* `FEE_DELEGATED_SMART_CONTRACT_EXECUTION_WITH_RATIO`
* `CANCEL`
* `FEE_DELEGATED_CANCEL`
* `FEE_DELEGATED_CANCEL_WITH_RATIO` 
* `FEE_PAYER`
