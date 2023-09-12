<template>
  <div class="container">
    <Loading v-if="loading" />
    <div class="card p-3">
      <div v-if="!loading" class="row">
        <div class="col-lg-4 lg-12" :style="{ margin: '2vh auto' }">
          <div class="image p-3">
            <model-viewer
              v-if="isMounted"
              :src="detail.animation_url"
              ar
              shadow-intensity="1"
              autoplay
              camera-controls
              touch-action="pan-y"
            ></model-viewer>
          </div>
        </div>
        <div class="col-lg-8 p-3">
          <div class="title" :style="{ color: 'white' }">
            <h3>{{ detail.name }}</h3>
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
              ><strong>Address:</strong> {{ contract.address }}</span
            >
            <span class="d-block mt-2" :style="{ color: 'white' }"
              ><strong>Name:</strong> {{ contract.contractMetadata.name }}</span
            >
            <span class="d-block mt-2" :style="{ color: 'white' }"
              ><strong>Symbol:</strong>
              {{ contract.contractMetadata.symbol }}</span
            >
            <span class="d-block mt-2" :style="{ color: 'white' }"
              ><strong>Token type:</strong>
              {{ contract.contractMetadata.tokenType }}</span
            >
          </div>

          <div class="attributeds mt-4 border-top pt-3">
            <h4 class="text-uppercase" :style="{ color: 'white' }">
              Attribute
            </h4>
            <div
              class="row mt-3"
              v-for="(attribute, index) in detail.attributes"
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
          <router-link to="/collection" class="btn btn-primary mt-3">
            Back to Collection
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
import { collectionStore } from "@/stores/collectionStore";
import moment from "moment";

export default defineComponent({
  components: { Loading },
  data() {
    return {
      detail: {},
      loading: true,
      isMounted: false,
    };
  },
  mounted() {
    this.isMounted = true;
    this.loadComponent();
  },
  computed: {
    image_convert() {
      const img = this.detail.image;
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
      const dateTime = moment();

      return dateTime.format(format);
    },
    loadComponent() {
      return () => import("@google/model-viewer/dist/model-viewer");
    },
  },
  async created() {
    this.loading = true;
    const id = this.$route.params.id;
    await this.fetchDataOpenSea(id);
  },
  methods: {
    fetchDataOpenSea(id) {
      if (collectionStore().list.length == 0) {
        collectionStore()
          .fetch()
          .then((res) => {
            this.detail = collectionStore().list.find((item, index) => {
              return index == Number(id);
            });
            this.fetInfoContract().then((res) => (this.loading = false));
          })
          .catch((err) => (this.loading = true));
      } else {
        this.detail = collectionStore().list.find((item, index) => {
          return index == Number(id);
        });
        this.fetInfoContract().then((res) => (this.loading = false));
      }
    },
    fetInfoContract() {
      const config = {
        Accept: "application/json",
      };

      const BASE_URL = import.meta.env.VITE_APP_GOERLI_ALCHEMY;
      const CONTRACT = import.meta.env.VITE_APP_CONTRACT;
      const url = `${BASE_URL}/getContractMetadata/?contractAddress=${CONTRACT}`;
      return new Promise((resolve, reject) => {
        axios
          .get(url, config)
          .then(({ data }) => {
            this.contract = data;
            resolve(data);
          })
          .catch((err) => {
            reject(err);
          });
      });
    },
  },
});
</script>

<style scoped>
.container {
  padding-left: 0px;
  padding-right: 0px;
}

img {
  background: #dee2e6;
}

.card.p-3 {
  height: 550px;
  background: rgba(0, 0, 0, 0.4);
  overflow-x: hidden;
  --bs-card-border-radius: 0px;
  border: 0px;
}

.image.p-3 {
  background: transparent;
  width: 100%;
  height: 100%;
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
.model-view-css-fix {
  object-fit: contain;
  height: 45vh;
  width: auto;
}

model-viewer {
  width: 100%;
  height: 100%;
  margin: auto;
}
</style>
