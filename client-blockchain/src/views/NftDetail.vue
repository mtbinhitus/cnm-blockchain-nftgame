<template>
  <div class="container">
    <div class="card p-3">
      <h4 class="title text-uppercase ms-3"></h4>
      <div class="row">
        <div class="col-lg-4 lg-12">
          <div class="image p-3 border rounded">
            <img :src="image_convert" alt="" class="w-100 rounded" />
          </div>
        </div>
        <div class="col-lg-8 p-3">
          <div class="title">
            <h3>{{ detail.title }}</h3>
          </div>
          <div class="mt-3">
            <span class="d-block">
              <strong>description: </strong>{{ detail.description }}</span
            >
            <span class="d-block mt-2">
              <strong>last updated: </strong>{{ dateTime }}</span
            >
          </div>
          <div class="content mt-4 border-top pt-3">
            <h5 class="text-uppercase">Contract:</h5>
            <span class="d-block mt-3"
              ><strong>Address:</strong> {{ detail.contract.address }}</span
            >
            <span class="d-block mt-2"
              ><strong>Name:</strong> {{ detail.contractMetadata.name }}</span
            >
            <span class="d-block mt-2"
              ><strong>Symbol:</strong>
              {{ detail.contractMetadata.symbol }}</span
            >
            <span class="d-block mt-2"
              ><strong>tokenType:</strong>
              {{ detail.contractMetadata.tokenType }}</span
            >
          </div>

          <div class="attributeds mt-4 border-top pt-3">
            <h5 class="text-uppercase">attributes</h5>
            <div
              class="row mt-3"
              v-for="(attribute, index) in detail.metadata.attributes"
              :key="index"
            >
              <div class="col-4">
                <span> {{ attribute.trait_type }}: </span>
              </div>
              <div class="col-8">
                <span>{{ attribute.value }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <loading v-if="loading" />
  </div>
</template>

<script>
import { authStore } from "@/stores/authStore";
import { defineComponent } from "vue";
import axios from "axios";
import Loading from "@/components/Loading.vue";
import { nftStore } from "@/stores/nftStore";
import moment from "moment";

export default defineComponent({
  components: { Loading },
  data() {
    return {
      detail: {},
    };
  },
  computed: {
    image_convert() {
      const img = this.detail.metadata.image;
      if (img.includes("https://ipfs.io/ipfs/")) return img;
      const ipfsHash = img.split("ipfs://")[1];
      if (!ipfsHash) {
        return "https://placehold.jp/150x150.png"; // Không phải định dạng ipfs:// hợp lệ
      }
      const convertedUrl = `https://ipfs.io/ipfs/${ipfsHash}`;
      return convertedUrl;
    },

    dateTime() {
      const format = "YYYY-MM-DD HH:mm:ss";
      const dateTime = moment(this.detail.metadata.timeLastUpdated);

      return dateTime.format(format);
    },
  },
  created() {
    const id = this.$route.params.id;

    this.detail = nftStore().list.find((item, index) => {
      return index == Number(id);
    });
  },
  methods: {
    fetchDataOpenSea() {},
  },
});
</script>

<style scoped>
img {
  background: #dee2e6;
}
</style>
