<template>
  <Header/>
  <div v-show="cell">
    <section class="bg-white dark:bg-gray-900">
      <div
          class="gap-8 items-center py-8 px-4 mx-auto max-w-screen-xl xl:gap-16 md:grid md:grid-cols-2 sm:py-16 lg:px-6">


        <div id="default-carousel" class="relative w-full" data-carousel="slide">
          <!-- Carousel wrapper -->
          <div class="relative h-56 overflow-hidden rounded-lg md:h-96">
            <!-- Item 1 -->
            <div class="hidden duration-700 ease-in-out" data-carousel-item>
              <img src="@/assets/img/cell-images-1.jpeg"
                   class="absolute block w-full -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2" alt="...">
            </div>
            <!-- Item 2 -->
            <div class="hidden duration-700 ease-in-out" data-carousel-item>
              <img src="@/assets/img/cell-images-2.webp"
                   class="absolute block w-full -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2" alt="...">
            </div>
            <!-- Item 3 -->
            <div class="hidden duration-700 ease-in-out" data-carousel-item>
              <img src="@/assets/img/cell-images-3-feel-home.jpeg"
                   class="absolute block w-full -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2" alt="...">
            </div>
          </div>
          <!-- Slider indicators -->
          <div class="absolute z-30 flex -translate-x-1/2 bottom-5 left-1/2 space-x-3 rtl:space-x-reverse">
            <button type="button" class="w-3 h-3 rounded-full" aria-current="true" aria-label="Slide 1"
                    data-carousel-slide-to="0"></button>
            <button type="button" class="w-3 h-3 rounded-full" aria-current="false" aria-label="Slide 2"
                    data-carousel-slide-to="1"></button>
            <button type="button" class="w-3 h-3 rounded-full" aria-current="false" aria-label="Slide 3"
                    data-carousel-slide-to="2"></button>
          </div>
          <!-- Slider controls -->
          <button type="button"
                  class="absolute top-0 start-0 z-30 flex items-center justify-center h-full px-4 cursor-pointer group focus:outline-none"
                  data-carousel-prev>
        <span
            class="inline-flex items-center justify-center w-10 h-10 rounded-full bg-white/30 dark:bg-gray-800/30 group-hover:bg-white/50 dark:group-hover:bg-gray-800/60 group-focus:ring-4 group-focus:ring-white dark:group-focus:ring-gray-800/70 group-focus:outline-none">
            <svg class="w-4 h-4 text-white dark:text-gray-800 rtl:rotate-180" aria-hidden="true"
                 xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M5 1 1 5l4 4"/>
            </svg>
            <span class="sr-only">Previous</span>
        </span>
          </button>
          <button type="button"
                  class="absolute top-0 end-0 z-30 flex items-center justify-center h-full px-4 cursor-pointer group focus:outline-none"
                  data-carousel-next>
        <span
            class="inline-flex items-center justify-center w-10 h-10 rounded-full bg-white/30 dark:bg-gray-800/30 group-hover:bg-white/50 dark:group-hover:bg-gray-800/60 group-focus:ring-4 group-focus:ring-white dark:group-focus:ring-gray-800/70 group-focus:outline-none">
            <svg class="w-4 h-4 text-white dark:text-gray-800 rtl:rotate-180" aria-hidden="true"
                 xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="m1 9 4-4-4-4"/>
            </svg>
            <span class="sr-only">Next</span>
        </span>
          </button>
        </div>


        <div v-if="cell" class="mt-4 md:mt-0">
          <h2 class="mb-4 text-4xl tracking-tight font-extrabold text-gray-900 dark:text-white">Thanks for using
            Cupolaxs with your reservation of room: {{ cell.id }}</h2>
          <p class="mb-6 font-light text-gray-500 md:text-lg dark:text-gray-400">If you scroll more down you see all the
            details of your reservation. We hope you enjoy your stay at Cupolaxs and if you got any question just come
            to our desk.</p>
        </div>
      </div>
      <div v-if="cell" class="mx-auto max-w-3xl px-4 pb-16 2xl:px-0">
        <h2 class="text-xl font-semibold text-gray-900 dark:text-white sm:text-2xl mb-2">Your order information!</h2>
        <div
            class="space-y-4 sm:space-y-2 rounded-lg border border-gray-100 bg-gray-50 p-6 dark:border-gray-700 dark:bg-gray-800 mb-6 md:mb-8">
          <dl class="sm:flex items-center justify-between gap-4">
            <dt class="font-normal mb-1 sm:mb-0 text-gray-500 dark:text-gray-400">Booked by</dt>
            <dd class="font-medium text-gray-900 dark:text-white sm:text-end">{{ cell.bookedBy[0] }}</dd>
          </dl>
          <dl class="sm:flex items-center justify-between gap-4">
            <dt class="font-normal mb-1 sm:mb-0 text-gray-500 dark:text-gray-400">Price</dt>
            <dd class="font-medium text-gray-900 dark:text-white sm:text-end">€ {{ cell.price }},- <span class="text-[10px] opacity-50">*per month</span></dd>
          </dl>
          <dl class="sm:flex items-center justify-between gap-4">
            <dt class="font-normal mb-1 sm:mb-0 text-gray-500 dark:text-gray-400">Booked From</dt>
            <dd class="font-medium text-gray-900 dark:text-white sm:text-end">{{ cell.dateStartBooking }}</dd>
          </dl>
          <dl class="sm:flex items-center justify-between gap-4">
            <dt class="font-normal mb-1 sm:mb-0 text-gray-500 dark:text-gray-400">Booked until</dt>
            <dd class="font-medium text-gray-900 dark:text-white sm:text-end">{{ cell.dateEndBooking }}</dd>
          </dl>
        </div>
        <div class="flex items-center space-x-4">
          <router-link to="/reservations"
             class="text-white bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 dark:bg-primary-600 dark:hover:bg-primary-700 focus:outline-none dark:focus:ring-primary-800">View all your rooms</router-link>
          <router-link to="/bookroom"
             class="py-2.5 px-5 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-primary-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700">Book another room</router-link>
          <button @click="openModal" type="button" class="focus:outline-none text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-900">Stop Reservation</button>
        </div>
      </div>
    </section>

    <!-- Modal -->
    <div v-if="showModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
      <div class="bg-white rounded-lg shadow dark:bg-gray-700 max-w-md mx-auto">
        <div class="p-6">
          <h3 class="text-lg font-medium text-gray-900 dark:text-white">Are you sure you want to cancel your reservation?</h3>
          <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">You will still have access to the room for one month from the cancellation date. Your booking end date will be updated accordingly.</p>
          <div class="mt-4 flex justify-end">
            <button @click="closeModal" class="text-gray-700 dark:text-gray-300 mr-4">Close</button>
            <button @click="confirmCancel" class="px-4 py-2 text-white bg-red-600 rounded-lg hover:bg-red-700 focus:ring-4 focus:ring-red-300 dark:focus:ring-red-900">Yes, Cancel</button>
          </div>
        </div>
      </div>
    </div>

  </div>

  <div v-if="cell"></div>
  <div v-else-if="loading">
    <h1 class="text-4xl font-medium text-center my-6">Loading...</h1>
  </div>
  <div v-else class="text-center">
    <h1 class="text-4xl font-medium text-center my-6">You did not book this cell or it does not exist.</h1>
    <router-link to="/bookroom"
                 class="py-2.5 px-5 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-primary-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700">Book a room</router-link>

  </div>
</template>

<script>
import { useRoute, useRouter } from 'vue-router';
import { AuthClient } from '@dfinity/auth-client';
import { cupolaxs_blockchain_backend as backend } from 'declarations/cupolaxs_blockchain_backend';
import Header from "@/components/Header.vue";
import { formatISO, addMonths, format } from 'date-fns';

export default {
  components: { Header },
  data() {
    return {
      cell: null,
      loading: true,
      showModal: false
    };
  },
  computed: {
    cellId() {
      return this.route.params.cellId;
    }
  },
  watch: {
    cellId: 'fetchCellDetails'
  },
  methods: {
    async fetchCellDetails() {
      const authClient = await AuthClient.create();
      if (await authClient.isAuthenticated()) {
        const identity = authClient.getIdentity();
        const userPrincipal = identity.getPrincipal().toString();
        const cellIdParam = this.cellId;

        if (!cellIdParam || isNaN(cellIdParam)) {
          this.loading = false;
          return;
        }

        const cellId = parseInt(cellIdParam, 10);

        try {
          const details = await backend.getCellDetails(cellId);

          if (details && details[0].bookedBy && details[0].bookedBy.length > 0) {
            const bookedByPrincipal = details[0].bookedBy[0].toString();
            if (bookedByPrincipal === userPrincipal) {
              this.cell = details[0];
            } else {
              console.log("You did not book this cell or it does not exist.");
            }
          } else {
            console.log("You did not book this cell or it does not exist.");
          }
        } catch (error) {
          console.error("Error fetching cell details:", error);
        } finally {
          this.loading = false;
        }
      } else {
        this.router.push({ name: 'bookroom' });
      }
    },
    openModal() {
      this.showModal = true;
    },
    closeModal() {
      this.showModal = false;
    },
    async confirmCancel() {
      if (this.cell) {
        const currentDate = new Date();
        const newEndDate = format(addMonths(currentDate, 3), 'dd/MM/yyyy');
        this.cell.dateEndBooking = newEndDate;

        try {
          await backend.updateCellEndDate(this.cell.id, newEndDate);
          this.closeModal();
        } catch (error) {
          console.error("Error updating cell end date:", error);
        }
      }
    }
  },
  created() {
    this.fetchCellDetails();
  },
  setup() {
    const route = useRoute();
    const router = useRouter();

    return {
      route,
      router
    };
  }
};
</script>
<style scoped>
.container {
  padding-top: 20px;
}
</style>
