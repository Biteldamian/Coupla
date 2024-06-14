<template>
  <div class="container mx-auto px-4">
    <Header />
    <div class="mt-12">
      <h1 class="text-4xl font-medium mb-4 text-white">My Wallet</h1>
      <div class="bg-white p-5 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
        <p class="text-gray-900 dark:text-white">Principal: {{ principal }}</p>
        <p class="text-gray-900 dark:text-white">Token Balance: {{ tokenBalance }}</p>
      </div>
    </div>
    <div class="mt-8">
      <h2 class="text-3xl font-medium mb-4 text-white">Actions</h2>
      <div class="flex flex-wrap gap-4">
        <button @click="showMintModal" class="bg-purple-700 hover:bg-purple-800 text-white font-bold py-2 px-4 rounded">
          Mint Tokens
        </button>
        <button @click="showPaymentModal" class="bg-red-700 hover:bg-red-800 text-white font-bold py-2 px-4 rounded">
          Make Payment
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
    <!-- Confirmation Modal -->
    <ConfirmationModal
      v-if="showModal"
      :title="modalTitle"
      :description="modalDescription"
      :confirmButtonText="modalConfirmButtonText"
      @confirm="handleConfirm"
      @close="showModal = false"
    />
  </div>
</template>

<script>
import { AuthClient } from '@dfinity/auth-client';
import { cupolaxs_blockchain_backend as backend } from 'declarations/cupolaxs_blockchain_backend';
import Header from "@/components/Header.vue";
import ConfirmationModal from "@/components/ConfirmationModal.vue";

export default {
  components: {
    Header,
    ConfirmationModal
  },
  data() {
    return {
      principal: '',
      tokenBalance: 0,
      errorMessage: null,
      showModal: false,
      modalTitle: '',
      modalDescription: '',
      modalConfirmButtonText: '',
      modalAction: null,
    };
  },
  async mounted() {
    await this.fetchPrincipal();
    await this.fetchTokenBalance();
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
    async fetchTokenBalance() {
      try {
        const balance = await backend.getTokenBalance(this.principal);
        this.tokenBalance = balance;
      } catch (error) {
        this.errorMessage = 'Error fetching token balance: ' + error.message;
        console.error('Error fetching token balance:', error);
      }
    },
    showMintModal() {
      this.modalTitle = 'Mint Tokens';
      this.modalDescription = 'Enter the amount of tokens you want to mint:';
      this.modalConfirmButtonText = 'Mint';
      this.modalAction = this.mintTokens;
      this.showModal = true;
    },
    showPaymentModal() {
      this.modalTitle = 'Make Payment';
      this.modalDescription = 'Enter the recipient principal and the amount:';
      this.modalConfirmButtonText = 'Pay';
      this.modalAction = this.makePayment;
      this.showModal = true;
    },
    async mintTokens() {
      const amount = parseInt(prompt("Enter the amount to mint:"), 10);
      try {
        const result = await backend.mintTokens(this.principal, amount);
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
    },
    async makePayment() {
      const to = prompt("Enter the 'to' principal:");
      const amount = parseInt(prompt("Enter the amount:"), 10);
      try {
        const result = await backend.makePayment(this.principal, to, amount);
        if (result) {
          alert("Payment successful");
          await this.fetchTokenBalance(); // Refresh the token balance
        } else {
          alert("Payment failed");
        }
      } catch (error) {
        this.errorMessage = 'Error making payment: ' + error.message;
        console.error("Error making payment:", error);
        alert("Failed to make payment");
      }t
    },
    handleConfirm() {
      if (this.modalAction) {
        this.modalAction();
      }
      this.showModal = false;
    }
  }
}
</script>

<style scoped>
/* Add any additional styling here */
</style>