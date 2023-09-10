<template>
  <div class="container">
    <div
      class="centered-content"
      v-if="!showSecondCentered && !showThirdCentered"
    >
      <div class="screen">
        <div class="image-container">
          <img :src="currentImage" alt="Ad Image" @click="incrementCounter" />
        </div>
        <div class="counter-container">
          <p :style="{ color: 'white', margin: '0', 'font-size': '20px' }">
            You have punched Pepe: {{ clickCount }}
          </p>
        </div>
      </div>

      <div class="screen">
        <div class="image-container">
          <img :src="currentImage2" alt="Ad Image" @click="incrementCounter2" />
        </div>
        <div class="counter-container">
          <p :style="{ color: 'white', margin: '0', 'font-size': '20px' }">
            You have punched Wojak: {{ clickCount2 }}
          </p>
        </div>
      </div>
    </div>

    <div class="centered-content" v-if="showSecondCentered">
      <img
        src="/wojak-finish.gif"
        alt="Ad Image"
        @click="resetClickCount"
        :style="{ width: '100%', height: '100%' }"
      />
    </div>

    <div class="centered-content" v-if="showThirdCentered">
      <img
        src="/pepe-finish.gif"
        alt="Ad Image"
        @click="resetClickCount2"
        :style="{ width: '100%', height: '100%' }"
      />
    </div>
  </div>
</template>

<script>
import Banner from "@/components/Banner.vue";
export default {
  data() {
    return {
      clickCount: 0,
      clickCount2: 0,
      showSecondCentered: false,
      showThirdCentered: false,
      currentImage: "/pepe-wojak.jpg",
      currentImage2: "/wojak-pepe.jpg",
      imageChangeTimer: null,
      imageChangeTimer2: null,
    };
  },
  components: { Banner },
  methods: {
    redirectTo(to) {
      this.$router.push({ path: `/${to}` });
    },
    incrementCounter() {
      this.clickCount++;

      if (this.inactivityTimer) {
        clearTimeout(this.inactivityTimer);
      }

      if (this.clickCount === 10) {
        // When clickCount reaches 10, hide the screen and show the image
        this.showSecondCentered = true;
      } else {
        // Start a timer for 5 seconds of inactivity
        this.currentImage = "/wojak-punch.gif";
        this.inactivityTimer = setTimeout(() => {
          this.currentImage = "/pepe-wojak.jpg";
        }, 2000);
      }
    },
    incrementCounter2() {
      this.clickCount2++;

      if (this.inactivityTimer2) {
        clearTimeout(this.inactivityTimer2);
      }

      if (this.clickCount2 === 10) {
        // When clickCount2 reaches 10, hide the screen and show the image
        this.showThirdCentered = true;
      } else {
        // Start a timer for 5 seconds of inactivity
        this.currentImage2 = "/pepe-punch.gif";
        this.inactivityTimer2 = setTimeout(() => {
          this.currentImage2 = "/wojak-pepe.jpg";
        }, 2000);
      }
    },
    resetClickCount() {
      // Reset clickCount to 0 and switch back to the first centered-content
      this.incrementCounter();
      if (this.clickCount >= 15) {
        this.clickCount = 0;
        this.currentImage = "/pepe-wojak.jpg";
        this.clickCount2 = 0;
        this.currentImage2 = "/wojak-pepe.jpg";
        this.showSecondCentered = false;
      }
    },
    resetClickCount2() {
      // Reset clickCount to 0 and switch back to the first centered-content
      this.incrementCounter2();
      if (this.clickCount2 >= 15) {
        this.clickCount = 0;
        this.currentImage = "/pepe-wojak.jpg";
        this.clickCount2 = 0;
        this.currentImage2 = "/wojak-pepe.jpg";
        this.showThirdCentered = false;
      }
    },
  },
};
</script>

<style scoped>
.centered-content {
  width: 1000px;
  height: 500px;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  justify-content: center;
  align-items: center;
  align-content: center;
  flex-direction: row;
}

.container {
  display: flex;
  justify-content: center;
  align-items: flex-start;
}

.image-container {
  width: 100%;
  height: 90%;
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 0;
}

.counter-container {
  height: 50px;
  display: flex;
  align-items: center;
}

.image-container img {
  width: 100%;
  height: 100%;
  z-index: 0;
}

.screen {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}
</style>
