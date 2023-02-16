// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract WearableNFT is ERC721("Wearable", "Wearable"), Ownable {
    struct metadata {
        uint256 traitIndex;
        uint256 valueIndex;
    }
    
    mapping(uint256 => metadata) public metadatas;

    function mint(address to, uint256 tokenId, uint256 traitIndex, uint256 valueIndex) public onlyOwner {
        metadatas[tokenId].traitIndex = traitIndex;
        metadatas[tokenId].valueIndex = valueIndex;
        _safeMint(to, tokenId);
    }

    function tokenURI(uint256 tokenId) public override view returns (string memory) {
        return string(
            abi.encodePacked(
                "https://0x31bc4dad21fad6212082c7953379bb62187ffe94.w3q-g.w3link.io/", 
                Strings.toString(metadatas[tokenId].traitIndex), "/",
                Strings.toString(metadatas[tokenId].valueIndex), ".png"
            )
        );
    }
}