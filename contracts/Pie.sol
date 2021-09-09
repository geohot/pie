// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";
import "./BigInt.sol";

contract Pie {
  using BigInt for bigint;

  uint256 k;
  // TODO: replace with bigints
  bigint p0;
  bigint q0;
  bigint p1;
  bigint q1;

  constructor() {
    p0 = BigInt.fromUint(0);
    q0 = BigInt.fromUint(1);
    p1 = BigInt.fromUint(4);
    q1 = BigInt.fromUint(1);
    k = 1;
  }
  
  // bigint needs (add, sub, mul, cmp)

  // see test.py
  function computeDigit() external returns (uint256 ret) {
    while (true) {
      uint256 d0 = 0;
      uint256 d1 = 0;
      // these need to be bigints
      bigint memory r0 = p0;
      bigint memory r1 = p1;
      while (q0.lt(r0)) { r0 = r0.sub(q0); d0 += 1; }
      while (q1.lt(r1)) { r1 = r1.sub(q1); d1 += 1; }

      if (d0 == d1) {
        // polarity here doesn't matter
        p0 = r0.mul(10);
        p1 = r1.mul(10);
        console.log(d1);
        return d1;
      } else {
        uint256 x = k * k;
        k += 1;
        uint256 y = 2 * k - 1;

        // bignumber math
        if ((k%2) == 0) {
          p0 = p0.mul(x).add(p1.mul(y));
          q0 = q0.mul(x).add(q1.mul(y));
        } else {
          p1 = p1.mul(x).add(p0.mul(y));
          q1 = q1.mul(x).add(q0.mul(y));
        }
      }

    }
  }

}