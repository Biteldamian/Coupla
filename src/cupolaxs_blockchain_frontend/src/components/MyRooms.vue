<template>
  <div class="container mx-auto p-4">
    <h1 class="text-2xl font-bold mb-4">My Booked Cells</h1>
    <div v-if="bookedCells.length > 0" class="grid grid-cols-3 gap-4">
      <div v-for="cell in bookedCells" :key="cell.id" class="p-4 border rounded shadow">
        <h2 class="font-semibold">Cell {{ cell.id }}</h2>
        <p>Price: ${{ cell.price }}</p>
        <p>Booked from: {{ cell.dateStartBooking }}</p>
        <p>To: {{ cell.dateEndBooking }}</p>
      </div>
    </div>
    <div v-else>
      <p>You have no booked cells.</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { AuthClient } from '@dfinity/auth-client';
import { cupolaxs_blockchain_backend as backend } from 'declarations/cupolaxs_blockchain_backend';

const bookedCells = ref([]);

const fetchUserCells = async () => {
  const authClient = await AuthClient.create();
  if (await authClient.isAuthenticated()) {
    const identity = authClient.getIdentity();
    const userPrincipal = identity.getPrincipal();
    bookedCells.value = await backend.listUserCells(userPrincipal.toString());
  } else {
    alert("Please log in to view your booked cells.");
  }
};

onMounted(fetchUserCells);
</script>

<style scoped>
/* Add any additional styling here */
</style>
