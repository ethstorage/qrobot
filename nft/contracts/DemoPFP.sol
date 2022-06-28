// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ComposableNFT.sol";

contract DemoPFP is ComposableNFT {
    constructor(
        address _sourceDir,
        uint256 _traitSize,
        uint256 _valueSize
    ) ComposableNFT("Demo PFP", "PFP", _sourceDir, _traitSize, _valueSize) {}
}
