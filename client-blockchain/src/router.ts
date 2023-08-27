import { createRouter, createWebHistory } from "vue-router";
import MiniGameVue from "./views/MiniGame.vue";
import HomePage from "./views/HomePage.vue";
import FortuneWheel from "./views/FortuneWheel.vue";
import Mission from "./views/Mission.vue"
import NotFound from "./components/ErrorPage.vue";
import { nextTick } from "vue";
import { authStore } from "./stores/authStore";
import Collection from "./views/Collection.vue";
import NftDetail from "./views/NftDetail.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/home",
      redirect: "/",
    },

    {
      path: "/game",
      component: MiniGameVue,
      name: "game",
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
      path: "/collection",
      component: Collection,
      name: "collection",
      meta: { authRequired: true },
    },
    {
      path: "/collection/:id",
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
  
  if(authStore().is_authen) {
    return next();
  } else {
    router.push({ path: "/" });
    alert("Please connect with Metamask wallet")
  }
});

router.afterEach((to) => {
  nextTick(() => {
    // document.title = to.meta.title || to.name;
  });
});

export default router;
