<script setup>
import { ref, computed } from "vue";
defineProps(["chaijuv", "pjurl", "url"]);
defineEmits(["fanyiju", "fanyijuguanbi"]);
</script>
<template>
  <div v-if="pjurl !== ''">
    <button style="width: 100%" @click="$emit('fanyijuguanbi', null)">关闭</button>
    <hr />
    <iframe :src="pjurl" frameborder="0"></iframe>
  </div>
  <div id="chaici" v-if="pjurl === ''">
    <button
      v-for="ju of chaijuv"
      :key="ju"
      v-text="ju"
      @click="$emit('fanyiju', ju)"
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
iframe {
  width: 100%;
  height: 100vh;
}
</style>
