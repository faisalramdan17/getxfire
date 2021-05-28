import { createApp } from "vue";
import App from "./App.vue";
import "./registerServiceWorker";
import router from "./router";
import store from "./store";

import firebase from "firebase/app";
import { AppService } from "./services/app.service";
import { firebaseConfig } from "../config";

firebase.initializeApp(firebaseConfig);

const appService = new AppService();

createApp(App)
  .mixin({
    data() {
      return {
        app: appService
      };
    }
  })
  .use(store)
  .use(router)
  .mount("#app");
