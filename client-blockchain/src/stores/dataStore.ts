
import { defineStore } from "pinia";
import axios from "axios";

export const dataStore = defineStore({
  id: "data",
  state: () => ({
    list: [] as any,
  }),
  actions: {
    fetch() {
        return new Promise((resolve, reject) => {
            axios.get(`${import.meta.env.VITE_APP_BASE_HOST}/static/list.json`).then(({data}) => {
                this.list = data;
                resolve(data)
            })
        })
    }
  }})