pragma solidity ^0.4.24;

import { StakeManager } from "../StakeManager.sol";

contract StakeManagerMock is StakeManager {
  function submitEpochMock(uint256 newEpoch) public {
    currentEpoch = newEpoch;
  }
}
