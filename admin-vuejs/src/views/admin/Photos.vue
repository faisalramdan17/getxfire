<template>
  <span v-for="path in paths" :key="path">
    <a :href="'/admin/photos/' + path">
      {{ path }}
    </a>
    |
  </span>
  <br /><br />

  <div class="grid">
    <div v-for="photo of photos" :key="photo.uid" class="image-holder">
      <a :href="'/admin/users/' + photo.uid">View Owner</a>
      <div class="photo position-relative">
        <img :src="photo.url" class="image" />
        <button
          class="position-absolute top left"
          type="button"
          @click="onClickDelete(url)"
        >
          Delete
        </button>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { Vue } from "vue-class-component";
import firebase from "firebase/app";
import "firebase/storage";
import { AppService } from "@/services/app.service";

export default class Posts extends Vue {
  app = new AppService();
  limit = 20;
  storageRef = firebase.storage().ref();
  paths = ["forum-photos", "user-profile-photos"];

  photos: any[] = [];
  loading = false;
  noMorePhotos = false;
  nextPageToken: string | null = null;

  created() {
    this.fetchImages();
    window.addEventListener("scroll", this.handleScroll);
  }

  get path(): string {
    return this.$route.params["path"] as string;
  }

  async fetchImages() {
    if (this.loading) return;
    if (this.noMorePhotos) return;

    this.loading = true;
    const folderRef = this.storageRef.child(this.path);
    const options: any = {
      maxResults: 20,
    };
    if (this.nextPageToken) options["pageToken"] = this.nextPageToken;
    const res = await folderRef.list(options);

    this.loading = false;
    if (!res.items || res.items.length < this.limit) {
      this.noMorePhotos = true;
    }
    this.nextPageToken = res.nextPageToken;

    res.items.forEach(async (item) => {
      const data = {
        url: "",
        uid: "",
      };
      data.url = await item.getDownloadURL();
      const metaData = await item.getMetadata();
      Object.assign(data, metaData.customMetadata);
      console.log(data);
      this.photos.push(data);
    });
  }

  handleScroll(e: any) {
    const bottomOfWindow =
      document.documentElement.scrollTop + window.innerHeight >
      document.documentElement.offsetHeight - 200;

    if (bottomOfWindow) {
      this.fetchImages();
    }
  }

  async onClickDelete(url: string) {
    url = this.app.getStorageFileFromUrl(url, this.path);
    try {
      await this.app.fileDelete(url);
      const pos = this.photos.findIndex((e) => e.includes(url.split("/")[1]));
      this.photos.splice(pos, 1);

      this.app.alert("success file deletion.");
    } catch (e) {
      this.app.error(e);
    }
  }
}
</script>

<style lang="scss" scoped>
.image-holder {
  box-sizing: border-box;
  padding: 0.25em;
}

@media screen and (min-width: 1200px) {
  .image-holder {
    width: 10%;
  }
}

@media screen and (max-width: 1200px) {
  .image-holder {
    width: 25%;
  }
}

@media screen and (max-width: 900px) {
  .image-holder {
    width: 33%;
  }
}

@media screen and (max-width: 500px) {
  .image-holder {
    flex: 50%;
  }
}

.image {
  width: 100%;
}

.grid {
  display: flex;
  flex-wrap: wrap;
  padding: 0 4px;
}
</style>
