pragma solidity ^0.4.24;

import { SafeMath } from "openzeppelin-solidity/contracts/math/SafeMath.sol";
import { ERC20 } from "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

import { Validator } from "./Validator.sol";
import { IStakeManager } from "./IStakeManager.sol";


contract StakeManager is IStakeManager, Validator {
  using SafeMath for uint256;

  //
  // Storage
  //

  struct ValidatorState {
    uint256 id;
    uint256 epoch;
    uint256 amount;
    uint256 reward;
    uint256 activationEpoch;
    uint256 deactivationEpoch;
    address signer;
  }

  // validators
  mapping(uint256 => ValidatorState) validators;

  uint256 constant public VALIDATOR_THRESHOLD = 128;
  uint256 constant public DYNASTY = 2**13;  // unit: epoch
  uint256 constant public MIN_DEPOSIT_SIZE = (10**18);  // in ERC20 token
  uint256 constant public EPOCH_LENGTH = 256; // unit: child block
  uint256 constant public UNSTAKE_DELAY = DYNASTY.mul(2); // unit: epoch

  uint256 public counter = 1; // token id > 0
  uint256 public totalStaked = 0;
  uint256 public currentEpoch = 1;
  ERC20 public token;

  //
  // Events
  //

  event Staked(address indexed user, uint256 indexed validatorId, uint256 currentEpoch);
  event Unstaked(address indexed user, uint256 indexed validatorId, uint256 currentEpoch);
  event InitUnstake(address indexed user, uint256 indexed validatorId, uint256 currentEpoch);
  event SignerChanged(address indexed newSigner, address indexed oldSigner, uint256 indexed validatorId, address sender);

  constructor(string _name, string _symbol, address _tokenAddress) public Validator(_name, _symbol) {
    require(_tokenAddress != address(0x0));
    token = ERC20(_tokenAddress);
  }

  // only staker
  modifier onlyStaker(uint256 validatorId) {
    require(ownerOf(validatorId) == msg.sender);
    _;
  }

  function stake(uint256 amount) public {
    stakeFor(msg.sender, amount);
  }

  function stakeFor(address user, uint256 amount) public {
    // transfer tokens
    require(token.transferFrom(msg.sender, this, amount));

    // signer address
    address signer = user;

    // mint token
    mint(counter, user);

    // validator state
    ValidatorState memory validatorState = ValidatorState({
      id: counter,
      epoch: currentEpoch,
      amount: amount,
      reward: 0,
      activationEpoch: currentEpoch.add(1),
      deactivationEpoch: 0,
      signer: signer
    });

    // increment counter
    counter = counter.add(1);

    // emit staked event
    emit Staked(user, validatorState.id, currentEpoch);

    // update total stake
    totalStaked = totalStaked.add(amount);
  }

  function initUnstake(uint256 validatorId) public onlyStaker(validatorId) {
    // check if already unstake
    require(validators[validatorId].deactivationEpoch > 0);

    // start activation period
    validators[validatorId].deactivationEpoch = currentEpoch.add(UNSTAKE_DELAY);

    // initialize unstake
    emit InitUnstake(msg.sender, validatorId, currentEpoch);
  }

  function unstake(uint256 validatorId) public onlyStaker(validatorId) {
    // check if unstake is already initiated
    require(validators[validatorId].deactivationEpoch >= currentEpoch);

    // emit unstake
    emit Unstaked(msg.sender, validatorId, currentEpoch);

    // burn validator
    burn(validatorId);

    // update total stake
    totalStaked = totalStaked.sub(validators[validatorId].amount);

    // distribute rewards
    if (validators[validatorId].reward > 0) {
      token.transfer(msg.sender, validators[validatorId].reward);
    }
  }

  function changeSigner(uint256 validatorId, address newSigner) public onlyStaker(validatorId) {
    // check if new signer is valid
    require(newSigner != address(0));

    // emit event on signer change
    emit SignerChanged(newSigner, validators[validatorId].signer, validatorId, msg.sender);

    // change signer
    validators[validatorId].signer = newSigner;
  }

  // function submitEpochMock(uint256 newEpoch) public {
  //   currentEpoch = newEpoch;
  // }
}
