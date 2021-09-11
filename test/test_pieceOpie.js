const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PieceOPie", function () {
  // this.timeout(0);

  let piece;

  before(async () => {
    const PieceOPice = await ethers.getContractFactory("PieceOPie");
    piece = await PieceOPice.deploy();
    await piece.deployed();

  });

  let testItems = [3, 1, 4, 15, 9, 2, 6, 5, 35, 8, 97, 93];

  it("Should give out the right pieces", async function () {

    for (let i = 0; i < testItems.length; i++) {
      let pTx = await piece.mint();
      await pTx.wait();
      let pid = await piece.tokenByIndex(i);
      expect(pid).to.equal(testItems[i])
    }

    let uri = await piece.tokenURI(testItems[testItems.length - 1]);

    // console.log("uri is", uri)

  });

  // //Doesn't make it :(
  // it("Should give right pieces for at least 1000 NFTs", async function () {
  //
  //   for (let i = testItems.length; i < 1100; i++) {
  //     let pTx = await piece.mint();
  //     await pTx.wait();
  //     let pid = await piece.tokenByIndex(i);
  //
  //     let r = await ethers.provider.getTransactionReceipt(pTx.hash);
  //     expect(r.gasUsed.toNumber()).is.below(15_000_000); //Current mainnet gas limit
  //     console.log(`#${i}, digits: ${pid.toString()} gas: ${r.gasUsed.toNumber()}`)
  //   }
  //
  // });
});
