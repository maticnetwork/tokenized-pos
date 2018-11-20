# Tokenzied proof-of-stake

Rough draft for Proof-of-Stake Stake Manager. **Don't use it in production.**

On staking, the staker gets an ERC721 token, which is `minted` in the `stakeFor` function. Upon `unstaking` the funds, the ERC721 token is burnt.

This can be used to sell the staking slot to other willing parties via 0x or other exchange mechanisms. This token could also be used as collateral for a CDO (collateralized debt obligation), on say Dharma.

### Installation

```
$ npm install
```

### Test-cases

```
$ npm run embark:test
```
