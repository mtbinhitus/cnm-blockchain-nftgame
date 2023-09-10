import { createRouter, createWebHistory } from "vue-router";
import MinigameVue from "./views/MiniGame.vue";
import MinigameVue2 from "./views/Minigame2.vue";
import HomePage from "./views/HomePage.vue";
import FortuneWheel from "./views/FortuneWheel.vue";
import Mission from "./views/Mission.vue";
import NotFound from "./components/ErrorPage.vue";
import { nextTick } from "vue";
import { authStore } from "./stores/authStore";
import Inventory from "./views/Inventory.vue";
import NftDetail from "./views/NftDetail.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/home",
      redirect: "/",
    },
    {
      path: "/minigame",
      component: MinigameVue,
      name: "minigame",
      meta: { authRequired: true },
    },
    {
      path: "/minigame2",
      component: MinigameVue2,
      name: "minigame2",
      meta: { authRequired: true },
    },
    {
      path: "/",
      component: HomePage,
      name: "home",
    },
    {
      path: "/wheel",
      component: FortuneWheel,
      name: "wheel",
      meta: { authRequired: true },
    },
    {
      path: "/mission",
      component: Mission,
      name: "mission",
      meta: { authRequired: true },
    },
    {
      path: "/Inventory",
      component: Inventory,
      name: "Inventory",
      meta: { authRequired: true },
    },
    {
      path: "/inventory/:id",
      component: NftDetail,
      name: "nft detail",
      meta: { authRequired: true },
    },

    {
      path: "/:pathMatch(.*)*",
      name: "Not found",
      component: NotFound,
    },
  ],

  scrollBehavior() {
    // always scroll to top
    return { top: 0 };
  },
});

router.beforeEach((routeTo, routeFrom, next) => {
  const authRequired = routeTo.matched.some((route) => route.meta.authRequired);
  if (!authRequired) {
    return next();
  }

  if (authStore().is_authen) {
    return next();
  } else {
    router.push({ path: "/" });
    alert("Please connect with Metamask wallet");
  }
});

router.afterEach((to) => {
  nextTick(() => {
    // document.title = to.meta.title || to.name;
  });
});

export default router;
