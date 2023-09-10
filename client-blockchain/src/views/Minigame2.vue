<script>
import { authStore } from "@/stores/authStore";
import axios from "axios";

const getIndex = (row, column, config) => {
  // Simply return if coordinates are out of field
  if (row < 0) return;
  if (column < 0) return;
  if (row >= config.height) return;
  if (column >= config.width) return;

  // Return index
  return row * config.width + column;
};

const getTileCoordinates = (index, config) => ({
  row: Math.floor(index / config.width),
  column: index % config.width,
});

const generateTiles = (config) => {
  // Generate an empty array with the appropriate length
  const bombs = Array.from({ length: config.width * config.height });

  // Inject bombs to random positions
  let bombsPlanted = 0;
  while (bombsPlanted != config.totalNumberOfBombs) {
    // Pick a random index within the array
    const index = Math.floor(Math.random() * config.width * config.height);

    // If tile doesn't already contain a bomb then plant it
    if (!bombs[index]) {
      bombs[index] = true;
      bombsPlanted++;
    }
  }

  return bombs.map((bomb, i, array) => {
    const { row, column } = getTileCoordinates(i, config);

    // Count number of bombs in the surroinding tiles
    let surroundingBombs = 0;
    if (array[getIndex(row - 1, column - 1, config)]) surroundingBombs++;
    if (array[getIndex(row - 1, column - 0, config)]) surroundingBombs++;
    if (array[getIndex(row - 1, column + 1, config)]) surroundingBombs++;
    if (array[getIndex(row - 0, column - 1, config)]) surroundingBombs++;
    if (array[getIndex(row - 0, column + 1, config)]) surroundingBombs++;
    if (array[getIndex(row + 1, column - 1, config)]) surroundingBombs++;
    if (array[getIndex(row + 1, column - 0, config)]) surroundingBombs++;
    if (array[getIndex(row + 1, column + 1, config)]) surroundingBombs++;

    return {
      bomb, // The tile contains a bomb
      flagged: false, // The tile is flagged
      revealed: false, // The tile has been revealed
      surroundingBombs, // The number of bombs in the surrounding fields
    };
  });
};

export default {
  data: () => ({
    config: {}, // Initialized in created lifecycle hook
    tiles: [], // Initialized in created lifecycle hook

    // Timer
    secondsPassed: 0, // Seconds passed since the game started
    timerIntervalID: undefined,
  }),
  created() {
    // At initialization set the game difficulty to beginner and re-render the game
    this.setBeginnerDifficulty();
  },
  computed: {
    cssVars() {
      return {
        "--width": this.config.width,
        "--height": this.config.height,
        "--size": `${this.config.size}px`,
      };
    },
    bombsRemaining() {
      // Reduce total number of bombs by the number of flagged tiles
      const numberOfFlaggedTiles = this.tiles.filter((t) => t.flagged).length;
      return this.config.totalNumberOfBombs - numberOfFlaggedTiles;
    },
    gameIsProgress() {
      // If game has ended already then return false
      if (this.gameStatus == "😞" || this.gameStatus == "😎") return false;
      // If game haven't even started then return false
      if (!this.tiles.find((tile) => tile.revealed)) return false;
      // Otherwise the game is in progress
      return true;
    },
    gameWon() {
      const numberOfRevealedTiles = this.tiles.filter((t) => t.revealed).length;

      // To win the game you need to reveal all the tiles that do not contain a bomb
      const numberOfTilesThatNeedsToBeRevealed =
        this.config.width * this.config.height - this.config.totalNumberOfBombs;

      return numberOfRevealedTiles == numberOfTilesThatNeedsToBeRevealed;
    },
    gameFailed() {
      // Once you reveal a tile that contains a bomb you failed
      return this.tiles.find((tile) => tile.bomb && tile.revealed);
    },
    gameStatus() {
      if (this.gameFailed) {
        const current_score = authStore().score;
        const address = authStore().address;

        axios.post(
          `${import.meta.env.VITE_APP_BASE_HOST}/api/nft/update-score`,
          {
            score: current_score + 1,
            address: address,
          }
        );

        authStore().score = current_score + 1;
        console.log("score", authStore().score);
        console.log("address", address);

        return "😞";
      } else if (this.gameWon) {
        const current_score = authStore().score;
        const address = authStore().address;

        axios.post(
          `${import.meta.env.VITE_APP_BASE_HOST}/api/nft/update-score`,
          {
            score: current_score + 20,
            address: address,
          }
        );

        authStore().score = current_score + 20;
        console.log("curr", authStore().score);
        console.log("address", address);

        return "😎";
      } else {
        return "🙂";
      }
    },
  },
  watch: {
    // Start / stop timer
    gameIsProgress(value) {
      if (value) {
        // Once the game started start cunting the seconds
        this.timerIntervalID = setInterval(() => {
          this.secondsPassed++;
        }, 1000);
      } else {
        // Once the game ended stop the timer
        clearInterval(this.timerIntervalID);
      }
    },
  },
  methods: {
    setBeginnerDifficulty() {
      this.config = {
        width: 8,
        height: 8,
        totalNumberOfBombs: 10,
        size: 50,
      };
      this.resetGame();
    },
    setIntermediateDifficulty() {
      this.config = {
        width: 16,
        height: 16,
        totalNumberOfBombs: 40,
        size: 35,
      };
      this.resetGame();
    },
    setExpertDifficulty() {
      this.config = {
        width: 30,
        height: 16,
        totalNumberOfBombs: 99,
        size: 25,
      };
      this.resetGame();
    },
    resetGame() {
      // Reset tiles based on the config
      this.tiles = generateTiles(this.config);

      // Reset timer
      this.secondsPassed = 0;
    },
    reveal(i) {
      // Do nothing if the game has already failed
      if (this.gameFailed) return;

      // Do nothing in case of wrong input
      // This can happen when the neighbours of a tile are being revealed and the 'neighbour' is out of the field
      if (i == undefined) return;

      const tile = this.tiles[i];

      // You can't reveal a flagged tile, you need to unflag it first
      if (tile.flagged) return;

      // Only reveal a tile if it is not revealed already
      // Avoids infinite loop of tile revealing it's neighbour then neighbour revealing the original tile
      if (!tile.revealed) {
        // Reveal tile
        tile.revealed = true;

        // If the tile is empty, also reveal the neighbour tiles
        if (!tile.bomb && tile.surroundingBombs == 0) {
          const { row, column } = getTileCoordinates(i, this.config);

          this.reveal(getIndex(row - 1, column - 1, this.config)); // Reveal top left neighbour
          this.reveal(getIndex(row - 1, column - 0, this.config)); // Reveal top neighbour
          this.reveal(getIndex(row - 1, column + 1, this.config)); // Reveal top right neighbour
          this.reveal(getIndex(row - 0, column - 1, this.config)); // Reveal left neighbour
          this.reveal(getIndex(row - 0, column + 1, this.config)); // Reveal right neighbour
          this.reveal(getIndex(row + 1, column - 1, this.config)); // Reveal bottom left neighbour
          this.reveal(getIndex(row + 1, column - 0, this.config)); // Reveal bottom neighbour
          this.reveal(getIndex(row + 1, column + 1, this.config)); // Reveal bottom right neighbour
        }
      }
    },
    flag(i) {
      // Do nothing if the game has already failed
      if (this.gameFailed) return;

      // Do nothing if the tile is alerady revealed
      if (this.tiles[i].revealed) return;

      // Flag or unflag tile
      this.tiles[i].flagged = !this.tiles[i].flagged;
    },
    // updateScore() {
    //   console.log(this.score, "---score--");

    //   const current_score = authStore().score;
    //   const address = authStore().address;
    //   axios.post(`${import.meta.env.VITE_APP_BASE_HOST}/api/nft/update-score`, {
    //     score: this.score + current_score,
    //     address: address,
    //   });

    //   authStore().score = current_score + this.score;
    //   // axios.post(`${import.meta.env.VITE_APP_BASE_HOST}/static/auth`)
    // },
  },
  filters: {
    addLeadingZeros: function (value) {
      // Add leading zeros. E.g. 1 -> 001, 10 -> 010, 100 -> 100
      return ("00" + value).slice(-3);
    },
  },
};
</script>

<template lang="pug">
.v-container
  .h-container
    .v-container
      main(:style="cssVars")
        .status
          div {{ bombsRemaining | addLeadingZeros }}
          button(@click="resetGame") {{ gameStatus }}
          div {{ secondsPassed | addLeadingZeros }}
        .board
          .tile(
            v-for="(tile, i) in tiles" :key="i"
            :class=`{
              revealed: tile.revealed,
              // If the game failed mark tile as a wrong pick ...
              // ... if a bomb has been revealed or
              // ... if a tile that does not have a bomb has been flagged
              'wrong-pick': gameFailed && ((tile.bomb && tile.revealed) || (!tile.bomb && tile.flagged))
            }`
            :data-surrounding-bombs="tile.surroundingBombs"
            @click="reveal(i)"
            @contextmenu.prevent="flag(i)"
          )
            template(v-if="tile.flagged") 🔴
            template(v-else-if="tile.revealed && tile.bomb") 💣
            template(v-else-if="tile.revealed && tile.surroundingBombs") {{ tile.surroundingBombs }}
</template>

<style lang="scss">
@import url("https://fonts.googleapis.com/css2?family=Roboto&family=Ubuntu:wght@700&display=swap");

$background-color: #006989;
$tile-color: #d4d4d4;
$border-radius: calc(var(--size) / 10);

html {
  height: 100%;
}

body {
  background-color: $background-color;
  font-family: "Roboto", sans-serif;
  height: 100%;
  margin: 0;
  text-align: center;
}

.h-container {
  display: flex;
  flex-direction: row;
  justify-content: center;
  height: 100%;
}

.v-container {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  height: 100%;
}

button {
  background-color: inherit;
  border: none;
  cursor: pointer;
  font-family: inherit;
  font-size: inherit;

  &:focus {
    outline: none;
  }
}

a:visited {
  color: inherit;
}

header {
  background-color: #0b2027;

  button {
    color: $tile-color;
    padding: 20px 30px;
  }
}

@mixin add-shadow($offset) {
  $opposite: calc(#{$offset} * -1);
  box-shadow: inset $offset $offset 0px 0px rgba(255, 255, 255, 0.45),
    inset $opposite $opposite 0px 0px rgba(0, 0, 0, 0.25);
}

main {
  background-color: $tile-color;
  font-family: "Ubuntu Mono", monospace;
  font-weight: 600;
  padding: 0 20px 20px 20px;
}

.status {
  align-items: center;
  color: #0b2027;
  display: flex;
  flex-direction: row;
  font-size: 2em;
  justify-content: space-between;
  margin: 15px 0;

  button {
    @include add-shadow(4px);
    border-radius: 5px;
  }
}

.board {
  display: grid;
  grid-template-columns: repeat(var(--width), auto);
  grid-template-rows: repeat(var(--height), auto);
  user-select: none;
}

.tile {
  width: var(--size);
  height: var(--size);
  line-height: var(--size);

  &:not(.revealed) {
    $shadow: calc(var(--size) / 12.5);
    @include add-shadow($shadow);
    border-radius: $border-radius;
    cursor: pointer;
  }

  &.revealed {
    border: 1px solid #bdbdbd;
    box-sizing: border-box;
  }

  &.wrong-pick {
    background-color: lightcoral;
  }

  &[data-surrounding-bombs="1"] {
    color: blue;
  }
  &[data-surrounding-bombs="2"] {
    color: green;
  }
  &[data-surrounding-bombs="3"] {
    color: red;
  }
  &[data-surrounding-bombs="4"] {
    color: purple;
  }
  &[data-surrounding-bombs="5"] {
    color: maroon;
  }
  &[data-surrounding-bombs="6"] {
    color: turquoise;
  }
  &[data-surrounding-bombs="7"] {
    color: black;
  }
  &[data-surrounding-bombs="8"] {
    color: gray;
  }
}

footer {
  font-size: 0.8em;
  color: $tile-color;
  margin: 20px;
}
</style>
