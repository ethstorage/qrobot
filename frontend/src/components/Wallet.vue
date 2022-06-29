<template>
  <div id="wallet">
    <div class="btn-unsupported" v-if="isUnsupportedChain">
      <a @click="connectWallet"> Unsupported Chain </a>
    </div>
    <div class="btn-connect" v-else-if="!account">
      <a @click="connectWallet"> Connect Wallet </a>
    </div>
    <div class="account" v-if="account && !isUnsupportedChain">
      <span :title="account" style="margin: 0 8px">{{ accountShort }}</span>
    </div>
  </div>
</template>
<script>
import { mapActions, mapState } from "vuex";
import { short } from "@/utils";
import chains from "@/config";
export default {
  name: "Wallet",
  props: {},

  data: () => ({
    isUnsupportedChain: false,
  }),
  async created() {
    window.ethereum.on("chainChanged", this.handleChainChanged);
    window.ethereum.on("accountsChanged", this.handleAccountsChanged);
    await this.connectWallet();
  },
  computed: {
    ...mapState(["account", "chainConfig"]),
    accountShort() {
      return short(this.account);
    },
    isMobile() {
      return window.matchMedia("(max-width: 420px)").matches;
    },
  },
  methods: {
    ...mapActions(["setChainConfig", "setAccount"]),
    async connectWallet() {
      if (!window.ethereum) {
        alert(
          "MetaMask is not installed. Please consider installing it: https://metamask.io/download.html"
        );
        return null;
      }
      const newChainId = await window.ethereum.request({
        method: "eth_chainId",
      });
      if (!this.setChain(newChainId)) {
        //unsupported chain
        this.promptSwitch();
      }
      window.ethereum
        .request({ method: "eth_requestAccounts" })
        .then(this.handleAccountsChanged)
        .catch((err) => {
          if (err.code === 4001) {
            // EIP-1193 userRejectedRequest error
            // If this happens, the user rejected the connection request.
            console.log("user rejected.");
          } else {
            console.error("eth_requestAccounts", err);
          }
        });
      return true;
    },
    handleChainChanged() {
      window.location.reload();
    },
    async handleAccountsChanged(accounts) {
      if (accounts.length === 0) {
        window.location.reload();
      }
      if (accounts[0] !== this.account) {
        this.setAccount(accounts[0].toLowerCase());
      }
    },
    setChain(newChainId) {
      if (
        !(
          this.chainConfig &&
          this.sameChain(this.chainConfig.chainId, newChainId)
        )
      ) {
        const c = chains.find((v) => this.sameChain(v.chainId, newChainId));
        if (!c) {
          this.isUnsupportedChain = true;
          console.warn("unsupported chain!");
          return false;
        }
        this.isUnsupportedChain = false;
        this.setChainConfig(JSON.parse(JSON.stringify(c)));
      }
      return true;
    },
    sameChain(a, b) {
      if (!a || !b) {
        return false;
      }
      if (a.toLowerCase() === b.toLowerCase()) {
        return true;
      }
      let anum = 0,
        bnum = 0;
      if (a.toLowerCase().startsWith("0x")) {
        anum = parseInt(a, 16);
      } else {
        anum = parseInt(a, 10);
      }
      if (b.toLowerCase().startsWith("0x")) {
        bnum = parseInt(b, 16);
      } else {
        bnum = parseInt(b, 10);
      }
      return anum === bnum;
    },
    async promptSwitch() {
      const [{ chainId, rpcUrls, scan }] = chains;
      try {
        // check if the chain to connect to is installed
        await window.ethereum.request({
          method: "wallet_switchEthereumChain",
          params: [{ chainId }],
        });
      } catch (error) {
        // This error code indicates that the chain has not been added to MetaMask
        // if it is not, then install it into the user MetaMask
        if (error.code === 4902) {
          try {
            await window.ethereum.request({
              method: "wallet_addEthereumChain",
              params: [{ chainId, rpcUrls, blockExplorerUrls: [scan] }],
            });
          } catch (addError) {
            console.error("wallet_addEthereumChain failed", addError);
          }
        }
        console.error("wallet_switchEthereumChain failed", error);
      }
    },
  },
};
</script>

<style scoped>
.account {
  height: 40px;
  width: 150px;
  border: 1px solid rgba(238, 238, 238, 1);
  box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.1);
  border-radius: 20px;
  font-size: 14px;
  padding: 0;
  font-family: AlibabaPuHuiTiM;
  color: #333333;
  display: flex;
  align-items: center;
  justify-content: center;
  @media (max-width: 420px) {
    width: 106px;
    height: 26px;
    font-size: 10px;
  }
}
.btn-unsupported {
  width: 150px;
  height: 30px;
  margin: 10px;
  padding-top: 3px;
  border-radius: 3px;
  border: 1px solid #ff5c1b;
  @media (max-width: 420px) {
    min-width: 96px;
    height: 26px;
    border-radius: 12px;
    font-size: 10px;
  }
}
.btn-unsupported a {
  margin-left: 8px;
  width: 114px;
  height: 16px;
  font-size: 14px;
  font-family: AlibabaPuHuiTiR;
  color: #ff5c1b !important;
  line-height: 16px;
}
.btn-connect {
  width: 120px;
  height: 30px;
  margin: 10px;
  padding-top: 3px;
  border-radius: 4px;
  border: 1px solid #00a5ff;
  @media (max-width: 420px) {
    min-width: 96px;
    height: 26px;
    border-radius: 12px;
    font-size: 10px;
  }
}
.btn-connect a {
  margin-left: 8px;
  width: 114px;
  height: 16px;
  font-size: 14px;
  font-family: AlibabaPuHuiTiR;
  color: #00a5ff !important;
  line-height: 16px;
}
</style>
