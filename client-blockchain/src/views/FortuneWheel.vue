<template>
  <div class="d-flex justify-content-around">
    <div class="lucky">
      <div class="cycle">
        <FortuneWheel
          style="width: 500px; max-width: 100%"
          :prizes="data"
          @rotateEnd="onRotateEnd"
          :duration="15000"
          :prizeId="numberLucky"
          @rotateStart="onChangePrize"
        />
      </div>
      <div class="x text-white mt-5 fs-4">
        <span class="d-flex justify-content-center"
          >Your point:
          <h4 class="ms-3 fs-2">{{ point }}</h4>
        </span>
      </div>
      <div class="x text-white mt-2 fs-4">
        <span class="d-flex justify-content-center"
          >Number spin:
          <h4 class="ms-3 fs-2">{{ number_spin }}</h4>
        </span>
      </div>
    </div>

    <div class="history">
      <h3 class="title text-uppercase text-center mb-5 text-danger fs-2">
        History
      </h3>
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
          <tr>
            <td>0x78282787428h2vs82342</td>
            <td>Challenger</td>
          </tr>
          <tr>
            <td>0x78282787428h2vs82342</td>
            <td>Diamond</td>
          </tr>
          <tr>
            <td>0x78282787428h2vs82342</td>
            <td>Diamond</td>
          </tr>
          <tr>
            <td>0x78282787428h2vs82342</td>
            <td>Diamond</td>
          </tr>
          <tr>
            <td>0x78282787428h2vs82342</td>
            <td>Diamond</td>
          </tr>
          <tr>
            <td>0x78282787428h2vs82342</td>
            <td>Diamond</td>
          </tr>
          <tr>
            <td>0x78282787428h2vs82342</td>
            <td>Diamond</td>
          </tr>
          <tr>
            <td>0x78282787428h2vs82342</td>
            <td>Diamond</td>
          </tr>
        </tbody>
      </table>

      <span class="text-white text-decoration-underline">Game rules</span>
    </div>
  </div>
  <ModalReceiveGiftVue/>
</template>

<script>
import FortuneWheel from "vue-fortune-wheel";
import "vue-fortune-wheel/style.css";
import { defineComponent } from "vue";
import { DataSpin } from "../data/data.js";
import ModalReceiveGiftVue from "@/components/ModalReceiveGift.vue";

export default defineComponent({
  components: { FortuneWheel, ModalReceiveGiftVue },
  data() {
    return {
      numberLucky: 1,
      data: DataSpin,
    };
  },

  computed: {
    number_spin() {
      return 1;
    },
    point() {
        return 100;
    }
  },

  methods: {
    onRotateEnd(prize) {
      alert(prize.value);
    },
    onChangePrize(id) {
      console.log(id);
      setTimeout(() => {
        this.numberLucky = 5;
        console.log("change number");
      }, 5000);
    },

    handleShow() {
      const myModal = new bootstrap.Modal(
        document.getElementById("exampleModal"),
        {}
      );
      myModal.show()
    },
  },
});
</script>

<style>
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
.wheel_font-size--4 {
  font-size: 8px;
}
.wheel_font-size--5,
.wheel_font-size--6 {
  font-size: 10px;
}
.wheel_font-size--7,
.wheel_font-size--8 {
  font-size: 8px;
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
