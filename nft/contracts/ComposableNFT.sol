// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract ComposableNFT is ERC721Enumerable {
    using Strings for uint256;

    string private sourceDir;
    string private chainId;

    mapping(uint256 => uint256) composeIdBitmap;
    mapping(string => uint256) tokenIdIndex;
    uint256 private _nextTokenId;
    uint256 traitSize;
    uint256 valueSize;

    constructor(
        string memory name,
        string memory symbol,
        address _sourceDir,
        uint256 _chainId,
        uint256 _traitSize,
        uint256 _valueSize
    ) ERC721(name, symbol) {
        sourceDir = Strings.toHexString(uint160(_sourceDir), 20);
        chainId = Strings.toString(_chainId);
        traitSize = _traitSize;
        valueSize = _valueSize;
    }

    function mintTo(address receiver) public virtual returns (uint256) {
        uint256 newItemId = _nextTokenId;
        _mint(receiver, newItemId);
        uint256 composeId = genId(receiver, newItemId);
        setComposeIdUsed(composeId);
        tokenIdIndex[newItemId.toString()] = composeId;
        _nextTokenId += 1;
        return newItemId;
    }

    function compose(string memory tokenIdSvg) public view returns (bytes memory) {
        require(bytes(tokenIdSvg).length > 4, "invalid token ID");
        string memory tokenId = trimSuffix(tokenIdSvg);
        return _compose(tokenId);
    }

    function _compose(string memory tokenId) internal view returns (bytes memory) {
        uint256 composeId = tokenIdIndex[tokenId];
        bytes memory images = bytes("");

        for (uint256 trait = 0; trait < traitSize; trait++) {
            uint256 value = composeId % valueSize;
            bytes memory imageUrl = abi.encodePacked(
                "https://", sourceDir, ".", chainId, ".w3link.io/", trait.toString(), "/", value.toString(), ".png"
            );

            images = abi.encodePacked(images, '<image xlink:href="', imageUrl, '" width="1080" height="1080"/>');
            composeId /= valueSize;
        }
        return abi.encodePacked(
            '<svg viewBox="0 0 1080 1080" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">',
            images,
            "</svg>"
        );
    }

    function genId(address receiver, uint256 itemId) private view returns (uint256) {
        uint256 sampleSpace = valueSize ** traitSize;
        uint256 randNonce = 0;
        uint256 composeId =
            uint256(keccak256(abi.encodePacked(block.timestamp, receiver, itemId, randNonce))) % sampleSpace;
        while (isComposeIdUsed(composeId)) {
            randNonce++;
            composeId = uint256(keccak256(abi.encodePacked(block.timestamp, receiver, itemId, randNonce))) % sampleSpace;
        }
        return composeId;
    }

    function trimSuffix(string memory fileName) public pure returns (string memory) {
        bytes memory srcBytes = bytes(fileName);
        uint256 endIndex = srcBytes.length - 4;
        bytes memory idBytes = new bytes(endIndex);
        for (uint256 i = 0; i < endIndex; i++) {
            idBytes[i] = srcBytes[i];
        }
        return string(idBytes);
    }

    function isComposeIdUsed(uint256 id) private view returns (bool) {
        uint256 wordIndex = id / 256;
        uint256 bitIndex = id % 256;
        uint256 word = composeIdBitmap[wordIndex];
        uint256 mask = (1 << bitIndex);
        return word & mask == mask;
    }

    function setComposeIdUsed(uint256 id) private {
        uint256 wordIndex = id / 256;
        uint256 bitIndex = id % 256;
        composeIdBitmap[wordIndex] = composeIdBitmap[wordIndex] | (1 << bitIndex);
    }
}
