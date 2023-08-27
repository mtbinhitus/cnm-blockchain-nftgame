<template>
  <div class="container">
    <div class="history d-flex justify-content-center flex-column align-items-center">
      <h2 class="title text-uppercase text-center mb-5 text-danger fs-2 mt-5">
        History
      </h2>
      <table
        class="table table-striped table-primary table-bordered border-primary"
      >
        <thead class="table-success border-primary">
          <tr class="text-center">
            <th scope="col fs-3">Mission</th>
          </tr>
        </thead>
        <tbody class="text-center">
          <tr>
            <td class="fs-4">
                <router-link to="/game" class="text-danger">Play Flappy bird</router-link>
            </td>
          </tr>
          
        </tbody>
      </table>

    </div>
  </div>
</template>

<script>
import {defineComponent} from "vue";

export default defineComponent({

})
</script>

<style scoped>

th {
  min-width: 30vw;
}

table {
    max-width: 600px;
}

</style>