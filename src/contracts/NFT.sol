// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyNFT is ERC721Enumerable, Ownable {
    using Strings for uint256;

    // Base URI
    string private _baseTokenURI;

    // Maximum supply
    uint256 private constant _maxSupply = 10000;

    // Starting index
    uint256 private _startingIndex = 1;

    constructor(string memory baseTokenURI) Ownable(msg.sender) ERC721("Dummy NFTs", "DNFT") {
        _baseTokenURI = baseTokenURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function mint(uint256 numTokens) public payable {
        require(totalSupply() + numTokens <= _maxSupply, "Exceeds maximum supply");
        require(msg.value >= numTokens * 0.01 ether, "Ether value sent is below the price");

        for (uint256 i = 0; i < numTokens; i++) {
            uint256 tokenId = _startingIndex + totalSupply();
            require(!_tokenExists(tokenId), "Token ID already exists");
            _safeMint(msg.sender, tokenId);
        }
    }

    function _tokenExists(uint256 tokenId) internal view returns (bool) {
        return ownerOf(tokenId)!=address(0);
    }


    // Owner function to withdraw ETH from the contract
    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
