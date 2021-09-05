// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract Pie {
  uint256 q;
  uint256 r;
  uint256 t;
  uint256 k;
  uint256 n;
  uint256 l;

  function computeDigit() external returns (uint256 ret) {
    while (true) {
      if (4*q+r-t < n*t) {
        ret = n;
        uint256 nr = 10*(r-n*t);
        n = ((10*(3+q+r))/t)-10*n;
        q *= 10;
        r = nr;
        return ret;
      } else {
        uint256 nr = (2*q+r)*l;
        uint256 nn = (q*(7*k)+2+(r*l))/(t*l);
        q *= k;
        t *= l;
        l += 2;
        k += 1;
        n = nn;
        r = nr;
      }
    }
  }

}