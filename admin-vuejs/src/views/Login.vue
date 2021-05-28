<template>
  <section class="layout-content mt-5">
    <LoginForm />
  </section>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";
import LoginForm from "@/components/LoginForm.vue"; // @ is an alias to /src

@Options({
  components: {
    LoginForm
  }
})
export default class Login extends Vue {}
</script>
