<template>
    <div class="error-area">
      <div class="d-table">
        <div class="d-table-cell">
          <div class="container">
            <div class="error-content">
              <h1>404</h1>
              <h2>Oops! Page Not Found!</h2>
              <p>The page you are looking for does not exist. It might have been moved or deleted.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent } from "vue";
  
  export default defineComponent({});
  </script>
  
  <style scoped>
  .error-area {
    height: 50vh;
  }
  </style>