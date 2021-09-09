const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Test Blocks", function () {
  it("Deploy block contract", async function () {
    const Block = await ethers.getContractFactory("Block")
    const block = await Block.deploy()
    await block.deployed()

    const result = await ethers.provider.call({
      to: block.address
    })
    console.log(result)

  });
});