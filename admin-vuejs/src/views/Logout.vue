<template>
  <div class="about">
    <h1>Logout!</h1>
  </div>
</template>

<script lang="ts">
import { Vue } from "vue-class-component";
import firebase from "firebase/app";
import "firebase/auth";
export default class Logout extends Vue {
  created() {
    firebase.auth().signOut();
  }
}
</script>
