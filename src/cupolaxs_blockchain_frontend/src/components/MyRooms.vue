<template>
  <div class="container mx-auto p-4">
    <h1 class="text-2xl font-bold mb-4">My Booked Rooms</h1>
    <div v-if="loading" class="text-center">
      <p>Loading...</p>
    </div>
    <div v-else-if="errorMessage">
      <p class="text-red-500">{{ errorMessage }}</p>
    </div>
    <div v-else-if="bookedRooms.length > 0" class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div v-for="room in bookedRooms" :key="room.id" class="p-4 border rounded shadow">
        <h2 class="font-semibold">Room {{ room.id }}</h2>
        <p>Price: €{{ room.price }}</p>
        <p>Booked from: {{ room.dateStartBooking }}</p>
        <p>To: {{ room.dateEndBooking }}</p>
        <button @click="cancelBooking(room.id)" class="mt-2 bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded">
          Cancel Booking
        </button>
      </div>
    </div>
    <div v-else>
      <p>You have no booked rooms.</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { AuthClient } from '@dfinity/auth-client';
import { cupolaxs_blockchain_backend as backend } from 'declarations/cupolaxs_blockchain_backend';

const bookedRooms = ref([]);
const loading = ref(true);
const errorMessage = ref(null);

const fetchUserRooms = async () => {
  loading.value = true;
  try {
    const authClient = await AuthClient.create();
    if (await authClient.isAuthenticated()) {
      const identity = authClient.getIdentity();
      const userPrincipal = identity.getPrincipal();
      bookedRooms.value = await backend.listUserRooms(userPrincipal.toString());
    } else {
      errorMessage.value = "Please log in to view your booked rooms.";
    }
  } catch (error) {
    console.error("Error fetching user rooms:", error);
    errorMessage.value = 'Error fetching user rooms: ' + error.message;
  } finally {
    loading.value = false;
  }
};

const cancelBooking = async (roomId) => {
  // Placeholder for cancellation logic
  // You would call a method on your backend to cancel the booking for the given room ID
  console.log(`Cancel booking for room ID: ${roomId}`);
  // After cancellation, you might want to refresh the list of booked rooms
  await fetchUserRooms();
};

onMounted(fetchUserRooms);
</script>

<style scoped>
/* Add any additional styling here */
</style>