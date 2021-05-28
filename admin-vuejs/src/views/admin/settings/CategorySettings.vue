<template>
  <div class="form">
    <h1>Forum Setting for: {{ category.id }}</h1>
    <div>
      Like:
      <span>
        <input type="checkbox" id="like" v-model="category.like" />
        <label for="like">{{ category.like ? "Enabled" : "Disabled" }}</label>
      </span>
    </div>
    <br />
    <div>
      Dislike:
      <span>
        <input type="checkbox" id="dislike" v-model="category.dislike" />
        <label for="dislike">{{
          category.dislike ? "Enabled" : "Disabled"
        }}</label>
      </span>
    </div>
    <br />
    <div>
      No of posts per each fetch: <br />
      <input
        type="number"
        id="postPerFetch"
        v-model="category['no-of-posts-per-fetch']"
      />
    </div>
    <br />
    <button type="button" @click="onSave">Submit</button>
  </div>
</template>

<script lang="ts">
import { Vue } from "vue-class-component";
import { proxy } from "../../../services/functions";
import firebase from "firebase/app";
import "firebase/firestore";

export default class CategorySettings extends Vue {
  category: any = {
    "no-of-posts-per-fetch": 20
  };
  fetchingCategories = false;

  col = firebase.firestore().collection("settings");

  async fetchCategory() {
    const doc = this.col.doc(this.category.id);
    const snapshot = await doc.get();
    Object.assign(this.category, snapshot.data());
    // console.log(this.category);
  }

  created() {
    this.category.id = this.$router.currentRoute.value.params["category"];
    this.fetchCategory();
  }
  async onSave() {
    try {
      await this.col
        .doc(this.category.id)
        .set(proxy(this.category), { merge: true });
      alert(
        "Settings for " + this.category.id + " category successfully updated"
      );
    } catch (e) {
      alert(e);
    }
  }
}
</script>

<style lang="scss" scoped>
.form {
  text-align: left;
}
</style>
