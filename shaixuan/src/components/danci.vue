<script setup>
defineEmits(["zhanshi"]);
defineProps(["danci"]);

const color = {
  "none.": "rgba(0,0,100,0.3)",
  "n.": "rgba(0,0,200,0.3)",
  "abbr.": "rgba(0,100,0,0.3)",
  "adj.": "rgba(0,100,100,0.3)",
  "prep.": "rgba(0,100,200,0.3)",
  "v.": "rgba(0,200,0,0.3)",
  "vi.": "rgba(0,200,100,0.3)",
  "vt.": "rgba(0,200,200,0.3)",
  "adv.": "rgba(100,0,0,0.3)",
  "int.": "rgba(100,0,100,0.3)",
  "num.": "rgba(100,0,200,0.3)",
  "pl.": "rgba(100,100,0,0.3)",
  "vbl.": "rgba(100,100,100,0.3)",
};
</script>
<template>
  <div
    v-text="danci[0]"
    :title="danci[0]"
    @click="$emit('zhanshi', danci)"
    :style="{ backgroundColor: color[danci[1]] }"
  ></div>
</template>
<style scoped></style>
