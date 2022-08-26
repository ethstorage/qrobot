QRobot
====
QRobot is a collection of standard ERC-721 NFT on Web3Q blockchain you can mint freely that demonstrates the idea of composable NFT.  

## What Is Composable NFT

Everything is composed of something else, so can be an NFT. 
A robot is composed of a body, a hat, a mouth, a pair of arms, a pair of eyes, etc., and QRobot as a robot theme NFT is composed of corresponding parts in the form of png files.  

Generally speaking, composable NFT is composed on demand by pre-deployed components based on a seed randomly generated on-chain when the NFT is minted. 

## How Does It Work

Composable NFT is accessible by its unique token ID following [EIP-4804](https://eips.ethereum.org/EIPS/eip-4804) standard. Simply put, this standard translates URI to contract read such that Web3 content can be accessed easily, for example from a browser's address bar.  

Being located by the token ID to seed mapping, the seed is interpreted by the `compose` method and the output is an SVG string concatenating a unique selection of grouped png files presenting the NFT's rarity features.

## The Benefits of Composable NFT

The composable NFT saves the Artist a lot of effort to design the same amount of artworks compared to traditional NFTs. For example, the artist of QRobot only needs to design $10\times7$ pieces of component pngs and the composable NFT contract can generate up to $10^{7}$ NFTs as a collection. 