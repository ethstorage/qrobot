import Vue from 'vue';
import App from './App.vue';
import Buefy from 'buefy';
import 'buefy/dist/buefy.css';
import store from './store';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';

Vue.use(Buefy);
Vue.config.productionTip = false;

Vue.component('font-awesome-icon', FontAwesomeIcon);

new Vue({
  store,
  render: h => h(App),
}).$mount('#app');
