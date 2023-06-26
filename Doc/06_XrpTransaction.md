# XrpTransaction

**Parameter**

| Name               | Type       | Description                                                                 |
| ------------------ | ---------- | --------------------------------------------------------------------------- |
| addressPath        | `String` | sign key path for xrp transaction                                           |
| sourceAddress      | `String` | Source address of xrp transaction                                           |
| destinationAddress | `String` | Destination addresse of xrp transaction                                     |
| amount             | `UInt64` | Amount to be send ( Drops unit value)                                       |
| fee                | `UInt64` | Fee of this transaction ( Drops unit value)                                 |
| sequence           | `UInt32` | The sequence number, relative to the initiating account, of xrp transaction |
| destinationTag     | `UInt64` | Destination tag of xrp transaction                                          |
