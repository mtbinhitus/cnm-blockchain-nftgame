<script setup lang="ts">
import { RouterView } from "vue-router";
import Header from "@/components/Header.vue";
</script>

<template>
  <div class="k7">
    <div class="container">
      <Header />
      <router-view />
    </div>
  </div>
</template>
<style scoped>
.k7 {
  background-image: url("https://www.jaxon.gg/wp-content/uploads/2022/07/Summoners-Rift-e1658690646915.jpeg");
  /* background-image: url("wallpaper.jpg"); */
  background-size: 100% 100%; /* Adjust the background size as needed */
  background-repeat: no-repeat;
  height: 100vh;
  width: 100vw;
  overflow: auto;
}
</style>
