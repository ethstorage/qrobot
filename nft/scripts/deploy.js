
const { ethers } = require("hardhat");

const pngDir = "0x28BD3AeF1a00677e1A1419AbA2A10D2E403eB6c2"; // test only

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    let tx, receipt;
    //deploy contract
    const nft = await ethers.getContractFactory("ComposableNFT");
    const myNFT = await nft.deploy("Web3Q Early Supporter", "WES", pngDir, 7, 10);;
    await myNFT.deployed();
    console.log("ComposableNFT deployed to:", myNFT.address);

    // mint #0 for test
    const gas = await myNFT.estimateGas.mint();
    tx = await myNFT.mint({ gasLimit: gas });
    receipt = await tx.wait();
    console.log("mint", receipt.status);
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
    const myNFT = nft.attach("0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0"); //attach to a deployed NFT contract
    let rs = await myNFT.isComposeIdUsed(1950275);
    console.log(rs)
    rs = await myNFT.isComposeIdUsed(1950278);
    console.log(rs)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });