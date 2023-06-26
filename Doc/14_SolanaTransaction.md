# SolanaTransaction

**Parameter**

| Name        | Type       | Description                                                                                                                                                                                                                  |
| ----------- | ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| key         | `String` | sign key path for stacks transaction                                                                                                                                                                                        |
| signHash    | `String` | transaction that has not been signed of stacks transaction                                                                                                                                                                   |
| fee         | `String` | transaction fee of stacks transaction<br />* fee value is configured in solana(SOL) unit                                                                                                                                    |
| symbol      | `String` | transaction symbol of stacks transaction                                                                                                                                                                                     |
| decimals    | `UInt32` | transaction decimals of stacks transaction                                                                                                                                                                                   |
| optionParam | `String` | (optional)hexadecimal value of the token method type is used only in spl token<br />- '01' : assert transfer<br />- '02' : token stake<br />- '03' + amount(8bytes) : for dapp (amount value is configured in lamport unit) |
