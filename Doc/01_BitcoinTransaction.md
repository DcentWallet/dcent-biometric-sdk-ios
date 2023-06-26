# BitcoinTransaction

**Parameter**

| Name        | Type                           | Description                                                                                                         |
| ----------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| version     | `UInt32`                     | version of bitcoin transaction. Currently 1<br />-` BCH` /`Dash`/`BTG `:  `2 `<br />- `ZCASH `: `4` |
| input       | [`UnspentTransactionOutput`](#unspenttransactionoutput) | previous transaction output information to be used                                                                  |
| output      | [`TransactionOutput`](#transactionoutput)        | coin spending information                                                                                           |
| locktime    | `UInt32`                     | locktime for this transaction                                                                                       |
| optionParam | `String`                     | (optional)option parameter for this transaction in case `ZCASH`                                                   |


# UnspentTransactionOutput

The class for previous transaction output information to be used for bitcoin network transaction.

**Parameter**

| Name     | Type           | Description                                     |
| -------- | -------------- | ----------------------------------------------- |
| prev_tx  | `String`     | full of previous transaction data               |
| utxo_idx | `UInt32`     | index of previous transaction output to be sent |
| type     | [`BtcTxtype`](#btctxtype) | bitcoin transaction type for this UTXO          |
| key      | `String`     | BIP44 key path for unlocking UTX                |


# TransactionOutput

The class for coin spending information of Bitcoin network Transaction

**Parameter**

| Name  | Type           | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ----- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| value | `UInt64`     | amount of coin to spend. Satoshi unit.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| to    | `[String]`   | if `type` is `p2pkh` or `p2sh`, Base58Check encoded address of the receiver.<br />The value of the field may follow the rule of version prefix.(`BITCOIN_BASE58CHECK`)<br />if the type is `p2pk `, Base58Check encoded non-compressed public key without version prefix.<br />if the type is `multisig `, Base58Check encoded non-compressed public key (without version prefix) list.<br />if the type is `change `, BIP44 formatted PATH to get change address. In this case, the transaction type is assumed as `p2pkh` |
| type  | [`BtcTxtype`](#btctxtype) | bitcoin network transaction type or this field can indicate output as a `change`                                                                                                                                                                                                                                                                                                                                                                                                                                                          |


# BtcTxtype

Defines Transaction type of Bitcoin or Monacoin

* `p2Pkh`: pay to public key hash
* `p2Pk`: pay to public key
* `p2Sh`: pay to script hash
* `change`: indicate output as a change
