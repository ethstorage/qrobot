// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ComposableNFT.sol";

contract DemoPFP is ComposableNFT {
    constructor(address _sourceDir)
        ComposableNFT("Web3 QRobot", "QRobot", _sourceDir, 10, 7)
    {}

    function mint() public returns (uint256) {
        return super.mintTo(msg.sender);
    }
}
