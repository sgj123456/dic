<script setup>
defineProps(["chaiciv"]);
defineEmits(["fanyi"]);
</script>
<template>
  <slot></slot>
  <div id="chaici">
    <button
      v-for="ci of chaiciv"
      :key="ci"
      v-text="ci"
      @click="$emit('fanyi', ci)"
    ></button>
  </div>
</template>
<style scoped>
#chaici {
  width: 100%;
  display: flex;
  gap: 0.125rem;
  flex-wrap: wrap;
}
button {
  padding: 0.35em;
  font-size: 0.85em;
  background-color: #e1e1e1;
}
</style>
