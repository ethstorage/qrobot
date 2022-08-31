QRobot
====
QRobot is a collection of standard ERC-721 NFT on Web3Q blockchain you can mint freely that demonstrates the idea of composable NFT.  

## What Is Composable NFT

Everything is composed of something else, so can be an NFT. 

A robot is composed of a body, a hat, a mouth, a pair of arms, a pair of eyes, etc., and QRobot as a robot theme NFT is composed of corresponding parts in the form of png files (i.e. metadata).  

<p align="center">
<img src="https://web3q.io/0x804a6B66b071e7E6494AE0e03768a536ded64262:w3q-g/compose/string!8.svg" width="400" />
</p>

Generally speaking, a composable NFT is composed on demand by pre-deployed components based on a seed randomly generated on-chain when the NFT is minted. 

## How Does It Work
When the NFT is being minted, a unique seed or `composeId` is randomly picked out of range $[0, valueSize^{traitSize})$ based on the timestamp, address of the NFT receiver, token ID in the form of a serial number, and a nonce to prevent duplication. 
```javascript
while (isComposeIdUsed(composeId)) {
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
```
The seeds will then be stored on-chain in the mapping from token ID to seed.

Now the minted composable NFT is accessible by its unique token ID following [EIP-4804](https://eips.ethereum.org/EIPS/eip-4804) standard.
Simply put, this standard translates URI to contract read such that Web3 content can be accessed easily, such as from a browser's address bar.  

When you request the URI, the NFT contract is located and the `compose` method will retrieve the seed by token ID and cut it into a series of metadata indexes presenting the NFT's traits. The output is an SVG string concatenating a selection of grouped png files read by Web3Q.

```javascript
uint256 composeId = tokenIdIndex[tokenId];
IW3RC3 w3q = IW3RC3(sourceDir);
bytes memory images = bytes("");
for (uint256 trait = 0; trait < traitSize; trait++) {
    uint256 value = composeId % valueSize;
    bytes memory pngFileName = abi.encodePacked(
        trait.toString(),
        "/",
        value.toString(),
        ".png"
    );
    (bytes memory png, ) = w3q.read(pngFileName);
    images = abi.encodePacked(
        images,
        '<image xlink:href="data:image/png;base64,',
        Base64.encode(png),
        '"/>'
    );
    composeId /= valueSize;
}
return
    abi.encodePacked(
        '<svg viewBox="0 0 1080 1080" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">',
        images,
        "</svg>"
    );
```

By the way, the metadata also can be accessed directly with an EIP-4804 standard URI, e.g., https://web3q.io/0x31bc4dAd21fAd6212082C7953379bb62187ffE94:w3q-g/2/0.png.
## The Benefits of Composable NFT

First of all, the minting and presenting processes of composable NFT fully happen on-chain, as well as the location of metadata, is transparent to everyone. This prevents the situation where the NFT blind box issuer can theoretically change the URI of metadata behind the scene to turn your rare item into a common one.

Secondly, the composable NFT saves the artist a lot of effort to design the same amount of artwork compared to traditional NFTs. For example, the artist of QRobot only needs to design $10\times7$ pieces of component pngs and the composable NFT contract can generate up to $10^{7}$ NFTs as a collection. 

Last but not least, since the NFTs are composed on demand, there is no need to store the generated pictures anywhere as static NFTs do, which saves the storage costs dramatically. 
