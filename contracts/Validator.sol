pragma solidity ^0.4.24;

import { ERC721Full } from "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import { ERC721Mintable } from "openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol";
import { ERC721Burnable } from "openzeppelin-solidity/contracts/token/ERC721/ERC721Burnable.sol";


contract Validator is ERC721Full {

  //
  // Storage
  //

  constructor(string _name, string _symbol) public ERC721Full(_name, _symbol) {

  }
}
