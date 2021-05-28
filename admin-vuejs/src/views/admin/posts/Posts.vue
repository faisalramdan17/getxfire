<template>
  <div class="p-3">
    <h2>
      Category:
      <select v-model="search.category" @change="onSearch()">
        <option value="">All</option>
        <option v-for="category of categories" :key="category">
          {{ category }}
        </option>
      </select>
    </h2>
    <br />

    <!-- post create -->
    <post-create-component
      :category="search.category"
      :categories="categories"
      @on-created="onPostCreated($event)"
    ></post-create-component>

    <!-- delete selected button / search bar -->
    <div class="d-flex mt-5">
      <button
        style="margin-right: 1.5em"
        type="button"
        @click="onDeleteAll()"
        :disabled="!selectedPostIDs.length"
      >
        DELETE SELECTED
      </button>
      <input
        style="margin-right: 0.5em"
        type="text"
        placeholder="Search User ID"
        v-model="search.uid"
      />
      <button type="button" @click="onSearch()">Search</button>
    </div>

    <!-- posts table -->
    <table class="mt-5 table table-striped table-sm mw-100">
      <thead>
        <tr>
          <th scope="col">
            <label for="select-all">
              <input
                type="checkbox"
                name="select-all"
                id="select-all"
                @change="onSelectAll($event.target.checked)"
                :checked="selectedPostIDs.length == posts.length"
              />
              All</label
            >
          </th>
          <th scope="col">Post ID / User ID / Category</th>
          <th scope="col">Title / Content</th>
          <th scope="col">Files</th>
          <th scope="col">ACTIONS</th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="post in posts"
          :key="post.id"
          style="border-bottom: 1px solid black"
        >
          <td>
            <input type="checkbox" :value="post.id" v-model="selectedPostIDs" />
          </td>
          <post-component :post="post" @on-deleted="onDeleted($event)" />
        </tr>
      </tbody>
    </table>
    <br />
    <p v-if="fetching">loading posts ...</p>
    <p v-if="noMorePosts">No more posts ...</p>
  </div>
</template>

<script lang="ts">
import { AppService } from "@/services/app.service";
import { Vue, Options } from "vue-class-component";
import firebase from "firebase/app";
import "firebase/firestore";
import "firebase/storage";

import PostCreateComponent from "./Post-create-component.vue";
import PostComponent from "./Post-component.vue";

@Options({
  components: {
    PostComponent,
    PostCreateComponent
  }
})
export default class Posts extends Vue {
  categoriesCol = firebase.firestore().collection("categories");
  postsCol = firebase.firestore().collection("posts");
  storage = firebase.storage();

  app = new AppService();

  uploadProgress = 0;
  limit = 30;

  search = {
    uid: "",
    category: ""
  };

  selectedPostIDs: string[] = [];
  categories: string[] = [];
  posts: any[] = [];

  fetchingCategories = false;
  fetching = false;
  noMorePosts = false;

  async created() {
    const cat = this.$route.params.category as any;
    if (cat != "all") this.search.category = cat;
    this.fetchPosts();
    this.fetchCategories();
    window.addEventListener("scroll", this.handleScroll);
  }

  async fetchCategories() {
    if (this.fetchingCategories) return;
    this.fetchingCategories = true;
    const snapshot = await this.categoriesCol.get();
    snapshot.docs.forEach((doc) => {
      this.categories.push(doc.id);
    });

    this.fetchingCategories = false;
  }

  onSearch() {
    // console.log(this.search);
    this.posts = [];
    this.noMorePosts = false;
    this.fetchPosts();
  }

  async fetchPosts() {
    if (this.fetching) return;
    if (this.noMorePosts) return;
    this.fetching = true;

    let q = this.postsCol.limit(this.limit);
    /// category filter
    if (this.search.category)
      q = q.where("category", "==", this.search.category);
    /// uid filter
    if (this.search.uid) q = q.where("uid", "==", this.search.uid);

    q = q.orderBy("createdAt", "desc");

    if (this.posts.length) {
      q = q.startAfter(this.posts[this.posts.length - 1]["createdAt"]);
    }

    const snapshot = await q.get();
    this.fetching = false;
    console.log("Snapshot size:", snapshot.size);
    this.noMorePosts = snapshot.size < this.limit;

    for (const docSnapshot of snapshot.docs) {
      const data = docSnapshot.data();
      data["id"] = docSnapshot.id;
      this.posts.push(data);
    }
  }

  handleScroll(e: any) {
    const bottomOfWindow =
      document.documentElement.scrollTop + window.innerHeight >
      document.documentElement.offsetHeight - 200;

    if (bottomOfWindow) {
      this.fetchPosts();
    }
  }

  onSelectAll(checked: boolean) {
    this.selectedPostIDs = [];
    if (checked) {
      this.posts.forEach((post) => this.selectedPostIDs.push(post.id));
    }
  }

  onPostCreated(post: any) {
    // console.log('onPostCreated', post);
    this.posts.unshift(post);
  }

  onDeleted(id: string) {
    const idx = this.posts.findIndex((post) => post.id == id);
    this.posts.splice(idx, 1);
  }

  onDeleteAll() {
    const conf = confirm("Delete selected posts?");

    if (!conf) return;

    this.selectedPostIDs.forEach((id) => {
      this.postsCol.doc(id).delete();
      this.onDeleted(id);
    });

    this.selectedPostIDs = [];
    alert("Selected Posts deleted!");
  }
}
</script>

<style lang="scss" scoped>
.posts-table {
  width: 100%;
  tr {
    padding: 0.25em !important;
  }

  tr > th {
    border: 1px solid black;
  }
}
</style>
