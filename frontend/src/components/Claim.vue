<template>
  <div class="container body">
    <div class="middle">
      <div class="card-wrapper">
        <div class="last-panel">
          <img src="../assets/demo.png" />
          <div class="pad"></div>
          <p class="text">
            Web3 QRobot is a collection of cute robots that can be minted freely
            on Web3Q blockchain. All the <a :href="metaLink" target="_blank" >metadata</a> has been uploaded to Web3Q in
            advance, and the traits of the robot will be fully determined by an
            on-chain random number generated when you mint. Enjoy your cute
            robots, Cheers!
          </p>
          <div class="btn-wrapper">
            <button @click="claim" class="btn-app">Mint</button>
          </div>
        </div>
      </div>
      <div class="card-wrapper">
        <div class="card">
          <header class="card-header">
            <p class="card-header-title">Minted</p>
          </header>
          <div class="last-panel centered" v-if="myTokenIds.length === 0">
            You don't own any QRobot yet
          </div>
          <div class="last-panel" v-else>
            <div class="columns" v-for="(group, index) in groups" :key="index">
              <div class="column is-4" v-for="id in group" :key="id">
                <a :href="tokenUrl(id)" target="_blank"> <img :src="tokenUrl(id)" /> </a>
                <p class="heading">QRobot #{{ id }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <b-modal v-model="isCheckingTx">
      <div class="card mask">
        <p class="head">Submit Your Request</p>
        <div class="card-img">
          <img src="../assets/loading.png" class="rotate" />
        </div>
        <p class="head">Processing...</p>
        <p v-if="txhash">
          Tx Hash:
          <a :href="txscan" target="_blank">{{ ftxhash }} </a>
        </p>
        <div class="buttons">
          <a class="btn-app cancel close" @click="cancelCheck">Close</a>
        </div>
      </div>
    </b-modal>
    <b-modal v-model="isImageModalActive">
      <p>
        <img :src="nftImage" />
      </p>
    </b-modal>
  </div>
</template>
<script>
import { BigNumber } from "ethers";
import { mapState } from "vuex";
import { transaction, contract } from "@/mixins";
import { short, checkOps } from "@/utils";

export default {
  name: "Claim",
  mixins: [transaction, contract],
  data: () => ({
    loading: null,
    txhash: "",
    isCheckingTx: false,
    myTokenIds: [],
    nftImage: "",
    isImageModalActive: false,
  }),

  methods: {
    async fetchData() {
      if (!this.account) {
        return;
      }
      this.myTokenIds = await this.getTokenIds(this.account);
    },
    async claim() {
      try {
        this.txhash = await this.sendTx(this.mint);
        this.isCheckingTx = true;
        await this.checkTx();
      } catch (e) {
        console.error(e.message);
      }
      await this.fetchData();
    },
    async checkTx() {
      if (!this.txhash) {
        this.timer = setTimeout(() => this.checkTx(), 1000);
        return;
      }
      const result = await this.txnCheck(this.txhash);
      if (result === undefined) {
        this.timer = setTimeout(() => this.checkTx(), 1000);
        return;
      }
      if (this.timer) {
        clearTimeout(this.timer);
      }
      if (result == 1) {
        this.info("Transaction executed successfully!");
      } else {
        this.error(
          `<a target="_blank" href="${this.txscan}"> Transaction failed!</a>`,
          10000
        );
      }
      await this.fetchData();
      this.isCheckingTx = false;
      this.txhash = "";
    },
    async cancelCheck() {
      if (this.timer) {
        clearTimeout(this.timer);
      }
      this.isCheckingTx = false;
    },
    zoomIn(id) {
      this.nftImage = this.tokenUrl(id);
      this.isImageModalActive = true;
    },
    tokenUrl(id) {
      return `https://web3q.io/${this.chainConfig.nft}:w3q-g/compose/string!${id}.svg`;
    },
  },
  computed: {
    ...mapState(["account", "chainConfig"]),
    accountShort() {
      return short(this.account);
    },
    ftxhash() {
      if (this.txhash) {
        return short(this.txhash);
      }
      return "loading...";
    },
    txscan() {
      if (this.chainConfig.scan) {
        return this.chainConfig.scan + "/tx/" + this.txhash;
      }
      return "";
    },
    groups() {
      const len = this.myTokenIds.length / 3;
      const arr = [];
      for (let i = 0; i < len; i++) {
        arr[i] = [];
        for (let j = 0; j < 3; j++) {
          if (i * 3 + j < this.myTokenIds.length) {
            arr[i][j] = this.myTokenIds[i * 3 + j];
          }
        }
      }
      return arr;
    },
    metaLink() {
      return `https://web3q.io/0x31bc4dAd21fAd6212082C7953379bb62187ffE94:w3q-g/2/0.png`;
    }
  },
  watch: {
    async account(newValue) {
      if (newValue) {
        await this.fetchData();
      } else {
        this.$router.push("Home");
      }
    },
  },
  async created() {
    await this.fetchData();
    this.loadInterval = setInterval(() => this.fetchData(), 3000);
  },
  destroyed() {
    if (this.loadInterval) {
      clearInterval(this.loadInterval);
    }
  },
};
</script>

<style lang="scss" scoped>
$res: 780px;
.card {
  background: #ffffff;
  border-radius: 0.75rem;
  border: 1px solid #e9f1f2;
}
.top {
  font-family: AlibabaPuHuiTiM;
  color: #000000;
  text-align: center;
  width: 100%;
}
.top img {
  vertical-align: middle;
  max-height: 1.5rem;
}
.top span {
  padding-left: 10px;
}
.key {
  font-family: AlibabaPuHuiTiB;
  color: #666666;
  line-height: 18px;
  padding: 0 1rem 0.5rem 0;
}
.num {
  font-size: 1.7rem;
  font-family: AlibabaPuHuiTiB;
  color: #FFC124;
  display: flex;
  align-items: center;
}
.grey {
  color: #999999;
}
a[target="_blank"] {
  color: #2a77fe;
}
.buttons {
  justify-content: space-evenly !important;
  padding: 20px 0;
}
.num img {
  max-height: 1.5rem;
  margin-left: 1rem;
}
.level {
  @media (max-width: $res) {
    text-align: center;
  }
}
.level img {
  max-width: 3rem;
}
.level span {
  padding-left: 10px;
}
.btn-wrapper button {
  border: 0;
  cursor: pointer;
  min-width: 8rem;
}
button:disabled {
  color: #ffffff;
  cursor: default;
  background: #999999 !important;
}
.inner {
  border: 1px solid #e9f1f2;
  box-shadow: none;
  margin-top: 1rem;
}
.nowrap.tile.is-child.box {
  @media (max-width: $res) {
    display: block;
  }
}
.tile.is-child.box {
  @media (min-width: $res) {
    display: flex;
    align-items: center;
  }
}
.tile.is-ancestor {
  padding: 0 1rem 0.5rem 1rem;
}
.no-padding {
  padding: 0 !important;
}
.small-padding {
  padding-left: 0.2rem;
  display: flex;
  align-items: center;
}
.pad {
  margin: 2rem;
}
.mask {
  width: 46%;
  text-align: center;
  border-radius: 16px;
  margin: auto;
  padding: 2rem;
  @media (max-width: $res) {
    width: 60%;
  }
}
.mask img {
  width: 4rem;
  height: 4rem;
}
.mask .head {
  font-family: AlibabaPuHuiTiB;
  font-size: 1.3rem;
  color: #221f33;
  padding-bottom: 0.5rem;
}
.mask .button {
  font-size: 1.2rem;
  border: 1px solid #e8e6f2;
  font-family: AlibabaPuHuiTiB;
  color: #FFC124;
}
.cancel {
  color: #FFC124;
  background-color: #fff;
  border: 1px solid #e8e6f2;
}
.cancel:hover {
  background-color: #FFC124;
  color: #fff;
}
.close {
  padding-top: 5px;
}
.heading {
  font-size: 0.9rem;
  white-space: nowrap;
  letter-spacing: 0;
  margin: 0.3rem 0 !important;
}
.card-wrapper {
  padding: 0 1rem 1rem 1rem;
}
.smaller {
  font-size: 1.1rem !important;
  @media (max-width: $res) {
    margin: 1rem 10%;
    text-align: center;
    font-size: 1.6rem !important;
  }
}
.inbox {
  border-radius: 12px;
  border: 1px solid #e9f1f2;
  background: #f9f9f9;
  padding: 1rem 1.25rem;
  margin: 1rem;
  @media (max-width: $res) {
    margin: 0.5rem;
    padding: 0.75rem;
  }
}
.step {
  background-color: #425f96;
  text-align: center;
  vertical-align: middle;
  border-radius: 50%;
  font-size: 0.8rem;
  width: 1.25rem;
  height: 1.25rem;
  color: #fff;
}
.rotate {
  animation: rotation 2s infinite linear;
}
@keyframes rotation {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(359deg);
  }
}
.svg-inline--fa {
  vertical-align: 0.125rem;
  margin-left: -0.5rem;
}
.point:hover {
  cursor: pointer;
}
.point {
  color: #FFC124;
}
.grid-wrapper {
  margin-top: 1rem;
  display: grid;
  text-align: center;
}
.card-wrapper .box {
  padding: 0.3rem;
}
.lefting {
  text-align: justify;
}
.nowrap {
  @media (max-width: $res) {
    display: flex;
    flex-direction: row;
    align-items: center;
  }
}
.tile.is-vertical > .tile.is-child:not(:last-child) {
  @media (max-width: $res) {
    margin-bottom: 0 !important;
    margin-right: 1rem !important;
  }
}
.inbox .columns .column {
  @media (max-width: $res) {
    flex-basis: unset !important;
    padding: 0.5rem;
  }
}
.centered {
  padding-top: 5rem !important;
}
.centered button {
  font-size: 16px;
  font-family: AlibabaPuHuiTiB !important;
  color: #ffffff !important;
  background: #00c7fb;
  border-radius: 2rem;
  border: 0;
}
.centered button:hover {
  background: #FFC124;
  color: #ffffff !important;
}
.last-panel {
  padding-top: 1rem;
  margin: 1rem;
  text-align: center;
  color: #999999;
  min-height: 12rem;
}
.last-panel img {
  border-radius: 1rem;
  cursor: pointer;
}
.last-panel .btn-wrapper {
  margin: 1rem;
}
.align-left .tag {
  border-radius: 1rem !important;
  background: #000000 !important;
  color: #ffffff !important;
  font-family: AlibabaPuHuiTiB !important;
}
.title {
  font-family: AlibabaPuHuiTiR !important;
  margin-bottom: 0 !important;
}
.input {
  border-radius: 2rem !important;
}
.control.is-clearfix {
  // margin-bottom: -4rem !important;
  padding-bottom: 0 !important;
  // width: 18rem !important;
  border-radius: 2rem !important;
}
.center {
  padding-left: 4rem;
  padding-right: 4rem;
}
.bbutton {
  margin-left: -4.5rem;
  width: 5rem;
}
.bbutton[disabled] {
  opacity: 1 !important;
}
.disabled {
  filter: grayscale(100%);
  pointer-events: none;
}
.align-left {
  text-align: left;
  padding-left: 1rem;
}
.text {
  width: 72%;
  text-align: justify;
  font-family: ComicSansMS;
  color: #000000;
  font-size: 1.1rem;
  line-height: 2rem;
  margin: auto;
  padding: 1rem;
  @media (max-width: $res) {
    width: 60%;
  }
}
.placeholder {
  background-color: #dddddd;
}
.bigger {
  font-size: 2rem;
}
.card-img {
  min-height: 6rem;
  padding-top: 3rem;
}
.pcolor {
  background-color: #FFC124 !important;
}
</style>
