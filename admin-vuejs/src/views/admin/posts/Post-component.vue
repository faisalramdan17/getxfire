<template>
  <td>
    <p><b>ID:</b> {{ post.id }}</p>
    <p><b>User ID:</b> {{ post.uid }}</p>
    <p><b>Category:</b> {{ post.category }}</p>
  </td>
  <td class="text-wrap text-break" v-if="!inEdit">
    <p><b>Title:</b> {{ post.title }}</p>
    <b>Content:</b>
    <p>{{ post.content }}</p>
  </td>
  <td v-if="inEdit">
    <b>Title:</b>
    <input type="text" v-model="editData.title" style="width: 100%" /> <br />
    <b>Content:</b>
    <textarea v-model="editData.content" style="width: 100%"> </textarea>
  </td>
  <td>
    <img
      v-for="file in post?.files"
      :key="file"
      :src="file"
      alt="file"
      style="height: 100px; width: 100px"
    />
  </td>
  <td v-if="!inEdit">
    <button type="button" @click="inEdit = true">EDIT</button>
    <button type="button" @click="onDelete()">DELETE</button>
  </td>
  <td v-if="inEdit">
    <button type="button" @click="inEdit = false">Cancel</button>
    <button type="button" @click="onSave()">Save</button>
  </td>
</template>

<script lang="ts">
import { Vue, Options } from "vue-class-component";
import firebase from "firebase/app";
import "firebase/firestore";

@Options({
  props: ["post"],
  emits: ["on-deleted"],
})
export default class PostComponent extends Vue {
  postsCol = firebase.firestore().collection("posts");
  post!: any;

  editData: any = {};

  inEdit = false;

  created() {
    this.editData = this.post;
  }

  async onSave() {
    // console.log(this.editData);
    try {
      this.editData.updatedAt = firebase.firestore.FieldValue.serverTimestamp();
      await this.postsCol.doc(this.post.id).set(this.editData, { merge: true });
      Object.assign(this.post, this.editData);
      this.inEdit = false;
      alert("Post Updated!");
    } catch (e) {
      alert(e);
    }
  }

  async onDelete() {
    const conf = confirm("Delete post?");

    if (!conf) return;

    try {
      await this.postsCol.doc(this.post.id).delete();
      this.$emit("on-deleted", this.post.id);
      alert("post deleted!");
    } catch (e) {
      console.log(e);
      alert(e);
    }
  }
}
</script>
