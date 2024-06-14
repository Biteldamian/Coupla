<template>
  <Header />
  <div class="container mx-auto px-4">
    <div class="mt-12 ml-12">
      <h1 class="text-4xl font-medium mx-2 mb-4 text-white">My Rooms</h1>
    </div>
    <div class="grid grid-cols-3 gap-4 justify-center">
      <div v-for="cell in myReservations" :key="cell.id"
           class="max-w-sm p-5 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700 mx-auto w-full">
        <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">Room {{ cell.id }}</h5>
        <p class="mb-3 font-normal text-gray-700 dark:text-gray-400">Price: {{ cell.price }}</p>
        <p v-if="!cell.isBooked" class="mb-3 font-normal text-gray-700 dark:text-gray-400">Cell availability: Available</p>
        <p v-else class="mb-3 font-normal text-gray-700 dark:text-gray-400">Cell availability: Booked</p>
        <button type="button" v-if="!cell.isBooked" @click="bookCell(cell.id)"
                class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800">
          Book
        </button>
        <p v-if="cell.isBooked" class="mb-3 font-normal text-gray-700 dark:text-gray-400">Booked by: {{ cell.bookedBy }}</p>
      </div>
    </div>
    <div class="mt-12 ml-12">
      <h2 class="text-3xl font-medium mx-2 mb-4 text-white">Token Actions</h2>
      <div class="mb-4">
        <label for="principal" class="block text-sm font-medium text-gray-700 dark:text-gray-400">Principal:</label>
        <input type="text" v-model="targetPrincipal" id="principal" class="mt-1 block w-full px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400">
      </div>
      <div class="flex space-x-4">
        <button @click="mintToken" class="text-white bg-green-700 hover:bg-green-800 focus:ring-4 focus:ring-green-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-green-600 dark:hover:bg-green-700 focus:outline-none dark:focus:ring-green-800">Mint Token</button>
        <button @click="sendToken" class="text-white bg-yellow-700 hover:bg-yellow-800 focus:ring-4 focus:ring-yellow-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-yellow-600 dark:hover:bg-yellow-700 focus:outline-none dark:focus:ring-yellow-800">Send Token</button>
      </div>
    </div>
    <Wallet :principal="principal" />
    <div v-if="errorMessage" class="mt-8">
      <h2 class="text-3xl font-medium mx-2 mb-4 text-red-600">Error</h2>
      <div class="bg-red-100 p-5 rounded-lg shadow">
        <p class="text-red-900">{{ errorMessage }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import { AuthClient } from '@dfinity/auth-client';
import { cupolaxs_blockchain_backend as backend } from 'declarations/cupolaxs_blockchain_backend';
import Header from "@/components/Header.vue";
import Wallet from "@/components/Wallet.vue";

export default {
  components: { Header, Wallet },
  data() {
    return {
      myReservations: [],
      errorMessage: null,
      principal: null,
      targetPrincipal: ''
    };
  },

  async mounted() {
    await this.fetchMyReservations();
  },

  methods: {
    async fetchMyReservations() {
      try {
        const authClient = await AuthClient.create();
        const identity = authClient.getIdentity();
        this.principal = identity.getPrincipal().toText();
        console.log("Fetching reservations for principal:", this.principal);

        const allCells = await backend.listCells();
        this.myReservations = allCells.filter(cell => cell.bookedBy && cell.bookedBy.toText() === this.principal);
      } catch (error) {
        this.errorMessage = 'Error fetching my reservations: ' + error.message;
        console.error('Error fetching my reservations:', error);
      }
    },

    async bookCell(cellId) {
      try {
        console.log(`Attempting to book cell ${cellId}`);
        const result = await backend.bookCell(cellId);
        if (result) {
          console.log(`Successfully booked cell ${cellId}`);
          alert("Booking successful");
          await this.fetchMyReservations(); // Refresh the reservations list
        } else {
          throw new Error("Booking failed due to an unknown error");
        }
      } catch (error) {
        this.errorMessage = `Error booking cell ${cellId}: ` + error.message;
        console.error(`Error booking cell ${cellId}:`, error);
        alert("Booking failed");
      }
    },

    async mintToken() {
      try {
        console.log(`Minting token for principal ${this.targetPrincipal}`);
        const result = await backend.mintToken(this.targetPrincipal);
        if (result) {
          console.log(`Successfully minted token for principal ${this.targetPrincipal}`);
          alert("Token minted successfully");
        } else {
          throw new Error("Minting token failed due to an unknown error");
        }
      } catch (error) {
        this.errorMessage = `Error minting token for principal ${this.targetPrincipal}: ` + error.message;
        console.error(`Error minting token for principal ${this.targetPrincipal}:`, error);
        alert("Minting token failed");
      }
    },

    async sendToken() {
      try {
        console.log(`Sending token to principal ${this.targetPrincipal}`);
        const result = await backend.sendToken(this.targetPrincipal);
        if (result) {
          console.log(`Successfully sent token to principal ${this.targetPrincipal}`);
          alert("Token sent successfully");
        } else {
          throw new Error("Sending token failed due to an unknown error");
        }
      } catch (error) {
        this.errorMessage = `Error sending token to principal ${this.targetPrincipal}: ` + error.message;
        console.error(`Error sending token to principal ${this.targetPrincipal}:`, error);
        alert("Sending token failed");
      }
    }
  }
}
</script>