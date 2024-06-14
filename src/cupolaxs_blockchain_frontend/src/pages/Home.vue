<template>
  <section class="bg-white dark:bg-gray-900">
    <Header />
    <NavBar :isAuthenticated="isAuthenticated" @login="handleLogin" @logout="logout" />
    <div class="grid max-w-screen-xl mt-36 px-4 py-8 mx-auto lg:gap-8 xl:gap-0 lg:py-16 lg:grid-cols-12">
      <div class="mr-auto place-self-center lg:col-span-7">
        <h1 class="max-w-2xl mb-4 text-4xl font-extrabold tracking-tight leading-none md:text-5xl xl:text-6xl dark:text-white">
          Cupolaxs Cell Booking Hub
        </h1>
        <p class="max-w-2xl mb-6 font-light text-gray-500 lg:mb-8 md:text-lg lg:text-xl dark:text-gray-400">
          A simple cell booking service running on an innovative ICP chain. Start now by creating your account.</p>
        <div v-if="loading" class="text-center">
          <p>Loading...</p>
        </div>
        <div v-else>
          <Login v-if="!isAuthenticated" @login="handleLogin" />
          <div v-else>
            <p class="text-lg font-medium text-gray-700 dark:text-gray-300">Welcome back, {{ userPrincipal }}!</p>
            <button @click="logout" class="mt-4 text-white bg-red-600 hover:bg-red-700 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-red-500 dark:hover:bg-red-600 focus:outline-none dark:focus:ring-red-800">Logout</button>
          </div>
        </div>
        <p v-if="errorMessage" class="mt-4 text-red-500">{{ errorMessage }}</p>
      </div>
      <div class="hidden lg:mt-0 lg:col-span-5 lg:flex">
        <img src="@/assets/cupola.png" alt="mockup" class="h-max">
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { AuthClient } from '@dfinity/auth-client';
import Header from "@/components/Header.vue";
import NavBar from "@/components/NavBar.vue";
import Login from "@/components/Login.vue";

const loading = ref(true);
const isAuthenticated = ref(false);
const userPrincipal = ref(null);
const errorMessage = ref('');

const checkAuth = async () => {
  try {
    const authClient = await AuthClient.create();
    isAuthenticated.value = await authClient.isAuthenticated();
    if (isAuthenticated.value) {
      const identity = authClient.getIdentity();
      userPrincipal.value = identity.getPrincipal().toText();
      errorMessage.value = ''; // Clear any previous error message
    }
  } catch (error) {
    console.error("Error checking authentication:", error);
    errorMessage.value = "An error occurred while checking authentication.";
  } finally {
    loading.value = false;
  }
};

const handleLogin = async () => {
  loading.value = true;
  try {
    const authClient = await AuthClient.create();
    await authClient.login({
      identityProvider: "https://identity.ic0.app",
      onSuccess: async () => {
        const identity = authClient.getIdentity();
        userPrincipal.value = identity.getPrincipal().toText();
        isAuthenticated.value = true;
        errorMessage.value = ''; // Clear error message on successful login
      },
    });
  } catch (error) {
    console.error("Error during login:", error);
    errorMessage.value = "Login failed. Please try again later.";
  } finally {
    loading.value = false;
  }
};

const logout = async () => {
  try {
    const authClient = await AuthClient.create();
    await authClient.logout();
    isAuthenticated.value = false;
    userPrincipal.value = null;
    errorMessage.value = ''; // Clear error message on successful logout
  } catch (error) {
    console.error("Error during logout:", error);
    errorMessage.value = "An error occurred while trying to logout.";
  }
};

onMounted(checkAuth);
</script>

<style scoped>
/* Add any additional styling here */
</style>