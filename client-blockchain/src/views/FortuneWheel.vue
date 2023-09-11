<template>
  <div
    class="d-flex justify-content-between"
    :style="{
      'flex-direction': 'row',
      'align-items': 'flex-start',
      height: '550px',
      background: 'rgba(0,0,0,0.4)',
    }"
  >
    <div
      class="lucky"
      :style="{
        height: '100%',
      }"
    >
      <div class="cycle">
        <FortuneWheel
          style="width: 400px; max-width: 100%"
          :prizes="data"
          @rotateEnd="onRotateEnd"
          :duration="duration"
          :prizeId="numberLucky"
          @rotateStart="onChangePrize"
          :verify="checkSpinCount"
          :canvas="canvasOptions"
        />
      </div>
      <div class="info">
        <div class="x text-white mt-3 fs-4">
          <span
            class="d-flex justify-content-center"
            :style="{ 'font-weight': 600, 'font-size': '24px' }"
            >Your points: {{ point }}
          </span>
        </div>
        <div class="x text-white mt-2 fs-4">
          <span
            class="d-flex justify-content-center"
            :style="{ 'font-weight': 600, 'font-size': '24px' }"
            >Number of spins: {{ number_spin }}
          </span>
        </div>
      </div>
    </div>

    <div
      class="history"
      :style="{
        height: '100%',
      }"
    >
      <div class="table-container" style="height: 500px; overflow-y: auto">
        <table class="table table-bordered">
          <thead class="thead-custom">
            <tr>
              <th>Wallet Address</th>
              <th>Pepe Card</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in listHistory" :key="index">
              <td
                :class="{
                  'common-text': containsCommonWord(getGiftName(item.data)),
                  'uncommon-text': containsUncommonWord(getGiftName(item.data)),
                  'rare-text': containsRareWord(getGiftName(item.data)),
                  'epic-text': containsEpicWord(getGiftName(item.data)),
                  'legendary-text': containsLegendaryWord(
                    getGiftName(item.data)
                  ),
                }"
              >
                {{ item.address }}
              </td>
              <td
                :class="{
                  'common-text': containsCommonWord(getGiftName(item.data)),
                  'uncommon-text': containsUncommonWord(getGiftName(item.data)),
                  'rare-text': containsRareWord(getGiftName(item.data)),
                  'epic-text': containsEpicWord(getGiftName(item.data)),
                  'legendary-text': containsLegendaryWord(
                    getGiftName(item.data)
                  ),
                }"
              >
                <convert-gift-name :link="item.data" />
              </td>
            </tr>
          </tbody>
        </table>
      </div>

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
    containsCommonWord() {
      return (text) => {
        return text.toLowerCase().includes("common");
      };
    },
    containsUncommonWord() {
      return (text) => {
        return text.toLowerCase().includes("uncommon");
      };
    },
    containsRareWord() {
      return (text) => {
        return text.toLowerCase().includes("rare");
      };
    },
    containsEpicWord() {
      return (text) => {
        return text.toLowerCase().includes("epic");
      };
    },
    containsLegendaryWord() {
      return (text) => {
        return text.toLowerCase().includes("legendary");
      };
    },
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
    getGiftName(link) {
      const giftList = dataStore().list;

      // Find the gift object that matches the link
      const gift = giftList.find((giftItem) => giftItem.key === link);

      // Check if a matching gift was found
      if (gift) {
        return gift.name; // Return the gift name if found
      } else {
        return ""; // Return an empty string or handle the case when no gift is found
      }
    },

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
.common-text {
  background-color: #bdbdb5;
}
.uncommon-text {
  background-color: #1fdd1d;
}
.rare-text {
  background-color: #4e5afd;
}
.epic-text {
  background-color: #a745ce;
}
.legendary-text {
  background-color: #f86912;
}

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
  width: 500px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.history {
  width: 800px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.table-container {
  width: 90%;
  overflow-x: auto;
}

.table {
  width: 100%;
  border-collapse: collapse;
  border: 1px solid white;
}

th,
td {
  padding: 8px;
  text-align: left;
  color: white;
}

/* Style table headers with a different background color */
.thead-custom th {
  background-color: #15bd96;
}

.cycle {
  height: 400px;
}

.info {
  height: 100px;
}
</style>
