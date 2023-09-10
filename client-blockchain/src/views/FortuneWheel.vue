<template>
  <div class="d-flex justify-content-around">
    <div class="lucky">
      <div class="cycle">
        <FortuneWheel
          style="width: 500px; max-width: 100%"
          :prizes="data"
          @rotateEnd="onRotateEnd"
          :duration="duration"
          :prizeId="numberLucky"
          @rotateStart="onChangePrize"
          :verify="checkSpinCount"
          :canvas="canvasOptions"
        />
      </div>
      <div class="x text-white mt-5 fs-4">
        <span
          class="d-flex justify-content-center"
          :style="{ 'font-weight': 600 }"
          >Your point:
          <h4 class="ms-3 fs-2" :style="{ 'font-weight': 600 }">{{ point }}</h4>
        </span>
      </div>
      <div class="x text-white mt-2 fs-4">
        <span
          class="d-flex justify-content-center"
          :style="{ 'font-weight': 600 }"
          >Number spin:
          <h4 class="ms-3 fs-2" :style="{ 'font-weight': 600 }">
            {{ number_spin }}
          </h4>
        </span>
      </div>
    </div>

    <div class="history">
      <table
        class="table table-striped table-primary table-bordered border-primary"
      >
        <thead class="table-success border-primary">
          <tr>
            <th scope="col">ID</th>
            <th scope="col">Gift</th>
          </tr>
        </thead>
        <tbody class="text-center">
          <tr v-for="(item, index) in listHistory" :key="index">
            <td>{{ item.address }}</td>
            <td>
              <convert-gift-name :link="item.data" />
            </td>
          </tr>
        </tbody>
      </table>

      <!-- <span class="text-white text-decoration-underline">Game rules</span> -->
    </div>
  </div>
  <ModalReceiveGiftVue :gift="gift" />
</template>

<script>
import FortuneWheel from "vue-fortune-wheel";
import "vue-fortune-wheel/style.css";
import { defineComponent } from "vue";
import { DataSpin } from "../data/data.js";
import ModalReceiveGiftVue from "@/components/ModalReceiveGift.vue";
import axios from "axios";
import { dataStore } from "@/stores/dataStore";
import ConvertGiftName from "@/components/ConvertGiftName.vue";
import { authStore } from "@/stores/authStore";

export default defineComponent({
  components: { FortuneWheel, ModalReceiveGiftVue, ConvertGiftName },
  data() {
    return {
      numberLucky: 1,
      data: DataSpin,
      duration: 90000, // 1p30s spin
      duration_fetch: 80000,
      listHistory: [],
      gift: {
        name: "",
        image: "",
      },
      canvasOptions: {
        textLength: 20,
      },
    };
  },

  created() {
    this.fetchHistory();
    dataStore().fetch();
  },

  computed: {
    number_spin() {
      return Math.floor(this.point / 10);
    },

    point() {
      return authStore().score;
    },

    checkSpinCount() {
      return this.number_spin < 1 ? true : false;
    },
  },

  methods: {
    onRotateEnd(prize) {
      this.handleShow();
      this.handleTransfer();
    },

    fetchHistory() {
      return new Promise((resolve, reject) => {
        axios
          .get(`${import.meta.env.VITE_APP_BASE_HOST}/static/history.json`)
          .then(({ data }) => {
            this.listHistory = data;
            resolve(data);
          });
      });
    },

    updateScore() {
      const address = authStore().address;
      return new Promise((resolve, reject) => {
        axios
          .post(`${import.meta.env.VITE_APP_BASE_HOST}/api/nft/update-score`, {
            score: this.point - 10,
            address: address,
          })
          .then(() => {
            authStore().getInfo();
          });
      });
    },

    onChangePrize(id) {
      if (!this.checkSpinCount) {
        this.handleCreateNft();
        this.updateScore();

        setTimeout(() => {
          // this.numberLucky = 5;
          this.handleGetInfoNFT();
        }, this.duration_fetch);
      }
    },

    handleCreateNft() {
      // setTimeout(() => {
      //   console.log("create complete")
      // }, 20000);
      return new Promise((resolve, reject) => {
        axios
          .post(`${import.meta.env.VITE_APP_BASE_HOST}/api/nft/mint`)
          .then(() => resolve(true))
          .catch((err) => reject(err));
      });
    },

    handleTransfer() {
      const address = authStore().address;
      axios.post(`${import.meta.env.VITE_APP_BASE_HOST}/api/nft/transfer`, {
        address_to: address,
      });
    },

    async handleGetInfoNFT() {
      const dataN = await axios.get(
        `${import.meta.env.VITE_APP_BASE_HOST}/api/nft/info`
      );
      const Link = dataN.data.pepeCardData;
      const Data = await axios.get(Link);

      console.log(Data.data, "----fetch data info---");

      this.gift.name = Data.data.name;
      this.gift.image = this.convertIpfsUrl(Data.data.image);

      const x = this.data.find(
        (i) =>
          i.value.toLowerCase() == Data.data.attributes[0].value.toLowerCase()
      );

      console.log("x:", x);

      if (x) {
        this.numberLucky = x.id;
      }
    },

    convertIpfsUrl(ipfsUrl) {
      const ipfsHash = ipfsUrl.split("ipfs://")[1];
      if (ipfsUrl.includes("https://ipfs.io/ipfs/")) return ipfsUrl;
      if (!ipfsHash) {
        return null; // Không phải định dạng ipfs:// hợp lệ
      }
      const convertedUrl = `https://ipfs.io/ipfs/${ipfsHash}`;
      return convertedUrl;
    },

    handleShow() {
      const myModal = new bootstrap.Modal(
        document.getElementById("exampleModal"),
        {}
      );
      myModal.show();
    },
  },
});
</script>

<style scoped>
.wheel {
  width: 100%;
  height: auto;
  margin: 0 auto;
}
.wheel textPath {
  letter-spacing: 1px;
  stroke: rgb(0 0 0 / 10%);
}
.wheel_font-size--1,
.wheel_font-size--2,
.wheel_font-size--3,
.wheel_font-size--4,
.wheel_font-size--5,
.wheel_font-size--6 {
  font-size: 2px;
}

.lucky {
  padding: 5em 1em;
}

.history {
  padding: 5em 1em;
}

th {
  min-width: 250px;
}

.table {
  display: block;
  height: 500px !important;
  overflow: auto;
}
</style>
