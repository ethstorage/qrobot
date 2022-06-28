import { ethers } from "ethers";
import chains from "@/config";
export const contract = {
    data: () => ({
        provider: null,
        nftContract: null,
    }),
    methods: {
        async mint() {
            const tx = await this.nftContract.connect(this.provider.getSigner()).mint();
            // const receipt = await tx.wait();
            return tx;
            // if (receipt.status == 1) {
            //     const tokenId = parseInt(ethers.BigNumber.from(receipt.events[0].topics[3]))
            //     console.log("tokenId", tokenId);
            //     return tokenId;
            // }
            // console.log("receipt.status", receipt.status)
        },
        async getTokenIds(addr) {
            const bal = await this.nftContract.balanceOf(addr);
            const promises = [];
            for (let i = 0; i < bal; i++) {
                promises.push(this.nftContract.tokenOfOwnerByIndex(addr, i));
            }
            const tokenIds = await Promise.all(promises);
            console.log("tokenIds", tokenIds)
            return tokenIds.map(t => t.toNumber());
        },
        async init() {
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            this.provider = provider;
            this.nftContract = new ethers.Contract(
                chains[0].nft,
                ["function mint() public returns (uint256)", "function balanceOf(address owner) external view returns (uint256 balance)",
                    "function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256)"],
                this.provider
            );
        },

        async txnCheck(txnHash) {
            const txReceipt = await this.provider.getTransactionReceipt(txnHash);
            if (txReceipt && txReceipt.blockNumber) {
                return txReceipt.status;
            }
        }
    },
    async created() {
        if (!this.contract) {
            await this.init();
        }
    }
}