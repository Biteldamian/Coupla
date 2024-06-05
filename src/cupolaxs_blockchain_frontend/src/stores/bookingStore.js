import {defineStore} from 'pinia';
import {Actor, HttpAgent} from '@dfinity/agent';
import {idlFactory as booking_idl, canisterId as booking_id} from '../../../declarations/my_second_canister_backend';

export const useBookingStore = defineStore('booking', {
    state: () => ({
        rooms: [],
        // Initialize the IC agent and actor
        bookingSystem: Actor.createActor(booking_idl, {
            agent: new HttpAgent({
                host: 'http://127.0.0.1:4943', skipCertVerification: true,
            }),
            canisterId: booking_id,
        }),
    }),
    actions: {
        async fetchRooms() {
            this.rooms = await this.bookingSystem.listRooms();
        },
        async bookRoom(id) {
            const success = await this.bookingSystem.bookRoom(id);
            if (success) {
                alert(`Room ${id} booked successfully!`);
                this.fetchRooms(); // Refresh room list
            } else {
                alert(`Failed to book Room ${id}.`);
            }
        },
    },
});
