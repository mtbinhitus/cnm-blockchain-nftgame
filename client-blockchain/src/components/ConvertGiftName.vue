<template>
  <div>{{ gift?.name }}</div>
</template>

<script>
import { defineComponent } from "vue";
import { dataStore } from "@/stores/dataStore";
export default defineComponent({
  props: {
    link: {
      type: String,
      required: true,
      default: "",
    },
  },

  computed: {
    list() {
      return dataStore().list;
    },
    gift() {
      return this.list.find((i) => i.key == this.link);
    },
  },
});
</script>
