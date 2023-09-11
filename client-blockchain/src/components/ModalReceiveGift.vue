<template>
  <!-- Modal -->
  <div
    class="modal fade"
    id="exampleModal"
    tabindex="-1"
    aria-labelledby="exampleModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1
            class="modal-title fs-5"
            id="exampleModalLabel"
            :style="{
              display: 'flex',
              'flex-direction': 'column',
              'align-items': 'flex-start',
            }"
          >
            <span> Congrats, you received a wonderful Pepe card:<br /> </span>
          </h1>
          <button
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Close"
          ></button>
        </div>
        <div
          class="modal-body d-flex justify-content-center"
          :style="{ 'flex-direction': 'column', 'align-items': 'center' }"
        >
          <img :src="gift.image" alt="" class="d-block" />
          <span :style="{ 'padding-top': '10px' }"> {{ gift.name }}</span>
        </div>
        <!-- <div class="modal-footer">
        <button type="button" class="btn btn-primary">Accept</button>
      </div> -->
      </div>
    </div>
  </div>
</template>

<script>
import { defineComponent } from "vue";

export default defineComponent({
  props: ["gift"],
});
</script>

<style scoped>
img {
  width: 150px;
  height: 150px;
}

.modal-header .btn-close {
  margin: 0;
}
</style>
