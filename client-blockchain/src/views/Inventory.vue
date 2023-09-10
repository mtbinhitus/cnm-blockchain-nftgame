<template>
  <div class="container">
    <div class="card p-3">
      <h4 class="title text-uppercase ms-3">Inventory</h4>
      <span class="ms-3 border-bottom pb-3">
        {{ inventory.length }} - NFT in your inventory.
      </span>

      <div class="card-items row">
        <NftCard
          v-for="(item, index) in inventory"
          :key="index"
          :item="item"
          @click="redirectToNftDetail(index)"
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
    redirectToNftDetail(index) {
      this.$router.push({
        path: `/inventory/${index}`,
      });
    },
    fetchDataOpenSea() {
      this.loading = true;
      nftStore().fetch().then(res => this.loading = false).catch(err => {
        this.loading = false
      });
    },
  },
});
</script>

<style scoped>
.card {
  max-height: 80vh;
  overflow-y: scroll;
}
.card::-webkit-scrollbar {
  display: none;
}
</style>
