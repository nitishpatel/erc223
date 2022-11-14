// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC223.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC223Mintable is ERC223Token, Ownable {
  constructor(
    string memory new_name,
    string memory new_symbol,
    uint8 new_decimals
  ) ERC223Token(new_name, new_symbol, new_decimals) {}

  function mint(address to, uint256 value) public onlyOwner {
    _mint(to, value);
  }

  function burn(address from, uint256 value) public onlyOwner {
    _burn(from, value);
  }
}
