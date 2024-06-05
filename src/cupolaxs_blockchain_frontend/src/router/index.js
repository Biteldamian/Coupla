// router/index.js
import { createRouter, createWebHistory } from 'vue-router';
import Home from "@/pages/Home.vue";
import RoomBooking from "@/components/RoomBooking.vue";
import MyRoomDetail from "@/components/MyRoomDetail.vue";
import MyReservations from "@/components/MyReservations.vue";

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/',
            name: 'home',
            component: Home
        },
        {
            path: '/bookroom',
            name: 'bookroom',
            component: RoomBooking
        },
        {
            path: '/reservations',
            name: 'My reservations',
            component: MyReservations
        },
        {
            path: '/my-room/:cellId',
            name: 'MyRoomDetail',
            component: MyRoomDetail
        },
    ]
});

export default router;
