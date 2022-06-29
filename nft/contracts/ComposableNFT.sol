// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

interface IW3RC3 {
    function read(bytes memory name) external view returns (bytes memory, bool);
}

contract ComposableNFT is ERC721Enumerable {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address private sourceDir;
    mapping(uint256 => bool) composeIdUsed;
    mapping(string => uint256) tokenIdIndex;
    uint256 traitSize;
    uint256 valueSize;
    uint256 sampleSpace;

    constructor(
        string memory name,
        string memory symbol,
        address _sourceDir,
        uint256 _traitSize,
        uint256 _valueSize
    ) ERC721(name, symbol) {
        sourceDir = _sourceDir;
        traitSize = _traitSize;
        valueSize = _valueSize;
        sampleSpace = traitSize**valueSize;
    }

    function mint() public returns (uint256) {
        uint256 newItemId = _tokenIds.current();
        address receiver = msg.sender;
        _mint(receiver, newItemId);
        uint256 composeId = genId(receiver, newItemId);
        composeIdUsed[composeId] = true;
        tokenIdIndex[newItemId.toString()] = composeId;
        _tokenIds.increment();
        return newItemId;
    }
    
    function compose(string memory tokenIdSvg) public view returns (bytes memory) {
        string memory tokenId = trimSuffix(tokenIdSvg);
        return _compose(tokenId);
    }

    function _compose(string memory tokenId) internal view returns (bytes memory) {
        uint256 composeId = tokenIdIndex[tokenId];
        require(composeId > 0, "invalid token ID");
        IW3RC3 w3q = IW3RC3(sourceDir);
        bytes memory images = bytes("");
        for (uint256 i = 0; i < traitSize; i++) {
            composeId /= valueSize;
            uint256 prop = composeId % valueSize;
            bytes memory pngFileName = abi.encodePacked(
                i.toString(),
                "/",
                prop.toString(),
                ".png"
            );
            (bytes memory png, ) = w3q.read(pngFileName);
            images = abi.encodePacked(
                images,
                '<image x="100" ',
                'y="',
                (i * 25).toString(),
                '" xlink:href="data:image/png;base64,',
                Base64.encode(png),
                '"/>'
            );
        }
        bytes memory svg = abi.encodePacked(
            '<svg viewBox="0 0 200 200" style="background-color:yellow" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">',
            images,
            "</svg>"
        );
        return svg;
    }

    function genId(address receiver, uint256 itemId)
        private
        view
        returns (uint256)
    {
        uint256 randNonce = 0;
        uint256 composeId = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, receiver, itemId, randNonce)
            )
        ) % sampleSpace;
        while (composeIdUsed[composeId]) {
            randNonce++;
            composeId =
                uint256(
                    keccak256(
                        abi.encodePacked(
                            block.timestamp,
                            receiver,
                            itemId,
                            randNonce
                        )
                    )
                ) %
                sampleSpace;
        }
        return composeId;
    }

    function trimSuffix(string memory tokenIdSvg) public pure returns (string memory) {
        bytes memory srcBytes = bytes(tokenIdSvg);
        uint256 endIndex = srcBytes.length - 4;
        bytes memory idBytes = new bytes(endIndex);
        for(uint256 i = 0; i < endIndex; i++) {
            idBytes[i] = srcBytes[i];
        }
        return string(idBytes);
    }
}
