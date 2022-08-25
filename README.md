QRobot
====
QRobot is a series of composable NFT.  

## Introduction to Composible NFT

Everything is composed of something else, so can be an NFT. 
A robot is composed of a body, a hat, a mouth, a pair of arms, a pair of eyes, etc., and QRobot as a robot NFT is composed of corresponding parts in the form of png files.  

Generally speaking, composable NFT is composed on demand by pre-deployed components based on a seed randomly generated on-chain when the NFT is minted. 

## How Does It Work

Composable NFT is accessible by its unique token ID following [EIP-4804](https://eips.ethereum.org/EIPS/eip-4804) standard. Simply put, this standard translates URI to a contract read such that Web3 content can be accessed easily, e.g. from a browser's address bar.  

Being located by the token ID to seed mapping, the seed is interpreted by the `compose` method and the output is an SVG string concatenating a unique selection of grouped png files corresponding to the NFT's rarity features.