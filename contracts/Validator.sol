pragma solidity ^0.4.24;

import { ERC721Full } from "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import { ERC721Mintable } from "openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol";
import { ERC721Burnable } from "openzeppelin-solidity/contracts/token/ERC721/ERC721Burnable.sol";


contract Validator is ERC721Full, ERC721Mintable, ERC721Burnable {

  //
  // Storage
  //

  constructor(string _name, string _symbol) public ERC721Full(_name, _symbol) {

  }

  function mint(uint256 _tokenId, address _owner) internal {
    _mint(_owner, _tokenId);
  }

  function burn(address _owner, uint256 _tokenId) internal {
    _burn(_owner, _tokenId);
  }
}
