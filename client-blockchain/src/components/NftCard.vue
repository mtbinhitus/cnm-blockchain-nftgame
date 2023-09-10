<template>
  <div class="card-item col-lg-3 col-6">
    <div class="item-body shadow">
      <div class="">
        <img :src="image_convert" alt="" />
      </div>
      <div class="content p-3">
        <h6 class="text-uppercase">{{ item.title }}</h6>
      </div>
    </div>
  </div>
</template>

<script>
import { defineComponent } from "vue";

export default defineComponent({
  props: ["item"],

  computed: {
    image_convert() {
      const img = this.item.metadata.image;
      if (img.includes("https://ipfs.io/ipfs/")) return img;
      const ipfsHash = img.split("ipfs://")[1];
      if (!ipfsHash) {
        return "https://placehold.jp/150x150.png"; // Không phải định dạng ipfs:// hợp lệ
      }
      const convertedUrl = `https://ipfs.io/ipfs/${ipfsHash}`;
      return convertedUrl;
    },
  },
});
</script>

<style scoped>
.card-item {
  padding: 1em;
  transition: transform 0.2s;
}
img {
  width: 100%;
  background: #dee2e6;
}
.card-item:hover {
  transform: scale(1.1);
  border-radius: 8px;
  cursor: pointer;
}
.item-body {
  background: white;
}
</style>
