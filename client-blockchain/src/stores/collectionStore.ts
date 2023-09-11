
import { defineStore } from "pinia";
import axios from "axios";

export const collectionStore = defineStore({
  id: "collection",
  state: () => ({
    list: [] as any,
  }),
  actions: {
    fetch() {
        return new Promise((resolve, reject) => {
            axios.get(`${import.meta.env.VITE_APP_BASE_HOST}/static/collection.json`).then(({data}) => {
                this.list = data;
                resolve(data)
            })
        })
    }
  }})