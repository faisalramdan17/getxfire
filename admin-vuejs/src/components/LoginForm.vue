<template>
  <div class="login-form">
    <small class="form-hint">Please login</small>
    <h1 class="form-title">Login</h1>
    <form @submit.prevent="onSubmit">
      <div>
        <div class="form-label">Email</div>
        <input type="email" name="email" v-model="form.email" />
      </div>
      <div>
        <div class="form-label">Password</div>
        <input type="password" name="password" v-model="form.password" />
      </div>
      <button class="form-submit" type="submit">Login</button>
    </form>
  </div>
</template>

<script lang="ts">
import { AppService } from "@/services/app.service";
import firebase from "firebase/app";
import "firebase/auth";

import { Vue } from "vue-class-component";

export default class LoginForm extends Vue {
  app = new AppService();

  form: any = {};

  async onSubmit() {
    try {
      const credential = await firebase
        .auth()
        .signInWithEmailAndPassword(this.form.email, this.form.password);
      this.app.alert("login success");
    } catch (e) {
      this.app.error(e);
    }
    return;
  }
}
</script>

<style scoped lang="scss"></style>
