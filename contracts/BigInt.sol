// https://docs.soliditylang.org/en/v0.8.0/contracts.html
// https://github.com/kokke/tiny-bignum-c

library BigInt {
  struct bigint {
    uint[] limbs;
  }

  function fromUint(uint x) internal pure returns (bigint memory r) {
    r.limbs = new uint[](1);
    r.limbs[0] = x;
  }
  
  function lt(bigint memory _a, bigint memory _b) internal pure returns (bool) {
    uint limbs = max(_a.limbs.length, _b.limbs.length);
    for (uint i = limbs-1; i >= 0; --i) {
      uint a = limb(_a, i);
      uint b = limb(_b, i);
      if (a < b) return true;
      if (a > b) return false;
    }
    return false;
  }

  function mul(bigint memory _a, uint256 b) internal pure returns (bigint memory r) {
    require(b <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    r.limbs = new uint[](_a.limbs.length+1);
    uint carry = 0;
    for (uint i = 0; i < r.limbs.length; ++i) {
      uint a = limb(_a, i);
      uint lower = (a & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) * b;
      uint upper = (a >> 128) * b;
      // TODO: this can overflow
      r.limbs[i] = lower + (upper << 128) + carry;
      carry = (upper >> 128);
    }
    if (carry > 0) {
      uint[] memory newLimbs = new uint[](r.limbs.length + 1);
      uint i;
      for (i = 0; i < r.limbs.length; ++i)
        newLimbs[i] = r.limbs[i];
      newLimbs[i] = carry;
      r.limbs = newLimbs;
    }
  }

  function sub(bigint memory _a, bigint memory _b) internal pure returns (bigint memory r) {
    r.limbs = new uint[](max(_a.limbs.length, _b.limbs.length));
    uint borrow = 0;
    for (uint i = 0; i < r.limbs.length; ++i) {
      uint a = limb(_a, i);
      uint b = limb(_b, i);
      r.limbs[i] = a - b + borrow;
      if (a - b > a)
        borrow = 1;
      else
        borrow = 0;
    }
    // sub can't require a new limb
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
