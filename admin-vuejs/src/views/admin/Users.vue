<template>
  <div class="about">
    <h1>User list in /users collection</h1>

    <div class="py-4">
      <button class="m-2" @click="onSelectAllUsers">
        {{ checkbox.length ? "Deselect selected users" : "Select all users" }}
      </button>
      <button
        :disabled="!checkbox.length"
        class="m-2"
        @click="onDeleteSelectedUsers"
      >
        Delete selected users
      </button>
      <input
        class="fs-6"
        type="text"
        placeholder="Search by UID"
        name="uid"
        v-model="uid"
      />
      <button class="m-2" @click="search()">Search</button>
    </div>

    <table class="table">
      <thead>
        <tr>
          <th scope="col"></th>
          <th scope="col">Photo</th>
          <th scope="col">UID / Display Name / Greeting</th>
          <th scope="col">Firstname</th>
          <th scope="col">Lastname</th>
          <th scope="col">Buttons</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.uid">
          <td>
            <input
              type="checkbox"
              :id="user.uid"
              :value="user.uid"
              v-model="checkbox"
            />
          </td>
          <td>
            <img v-if="user.photoURL" :src="user.photoURL" class="avatar" />
          </td>
          <td>
            <div class="sm">{{ user.uid }}</div>
            <div class="md bold">{{ user.displayName }}</div>
            <div class="sm grey">{{ user.greeting ?? "" }}</div>
          </td>
          <td>{{ user.firstName }}</td>
          <td>{{ user.lastName }}</td>
          <td>
            <button type="button" @click="onDelete(user.uid)">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>

    <p v-if="fetching">loading users ...</p>
    <p v-if="noMoreUsers">No more users ...</p>
  </div>
</template>

<script lang="ts">
import { Vue } from "vue-class-component";
import firebase from "firebase/app";
import "firebase/firestore";
import { AppService } from "@/services/app.service";
import { proxy } from "@/services/functions";
export default class Users extends Vue {
  app = new AppService();
  limit = 30;
  users: any[] = [];
  fetching = false;
  noMoreUsers = false;

  checkbox: any = [];
  userCol = firebase.firestore().collection("users");
  publicCol = firebase
    .firestore()
    .collection("meta")
    .doc("user")
    .collection("public");

  lastSnapshot: any;

  uid: any = "";

  search() {
    this.users = [];
    this.noMoreUsers = false;
    this.lastSnapshot = null;
    if (this.uid == "") {
      this.fetchUsers();
    } else {
      this.fetchUser();
    }
  }

  async fetchUser() {
    const snapshot = await this.userCol.doc(this.uid).get();
    if (snapshot.exists) {
      const data: any = {};
      const snapshotData = snapshot.data();
      data["uid"] = snapshot.id;
      Object.assign(data, snapshotData);
      this.users.push(data);
      this.fetchPublicData(snapshot.id);
    }
  }

  async fetchUsers() {
    if (this.fetching) return;
    if (this.noMoreUsers) return;
    this.fetching = true;
    let q = this.userCol.limit(this.limit);
    if (this.lastSnapshot) {
      q = q.startAfter(this.lastSnapshot);
    }

    const snapshot = await q.get();

    this.fetching = false;
    this.noMoreUsers = snapshot.size < this.limit;

    for (const docSnapshot of snapshot.docs) {
      this.lastSnapshot = docSnapshot;
      const data = docSnapshot.data();
      data["uid"] = docSnapshot.id;
      this.fetchPublicData(docSnapshot.id);
      this.users.push(data);
    }
  }

  async fetchPublicData(uid: string) {
    const docRef = this.publicCol.doc(uid);
    try {
      const res = await docRef.get();
      const i = this.users.findIndex(user => user.uid == uid);
      if (res.exists) {
        Object.assign(this.users[i], res.data());
      }
    } catch (e) {
      console.log(e);
    }
  }

  async created() {
    const uid = this.$router.currentRoute.value.params["uid"];
    if (uid != "all") this.uid = uid;
    this.search();
    window.addEventListener("scroll", this.handleScroll);
  }

  handleScroll(e: any) {
    const bottomOfWindow =
      document.documentElement.scrollTop + window.innerHeight >
      document.documentElement.offsetHeight - 200;

    if (bottomOfWindow) {
      this.fetchUsers();
    }
  }
  onDelete(uid: string) {
    console.log(uid);
    try {
      this.app.userDelete(uid);
    } catch (e) {
      console.log(e);
    }
  }
  onDeleteSelectedUsers() {
    const conf = confirm("Delete Selected Users?");
    if (!conf) return;
    const uids = proxy(this.checkbox);
    this.onDelete(uids);
  }
  onSelectAllUsers() {
    if (this.checkbox.length) {
      this.checkbox = [];
    } else {
      this.users.forEach(user => {
        this.checkbox.push(user.uid);
      });
    }
  }
}
</script>

<style lang="scss" scoped></style>
