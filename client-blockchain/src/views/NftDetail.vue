<template>
  <div class="container">
    <Loading v-if="loading" />
    <div class="card p-3">
      <div v-if="!loading" class="row">
        <div class="col-lg-4 lg-12" :style="{ margin: 'auto' }">
          <div class="image p-3">
            <img :src="image_convert" alt="" class="w-100 rounded" />
          </div>
        </div>
        <div class="col-lg-8 p-3">
          <div class="title" :style="{ color: 'white' }">
            <h3>{{ detail.title }}</h3>
          </div>
          <div class="mt-3">
            <span class="d-block" :style="{ color: 'white' }">
              <strong>Description: </strong>{{ detail.description }}</span
            >
            <span class="d-block mt-2" :style="{ color: 'white' }">
              <strong>Last updated: </strong>{{ dateTime }}</span
            >
          </div>
          <div class="content mt-4 border-top pt-3">
            <h4 class="text-uppercase" :style="{ color: 'white' }">Contract</h4>
            <span class="d-block mt-3" :style="{ color: 'white' }"
              ><strong>Address:</strong> {{ detail.contract.address }}</span
            >
            <span class="d-block mt-2" :style="{ color: 'white' }"
              ><strong>Name:</strong> {{ detail.contractMetadata.name }}</span
            >
            <span class="d-block mt-2" :style="{ color: 'white' }"
              ><strong>Symbol:</strong>
              {{ detail.contractMetadata.symbol }}</span
            >
            <span class="d-block mt-2" :style="{ color: 'white' }"
              ><strong>Token type:</strong>
              {{ detail.contractMetadata.tokenType }}</span
            >
          </div>

          <div class="attributeds mt-4 border-top pt-3">
            <h4 class="text-uppercase" :style="{ color: 'white' }">
              Attributes
            </h4>
            <div
              class="row mt-3"
              v-for="(attribute, index) in detail.metadata.attributes"
              :key="index"
            >
              <div class="d-block" :style="{ color: 'white' }">
                <span
                  ><strong>{{ attribute.trait_type }}: </strong>
                  {{ attribute.value }}</span
                >
              </div>
              <!-- <div class="col-1" :style="{ color: 'white' }">
                <span :style="{ color: 'white' }">{{ attribute.value }}</span>
              </div> -->
            </div>
          </div>

          <router-link to="/inventory" class="btn btn-primary mt-3">
            Back to Inventory
          </router-link>
        </div>
      </div>
    </div>
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
      loading: true,
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
      const dateTime = moment(this.detail.timeLastUpdated);

      return dateTime.format(format);
    },
  },
  async created() {
    this.loading = true;
    const id = this.$route.params.id;
    await this.fetchDataOpenSea(id);
  },
  methods: {
    fetchDataOpenSea(id) {
      if (nftStore().list.length == 0) {
        nftStore()
          .fetch()
          .then((res) => {
            this.detail = nftStore().list.find((item, index) => {
              return index == Number(id);
            });
            this.loading = false;
          })
          .catch((err) => (this.loading = false));
      } else {
        this.detail = nftStore().list.find((item, index) => {
          return index == Number(id);
        });
        this.loading = false;
      }
    },
  },
});
</script>

<style scoped>
img {
  background: #dee2e6;
}

.card.p-3 {
  background: rgba(0, 0, 0, 0.4);
  overflow-x: hidden;
  --bs-card-border-radius: 0px;
}

.image.p-3 {
  background: white;
}

.btn {
  width: 80%;
  background: rgba(0, 0, 0, 0.4);
  border: 3px solid white;
  border-radius: 0px;
  color: white;
}

.btn:hover {
  background: black;
}

.btn:focus {
  background: black;
  border: 3px solid white;
}
</style>
