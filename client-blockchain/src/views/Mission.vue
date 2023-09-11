<template>
  <div class="container">
    <div class="text-center btn-gr">
      <button
        class="button-57 m-4"
        role="button"
        @click="redirectTo('minigame', $event)"
      >
        <span class="text">Flappy Bird</span><span>Go!</span>
      </button>

      <button
        class="button-57 m-4"
        role="button"
        @click="redirectTo('minigame2', $event)"
      >
        <span class="text">Minesweeper</span><span>Go!</span>
      </button>
    </div>
  </div>
</template>

<script>
import { defineComponent } from "vue";

export default defineComponent({
  methods: {
    redirectTo(to, event) {
      if (event.ctrlKey) {
        // Open a new tab with the desired URL
        const newTab = window.open(`/${to}`, "_blank");
        // Focus back on the current tab
        event.preventDefault();
      } else {
        // If Ctrl key is not pressed, navigate normally
        this.$router.push({
          path: `/${to}`,
        });
      }
    },
  },
});
</script>

<style scoped>
.btn-gr {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.button-57 {
  background: rgba(0, 0, 0, 0.4);
  width: 400px;
  position: relative;
  overflow: hidden;
  border: 3px solid #fff;
  color: #fff;
  display: inline-block;
  font-size: 2.5em;
  line-height: 1em;
  padding: 1em 2em 1em;
  text-decoration: none;
  cursor: pointer;
  user-select: none;
  -webkit-user-select: none;
  touch-action: manipulation;
}

.button-57 span:first-child {
  position: relative;
  transition: color 600ms cubic-bezier(0.48, 0, 0.12, 1);
  z-index: 10;
}

.button-57 span:last-child {
  color: white;
  display: block;
  position: absolute;
  bottom: 0;
  transition: all 500ms cubic-bezier(0.48, 0, 0.12, 1);
  z-index: 100;
  opacity: 0;
  top: 55%;
  left: 50%;
  transform: translateY(225%) translateX(-50%);
  height: 14px;
  line-height: 13px;
}

.button-57:after {
  content: "";
  position: absolute;
  bottom: -50%;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: black;
  transform-origin: bottom center;
  transition: transform 600ms cubic-bezier(0.48, 0, 0.12, 1);
  transform: skewY(9.3deg) scaleY(0);
  z-index: 50;
}

.button-57:hover:after {
  transform-origin: bottom center;
  transform: skewY(9.3deg) scaleY(2);
}

.button-57:hover span:last-child {
  transform: translateX(-50%) translateY(-100%);
  opacity: 1;
  transition: all 900ms cubic-bezier(0.48, 0, 0.12, 1);
}

.container {
  padding-left: 0px;
  padding-right: 0px;
}
</style>
