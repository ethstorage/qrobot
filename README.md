QRobot
====
QRobot is a collection of standard ERC-721 NFT on Web3Q blockchain you can mint freely that demonstrates the idea of composable NFT.  

## What Is Composable NFT

Everything is composed of something else, so can be an NFT. 
A robot is composed of a body, a hat, a mouth, a pair of arms, a pair of eyes, etc., and QRobot as a robot theme NFT is composed of corresponding parts in the form of png files.  

<p align="center">
<img src="https://web3q.io/0x804a6B66b071e7E6494AE0e03768a536ded64262:w3q-g/compose/string!8.svg" width="400" />
</p>

Generally speaking, composable NFT is composed on demand by pre-deployed components based on a seed randomly generated on-chain when the NFT is minted. 

## How Does It Work

Composable NFT is accessible by its unique token ID following [EIP-4804](https://eips.ethereum.org/EIPS/eip-4804) standard.
Simply put, this standard translates URI to contract read such that Web3 content can be accessed easily, for example from a browser's address bar.  

Being located by the token ID to seed mapping, the seed is interpreted by the `compose` method and the output is an SVG string concatenating a unique selection of grouped png files presenting the NFT's rarity features.

## The Benefits of Composable NFT

First of all, composable NFT is a fully decentralized and transparent NFT implementation, as the creating and presenting processes fully happen on chain, as well as where the metadata (png files as design elements) are stored. As an example, you can view the [metadata](https://web3q.io/0x31bc4dAd21fAd6212082C7953379bb62187ffE94:w3q-g/2/0.png) directly with an EIP-4804 standard URI.

Secondly, the composable NFT saves the artist a lot of effort to design the same amount of artwork compared to traditional NFTs. For example, the artist of QRobot only needs to design $10\times7$ pieces of component pngs and the composable NFT contract can generate up to $10^{7}$ NFTs as a collection. 

Lastly, as the NFTs are composed on demand, there is no need to store the generated pictures anywhere as static NFTs do, which saves the storage costs dramatically.
