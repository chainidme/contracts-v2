# Identity Contracts


## Attributes

`function addAttribute(bytes attribute)`

`function revokeAttribute(bytes attribute, address from)`

`function verifyAttribute(bytes attribute, address from) view`

## Verifiable Credentials

`function issueCredential(bytes credential, address to)`

`function revokeCredential(uint credentialID)`

`function verifyCredential(uint credentialID, address to) view`

## Staking Identities
`function stake(bytes identity, uint4 rating)`

Stake an identity to your identity on a scale of 1-5 based to relationship to your account
| Relation Type | Rating |
| ----- | ----- |
| No Relation | 0 |
| Low Relation | 1-3 |
| Moderately Close Relation | 4-6 |
| Close Relation | 7-10 |

`function unstake(bytes identity)`

Unstake identity from your identity

## Delegation

`function delegate(bytes signature, bytes data, address contract, address to)`

hash(to, contract_address, data)

`function revokeDelegation(signature)`

## Multi Signature
Owner of this identity
`function addOwner(address owner, uint newQuorum)`
