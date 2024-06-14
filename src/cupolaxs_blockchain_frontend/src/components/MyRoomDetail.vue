<template>
  <Header />
  <div class="container mx-auto px-4">
    <div v-if="loading" class="text-center">
      <LoadingSpinner />
    </div>
    <div v-else-if="cell" class="container">
      <div class="mt-12 ml-12">
        <h1 class="text-4xl font-medium mx-2 mb-4 text-white">Room {{ cell.id }}</h1>
        <p class="text-lg">Price: {{ cell.price }}</p>
        <p class="text-lg">Booking End Date: {{ cell.dateEndBooking }}</p>
        <button @click="showModal = true" class="py-2.5 px-5 text-sm font-medium text-white bg-red-600 rounded-lg hover:bg-red-700">Cancel Reservation</button>
      </div>
      <!-- Modal for Canceling Reservation -->
      <ConfirmationModal
        v-if="showModal"
        @close="closeModal"
        @confirm="confirmCancel"
        title="Are you sure you want to cancel your reservation?"
        confirmButtonText="Yes, Cancel"
        :description="'You will still have access to the room for one month from the cancellation date. Your booking end date will be updated accordingly.'">
      </ConfirmationModal>
    </div>
    <div v-else class="text-center">
      <h1 class="text-4xl font-medium my-6">You did not book this cell or it does not exist.</h1>
      <router-link to="/bookroom"
                   class="py-2.5 px-5 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-primary-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700">Book a room</router-link>
    </div>
    <div class="mt-8">
      <button @click="goBack" class="py-2.5 px-5 text-sm font-medium text-white bg-blue-600 rounded-lg hover:bg-blue-700">Back to My Reservations</button>
    </div>
    <div v-if="errorMessage" class="mt-8">
      <h2 class="text-3xl font-medium mx-2 mb-4 text-red-600">Error</h2>
      <div class="bg-red-100 p-5 rounded-lg shadow">
        <p class="text-red-900">{{ errorMessage }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { AuthClient } from '@dfinity/auth-client';
import { cupolaxs_blockchain_backend as backend } from 'declarations/cupolaxs_blockchain_backend';
import Header from "@/components/Header.vue";
import ConfirmationModal from "@/components/ConfirmationModal.vue";
import LoadingSpinner from "@/components/LoadingSpinner.vue";
import { formatISO, addMonths, format } from 'date-fns';

const route = useRoute();
const router = useRouter();
const cell = ref(null);
const loading = ref(true);
const showModal = ref(false);
const errorMessage = ref(null);

const fetchCellDetails = async () => {
  loading.value = true;
  try {
    const authClient = await AuthClient.create();
    if (await authClient.isAuthenticated()) {
      const identity = authClient.getIdentity();
      const userPrincipal = identity.getPrincipal().toText(); // Ensure correct format
      const cellIdParam = route.params.cellId;

      if (!cellIdParam || isNaN(cellIdParam)) {
        loading.value = false;
        return;
      }

      const cellId = parseInt(cellIdParam, 10);
      const details = await backend.getCellDetails(cellId);

      if (details && details.bookedBy && details.bookedBy.toText() === userPrincipal) { // Ensure correct comparison
        cell.value = details;
      } else {
        console.log("You did not book this cell or it does not exist.");
      }
    } else {
      router.push({ name: 'bookroom' });
    }
  } catch (error) {
    console.error("Error fetching cell details:", error);
    errorMessage.value = 'Error fetching cell details: ' + error.message;
  } finally {
    loading.value = false;
  }
};

const closeModal = () => {
  showModal.value = false;
};

const confirmCancel = async () => {
  if (cell.value) {
    const currentDate = new Date();
    const newEndDate = format(addMonths(currentDate, 1), 'dd/MM/yyyy');
    cell.value.dateEndBooking = newEndDate;

    try {
      await backend.updateCellEndDate(cell.value.id, newEndDate);
      closeModal();
    } catch (error) {
      console.error("Error updating cell end date:", error);
      errorMessage.value = 'Error updating cell end date: ' + error.message;
    }
  }
};

const goBack = () => {
  router.push({ name: 'myreservations' });
};

onMounted(fetchCellDetails);
watch(() => route.params.cellId, fetchCellDetails);
</script>