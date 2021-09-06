// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

contract Pie {
  uint256 k;
  // TODO: replace with bigints
  uint256 p0;
  uint256 q0;
  uint256 p1;
  uint256 q1;

  constructor() {
    p0 = 0;
    q0 = 1;
    p1 = 4;
    q1 = 1;
    k = 1;
  }
  
  // bigint needs (add, sub, mul, cmp)

  // see test.py
  function computeDigit() external returns (uint256 ret) {
    while (true) {
      uint256 d0 = 0;
      uint256 d1 = 0;
      // these need to be bigints
      uint256 r0 = p0;
      uint256 r1 = p1;
      while (r0 > q0) { r0 -= q0; d0 += 1; }
      while (r1 > q1) { r1 -= q1; d1 += 1; }

      if (d0 == d1) {
        // polarity here doesn't matter
        p0 = 10 * r0;
        p1 = 10 * r1;
//        console.log(d1);
        return d1;
      } else {
        uint256 x = k * k;
        k += 1;
        uint256 y = 2 * k - 1;

        // bignumber math
        if ((k%2) == 0) {
          p0 = x * p0;
          p0 += y * p1;
          q0 = x * q0;
          q0 += y * q1;
        } else {
          p1 = x * p1;
          p1 += y * p0;
          q1 = x * q1;
          q1 += y * q0;
        }
      }

    }
  }

}