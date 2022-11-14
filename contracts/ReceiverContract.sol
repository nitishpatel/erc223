// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./utils/IERC223Recipient.sol";

contract ReceiverContract is IERC223Recipient {
  address public tokenAddress;
  address public owner;
  uint256 public lastTransactionCount = 0;

  //   Maintain a log of all the transactions
  struct Transaction {
    address sender;
    uint256 amount;
    uint256 timestamp;
  }
  Transaction[] public transactions;

  constructor(address _tokenAddress) {
    tokenAddress = _tokenAddress;
    owner = msg.sender;
  }

  function tokenReceived(
    address _from,
    uint256 _value,
    bytes memory _data
  ) public override {
    require(msg.sender == tokenAddress, "Only token contract can call this");
    // Do something with the tokens

    Transaction memory transaction = Transaction(
      _from,
      _value,
      block.timestamp
    );
    transactions.push(transaction);
    lastTransactionCount++;
  }

  function getAllTransactions() public view returns (Transaction[] memory) {
    return transactions;
  }
}
