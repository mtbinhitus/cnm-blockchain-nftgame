<template>
  <div class="container">
    <div class="card p-3">
      <h4
        class="title text-uppercase ms-3"
        :style="{ color: 'white', 'font-size': '30px', 'font-weight': 600 }"
      >
        Inventory
      </h4>
      <span class="ms-3 pb-3" :style="{ color: 'white', 'font-size': '24px' }">
        You have {{ inventory.length }} wonderful Pepes
      </span>

      <div class="card-items row">
        <NftCard
          v-for="(item, index) in inventory"
          :key="index"
          :item="item"
          @click="redirectToNftDetail(index, $event)"
        />
      </div>
    </div>
    <Loading v-if="loading" />
  </div>
</template>

<script>
import { authStore } from "@/stores/authStore";
import { defineComponent } from "vue";
import axios from "axios";
import NftCard from "@/components/NftCard.vue";
import Loading from "@/components/Loading.vue";
import { nftStore } from "@/stores/nftStore";

export default defineComponent({
  components: { NftCard, Loading },
  data() {
    return {
      loading: false,
      // inventory: [],
    };
  },
  computed: {
    inventory() {
      return nftStore().list;
    },
  },
  created() {
    this.fetchDataOpenSea();
  },
  methods: {
    redirectToNftDetail(index, event) {
      // Check if the Ctrl key is pressed when clicking
      if (event.ctrlKey) {
        // Open a new tab with the desired URL
        const newTab = window.open(`/inventory/${index}`, "_blank");
        // Focus back on the current tab
        event.preventDefault();
      } else {
        // If Ctrl key is not pressed, navigate normally
        this.$router.push({
          path: `/inventory/${index}`,
        });
      }
    },
    fetchDataOpenSea() {
      this.loading = true;
      const config = {
        Accept: "application/json",
      };

      const WALLET_ADDRESS = authStore().address;
      const BASE_URL = import.meta.env.VITE_APP_GOERLI_ALCHEMY;
      const CONTRACT = import.meta.env.VITE_APP_CONTRACT;
      const url = `${BASE_URL}/getNFTs/?owner=${WALLET_ADDRESS}&contractAddresses[]=${CONTRACT}`;
      return new Promise((resolve, reject) => {
        axios
          .get(url, config)
          .then(({ data }) => {
            // this.collection = data.ownedNfts  ;
            nftStore().list = data.ownedNfts.reverse();
            console.log(data);
            this.loading = false;
            resolve(data);
          })
          .catch((err) => {
            this.loading = false;
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

.card {
  max-height: 80vh;
  overflow-y: scroll;
}
.card::-webkit-scrollbar {
  display: none;
}

.card.p-3 {
  background: rgba(0, 0, 0, 0.4);
  overflow-x: hidden;
  --bs-card-border-radius: 0px;
  border: 0px;
  height: 735px;
}
</style>
