// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * This Code is Extended from Dexran's ERC223 Token Standard
 * All the Credits goes to Dexaran for the Original Code
 * You can find the Original Code here: https://github.com/Dexaran/ERC223-token-standard
 */

import "./utils/IERC223.sol";
import "./utils/IERC223Recipient.sol";
import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title Reference implementation of the ERC223 standard token.
 */
contract ERC223Token is IERC223 {
  string private _name;
  string private _symbol;
  uint8 private _decimals;
  uint256 private _totalSupply;

  mapping(address => uint256) public balances; // List of user balances.
  mapping(address => mapping(address => uint256)) private _allowances; // List of user allowances.

  /**
   * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
   * a default value of 18.
   *
   * To select a different value for {decimals}, use {_setupDecimals}.
   *
   * All three of these values are immutable: they can only be set once during
   * construction.
   */

  constructor(
    string memory new_name,
    string memory new_symbol,
    uint8 new_decimals
  ) {
    _name = new_name;
    _symbol = new_symbol;
    _decimals = new_decimals;
  }

  /**
   * @dev ERC223 tokens must explicitly return "erc223" on standard() function call.
   */
  function standard() public pure override returns (string memory) {
    return "erc223";
  }

  /**
   * @dev Returns the name of the token.
   */
  function name() public view override returns (string memory) {
    return _name;
  }

  /**
   * @dev Returns the symbol of the token, usually a shorter version of the
   * name.
   */
  function symbol() public view override returns (string memory) {
    return _symbol;
  }

  /**
   * @dev Returns the number of decimals used to get its user representation.
   * For example, if `decimals` equals `2`, a balance of `505` tokens should
   * be displayed to a user as `5,05` (`505 / 10 ** 2`).
   *
   * Tokens usually opt for a value of 18, imitating the relationship between
   * Ether and Wei. This is the value {ERC223} uses, unless {_setupDecimals} is
   * called.
   *
   * NOTE: This information is only used for _display_ purposes: it in
   * no way affects any of the arithmetic of the contract, including
   * {IERC223-balanceOf} and {IERC223-transfer}.
   */
  function decimals() public view override returns (uint8) {
    return _decimals;
  }

  /**
   * @dev See {IERC223-totalSupply}.
   */
  function totalSupply() public view override returns (uint256) {
    return _totalSupply;
  }

  /**
   * @dev Returns balance of the `_owner`.
   *
   * @param _owner   The address whose balance will be returned.
   * @return balance Balance of the `_owner`.
   */
  function balanceOf(address _owner) public view override returns (uint256) {
    return balances[_owner];
  }

  function allowance(
    address owner,
    address spender
  ) public view virtual override returns (uint256) {
    return _allowances[owner][spender];
  }

  /**
   * @dev Transfer the specified amount of tokens to the specified address.
   *      Invokes the `tokenFallback` function if the recipient is a contract.
   *      The token transfer fails if the recipient is a contract
   *      but does not implement the `tokenFallback` function
   *      or the fallback function to receive funds.
   *
   * @param _to    Receiver address.
   * @param _value Amount of tokens that will be transferred.
   * @param _data  Transaction metadata.
   */
  function transfer(
    address _to,
    uint _value,
    bytes calldata _data
  ) public override returns (bool success) {
    _transfer(msg.sender, _to, _value, _data);
    return true;
  }

  /**
   * @dev Transfer the specified amount of tokens to the specified address.
   *      This function works the same with the previous one
   *      but doesn't contain `_data` param.
   *      Added due to backwards compatibility reasons.
   *
   * @param _to    Receiver address.
   * @param _value Amount of tokens that will be transferred.
   */
  function transfer(
    address _to,
    uint _value
  ) public override returns (bool success) {
    bytes memory _empty = hex"00000000";
    _transfer(msg.sender, _to, _value, _empty);
    return true;
  }

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 amount
  ) internal virtual {}

  function _afterTokenTransfer(
    address from,
    address to,
    uint256 amount
  ) internal virtual {}

  function _mint(address account, uint256 amount) internal virtual {
    require(account != address(0), "ERC20: mint to the zero address");

    _beforeTokenTransfer(address(0), account, amount);

    _totalSupply += amount;
    unchecked {
      // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
      balances[account] += amount;
    }
    bytes memory _empty = hex"00000000";

    emit Transfer(address(0), account, amount);
    emit TransferData(_empty);

    _afterTokenTransfer(address(0), account, amount);
  }

  function _burn(address account, uint256 amount) internal virtual {
    require(account != address(0), "ERC20: burn from the zero address");

    _beforeTokenTransfer(account, address(0), amount);

    uint256 accountBalance = balances[account];
    require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
    unchecked {
      balances[account] = accountBalance - amount;
      // Overflow not possible: amount <= accountBalance <= totalSupply.
      _totalSupply -= amount;
    }
    bytes memory _empty = hex"00000000";

    emit Transfer(account, address(0), amount);
    emit TransferData(_empty);

    _afterTokenTransfer(account, address(0), amount);
  }

  function approve(
    address spender,
    uint256 amount
  ) public virtual override returns (bool) {
    address owner = msg.sender;
    _approve(owner, spender, amount);
    return true;
  }

  function _approve(
    address owner,
    address spender,
    uint256 amount
  ) internal virtual {
    require(owner != address(0), "ERC20: approve from the zero address");
    require(spender != address(0), "ERC20: approve to the zero address");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  function increaseAllowance(
    address spender,
    uint256 addedValue
  ) public virtual returns (bool) {
    address owner = msg.sender;
    _approve(owner, spender, allowance(owner, spender) + addedValue);
    return true;
  }

  function decreaseAllowance(
    address spender,
    uint256 subtractedValue
  ) public virtual returns (bool) {
    address owner = msg.sender;
    _approve(owner, spender, allowance(owner, spender) - subtractedValue);
    return true;
  }

  function _spendAllowance(
    address owner,
    address spender,
    uint256 amount
  ) internal virtual {
    uint256 currentAllowance = allowance(owner, spender);
    if (currentAllowance != type(uint256).max) {
      require(currentAllowance >= amount, "ERC20: insufficient allowance");
      unchecked {
        _approve(owner, spender, currentAllowance - amount);
      }
    }
  }

  function _transfer(
    address from,
    address to,
    uint256 amount,
    bytes memory data
  ) internal virtual {
    require(from != address(0), "ERC20: transfer from the zero address");
    require(to != address(0), "ERC20: transfer to the zero address");
    uint256 fromBalance = balances[from];
    require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");

    unchecked {
      balances[from] = fromBalance - amount;
      // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
      // decrementing then incrementing.
      balances[to] += amount;
    }
    if (Address.isContract(to)) {
      IERC223Recipient(to).tokenReceived(msg.sender, amount, data);
    }
    emit Transfer(from, to, amount);

    _afterTokenTransfer(from, to, amount);
  }

  function transferFrom(
    address from,
    address to,
    uint256 amount
  ) public virtual override returns (bool) {
    address spender = msg.sender;
    _spendAllowance(from, spender, amount);
    bytes memory _empty = hex"00000000";
    _transfer(from, to, amount, _empty);
    return true;
  }
}
