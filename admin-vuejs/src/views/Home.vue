<template>
  <section class="home p-5">
    <div class="p-5 d-flex justify-content-center">
      <img width="120" height="120" src="/img/fire.svg" />
    </div>

    <p class="text-center text-white">
      <router-link class="text-white" to="/about">The fire project</router-link>
    </p>
  </section>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";
import LoginForm from "@/components/LoginForm.vue"; // @ is an alias to /src
import { AppService } from "@/services/app.service";

// import firebase from "firebase/app";
// import "firebase/functions";

@Options({
  components: {
    LoginForm
  }
})
export default class Home extends Vue {
  app = new AppService();
  // created() {}
}
</script>

<style lang="scss" scoped>
.home {
  background-color: #2196f3;
  height: 100vh;
}
</style>
