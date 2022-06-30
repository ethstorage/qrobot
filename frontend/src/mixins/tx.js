export const transaction = {
  data: () => ({
    // isLoading: false,
  }),
  methods: {
    async sendTx(func, ...args) {
      const { chainConfig } = this.$store.state;
      const loadingComponent = this.$buefy.loading.open();
      try {
        let tx = await func(...args);
        if (!tx) {
          return null;
        }
        this.info(`<a target="_blank" href="${chainConfig.scan}/tx/${tx.hash}"> Transaction sent!</a>`, 1000);
        this.$emit("txSent");
        console.log("tx.hash", tx.hash);
        loadingComponent.close();
        return tx.hash;
        // const rcpt = await tx.wait();
        // console.log("receipt", rcpt.status);
        // if (rcpt.status == 1) {
        //   this.success(`<a target="_blank" href="${chainConfig.scan}/tx/${tx.hash}"> Transaction confirmed!</a>`);
        // } else {
        //   this.error(`<a target="_blank" href="${chainConfig.scan}/tx/${tx.hash}"> Transaction failed!</a>`);
        // }
        // this.$emit("txConfirmed", tx.hash);
        // return rcpt.status;
      } catch (e) {
        console.error("sendTx", e.message);
        const prefix = "Error: VM Exception while processing transaction: reverted with reason string";
        let err = e.data ? e.data.message : "";
        if (err && err.indexOf(prefix) === 0) {
          err = err.substring(prefix.length);
        }
        if (e.code !== 4001) {
          this.error(err || "Transaction Failed");
        }
      } finally {
        loadingComponent.close();
      }
    },
    success(content) {
      this.alert(content, 'is-success');
    },
    error(content) {
      this.alert(content, 'is-danger');
    },
    info(content, duration) {
      this.alert(content, 'is-info', duration);
    },
    alert(content, type, duration) {
      this.$buefy.notification.open({
        duration: duration || 5000,
        hasIcon: false,
        queue: false,
        message: content,
        position: 'is-bottom-right',
        type,
      });
    },
  }
}