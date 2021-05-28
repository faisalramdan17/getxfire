<template>
  <section class="profile layout-content pt-5">
    <h1>Profile page</h1>

    <div v-if="app.loggedIn">User logged: uid: {{ app.user.uid }}</div>
  </section>
</template>
