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

describe("PieceOPie", function () {
    it("Should give out the right pieces", async function () {
        const PieceOPice = await ethers.getContractFactory("PieceOPie");
        const piece = await PieceOPice.deploy();
        await piece.deployed();

        let testItems = [3, 1, 4, 15, 9, 2, 6, 5, 35, 8, 97, 93];

        for (let i = 0; i < testItems.length; i++) {
            let pTx = await piece.mint();
            await pTx.wait();
            let pid = await piece.tokenByIndex(i);
            expect(pid).to.equal(testItems[i])
        }

        let uri = await piece.tokenURI(testItems.length - 1);

        console.log("uri is", uri)

    });
});
