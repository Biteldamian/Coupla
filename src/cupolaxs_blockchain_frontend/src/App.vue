<template>
  <div>
    <NavBar />
    <div v-if="loading" class="text-center">
      <LoadingSpinner />
    </div>
    <div v-if="errorMessage" class="text-center text-red-500">
      <p>{{ errorMessage }}</p>
    </div>
    <div v-else>
      <RouterView />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { AuthClient } from '@dfinity/auth-client';
import NavBar from '@/components/NavBar.vue';
import LoadingSpinner from '@/components/LoadingSpinner.vue';

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
      userPrincipal.value = identity.getPrincipal().toString();
      errorMessage.value = ''; // Clear any previous error message
    }
  } catch (error) {
    console.error("Error checking authentication:", error);
    errorMessage.value = "Failed to check authentication. Please try again.";
  } finally {
    loading.value = false;
  }
};

onMounted(checkAuth);
</script>

<style scoped>
/* Add any additional styling here */
</style>