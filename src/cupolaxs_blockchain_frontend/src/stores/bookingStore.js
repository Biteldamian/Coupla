import { defineStore } from 'pinia';
import { Actor, HttpAgent } from '@dfinity/agent';
import { idlFactory as booking_idl, canisterId as booking_id } from '../../../declarations/my_second_canister_backend';
import { AuthClient } from '@dfinity/auth-client';

export const useBookingStore = defineStore('booking', {
    state: () => ({
        rooms: [],
        bookingSystem: null, // Initialize bookingSystem as null
    }),
    actions: {
        async init() {
            const authClient = await AuthClient.create();
            const identity = authClient.getIdentity();

            // Initialize the IC agent and actor with the user's identity
            const agent = new HttpAgent({
                identity,
                host: 'http://127.0.0.1:4943',
                skipCertVerification: true,
            });

            this.bookingSystem = Actor.createActor(booking_idl, {
                agent,
                canisterId: booking_id,
            });
        },
        async fetchRooms() {
            try {
                if (!this.bookingSystem) {
                    await this.init();
                }
                this.rooms = await this.bookingSystem.listRooms();
            } catch (error) {
                console.error("Error fetching rooms:", error);
                alert("An error occurred while fetching rooms.");
            }
        },
        async bookRoom(id) {
            try {
                if (!this.bookingSystem) {
                    await this.init();
                }

                const authClient = await AuthClient.create();
                if (!(await authClient.isAuthenticated())) {
                    alert("Please log in first.");
                    return;
                }

                const success = await this.bookingSystem.bookRoom(id);
                if (success) {
                    alert(`Room ${id} booked successfully!`);
                    await this.fetchRooms(); // Refresh room list
                } else {
                    alert(`Failed to book Room ${id}.`);
                }
            } catch (error) {
                console.error("Error booking room:", error);
                alert("An error occurred while trying to book the room.");
            }
        },
    },
});