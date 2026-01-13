// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ComposableNFT.sol";

contract QRobot is ComposableNFT {
    constructor(address _sourceDir, uint256 _chainId)
        ComposableNFT("Web3 QRobot", "QRobot", _sourceDir, _chainId, 7, 10)
    {}

    function mint() public returns (uint256) {
        return super.mintTo(msg.sender);
    }
}
