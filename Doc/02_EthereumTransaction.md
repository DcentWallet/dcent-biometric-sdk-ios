# EthereumTransaction

**Parameter**

| Name           | Type       | Description                                                                       |
| -------------- | ---------- | --------------------------------------------------------------------------------- |
| addressPath    | `String` | sign key path for ethereum transaction                                            |
| nonce          | `String` | account nonce for ethereum transaction                                            |
| to             | `String` | recipient's address of ethereum transaction                                       |
| amount         | `String` | amount of ether to be sent. ( wei unit value )                                   |
| gasLimit       | `String` | gas limit value of ethereum transaction                                           |
| gasPrice       | `String` | gas price for ethereum transaction                                                |
| data           | `String` | transaction data of ethereum transaction                                          |
| chainId        | `String` | chain id                                                                          |
| symbol         | `String` | symbol for ethereum transaction<br />symbol value used for evm chain (`.CHAN`) |
| txType         | `String` | (optional)Type of ethereum transaction                                            |
| maxPriorityFpg | `String` | (optional)max_priority_fpg of ethereum transaction                                |
| maxFeePerGas   | `String` | (optional)max_fee_per gas of ethereum transaction                                 |
| accessList     | `String` | (optional)access_list of ethereum transaction                                     |
