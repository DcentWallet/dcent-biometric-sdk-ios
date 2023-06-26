# KlaytnTokenTransaction

**Parameter**

| Name        | Type       | Description                                                                                      |
| ----------- | ---------- | ------------------------------------------------------------------------------------------------ |
| addressPath | `String` | sign key path for klaytn transaction                                                             |
| nonce       | `String` | account nonce for klaytn transaction                                                            |
| to          | `String` | recipient's address of klaytn transaction                                                        |
| amount      | `String` | amount of ether to be sent. ( wei unit value )                                                  |
| gasLimit    | `String` | gas limit value of klaytn transaction                                                           |
| gasPrice    | `String` | gas price for klaytn transaction                                                                 |
| data        | `String` | transaction data of klaytn transaction                                                           |
| chainId     | `UInt32` | chain id                                                                                         |
| tokenName   | `String` | token name of contract for `KLAYTN_ERC20` transaction                                          |
| decimals    | `UInt32` | decimals of contract for `KLAYTN_ERC20` transaction                                            |
| tokenSymbol | `String` | symbol of contract for `KLAYTN_ERC20` transaction                                              |
| from        | `String` | (optional) Signer's Address of klaytn transaction                                                |
| tx_type     | `UInt8`  | (optional) Type of klaytn transaction<br />The default value is[ `KlaytnType.LEGACY.rawValue`](./04_KlaytnTransaction.md#klatytntype) |
| fee_ratio   | `UInt32` | (optional)Fee Ratio of klaytn transaction                                                        |
