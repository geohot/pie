// https://docs.soliditylang.org/en/v0.8.0/contracts.html
// https://github.com/kokke/tiny-bignum-c
import "hardhat/console.sol";

struct bigint {
  uint[] limbs;
}

uint256 constant MAX_INT_TYPE = type(uint256).max;

library BigInt {

  function fromUint(uint x) internal pure returns (bigint memory r) {
    r.limbs = new uint[](1);
    r.limbs[0] = x;
  }
  
  function lt(bigint memory _a, bigint memory _b) internal view returns (bool) {
    uint limbs = max(_a.limbs.length, _b.limbs.length);
    uint i = limbs-1;
    while (true) {
      uint a = limb(_a, i);
      uint b = limb(_b, i);
      if (a < b) return true;
      if (a > b) return false;
      if (i == 0) break;
      --i;
    }
    return false;
  }

  function mul(bigint memory _a, uint256 b) internal pure returns (bigint memory r) {
    require(b <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    r.limbs = new uint[](_a.limbs.length);
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

  function sub(bigint memory _a, bigint memory _b) internal view returns (bigint memory r) {
      r.limbs = new uint[](max(_a.limbs.length, _b.limbs.length));
      uint borrow = 0;
      for (uint i = 0; i < r.limbs.length; ++i) {
        uint a = limb(_a, i);
        uint b = limb(_b, i) + borrow;
        if (a < b) {
          r.limbs[i] = MAX_INT_TYPE - (b - a) + 1;
          borrow = 1;
        } else {
          r.limbs[i] = a - b;
          borrow = 0;
      }
      // sub can't require a new limb
    }
  }

  function add(bigint memory _a, bigint memory _b) internal pure returns (bigint memory r) {
    r.limbs = new uint[](max(_a.limbs.length, _b.limbs.length));
    uint carry = 0;
    for (uint i = 0; i < r.limbs.length; ++i) {
      uint a = limb(_a, i);
      uint b = limb(_b, i) + carry;
      if (a > MAX_INT_TYPE - b || (a + b == 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff && carry > 0)) {
        r.limbs[i] = a - (MAX_INT_TYPE - b) - 1;
        carry = 1;
      } else {
        r.limbs[i] = a + b;
        carry = 0;
      }

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
