<template>
  <small class="hint"
    >To add new settings, simply submit the form with key and value.</small
  >
  <form @submit.prevent="onSubmit">
    <input type="text" v-model="form.field" placeholder="Setting Key" />
    <input type="text" v-model="form.value" placeholder="Setting Value" />
    <button type="submit">Save</button>
  </form>

  <table class="table">
    <thead>
      <tr>
        <th scope="col"># Name</th>
        <th scope="col">Value (editable)</th>
        <th scope="col">Buttons</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="key of Object.keys(settings).sort()" :key="key">
        <td>{{ key }}</td>
        <td>
          <form @submit.prevent="onUpdate(key)">
            <input type="text" v-model="settings[key]" />
            <button type="submit">Save</button>
            <button type="button" @click="onDelete(key)">Delete</button>
          </form>
        </td>
      </tr>
    </tbody>
  </table>
</template>

<script lang="ts">
import { Vue } from "vue-class-component";
import firebase from "firebase/app";
import "firebase/firestore";

export default class AppSettings extends Vue {
  col = firebase.firestore().collection("settings");

  form: any = {};
  settings: any = {};

  created() {
    this.col.doc("app").onSnapshot(doc => (this.settings = doc.data()));
  }

  onSubmit() {
    this.col.doc("app").set(
      {
        [this.form.field]: this.form.value
      },
      { merge: true }
    );
    this.form = {};
  }

  onUpdate(field: string) {
    this.col.doc("app").set(
      {
        [field]: this.settings[field]
      },
      { merge: true }
    );
  }

  onDelete(field: string) {
    this.col.doc("app").set(
      {
        [field]: firebase.firestore.FieldValue.delete()
      },
      { merge: true }
    );
  }
}
</script>
