<template>
  <div id="app">
    <w3q-tip
      style="width: 100vw"
      bgColor="#FFC124"
      fontColor="#000000"
      :fontSize="isMobile ? '12px' : '15px'"
    />
    <div class="container">
      <div class="nav">
        <b-navbar :mobileBurger="false">
          <template #brand>
            <b-navbar-item> 
                <div class="brand-wrapper">
                  <img src="./assets/logo.png" alt="Web3Q" />
                </div>
            </b-navbar-item>
            <b-navbar-item v-if="isMobile" class="mobile-menu">
              <div class="buttons">
                <Wallet />
              </div>
            </b-navbar-item>
          </template>
          <template #start v-if="!isMobile"> </template>
          <template #end v-if="!isMobile">
            <b-navbar-item v-if="!isMobile">
              <div class="buttons">
                <Wallet />
              </div>
            </b-navbar-item>
          </template>
        </b-navbar>
      </div>
    </div>
    <div class="container content">
      <div class="body">
        <Claim />
      </div>
      <div class="footer">
        <div class="has-text-centered">
          <a href="https://github.com/ethstorage/qrobot" target="_blank"
            ><img src="./assets/github.png"
          /></a>
          <a href="https://twitter.com/EthStorage" target="_blank"
            ><img src="./assets/twitter.png"
          /></a>
          <a href="https://ethstorage.medium.com/" target="_blank"
            ><img src="./assets/medium.png"
          /></a>
          <a href="https://t.me/ethstorage" target="_blank"
            ><img src="./assets/telegram.png"
          /></a>
          <a href="https://discord.gg/mZqqUZxjed" target="_blank"
            ><img src="./assets/discord.png"
          /></a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Wallet from "@/components/Wallet.vue";
import Claim from "@/components/Claim.vue";
export default {
  name: "App",
  components: {
    Wallet,
    Claim,
  },
  computed: {
    isMobile() {
      return window.matchMedia("(max-width: 780px)").matches;
    },
  },
};
</script>

<style lang="scss">
@font-face {
  font-family: AlibabaPuHuiTiR;
  src: url("./assets/fonts/AlibabaSans-Regular.ttf");
}
@font-face {
  font-family: AlibabaPuHuiTiM;
  src: url("./assets/fonts/AlibabaSans-Medium.ttf");
}
@font-face {
  font-family: AlibabaPuHuiTiB;
  src: url("./assets/fonts/AlibabaSans-Bold.otf");
}
@font-face {
  font-family: ComicSansMS;
  src: url("./assets/fonts/Comic-Sans-MS.ttf");
}
$res: 780px;
$input-radius: 2rem;
html,
body {
  width: 100%;
  height: 100% !important;
  background-size: 100% 100%;
  position: absolute;
  font-family: AlibabaPuHuiTiR;
}
#app {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  margin-top: 0px !important;
  height: calc(100vh - 9rem) !important;
}
.brand-wrapper img {
  vertical-align: middle;
}
.brand-wrapper {
  padding: 10px 0 0 10px;
}
.navbar-item img {
  max-height: 3rem !important;
}
.navbar-item {
  cursor: default !important;
  padding-right: 1.5rem !important;
}
.navbar-item:hover {
  background: #ffffff !important;
}
.brand {
  font-family: AlibabaPuHuiTiB;
  font-size: 1.5rem;
  color: #000000;
  padding-left: 10px;
  vertical-align: middle;
}
.navbar {
  background-color: transparent !important;
}
.content {
  min-height: calc(100vh - 9rem) !important;
  position: relative !important;
}
.body {
  padding-bottom: 3rem !important;
  @media (max-width: $res) {
    padding-bottom: 2rem !important;
  }
}
.footer {
  padding: 3rem !important;
  background-color: transparent !important;
  position: absolute !important;
  bottom: 0 !important;
  width: 100% !important;
  height: 6rem !important;
  @media (max-width: $res) {
    height: 2rem !important;
  }
}
.footer img {
  padding: 10px;
  @media (max-width: $res) {
    width: 36px;
    height: 36px;
    padding: 5px;
  }
}
.btn-app {
  border-radius: 2rem;
  border: 1px solid #e8e6f2;
  text-align: center;
  vertical-align: middle;
  display: table-cell;
  background: #FFC124;
  color: #ffffff;
  font-size: 1rem;
  font-family: AlibabaPuHuiTiB;
  padding: 0.4rem 1rem;
  white-space: nowrap;
  max-height: 3rem;
}
.btn-app:hover {
  background: #ffffff;
  color: #FFC124;
  border: 1px solid #e8e6f2;
  cursor: pointer;
}
.notification.is-info {
  background-color: #FFC124 !important;
}
.container:not(.is-max-desktop):not(.is-max-widescreen) {
  max-width: 1000px !important;
}
.container:not(.is-max-desktop) {
  max-width: 1000px;
}
.title {
  font-size: 1.6rem !important;
}
.mobile-menu {
  padding: 0 1rem 0.5rem 0 !important;
}
.navbar-brand,
.navbar-tabs {
  justify-content: space-between !important;
}
.is-1 img {
  max-width: 3rem;
}
</style>
