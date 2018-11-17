// /*global contract, config, it, assert*/

const ERC20Mock = require("Embark/contracts/ERC20Mock")
const StakeManager = require("Embark/contracts/StakeManager")

let accounts

// For documentation please see https://embark.status.im/docs/contracts_testing.html
config(
  {
    //deployment: {
    //  accounts: [
    //    // you can configure custom accounts with a custom balance
    //    // see https://embark.status.im/docs/contracts_testing.html#Configuring-accounts
    //  ]
    //},
    contracts: {}
  },
  (_err, web3_accounts) => {
    accounts = web3_accounts
  }
)

contract("StakeManager", function() {
  let stakeManager
  let erc20Token

  before(async function() {
    erc20Token = await ERC20Mock.deploy({}).send()
    stakeManager = await StakeManager.deploy({
      arguments: ["Stake manager", "STAKE", erc20Token.options.address]
    }).send()
  })

  it("should set constructor value", async function() {
    let token = await stakeManager.methods.token().call()
    assert.equal(token, erc20Token.options.address)
  })

  // TODO add more test cases
})
