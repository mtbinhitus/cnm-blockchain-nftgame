<template>
  <header class="mb-3">
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light ">
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
              <router-link class="nav-link  text-white" to="/home">
                Home
              </router-link>
            </li>
            <li class="nav-item ms-3 p-1 ">
              <!-- <a class="nav-link text-white" href="#"></a> -->
              <router-link class="nav-link text-white" to="/game">
                Mini Game
              </router-link>
            </li>
            <li class="nav-item ms-3 p-1">
              <router-link class="nav-link text-white" to="/misstion">
                Misstion
              </router-link>
            </li>
            <li class="nav-item ms-3 p-1">
              <router-link class="nav-link text-white" to="/wheel">
                Spin Bonus
              </router-link>
            </li>
          </ul>
        </div>
      </div>
    </nav>

  </header>
 </template>

 <style scoped>
 header{
  z-index: 10;
 }
header::before{
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
.nav-item:hover{
  background: rgba(248, 248, 196, 0.214);
  border-radius: 8px;
  transition: 0.3s;
}
</style>

