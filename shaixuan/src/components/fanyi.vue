<script setup>
import { ref, onMounted } from "vue";
defineProps(["fanyi"]);

const shouqi = (event) => {
  zhuangtai.value = false;
};

const zhuangtai = ref(true);
</script>
<template>
  <div @click="shouqi" v-if="zhuangtai">
    <div
      v-text="shuxing"
      :title="shuxing"
      v-for="shuxing of fanyi"
      :key="shuxing"
      class="shuxing"
    ></div>
  </div>
</template>
<style scoped>
.shuxing {
  color: rgb(255, 255, 255);
  text-align: center;
  text-overflow: ellipsis;
  white-space: nowrap;
  overflow: hidden;
}
</style>
