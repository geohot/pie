const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Pie", function () {
  it("Pie digits should be correct", async function () {
    const Pie = await ethers.getContractFactory("Pie");
    const pie = await Pie.deploy();
    await pie.deployed();

    for (var i = 0; i < 50; i++) {
      let d = await pie.computeDigit();
      let r = await ethers.provider.getTransactionReceipt(d.hash);
      //console.log(r.gasUsed.toString());
    }
  });
});
