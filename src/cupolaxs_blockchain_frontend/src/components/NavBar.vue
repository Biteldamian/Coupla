<template>
    <nav class="bg-gray-800 p-4">
      <div class="container mx-auto flex justify-between items-center">
        <div class="text-white text-lg font-semibold">
          <router-link to="/">Home</router-link>
        </div>
        <div class="flex space-x-4">
          <router-link to="/myReservations" class="text-white hover:text-gray-300">My Reservations</router-link>
          <router-link to="/bookroom" class="text-white hover:text-gray-300">Book a Room</router-link>
          <router-link to="/wallet" class="text-white hover:text-gray-300">Wallet</router-link>
          <button v-if="!isAuthenticated" @click="$emit('login')" class="text-white hover:text-gray-300">Login</button>
          <button v-else @click="$emit('logout')" class="text-white hover:text-gray-300">Logout</button>
        </div>
      </div>
    </nav>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  
  const props = defineProps({
    isAuthenticated: {
      type: Boolean,
      required: true,
    },
  });
  </script>
  
  <style scoped>
  nav {
    background-color: #2d3748;
  }
  </style>