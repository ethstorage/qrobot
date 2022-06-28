// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IComposable {
    function compose(uint256 tokenId) external view returns (bytes memory);
}