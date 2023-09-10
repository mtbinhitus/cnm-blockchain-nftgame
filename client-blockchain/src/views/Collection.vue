<template>
    <div class="container">
        <div class="card p-3">
            <h4 class="title text-uppercase ms-3" :style="{ color: 'white', 'font-size': '30px' }">
                Collection
            </h4>
            <span class="ms-3 pb-3" :style="{ color: 'white', 'font-size': '24px' }">
                We have {{ collection.length }} wonderful Pepes for You
            </span>

            <div class="card-items row">
                <div v-for="(item, index) in collection" :key="index" @click="redirectToNftDetail(index)" class="card-item col-lg-3 col-6">
                    <div class="item-body shadow">
                        <div class="content p-3"></div>
                        <div class="">
                            <img :src="image_convert(item.image)" alt="" />
                        </div>
                        <div class="content p-3">
                            <h6 class="text-uppercase">{{ item.name }}</h6>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <Loading v-if="loading" />
    </div>
</template>
  
<script>
import { authStore } from "@/stores/authStore";
import { defineComponent } from "vue";
import axios from "axios";
import Loading from "@/components/Loading.vue";
import { collectionStore } from "@/stores/collectionStore";

export default defineComponent({
    components: { Loading },
    data() {
        return {
            loading: false,
            // inventory: [],
        };
    },
    computed: {
        collection() {
            return collectionStore().list;
        },
    },
    created() {
        this.loading = true;
        this.fetchDataOpenSea();
    },
    methods: {
        redirectToNftDetail(index) {
            this.$router.push({
                path: `/collection/${index}`,
            });
        },
        fetchDataOpenSea() {
            collectionStore().fetch().then(res => this.loading = false).catch(err => this.loading = false);
        },
        image_convert(img) {
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
}

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
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

.text-uppercase {
    font-weight: 600;
}
</style>
  