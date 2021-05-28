<template>
  <section class="admin-layout layout-content">
    <div v-if="!app.isAdmin">
      <div v-if="app.loggedIn">You have logged in as a user account.</div>
      Please login with admin account.
      <LoginForm />
    </div>

    <section v-if="app.isAdmin">
      <hr />

      <div id="nav">
        <router-link to="/admin/users/all">Users</router-link> |
        <router-link to="/admin/categories">Categories</router-link> |
        <router-link to="/admin/posts/all">Posts</router-link> |
        <router-link to="/admin/search-posts">Search Posts</router-link> |
        <router-link to="/admin/photos/all">Photos</router-link> |
        <router-link to="/admin/purchases">Purchases</router-link> |
        <router-link to="/admin/settings">Settings</router-link> |
        <router-link to="/admin/translations">Translations</router-link>

        <p v-if="app.loggedIn">
          Current user Email: {{ $store.state.user.email }} |
          <span v-if="app.isAdmin">You are an ADMIN!</span>
        </p>
      </div>
      <hr />
      <router-view />
    </section>
  </section>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";
import LoginForm from "@/components/LoginForm.vue"; // @ is an alias to /src
import { AppService } from "@/services/app.service";

@Options({
  components: {
    LoginForm
  }
})
export default class Login extends Vue {
  app = new AppService();
}
</script>
