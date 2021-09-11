// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";
import "./BigInt.sol";

// Thin wrapper contract around BigInt for testing
contract TestBigInt {
  using BigInt for bigint;

  constructor() {
  }

  function fromUint(uint x) public pure returns (bigint memory r) {
    return BigInt.fromUint(x);
  }

  function lt(bigint memory _a, bigint memory _b) public pure returns (bool) {
    return BigInt.lt(_a, _b);
  }

  function mul(bigint memory _a, uint256 b) public pure returns (bigint memory r) {
    return BigInt.mul(_a, b);
  }

  function sub(bigint memory _a, bigint memory _b) public pure returns (bigint memory r) {
    return BigInt.sub(_a, _b);
  }

  function add(bigint memory _a, bigint memory _b) public pure returns (bigint memory r) {
    return BigInt.add(_a, _b);
  }

  function limb(bigint memory _a, uint _limb) public pure returns (uint) {
    return BigInt.limb(_a, _limb);
  }

}