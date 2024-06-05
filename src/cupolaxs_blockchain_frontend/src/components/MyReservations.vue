<template>
  <Header />
  <div class="container mx-auto px-4">
    <div class="mt-12 ml-12">
      <h1 class="text-4xl font-medium mx-2 mb-4 text-white">My rooms</h1>
    </div>
    <div class="grid grid-cols-3 gap-4 justify-center">
      <div v-for="cell in myReservations" :key="cell.id"
           class="max-w-sm p-5 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700 mx-auto w-full">
        <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">Room {{ cell.id }}</h5>
        <p class="mb-3 font-normal text-gray-700 dark:text-gray-400">Price: {{ cell.price }}</p>
        <p v-if="!cell.isBooked" class="mb-3 font-normal text-gray-700 dark:text-gray-400">Cell availability:
          Available</p>
        <p v-else class="mb-3 font-normal text-gray-700 dark:text-gray-400">Cell availability: Booked</p>
        <button type="button" v-if="!cell.isBooked" @click="bookCell(cell.id)"
                class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800">
          Book
        </button>
        <p v-if="cell.isBooked" class="mb-3 font-normal text-gray-700 dark:text-gray-400">Booked by: {{ cell.bookedBy[0] }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import { AuthClient } from '@dfinity/auth-client';
import { cupolaxs_blockchain_backend as backend } from 'declarations/cupolaxs_blockchain_backend';
import Header from "@/components/Header.vue";

export default {
  components: { Header },
  data() {
    return {
      cells: [],
      principal: null,
      myReservations: []
    }
  },

  async mounted() {
    await this.fetchPrincipal();
    await this.fetchRooms();
  },

  methods: {
    async fetchPrincipal() {
      try {
        const authClient = await AuthClient.create();
        const identity = authClient.getIdentity();
        this.principal = identity.getPrincipal().toUint8Array().toString();
      } catch (error) {
        console.error('Error fetching principal:', error);
      }
    },

    async fetchRooms() {
      try {
        const allCells = await backend.listCells();
        this.myReservations = allCells.filter(cell => {
          return cell.bookedBy && cell.bookedBy[0] && cell.bookedBy[0]._arr.toString() === this.principal;
        });

        this.cells = allCells;  // Keep the full list of cells if needed for other purposes
      } catch (error) {
        console.error('Error fetching rooms:', error);
      }
    },
  }
}
</script>
