<script setup>
import { ref } from "@vue/runtime-core";
import dic from "../../public/dic.json";
defineProps(["tiquv"]);
function ci(key) {
  const dicj = dic.filter((i) => {
    if (i[0].toLowerCase() === key) {
      return true;
    }
  });
  if (dicj.length >= 1) {
    return dicj;
  }
  return [["无", "结", "果"]];
}

function fanyixiangxi(value) {
  return value
    .map((v, i) => {
      if (i % 2) {
        return " || " + v;
      } else {
        return v;
      }
    })
    .join(" ");
}
</script>
<template>
  <div>
    <div v-for="(val, key) of tiquv" :key="key" class="diczu">
      <span v-text="val + '次'"></span>
      <button v-text="key" id="dic"></button>
      <button
        id="fanyi"
        v-for="zhis of ci(key)"
        :key="zhis"
        v-text="fanyixiangxi(zhis)"
        class="zhi"
      ></button>
      <hr />
    </div>
  </div>
</template>
<style scoped>
span {
  font-weight: 900;
  background-color: #e1e1e1;
  width: 10%;
  border-radius: 50em;
}
#dic {
  width: 10%;
  font-size: 0.85em;
  font-weight: 600;
  display: inline-block;
  padding: 0.25em;
  font-size: 0.85em;
  background-color: #e1e1e1;
}
.diczu {
  text-align: left;
}
.zhi {
  width: 20%;
  font-size: 0.85em;
  font-weight: 600;
  display: inline-block;
  padding: 0.25em;
  font-size: 0.85em;
}
</style>
