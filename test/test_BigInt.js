const { expect } = require("chai");
const { ethers } = require("hardhat");

const bnArray = a => a.map(n => ethers.BigNumber.from(n));

const UINT256_MAX = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';

describe("BigInt", function () {
  let bi;

  before(async () => {
    const BigInt = await ethers.getContractFactory("TestBigInt");
    bi = await BigInt.deploy();
    await bi.deployed();
  });

  it("fromUint should work", async function () {

    let res = await bi.fromUint(0);
    expect(res.limbs).to.eql(bnArray([0]));

    res = await bi.fromUint(3);
    expect(res.limbs).to.eql(bnArray([3]));

    res = await bi.fromUint('123456765432123454377');
    expect(res.limbs).to.eql(bnArray(['123456765432123454377']));

  });

  it("lt should work", async function () {

    let res = await bi.lt([[4]],[[5]]);
    expect(res).to.equal(true);

    res = await bi.lt([[5]],[[4]]);
    expect(res).to.equal(false);

    res = await bi.lt([[4,3]],[[4,3]]);
    expect(res).to.equal(false);

    res = await bi.lt([[4,3]],[[3,4]]);
    expect(res).to.equal(true); //Little Endian-ish

    res = await bi.lt([[3,4]],[[4,3]]);
    expect(res).to.equal(false);

    res = await bi.lt([[4,3,0]],[[3,4]]);
    expect(res).to.equal(true); //Little Endian-ish

  });

  it("add should work", async function () {

    let res = await bi.add([[4]],[[5]]);
    expect(res.limbs).to.eql(bnArray([9]));

    res = await bi.add([[6]],[[5]]);
    expect(res.limbs).to.eql(bnArray([11])); //We're in base uint256 not base 10

    res = await bi.add([[1,6]],[[3,6]]);
    expect(res.limbs).to.eql(bnArray([4,12]));

    res = await bi.add([[1,6,0,0]],[[3,6,0,0,0,0]]);
    expect(res.limbs).to.eql(bnArray([4,12,0,0,0,0]));

    res = await bi.add([[6]],[[UINT256_MAX]]);
    expect(res.limbs).to.eql(bnArray([5,1])); //Little Endian-ish

    res = await bi.add([[UINT256_MAX]],[[6]]);
    expect(res.limbs).to.eql(bnArray([5,1])); //Test for commutative behavior

  });

  it("sub should work", async function () {

    let res = await bi.sub([[7]],[[3]]);
    expect(res.limbs).to.eql(bnArray([4]));

    res = await bi.sub([[5,5]],[[3]]);
    expect(res.limbs).to.eql(bnArray([2,5]));

    res = await bi.sub([[5,5,0,0]],[[3,0]]);
    expect(res.limbs).to.eql(bnArray([2,5,0,0]));

    res = await bi.sub([[5,5,5]],[[0, 3]]);
    expect(res.limbs).to.eql(bnArray([5, 2, 5]));

    let lsb = ethers.BigNumber.from(UINT256_MAX).sub(2);

    res = await bi.sub([[5,5]],[[8,1]]);
    expect(res.limbs).to.eql(bnArray([lsb, 3]));


  });

  it("mul should work", async function () {

    let res = await bi.mul([[7]],3);
    expect(res.limbs).to.eql(bnArray([21]));

    res = await bi.mul([[5,9]],3);
    expect(res.limbs).to.eql(bnArray([15,27]));

    res = await bi.mul([[5,9,0]],3);
    expect(res.limbs).to.eql(bnArray([15,27,0]));

    let lsb = ethers.BigNumber.from(UINT256_MAX).sub(2);

    res = await bi.mul([[UINT256_MAX]],3);
    expect(res.limbs).to.eql(bnArray([lsb,2]));  //Uint256 equiv of 9*3=27

  });

  it("limb should work", async function () {
    let res = await bi.limb([[7]],0);
    expect(res.toNumber()).to.eql(7);

    res = await bi.limb([[7,3]],0);
    expect(res.toNumber()).to.eql(7);

    res = await bi.limb([[7,3]],1);
    expect(res.toNumber()).to.eql(3);

    res = await bi.limb([[7,3]],2);
    expect(res.toNumber()).to.eql(0);

  });

});

