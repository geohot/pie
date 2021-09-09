// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// 21000 is the minimum for a transaction
contract Block is ERC721Enumerable, Ownable {
  event Waste();

  uint256 public constant MAX_NFT_SUPPLY = 100;

  constructor() ERC721("Blocks", "BLOCKS") {}

  function withdraw() public onlyOwner {
    payable(msg.sender).transfer(address(this).balance);
  }

  receive() external payable {
    uint startgas = gasleft();
    // confirm spend a lot of gas
    require((block.gaslimit-21000-1000) < startgas, "You have to spend all the gas!");
    // only 1000 blocks available
    require(totalSupply() < MAX_NFT_SUPPLY, "All blocks have been minted.");

    // debug
    console.log(block.gaslimit, startgas);
    
    // TODO: save NFT parameters

    // mint NFT
    _safeMint(msg.sender, totalSupply());

    // make many logs / waste any remaining gas
    while(gasleft() > 10000) { emit Waste(); }
    while(gasleft() > 999) {}
  }
}
