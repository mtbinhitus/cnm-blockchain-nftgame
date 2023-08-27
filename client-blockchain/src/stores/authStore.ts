import { defineStore } from "pinia";
import axios from "axios";

export const authStore = defineStore({
  id: "auth",
  state: () => ({
    is_authen: false,
    address: "",
    score: 0,
  }),
  actions: {
    authenticate() {},

    getInfo() {
      return new Promise((resolve, reject) => {
        axios
          .get(`${import.meta.env.VITE_APP_BASE_HOST}/static/auth.json`)
          .then(({ data }) => {
            const list = data;
            const x = list.find((i: any) => i.address == this.address);
            if (x) {
              this.score = x.score;
            } else {
              this.score = 0;
            }
            resolve(data);
          });
      });
    },
    // fetch() {
    //     return new Promise((resolve, reject) => {
    //         axios.get(`${import.meta.env.VITE_APP_BASE_HOST}/static/list.json`).then(({data}) => {
    //             this.list = data;
    //             resolve(data)
    //         })
    //     })
    // }
  },
});
