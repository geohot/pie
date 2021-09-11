// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Base64.sol";
import "./Pie.sol";

contract PieceOPie is Pie, ERC721Enumerable, ReentrancyGuard {

    constructor() ERC721("PieceOPie", "PIE") {
    }

    function appendDigit(uint256 original, uint256 toAppend) internal pure returns (uint256) {
        return original * 10 + toAppend;
    }

    function mint() public nonReentrant {

        uint256 nextDigits = this.computeDigit();

        while (_exists(nextDigits)) {
            nextDigits = appendDigit(nextDigits, this.computeDigit());
        }

        _safeMint(_msgSender(), nextDigits);
    }

    function getText(uint256 tokenId) private pure returns (string memory) {
        return Strings.toString(tokenId);
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string[3] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: monospace; font-size: 60px; }</style><rect width="100%" height="100%" fill="black" /><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" class="base">';

        parts[1] = getText(tokenId);

        parts[2] = '</text></svg>';

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2]));

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Piece #', Strings.toString(tokenId), '", "description": "PieceOPie - distributing Pieces of Pie on the Blockchain Since 2021", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }
}
