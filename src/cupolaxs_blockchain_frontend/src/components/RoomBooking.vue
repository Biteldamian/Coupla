<template>
  <Header/>
  <div class="container mx-auto px-4">
    <div class="mt-12 ml-12">
      <h1 class="text-5xl font-medium mx-2 mb-4 dark:text-white">Book a room</h1>
    </div>
    <div>
      <p class="mb-3 font-normal text-gray-700 dark:text-gray-400">
        Start date: 
        <VueDatePicker v-model="startBookingDate" :format="formatDate" :enable-time-picker="false" :max-date="maxDate" :min-date="minDate" aria-label="Select start booking date"></VueDatePicker>
      </p>
      <p v-if="errorMessage" class="text-red-500">{{ errorMessage }}</p>
    </div>

    <h3 class="mt-3 text-2xl font-medium mb-1 dark:text-white">Available cells:</h3>

    <div v-if="loading" class="text-center">
      <p>Loading...</p>
    </div>
    <div v-else class="grid grid-cols-3 gap-4 justify-center">
      <h4 v-if="availableCells.length == 0">No cells found</h4>
      <div v-for="cell in availableCells" :key="cell.id" class="max-w-sm p-5 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700 mx-auto w-full">
        <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">Room {{ cell.id }}</h5>
        <p class="mb-3 font-normal text-gray-700 dark:text-gray-400">Price: €{{ cell.price }}</p>
        <p class="mb-3 font-normal text-gray-700 dark:text-gray-400">Cell availability: Available</p>
        <button type="button" @click="bookCell(cell.id)" class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800">Book</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { AuthClient } from '@dfinity/auth-client';
import { cupolaxs_blockchain_backend as backend } from 'declarations/cupolaxs_blockchain_backend';
import Header from "@/components/Header.vue";
import VueDatePicker from '@vuepic/vue-datepicker';
import '@vuepic/vue-datepicker/dist/main.css';

const availableCells = ref([]);
const startBookingDate = ref(new Date());
const loading = ref(true);
const errorMessage = ref('');

const fetchRooms = async () => {
  loading.value = true;
  errorMessage.value = '';
  try {
    const allCells = await backend.listCells();
    availableCells.value = allCells.filter(cell => !cell.isBooked);
  } catch (error) {
    console.error("Error fetching rooms:", error);
    errorMessage.value = 'Error fetching rooms: ' + error.message;
  } finally {
    loading.value = false;
  }
};

const bookCell = async (cellId) => {
  const authClient = await AuthClient.create();
  errorMessage.value = '';

  if (!(await authClient.isAuthenticated())) {
    errorMessage.value = "Please log in first.";
    return;
  }

  if (!startBookingDate.value) {
    errorMessage.value = "Choose a correct start date.";
    return;
  }

  const startBookingDateString = formatDate(startBookingDate.value);

  try {
    const identity = authClient.getIdentity();
    const userPrincipal = identity.getPrincipal().toText(); // Ensure correct format
    const success = await backend.bookCell(userPrincipal, cellId, startBookingDateString);

    if (success) {
      alert(`Cell ${cellId} booked successfully.`);
      await fetchRooms();
    } else {
      errorMessage.value = "Failed to book cell. It might already be booked.";
    }
  } catch (error) {
    console.error("Booking error:", error);
    errorMessage.value = 'Booking error: ' + error.message;
  }
};

const formatDate = (date) => {
  const d = new Date(date);
  const month = '' + (d.getMonth() + 1);
  const day = '' + d.getDate();
  const year = d.getFullYear();

  return [year, month.padStart(2, '0'), day.padStart(2, '0')].join('-');
};

onMounted(fetchRooms);
</script>

<style scoped>
.container {
  max-width: 800px;
}
</style>