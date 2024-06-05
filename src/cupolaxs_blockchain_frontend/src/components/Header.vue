<template>
  <header>
    <nav class="bg-white border-gray-200 px-4 lg:px-6 py-2.5 dark:bg-gray-800">
      <div class="flex flex-wrap justify-between items-center mx-auto max-w-screen-xl">
        <a href="https://flowbite.com" class="flex items-center">
          <img src="../assets/cupola.png" class="mr-3 h-6 sm:h-9" alt=" Logo" />
        </a>
        <div class="flex items-center lg:order-2">
          <Login/>
        </div>
        <div class="hidden justify-between items-center w-full lg:flex lg:w-auto lg:order-1" id="mobile-menu-2">
          <ul class="flex flex-col mt-4 font-medium lg:flex-row lg:space-x-8 lg:mt-0">
            <li>
              <router-link to="/bookroom" class="block py-2 pr-4 pl-3 text-white rounded bg-primary-700 lg:bg-transparent lg:text-primary-700 lg:p-0 text-black dark:text-white" aria-current="page">All rooms</router-link>
            </li>
            <li>
              <router-link to="/reservations" href="#" class="block py-2 pr-4 pl-3 text-white rounded bg-primary-700 lg:bg-transparent lg:text-primary-700 lg:p-0 text-black dark:text-white" aria-current="page">My reservations</router-link>
            </li>
            <li>
              <router-link to="/" class="block py-2 pr-4 pl-3 text-white rounded bg-primary-700 lg:bg-transparent lg:text-primary-700 lg:p-0 text-black dark:text-white" aria-current="page">My account</router-link>
            </li>
          </ul>
        </div>
      </div>
    </nav>
  </header>
</template>

<style scoped>

</style>
<script setup lang="ts">
import Login from "@/components/Login.vue";
</script>