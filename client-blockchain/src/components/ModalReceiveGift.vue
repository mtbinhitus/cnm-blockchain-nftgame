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
          <h1 class="modal-title fs-5" id="exampleModalLabel">
            Congrats you received a wonderful Pepe card: {{ gift.name }}
          </h1>
          <button
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Close"
          ></button>
        </div>
        <div class="modal-body d-flex justify-content-center">
          <img :src="gift.image" alt="" class="d-block" />
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
</style>
