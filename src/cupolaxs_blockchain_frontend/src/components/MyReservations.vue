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
    <!-- Add Wallet Section -->
    <div v-if="principal" class="mt-8">
      <h2 class="text-3xl font-medium mx-2 mb-4 text-white">My Wallet</h2>
      <div class="bg-white p-5 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
        <p class="text-gray-900 dark:text-white">Principal: {{ principal }}</p>
        <p class="text-gray-900 dark:text-white">Token Balance: {{ tokenBalance }}</p>
      </div>
    </div>
    <!-- Add Transaction History Section -->
    <div v-if="principal" class="mt-8">
      <h2 class="text-3xl font-medium mx-2 mb-4 text-white">Transaction History</h2>
      <div class="bg-white p-5 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
        <ul>
          <li v-for="transaction in transactionHistory" :key="transaction.id" class="text-gray-900 dark:text-white">
            {{ transaction }}
          </li>
        </ul>
      </div>
    </div>
    <!-- Add buttons for testing under "My Reservations" -->
    <div v-if="principal" class="mt-8">
      <h2 class="text-3xl font-medium mx-2 mb-4 text-white">Testing Actions</h2>
      <div class="flex flex-wrap gap-4">
        <button @click="deployBalances" class="text-white bg-green-700 hover:bg-green-800 focus:ring-4 focus:ring-green-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-green-600 dark:hover:bg-green-700 focus:outline-none dark:focus:ring-green-800">
          Deploy Balances
        </button>
        <button @click="deployApp" class="text-white bg-yellow-700 hover:bg-yellow-800 focus:ring-4 focus:ring-yellow-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-yellow-600 dark:hover:bg-yellow-700 focus:outline-none dark:focus:ring-yellow-800">
          Deploy App
        </button>
        <button @click="makePayment" class="text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-red-600 dark:hover:bg-red-700 focus:outline-none dark:focus:ring-red-800">
          Make Payment
        </button>
        <button @click="depositCycles" class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800">
          Deposit Cycles
        </button>
        <button @click="mintTokens" class="text-white bg-purple-700 hover:bg-purple-800 focus:ring-4 focus:ring-purple-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-purple-600 dark:hover:bg-purple-700 focus:outline-none dark:focus:ring-purple-800">
          Mint Tokens
        </button>
      </div>
    </div>
    <!-- Display Errors -->
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

export default {
  components: { Header },
  data() {
    return {
      cells: [],
      principal: null,
      myReservations: [],
      tokenBalance: 0,
      transactionHistory: [],
      errorMessage: null
    }
  },

  async mounted() {
    await this.fetchPrincipal();
    await this.fetchRooms();
    await this.fetchTokenBalance();
    await this.fetchTransactionHistory();
  },

  methods: {
    async fetchPrincipal() {
      try {
        const authClient = await AuthClient.create();
        const identity = authClient.getIdentity();
        this.principal = identity.getPrincipal().toText();
      } catch (error) {
        this.errorMessage = 'Error fetching principal: ' + error.message;
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
        this.errorMessage = 'Error fetching rooms: ' + error.message;
        console.error('Error fetching rooms:', error);
      }
    },

    async fetchTokenBalance() {
      try {
        const balance = await backend.getTokenBalance(this.principal);
        this.tokenBalance = balance;
      } catch (error) {
        this.errorMessage = 'Error fetching token balance: ' + error.message;
        console.error('Error fetching token balance:', error);
      }
    },

    async fetchTransactionHistory() {
      try {
        const history = await backend.getTransactionHistory(this.principal);
        this.transactionHistory = history;
      } catch (error) {
        this.errorMessage = 'Error fetching transaction history: ' + error.message;
        console.error('Error fetching transaction history:', error);
      }
    },

    async deployBalances() {
      try {
        await backend.deployBalances();
        alert("Balances deployed successfully");
      } catch (error) {
        this.errorMessage = 'Error deploying balances: ' + error.message;
        console.error("Error deploying balances:", error);
        alert("Failed to deploy balances");
      }
    },

    async deployApp() {
      try {
        await backend.deployApp();
        alert("App deployed successfully");
      } catch (error) {
        this.errorMessage = 'Error deploying app: ' + error.message;
        console.error("Error deploying app:", error);
        alert("Failed to deploy app");
      }
    },

    async makePayment() {
      const from = prompt("Enter the 'from' principal:");
      const to = prompt("Enter the 'to' principal:");
      const amount = parseInt(prompt("Enter the amount:"), 10);

      try {
        const result = await backend.makePayment(from, to, amount);
        if (result) {
          alert("Payment successful");
        } else {
          alert("Payment failed");
        }
      } catch (error) {
        this.errorMessage = 'Error making payment: ' + error.message;
        console.error("Error making payment:", error);
        alert("Failed to make payment");
      }
    },

    async depositCycles() {
      try {
        await backend.deposit_cycles();
        alert("Cycles deposited successfully");
      } catch (error) {
        this.errorMessage = 'Error depositing cycles: ' + error.message;
        console.error("Error depositing cycles:", error);
        alert("Failed to deposit cycles");
      }
    },

    async mintTokens() {
      const user = prompt("Enter the user's principal:");
      const amount = parseInt(prompt("Enter the amount to mint:"), 10);

      try {
        const result = await backend.mintTokens(user, amount);
        if (result) {
          alert("Tokens minted successfully");
          await this.fetchTokenBalance(); // Refresh the token balance
        } else {
          alert("Failed to mint tokens");
        }
      } catch (error) {
        this.errorMessage = 'Error minting tokens: ' + error.message;
        console.error("Error minting tokens:", error);
        alert("Failed to mint tokens");
      }
    }
  }
}
</script>