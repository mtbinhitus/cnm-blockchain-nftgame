import { createRouter, createWebHistory } from "vue-router";
import MiniGameVue from "./views/MiniGame.vue";
import HomePage from "./views/HomePage.vue";
import FortuneWheel from "./views/FortuneWheel.vue";
import Mission from "./views/Mission.vue"

import { nextTick } from "vue";
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
    },
    {
      path: "/mission",
      component: Mission,
      name: "mission",
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
});

router.afterEach((to) => {
  nextTick(() => {
    // document.title = to.meta.title || to.name;
  });
});

export default router;
