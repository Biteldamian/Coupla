import { createRouter, createWebHistory } from "vue-router";
import Home from "@/pages/Home.vue";
import RoomBooking from "@/components/RoomBooking.vue";
import MyRoomDetail from "@/components/MyRoomDetail.vue";
import MyReservations from "@/components/MyReservations.vue";
import Wallet from "@/components/Wallet.vue"; // Assuming you've created this component
import Login from "@/components/Login.vue"; // Assuming this is your login component
import { AuthClient } from '@dfinity/auth-client'; // Ensure AuthClient is imported

const routes = [
  {
    path: "/",
    name: "home",
    component: Home,
  },
  {
    path: "/login",
    name: "login",
    component: Login,
  },
  {
    path: "/bookroom",
    name: "bookroom",
    component: RoomBooking,
    meta: { requiresAuth: true },
  },
  {
    path: "/reservations",
    name: "myReservations",
    component: MyReservations,
    meta: { requiresAuth: true },
  },
  {
    path: "/my-room/:cellId",
    name: "myRoomDetail",
    component: MyRoomDetail,
    meta: { requiresAuth: true },
  },
  {
    path: "/wallet",
    name: "wallet",
    component: Wallet,
    meta: { requiresAuth: true },
  },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

router.beforeEach(async (to, from, next) => {
  if (to.matched.some((record) => record.meta.requiresAuth)) {
    const authClient = await AuthClient.create();
    const isAuthenticated = await authClient.isAuthenticated();
    if (!isAuthenticated) {
      next({ name: "login" }); // Ensure the route name matches
    } else {
      next();
    }
  } else {
    next();
  }
});

export default router;