import { createApp } from "vue";
import App from "./App.vue";
import "./assets/index.css";
import "flowbite";
import { createPinia } from "pinia";
import router from "./router/index.js";

const app = createApp(App);

app.config.errorHandler = (err, vm, info) => {
  console.error(`Error: ${err.toString()}\nInfo: ${info}`);
  // You can also display a global error message here
};

app.use(createPinia());

app.use(router);
app.mount("#app");
