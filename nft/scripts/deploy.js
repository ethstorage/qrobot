
const { ethers } = require("hardhat");

const pngDir = "0x28BD3AeF1a00677e1A1419AbA2A10D2E403eB6c2"; // test only

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    let tx, receipt;
    //deploy contract
    const nft = await ethers.getContractFactory("DemoPFP");
    const myNFT = await nft.deploy(pngDir);
    await myNFT.deployed();
    console.log("DemoNFT deployed to:", myNFT.address);

    // mint #0 for test
    const gas = await myNFT.estimateGas.mint();
    tx = await myNFT.mint({ gasLimit: gas });
    receipt = await tx.wait();
    console.log("mint", receipt.status);
    console.log(await myNFT.compose("0.svg"));
}


async function mint() {
    const [deployer] = await ethers.getSigners();
    const nft = await ethers.getContractFactory("ComposableNFT");
    const myNFT = nft.attach("0xbe9e69DE9D41f95b54fdfFE888ccb9cc00c14951"); //attach to a deployed NFT contract
    const gas = await myNFT.connect(deployer).estimateGas.mint();
    const tx = await myNFT.connect(deployer).mint({ gasLimit: gas });
    const receipt = await tx.wait();
    console.log("distribute", receipt.status)
}

async function test() {
    const nft = await ethers.getContractFactory("ComposableNFT");
    const myNFT = nft.attach("0x855f0369B9721061ec8Ce66aE6Eb02E92442663b"); //attach to a deployed NFT contract
    let rs = await myNFT.compose("0.svg");
    console.log(rs)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });