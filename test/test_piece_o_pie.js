const { expect } = require("chai");
const { ethers } = require("hardhat");

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

        let uri = await piece.tokenURI(testItems[testItems.length - 1]);

        // console.log("uri is", uri)

    });
});
