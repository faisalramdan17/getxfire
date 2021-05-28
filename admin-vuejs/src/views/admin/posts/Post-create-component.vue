<template>
  <div class="border p-3">
    <!-- title -->
    <b>Title</b>
    <input
      type="text"
      name="title"
      id="title"
      v-model="newPostData.title"
      class="mb-3 w-100"
    />
    <!-- content -->
    <b>Content</b>
    <textarea
      name="content"
      id="content"
      v-model="newPostData.content"
      class="mb-3 w-100"
      style="min-height: 150px;"
    />
    <!-- files -->
    <div v-if="newPostData.files.length" class="d-flex m-2">
      <div
        v-for="url in newPostData.files"
        :key="url"
        class="position-relative"
        style="width: 150px; height: 150px"
      >
        <img :src="url" style="width: 100%; height: 100%" />
        <button
          type="button"
          class="position-absolute top left"
          @click="onClickDeleteFile(url)"
        >
          DELETE
        </button>
      </div>
    </div>
    <!-- buttons -->
    <div class="d-flex">
      <input
        type="file"
        name="image_upload"
        id="image_upload"
        v-on:change="onImageChanged($event)"
      />
      <select class="mx-3" v-if="!category" v-model="newPostData.category">
        <option disabled value="">Category</option>
        <option v-for="category of categories" :key="category">
          {{ category }}
        </option>
      </select>
      <span class="flex-grow-1"></span>
      <button class="btn-success" type="button" @click="onCreate()">
        Create
      </button>
    </div>
  </div>
</template>

<script lang="ts">
import { Vue, Options } from "vue-class-component";
import firebase from "firebase/app";
import "firebase/firestore";
import "firebase/storage";
import PostComponent from "./Post-component.vue";
import { AppService } from "@/services/app.service";

import algoliasearch from "algoliasearch";
import { Settings } from "@/services/settings.service";

@Options({
  props: ["category", "categories"],
  emits: ["on-created"]
})
export default class PostsCreateComponent extends Vue {
  postsCol = firebase.firestore().collection("posts");
  storage = firebase.storage();
  app = new AppService();

  categories!: string[];
  category!: string;
  post!: string;

  forumPhotosFolder = "forum-photos";

  newPostData: any = {
    title: "",
    content: "",
    category: "",
    files: []
  };

  created() {
    console.log(Settings.get("ALGOLIA_APP_ID"));
  }

  /**
   * Creates new post
   *
   * TODO: add files.
   */
  async onCreate() {
    // const data: any = {};
    // Object.assign(data, this.newPostData);
    if (this.category) this.newPostData.category = this.category;

    if (!this.newPostData.category) {
      return alert("Please choose category");
    }
    this.newPostData.uid = firebase.auth().currentUser?.uid;
    this.newPostData.createdAt = firebase.firestore.FieldValue.serverTimestamp();
    this.newPostData.updatedAt = firebase.firestore.FieldValue.serverTimestamp();

    // console.log(this.newPostData);
    try {
      const post = await this.postsCol.add(this.newPostData);
      this.newPostData.id = post.id;
      this.$emit("on-created", Object.assign({}, this.newPostData));
    } catch (e) {
      alert(e);
    }

    try {
      const client = algoliasearch(
        Settings.get("ALGOLIA_APP_ID"),
        Settings.get("ALGOLIA_ADMIN_API_KEY")
      );
      const index = client.initIndex(Settings.get("ALGOLIA_INDEX_NAME"));
      const data = {
        objectID: "posts/" + this.newPostData.id,
        title: this.newPostData.title,
        content: this.newPostData.content,
        stamp: new Date().getTime()
      };
      console.log("data: ", data);

      /// This does not throw exception even if there is an error.
      await index.saveObject(data);
    } catch (e) {
      this.app.error(e);
    }

    this.newPostData.title = "";
    this.newPostData.content = "";
    this.newPostData.files = [];
    alert("New post created!");
  }

  async onImageChanged(event: any) {
    const file: File = event.target.files[0];
    const filename = this.app.getRandomString();

    const ref = this.storage.ref(this.forumPhotosFolder + "/" + filename);
    const customMeta = { uid: firebase.auth().currentUser?.uid as string };
    const task = ref.put(file, {
      customMetadata: customMeta
    });

    /// TODO: upload progress indicator
    task.on("next", (snapshot) => {
      console.log("upload", snapshot.bytesTransferred, snapshot.totalBytes);
      console.log(
        "upload progress",
        snapshot.bytesTransferred / snapshot.totalBytes
      );
    });

    try {
      await task;
      const url = await ref.getDownloadURL();
      this.newPostData.files.push(url);
      this.app.alert("Upload success!");
    } catch (e) {
      this.app.error(e);
    }
  }

  async onClickDeleteFile(url: string) {
    console.log(url);
    url = this.app.getStorageFileFromUrl(url, this.forumPhotosFolder);

    try {
      await this.app.fileDelete(url);
      const pos = this.newPostData.files.findIndex((e: string) => e == url);
      this.newPostData.files.splice(pos, 1);

      console.log("success file deletion.");
    } catch (e) {
      console.log("error on deleting file: , ", e);
    }
  }
}
</script>
