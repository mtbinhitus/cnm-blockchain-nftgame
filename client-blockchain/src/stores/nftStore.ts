
import { defineStore } from "pinia";
import axios from "axios";
import { authStore } from "@/stores/authStore";

export const nftStore = defineStore({
  id: "nft",
  state: () => ({
    list: [] as any,
  }),
  actions: {
    fetch() {
      // const config = {
      //   "Accept": "application/json",
      // };

      const WALLET_ADDRESS = authStore().address;
      const BASE_URL = import.meta.env.VITE_APP_GOERLI_ALCHEMY;
      const CONTRACT = import.meta.env.VITE_APP_CONTRACT;
      const url = `${BASE_URL}/getNFTs/?owner=${WALLET_ADDRESS}&contractAddresses[]=${CONTRACT}`
      return new Promise((resolve, reject) => {
        axios.get(url).then(({data}) => {
        // this.collection = data.ownedNfts  ;
        nftStore().list = data.ownedNfts.reverse();
        resolve(data);
      }).catch((err) => {
        reject(err)})
      });
    }
  }})