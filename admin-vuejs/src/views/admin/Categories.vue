<template>
  <div class="list">
    <h2>Categories page</h2>

    <h5 class="mt-5">New Category</h5>
    <table class="table table-sm mw-100 text-center">
      <tr>
        <td><input placeholder="ID" type="text" v-model="newCategory.id" /></td>
        <td>
          <input placeholder="Title" type="text" v-model="newCategory.title" />
        </td>
        <td>
          <input
            placeholder="Description"
            type="text"
            v-model="newCategory.description"
          />
        </td>
        <td>
          <button type="button" @click="onCreate">Add Category</button>
        </td>
      </tr>
    </table>

    <table class="table table-sm mt-5 mw-100">
      <tr>
        <th scope="col">ID</th>
        <th scope="col">TITLE</th>
        <th scope="col">DESCRIPTION</th>
        <th scope="col">ACTIONS</th>
      </tr>
      <tr v-for="category in categories" :key="category.id">
        <td>{{ category.id }}</td>
        <td><input type="text" v-model="category.title" /></td>
        <td><input type="text" v-model="category.description" /></td>
        <td>
          <a :href="'/admin/settings/forum/' + category.id">Settings</a>
          <button type="button" @click="onDelete(category.id)">Delete</button>
        </td>
      </tr>
    </table>

    <button type="button" @click="onSave()">Save All</button>

    <p v-show="fetchingCategories">Loading category list ..</p>
  </div>
</template>

<script lang="ts">
import { Vue } from "vue-class-component";
import { proxy } from "../../services/functions";
import { AppService } from "@/services/app.service";
import firebase from "firebase/app";
import "firebase/firestore";

export default class Categories extends Vue {
  app = new AppService();
  col = firebase.firestore().collection("categories");

  newCategory = {
    id: "",
    title: "",
    description: "",
  };

  categories: any[] = [];
  fetchingCategories = false;

  async fetchCategories() {
    if (this.fetchingCategories) return;
    this.fetchingCategories = true;

    const snapshot = await this.col.get();
    snapshot.docs.forEach((doc) => {
      this.categories.push(doc.data());
    });

    this.fetchingCategories = false;
  }

  created() {
    this.fetchCategories();
  }

  async onCreate() {
    const docRef = this.col.doc(this.newCategory.id);
    console.log(this.newCategory);
    try {
       await docRef.set(this.newCategory);
      this.categories.push(proxy(this.newCategory));
      this.newCategory.id = "";
      this.newCategory.title = "";
      this.newCategory.description = "";
      this.app.alert("Category created!");
    } catch (e) {
      this.app.error(e);
    }
  }

  onSave() {
    this.categories.map((category) => {
      this.col.doc(category["id"]).update({
        title: category.title ?? "",
        description: category.description ?? "",
      });
    });
  }

  async onDelete(id: string) {
    const conf = confirm("Delete Category?");
    if (!conf) return;
    try {
      await this.col.doc(id).delete();
      const i = this.categories.findIndex((cat) => cat.id == id);
      this.categories.splice(i, 1);
      this.app.alert("Category " + id + " deleted!");
    } catch (e) {
      this.app.error(e);
    }
  }
}
</script>

<style lang="scss" scoped>
.table {
  width: 100%;
  & tr > th {
    border: 1px solid black;
  }
}

input {
  width: 100%;
}
</style>
