const { expect } = require("chai");
const { ethers } = require("hardhat");
const  { PI } = require("./pi");

describe("Pie", function () {
  it("Pie digits should be correct", async function () {
    const Pie = await ethers.getContractFactory("Pie");
    const pie = await Pie.deploy();
    await pie.deployed();

    for (var i = 0; i < 50; i++) {

      // First call method so that the compted digit is returned
      let computedDigit = await pie.callStatic.computeDigit();
      expect(computedDigit.toString()).is.equal(PI.slice(i, i+1));

      //Now transact method so state mutates
      let d = await pie.computeDigit();
      let r = await ethers.provider.getTransactionReceipt(d.hash);
      //console.log(r.gasUsed.toString());


    }
  });

});
