const { expect } = require("chai");
const { ethers } = require("hardhat");
import {BigNumber} from "ethers";

const bnArray = a => a.map(n => BigNumber.from(n));

describe("BigInt", function () {
  let bi;

  before(async () => {
    const BigInt = await ethers.getContractFactory("TestBigInt");
    bi = await BigInt.deploy();
    await bi.deployed();
  })

  // it("fromUint should work", async function () {
  //
  //   let res = await bi.fromUint(3);
  //
  //   expect(res).to.equal([3]);
  //
  //   // let res = await bi.add([[4]],[[5]]);
  //
  //   console.log(res.toString())
  // });

  it("add should work", async function () {

    let res = await bi.add([[1,2]],[[3,4]]);

    // let res = await bi.add([[4]],[[5]]);

    console.log(res.limbs[0].toString())
  });

  it("sub should work", async function () {

    let res = await bi.sub([[1,5]],[[3,4]]);

    // let res = await bi.add([[4]],[[5]]);

    console.log(res.limbs[0].toString())
  });
});

