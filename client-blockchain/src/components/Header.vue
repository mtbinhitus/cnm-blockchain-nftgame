<template>
  <header class="mb-3">
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light">
      <div class="container-fluid">
        <!-- <button
          class="navbar-toggler"
          type="button"
          data-mdb-toggle="collapse"
          data-mdb-target="#navbarExample01"
          aria-controls="navbarExample01"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          <i class="fas fa-bars"></i>
        </button> -->
        <div class="collapse navbar-collapse" id="navbarExample01">
          <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <li class="nav-item active p-1">
              <router-link class="nav-link text-white" to="/home">
                Home
              </router-link>
            </li>
            <li class="nav-item ms-3 p-1">
              <router-link class="nav-link text-white" to="/collection">
                Collection
              </router-link>
            </li>
            <li class="nav-item ms-3 p-1">
              <router-link class="nav-link text-white" to="/mission">
                Mission
              </router-link>
            </li>
            <li class="nav-item ms-3 p-1">
              <router-link class="nav-link text-white" to="/wheel">
                Fortune Wheel
              </router-link>
            </li>
            <li class="nav-item ms-3 p-1">
              <!-- <a class="nav-link text-white" href="#"></a> -->
              <router-link class="nav-link text-white" to="/inventory">
                Inventory
              </router-link>
            </li>
          </ul>

          <div class="btn btn-success" @click="connectWithMetaMask">
            <i class="fa-solid fa-wallet me-2"></i>
            <span v-if="!isConnected">Connect to your MetaMask wallet</span>
            <span v-else class="text-white" style="text-decoration: none">
              {{ address }}
            </span>
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
import VueCookies from "vue-cookies"; // Import vue-cookies

export default defineComponent({
  created() {
    // Check if the user was previously logged in
    const isLoggedIn = VueCookies.get("isLoggedIn");

    if (isLoggedIn) {
      this.isConnected = true;
      this.address = VueCookies.get("userAddress");
      authStore().address = this.address;
      authStore().is_authen = true;
      authStore().getInfo();
    }
  },

  data() {
    return {
      isConnected: false,
      address: "",
    };
  },

  methods: {
    async connectWithMetaMask() {
      if (this.isConnected) {
        // Log out and remove the stored data
        this.isConnected = false;
        this.address = "";
        authStore().address = "";
        authStore().is_authen = false;
        VueCookies.remove("isLoggedIn");
        VueCookies.remove("userAddress");

        this.$router.push("/");
      } else {
        // Log in and store the data
        if (typeof window.ethereum !== "undefined") {
          try {
            const accounts = await window.ethereum.request({
              method: "eth_requestAccounts",
            });
            if (accounts.length > 0) {
              // Prompt the user to choose an account if multiple accounts are available
              if (accounts.length > 1) {
                const selectedAccount = await this.chooseAccount(accounts);
                if (selectedAccount) {
                  this.isConnected = true;
                  this.address = selectedAccount;
                  authStore().address = selectedAccount;
                  authStore().is_authen = true;
                  authStore().getInfo();

                  // Store login data in cookies
                  VueCookies.set("isLoggedIn", true);
                  VueCookies.set("userAddress", selectedAccount);
                }
              } else {
                this.isConnected = true;
                this.address = accounts[0];
                authStore().address = accounts[0];
                authStore().is_authen = true;
                authStore().getInfo();

                // Store login data in cookies
                VueCookies.set("isLoggedIn", true);
                VueCookies.set("userAddress", accounts[0]);
              }
            }
          } catch (error) {
            console.error("Error connecting to MetaMask:", error);
          }
        } else {
          console.error("MetaMask extension not detected.");
        }
      }
    },
    chooseAccount(accounts) {
      return new Promise((resolve) => {
        // You can implement your own account selection UI here
        // For example, use a modal to display a list of accounts and let the user choose one.
        // When an account is selected, call resolve with the selected account address.
        // You can use a library like Bootstrap Modal for the modal UI.
        // Here's a simplified example:

        const modal = document.createElement("div");
        modal.innerHTML = `
          <div class="modal fade" id="accountSelectionModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="exampleModalLabel">Select an account</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                  <ul class="list-group">
                    ${accounts
                      .map(
                        (account, index) =>
                          `<li class="list-group-item" data-index="${index}">${account}</li>`
                      )
                      .join("")}
                  </ul>
                </div>
              </div>
            </div>
          </div>
        `;

        document.body.appendChild(modal);

        // Initialize the modal and attach event listeners
        const accountSelectionModal = new bootstrap.Modal(
          document.getElementById("accountSelectionModal")
        );
        const accountItems = modal.querySelectorAll(".list-group-item");

        accountItems.forEach((item) => {
          item.addEventListener("click", () => {
            const selectedIndex = parseInt(item.getAttribute("data-index"), 10);
            const selectedAccount = accounts[selectedIndex];
            accountSelectionModal.hide();
            modal.remove();
            resolve(selectedAccount);
          });
        });

        // Show the modal
        accountSelectionModal.show();
      });
    },
  },
});
</script>

<style scoped>
header {
  display: none;
}

/*header::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100vw;
  height: 60px;
  background: rgba(0, 0, 0, 0.243);
}*/
.nav-link:hover {
  color: white;
}
.nav-item:hover {
  background: rgba(0, 0, 0, 0.6);
  transition: 0.2s;
}

#navbarExample01 {
  white-space: nowrap;
}

@media (min-width: 992px) {
  header {
    display: block;
    z-index: 10;
    background: rgba(0, 0, 0, 0.4);
    overflow: hidden;
  }
}

.btn.btn-success {
  background: rgba(0, 0, 0, 0.4);
  border: 3px solid white;
  border-radius: 0px;
}

.btn.btn-success:hover {
  background: black;
}
</style>
