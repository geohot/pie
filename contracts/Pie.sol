// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

contract Pie {
  int256 q;
  int256 r;
  int256 t;
  int256 k;
  int256 n;
  int256 l;

  constructor() {
    q = 1;
    r = 0;
    t = 1;
    k = 1;
    n = 3;
    l = 3;
  }

  // see test.py
  function computeDigit() external returns (int256 ret) {
    while (true) {
      //console.log("here", uint256(q), uint256(r));
      //console.log(uint256(t), uint256(k), uint256(n), uint256(l));
      if ((4*q+r-t) < (n*t)) {
        ret = n;
        int256 nr = 10*(r-n*t);
        n = ((10*(3*q+r))/t)-10*n;
        q *= 10;
        r = nr;
        // mint NFT
        console.log(uint256(ret));
        return ret;
      } else {
        n = (q*(7*k)+2+(r*l))/(t*l);
        r = (2*q+r)*l;
        q *= k;
        t *= l;
        l += 2;
        k += 1;
      }
    }
  }

}