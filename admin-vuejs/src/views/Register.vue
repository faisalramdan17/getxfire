<template>
  <div class="about">
    <h1>This is an register page</h1>
    <RegisterForm />
  </div>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";
import RegisterForm from "@/components/RegisterForm.vue"; // @ is an alias to /src

@Options({
  components: {
    RegisterForm
  }
})
export default class Register extends Vue {}
</script>
