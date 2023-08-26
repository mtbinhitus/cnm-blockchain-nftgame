import { createRouter, createWebHistory } from "vue-router";

import { nextTick } from "vue";
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/home",
      redirect: "/",
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
    document.title = (to.meta.title || to.name) 
  });
});

export default router;
