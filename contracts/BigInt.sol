// https://docs.soliditylang.org/en/v0.8.0/contracts.html
library BigInt {
  struct bigint {
    uint[] limbs;
  }

  function fromUint(uint x) internal pure returns (bigint memory r) {
    r.limbs = new uint[](1);
    r.limbs[0] = x;
  }

  function add(bigint memory _a, bigint memory _b) internal pure returns (bigint memory r) {
    r.limbs = new uint[](max(_a.limbs.length, _b.limbs.length));
    uint carry = 0;
    for (uint i = 0; i < r.limbs.length; ++i) {
      uint a = limb(_a, i);
      uint b = limb(_b, i);
      r.limbs[i] = a + b + carry;
      if (a + b < a || (a + b == 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff && carry > 0))
        carry = 1;
      else
        carry = 0;
    }
    if (carry > 0) {
      // too bad, we have to add a limb
      uint[] memory newLimbs = new uint[](r.limbs.length + 1);
      uint i;
      for (i = 0; i < r.limbs.length; ++i)
        newLimbs[i] = r.limbs[i];
      newLimbs[i] = carry;
      r.limbs = newLimbs;
    }
  }

  function limb(bigint memory _a, uint _limb) internal pure returns (uint) {
    return _limb < _a.limbs.length ? _a.limbs[_limb] : 0;
  }

  function max(uint a, uint b) private pure returns (uint) {
    return a > b ? a : b;
  }
}
