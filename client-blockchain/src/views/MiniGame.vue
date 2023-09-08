<template>
  <div class="wrap">
    <div class="top-game d-flex mb-3">
      <div class="btn-gr">
        <button class="btn btn-success" @click="handleStart">Start</button>
        <button class="btn btn-primary ms-3" @click="pause">pause</button>
      </div>
      <div class="score ms-5">
        <h2 class="text-danger">{{ score }}</h2>
      </div>
    </div>

    <div class="game-container" @click="jump()">
      <div
        class="bird"
        :style="{ top: bird.y + 'px', left: bird.x + 'px' }"
      ></div>
      <div v-for="(pipe, index) in pipes" :key="index" class="pipe-col">
        <div
          class="pipe top-pipe"
          :style="{
            top: '0px',
            left: pipe.top.x + 'px',
            height: pipe.top.height + 'px',
          }"
        ></div>
        <div
          class="pipe bottom-pipe"
          :style="{
            bottom: '0px',
            left: pipe.bottom.x + 'px',
            height: pipe.bottom.height + 'px',
          }"
        ></div>
      </div>
    </div>
  </div>

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
            Your score in this round: {{ score_current }}
          </h1>
          <button
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Close"
          ></button>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-bs-dismiss="modal">
            Accept
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { authStore } from "@/stores/authStore";
import axios from "axios";
import { defineComponent } from "vue";
export default defineComponent({
  data() {
    return {
      bird: {
        x: 50,
        y: 150,
      },
      pipes: [],

      start: false,
      score: 0,
      isGameOver: false,

      jumpTimeout: null,
      birdDownInterval: null,

      score_current: 0,
    };
  },
  mounted() {
    this.generatePipes();
    // this.gameLoop();
  },

  methods: {
    handleStart() {
      this.start = true;
      this.pipeMove();
      this.jump();
    },

    handleLose() {
      const myModal = new bootstrap.Modal(
        document.getElementById("exampleModal"),
        {}
      );
      myModal.show();

      this.updateScore();
      this.handleRestart();
      this.generatePipes();
    },

    handleRestart() {
      this.bird = { x: 50, y: 150 };
      this.pipes = [];
      this.start = false;
      this.score = 0;
      this.isGameOver = false;
      clearTimeout(this.jumpTimeout);
      clearInterval(this.birdDownInterval);
    },

    handleCheck() {
      // vị trí của bird
      const bird_y = this.bird.y;
      const pipe_top = this.pipes[0].top.height + 10;
      const pipe_bottom = 600 - this.pipes[0].bottom.height - 30;

      // console.log(bird_y, pipe_top, pipe_bottom);

      if (pipe_top < bird_y && pipe_bottom > bird_y) {
        this.score += 1;
      } else {
        this.score_current = this.score;
        this.handleLose();
        // alert("thua");
      }

      //kiểm tra pipe.top.y < bird.y < pipe.bottom.y
    },

    pipeMove() {
      let move = "";
      move = setInterval(() => {
        for (let i = 0; i < this.pipes.length; i++) {
          this.pipes[i].top.x -= 2;
          this.pipes[i].bottom.x -= 2;
        }

        if (this.pipes[0].bottom.x == 50) {
          this.handleCheck();
        }

        if (this.pipes[0].bottom.x <= 0) {
          this.handleIncreaseScore();
        }

        if (!this.start) {
          clearInterval(move);
        }
      }, 10);
    },

    updateScore() {
      console.log(this.score, "---score--");

      const current_score = authStore().score;
      const address = authStore().address;
      axios.post(`${import.meta.env.VITE_APP_BASE_HOST}/api/nft/update-score`, {
        score: this.score + current_score,
        address: address,
      });

      authStore().score = current_score + this.score;
      // axios.post(`${import.meta.env.VITE_APP_BASE_HOST}/static/auth`)
    },

    birdDown() {
      clearInterval(this.jumpTimeout);
      this.birdDownInterval = setInterval(() => {
        this.bird.y += 5;
        if (this.bird.y >= 550) {
          clearInterval(this.jumpTimeout);
          clearInterval(this.birdDownInterval);
          this.pause();
        }
      }, 50);
    },

    pause() {
      this.start = false;
      clearInterval(this.jumpTimeout);
      clearInterval(this.birdDownInterval);
    },

    jump() {
      clearInterval(this.jumpTimeout);
      clearInterval(this.birdDownInterval);

      this.birdDownInterval = setTimeout(() => {
        this.birdDown();
      }, 300);

      // Thay đổi count trong 1s
      const targetCount = this.bird.y - 50;
      const duration = 300; //
      const decrementPerInterval =
        (this.bird.y - targetCount) / (duration / 100);

      this.jumpTimeout = setInterval(() => {
        if (this.bird.y <= targetCount) {
          clearInterval(this.jumpTimeout);
        } else {
          this.bird.y -= decrementPerInterval;
        }
      }, 100);
    },

    handleIncreaseScore() {
      // xóa ống đầu tiên
      this.pipes.shift();

      // Thêm ống mới phía sau
      const x = this.pipes[8].bottom.x + 250; // Vị trí x cách nhau pipeSpacing
      const minBottomHeight = 150; // Chiều cao tối thiểu của ống dưới
      const maxBottomHeight = 350; // Chiều cao tối đa của ống dưới

      const randomBottomHeight =
        Math.random() * (maxBottomHeight - minBottomHeight) + minBottomHeight;
      const topHeight = 600 - 160 - randomBottomHeight; // Chiều cao của ống trên

      const topPipe = {
        x,
        y: 0, // Vị trí y ống trên
        height: topHeight,
      };

      const bottomPipe = {
        x,
        y: 600, // Vị trí y ống dưới
        height: randomBottomHeight,
      };

      this.pipes.push({
        top: {
          ...topPipe,
        },
        bottom: {
          ...bottomPipe,
        },
      });
    },

    generatePipes() {
      const pipeSpacing = 250; // Khoảng cách giữa các cặp ống

      // Xóa các ống cũ để tạo mới
      this.pipes = [];

      for (let i = 0; i < 10; i++) {
        const x = 400 + i * pipeSpacing; // Vị trí x cách nhau pipeSpacing
        const minBottomHeight = 150; // Chiều cao tối thiểu của ống dưới
        const maxBottomHeight = 350; // Chiều cao tối đa của ống dưới

        const randomBottomHeight =
          Math.random() * (maxBottomHeight - minBottomHeight) + minBottomHeight;
        const topHeight = 600 - 160 - randomBottomHeight; // Chiều cao của ống trên

        const topPipe = {
          x,
          y: 0, // Vị trí y ống trên
          height: topHeight,
        };

        const bottomPipe = {
          x,
          y: 600, // Vị trí y ống dưới
          height: randomBottomHeight,
        };

        this.pipes.push({
          top: {
            ...topPipe,
          },
          bottom: {
            ...bottomPipe,
          },
        });
      }
    },
    gameLoop() {
      // Game loop logic, update bird and pipes positions
      // requestAnimationFrame(this.gameLoop);
    },
  },
});
</script>

<style scoped>
.game-container {
  position: relative;
  width: 1000px;
  height: 600px;
  background: url("../../public/flappybirdbg.png");
  overflow: hidden;
}

.bird {
  position: absolute;
  width: 64px;
  height: 64px;
  /* background-image: url("../../public/flappybird.png"); */
  background-image: url("../../wojak_fly.gif");
  /* background-size: cover;
  object-fit: cover; */
  background-size: 100% 100%;
}

.pipe-col {
}

.pipe {
  position: absolute;
  width: 80px;
  /* height: 400px; */

  /* background: red; */
}

.top-pipe {
  background-image: url("../../pepe_dance_2.gif");
  background-size: 100% 100%;
  /* object-fit: 100% 100%; */
  /* background-position: bottom center; */
}

.bottom-pipe {
  background-image: url("../../pepe_dance.gif");
  background-size: 100% 100%;
  /* object-fit: 100% 100%; */
}

.wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
}
</style>
