const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Pie", function () {
  it("Pie digits should be correct", async function () {
    const Pie = await ethers.getContractFactory("Pie");
    const pie = await Pie.deploy();
    await pie.deployed();

    for (var i = 0; i < 30; i++) {
      let d = await pie.computeDigit();
      //console.log(d);
    }
  });
});
