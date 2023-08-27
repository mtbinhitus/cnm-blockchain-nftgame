<template>
  <header class="mb-3">
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light">
      <div class="container-fluid">
        <button
          class="navbar-toggler"
          type="button"
          data-mdb-toggle="collapse"
          data-mdb-target="#navbarExample01"
          aria-controls="navbarExample01"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          <i class="fas fa-bars"></i>
        </button>
        <div class="collapse navbar-collapse" id="navbarExample01">
          <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <li class="nav-item active p-1">
              <router-link class="nav-link text-white" to="/home">
                Home
              </router-link>
            </li>
            <li class="nav-item ms-3 p-1">
              <!-- <a class="nav-link text-white" href="#"></a> -->
              <router-link class="nav-link text-white" to="/game">
                Mini Game
              </router-link>
            </li>
            <li class="nav-item ms-3 p-1">
              <router-link class="nav-link text-white" to="/mission">
                Mission
              </router-link>
            </li>
            <li class="nav-item ms-3 p-1">
              <router-link class="nav-link text-white" to="/wheel">
                Spin Bonus
              </router-link>
            </li>
            <!-- <li class="nav-item ms-3 p-1">
              <router-link class="nav-link text-white" to="/marketplace">
                Marketplace
              </router-link>
            </li> -->
          </ul>

          <div class="btn btn-success" @click="connectWithMetaMask">
            <i class="fa-solid fa-wallet me-2"></i>
            <span v-if="!isConnected">Connect to METAMASK Wallet</span>
            <router-link to="/collection" v-else class="text-white" style="text-decoration: none;">
            <span>{{ address }}</span>
            </router-link>
          </div>
        </div>
      </div>
    </nav>
  </header>
</template>

<script>
import { authStore } from "@/stores/authStore";
import { dataStore } from "@/stores/dataStore";
import { defineComponent } from "vue";


export default defineComponent({

  data() {
    return {
      isConnected: false,
      address: '',
    };
  },
  
  methods: {
    async connectWithMetaMask() {
      if (typeof window.ethereum !== 'undefined') {
        try {
          // Request account access
          const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
          if (accounts.length > 0) {
            this.isConnected = true;
            this.address = accounts[0];
            authStore().address =  accounts[0];
            authStore().is_authen = true;
            authStore().getInfo()
            
          }
        } catch (error) {
          console.error('Error connecting to MetaMask:', error);
        }
      } else {
        console.error('MetaMask extension not detected.');
      }
    },
  },
});
</script>

<style scoped>
header {
  z-index: 10;
}
header::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100vw;
  height: 60px;
  background: rgba(0, 0, 0, 0.243);
}
.nav-link:hover {
  color: red !important;
}
.nav-item:hover {
  background: rgba(248, 248, 196, 0.214);
  border-radius: 8px;
  transition: 0.3s;
}
</style>
