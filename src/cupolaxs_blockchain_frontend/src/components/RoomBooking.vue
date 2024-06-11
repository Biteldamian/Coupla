<template>
  <Header/>
  <div class="container mx-auto px-4">
    <div class="mt-12 ml-12">
      <h1 class="text-5xl font-medium mx-2 mb-4 dark:text-white">Book a room</h1>
    </div>
    <div>
      <p class="mb-3 font-normal text-gray-700 dark:text-gray-400">
        Start date: 
        <VueDatePicker v-model="startBookingDate" :format="formatDate" :enable-time-picker="false" :max-date="maxDate" :min-date="minDate"></VueDatePicker>
      </p>
    </div>

    <h3 class="mt-3 text-2xl font-medium mb-1 dark:text-white">Available cells:</h3>

    <div class="grid grid-cols-3 gap-4 justify-center">
      <h4 v-if="availableCells.length == 0">No cells found</h4>
      <div v-for="cell in availableCells" :key="cell.id" class="max-w-sm p-5 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700 mx-auto w-full">
        <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">Room {{ cell.id }}</h5>
        <p class="mb-3 font-normal text-gray-700 dark:text-gray-400">Price: {{ cell.price }}</p>
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
const userId = ref(null); // Store the user's principal here
const startBookingDate = ref(new Date());

const fetchRooms = async () => {
  try {
    const allCells = await backend.listCells();
    availableCells.value = allCells.filter(cell => !cell.isBooked);
  } catch (error) {
    console.error("Error fetching rooms:", error);
    alert("An error occurred while fetching rooms.");
  }
};

const bookCell = async (cellId) => {
  const authClient = await AuthClient.create();

  if (!(await authClient.isAuthenticated())) {
    userId.value = null; // Ensure userId reflects the current auth state
    alert("Please log in first.");
    return;
  }

  // Validate that a correct date is chosen
  if (!startBookingDate.value) {
    alert("Choose a correct start date.");
    return;
  }

  const startBookingDateString = formatDate(startBookingDate.value); // Format date to send to backend

  try {
    const identity = authClient.getIdentity();
    const userPrincipal = identity.getPrincipal(); // Fetch the current user principal

    // Log the principal for debugging
    console.log("User Principal:", userPrincipal.toText());

    // Call the backend function with the principal as a string and the cell ID
    const success = await backend.bookCell(userPrincipal.toText(), cellId, startBookingDateString);

    if (success) {
      alert(`Cell ${cellId} booked successfully.`);
      await fetchRooms(); // Refresh the list of cells
    } else {
      alert("Failed to book cell. It might already be booked.");
    }
  } catch (error) {
    console.error("Booking error:", error);
    alert("An error occurred while trying to book the cell.");
  }
};

/**
 * Format date to DD/MM/YYYY
 * @param {Date} date 
 * @returns {string}
 */
const formatDate = (date) => {
  if (!date) {
    return '';
  }

  const day = date.getDate().toString().padStart(2, '0');
  const month = (date.getMonth() + 1).toString().padStart(2, '0');
  const year = date.getFullYear();

  return `${day}/${month}/${year}`;
};

/**
 * Disables all dates further than a month from now
 */
const maxDate = computed(() => {
  const datePlusMonth = new Date();
  datePlusMonth.setMonth(datePlusMonth.getMonth() + 1);
  return datePlusMonth.toISOString().substr(0, 10);
});

/**
 * Disables all dates earlier than today
 */
const minDate = computed(() => {
  const currentDate = new Date();
  return currentDate.toISOString().substr(0, 10);
});

onMounted(async () => {
  const authClient = await AuthClient.create();
  if (await authClient.isAuthenticated()) {
    const identity = authClient.getIdentity();
    userId.value = identity.getPrincipal(); // Capture and store the authenticated user's principal
  }
  await fetchRooms(); // Fetch the list of cells
});
</script>