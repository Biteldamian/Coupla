import { createApp } from 'vue';
import App from './App.vue';
import './assets/index.css';
import 'flowbite';
import { createPinia } from 'pinia';
import router from './router/index.js'

const app = createApp(App);

app.use(router)
app.use(createPinia());
app.mount('#app');
