<template>
    <div class="modal-backdrop">
      <div class="modal">
        <h2>{{ title }}</h2>
        <p>{{ description }}</p>
        <button @click="confirm"> {{ confirmButtonText }} </button>
        <button @click="close">Cancel</button>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    props: {
      title: String,
      description: String,
      confirmButtonText: String,
    },
    emits: ['confirm', 'close'],
    methods: {
      confirm() {
        this.$emit('confirm');
      },
      close() {
        this.$emit('close');
      },
    },
  };
  </script>
  
  <style scoped>
  .modal-backdrop {
    /* Styles for modal backdrop */
  }
  .modal {
    /* Styles for modal */
  }
  </style>