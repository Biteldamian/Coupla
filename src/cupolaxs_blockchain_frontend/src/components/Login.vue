<template>
  <div>
    <button v-if="!userId" @click="loginWithInternetIdentity"
            class="inline-flex items-center justify-center px-5 py-3 text-base font-medium text-center text-gray-900 border border-gray-300 rounded-lg hover:bg-gray-100 focus:ring-4 focus:ring-gray-100 dark:text-white dark:border-gray-700 dark:hover:bg-gray-700 dark:focus:ring-gray-800">
      Login with Internet Identity
      <svg class="w-5 h-5 ml-2 -mr-1" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd"
              d="M10.293 3.293a1 1 0 011.414 0l6 6a1 1 0 010 1.414l-6 6a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-4.293-4.293a1 1 0 010-1.414z"
              clip-rule="evenodd"></path>
      </svg>
    </button>
    <div v-if="userId" class="dark:text-white">
      {{ userId }}
      <button @click="logout" type="button"
              class="ml-4 text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800">
        Logout
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { AuthClient } from '@dfinity/auth-client';
import { cupolaxs_blockchain_backend as backend } from 'declarations/cupolaxs_blockchain_backend';
import router from "@/router/index.js";

const userId = ref(null); // Stores the user's principal as a string

async function initAuth() {
  const authClient = await AuthClient.create();
  if (await authClient.isAuthenticated()) {
    const identity = authClient.getIdentity();
    userId.value = identity.getPrincipal().toString();
    console.log("initauth: " + userId.value);
    // No redirection here
    if (router.currentRoute.value.name === 'home') {
      await router.push({ name: 'bookroom' });
    }
  }
}

async function loginWithInternetIdentity() {
  const authClient = await AuthClient.create();
  await authClient.login({
    identityProvider: 'https://identity.ic0.app/#authorize',
    onSuccess: async () => {
      const identity = authClient.getIdentity();
      userId.value = identity.getPrincipal().toString();
      await registerUser(userId.value); // Call registerUser upon successful login
      await router.push({name: 'bookroom'}); // Redirect to dashboard or another route
    },
  });
}

async function registerUser(userPrincipal) {
  try {
    const success = await backend.registerUser(userPrincipal);
    if (success) {
      console.log("User registered successfully");
    } else {
      console.log("User was already registered or registration failed");
    }
  } catch (error) {
    console.error("Registration error:", error);
  }
}

// Logout function
async function logout() {
  const authClient = await AuthClient.create();
  await authClient.logout();
  userId.value = null; // Reset the user state
  router.push({ name: 'home' }); // Redirect to the home page after logout
}

onMounted(initAuth);
</script>
