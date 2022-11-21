<script setup>
import { ref, onMounted, computed } from "vue";
import danciVue from "./components/danci.vue";
import fanyiVue from "./components/fanyi.vue";
import dic from "../public/dic.json";
const h1 = ref("单词检索系统");
function zhengzepipei(zhengze) {
  return dic.filter((v) => {
    return zhengze.test(v[0]);
  });
}
onMounted(() => {
  let zhuangtai = true;
  setInterval(() => {
    if (zhuangtai) {
      h1.value = "万词王";
      zhuangtai = false;
    } else {
      h1.value = "正则表达式";
      zhuangtai = true;
    }
  }, 1500);
});

const debounce = (fn, delay) => {
  let timer = null;
  return function () {
    let context = this;
    let args = arguments;
    clearTimeout(timer);
    timer = setTimeout(function () {
      fn.apply(context, args);
    }, delay);
  };
};
const dics = ref();
const dicl = ref();
const fanyis = ref([]);
const inputv = ref();
const input = debounce(function () {
  const dic = zhengzepipei(new RegExp(inputv.value));
  dicl.value = dic.length;
  if (dic.length <= 10000) {
    dics.value = zhengzepipei(new RegExp(inputv.value));
  } else {
    dics.value = [];
  }
}, 1000);
function zhanshi(danci) {
  fanyis.value.push(danci);
}
function fanyishou(e) {
  console.log(e);
}
</script>

<template>
  <h1 v-text="h1"></h1>
  <input type="text" v-model="inputv" @input.passive="input" id="input" />
  <p
    v-if="dicl !== undefined && inputv !== ''"
    v-text="dicl <= 10000 ? `共有${dicl}个结果单词` : `结果单词${dicl}个过多`"
  ></p>
  <div id="fanyiquke">
    <div id="fanyiqu">
      <fanyiVue
        v-for="fanyi of fanyis"
        :key="fanyi"
        :fanyi="fanyi"
        class="fanyi"
      ></fanyiVue>
    </div>
  </div>
  <div id="danciqu">
    <danciVue
      v-for="dic of dics"
      :key="dic"
      :danci="dic"
      class="danci"
      @zhanshi="zhanshi"
    ></danciVue>
  </div>
</template>

<style scoped>
#input {
  width: 100%;
  line-height: 2em;
  text-align: center;
  font-size: 2em;
  border-radius: 2em;
}
#danciqu {
  width: 100%;
  height: 60rem;
  display: flex;
  gap: 0.125em;
  flex-wrap: wrap;
  gap: 2px;
  flex-wrap: wrap;
  justify-content: space-around;
  overflow-x: hidden;
  overflow-y: auto;
}
.danci {
  width: 7em;
  height: 2em;
  line-height: 2em;
  border-radius: 0.3em;
  font-weight: 550;
  font-size: 1.25em;
  text-align: center;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}
#fanyiquke {
  padding: 1rem 0;
  width: 100%;
  overflow-x: auto;
}
#fanyiqu {
  display: inline-flex;
  gap: 2px;
}
.fanyi {
  height: 6em;
  overflow: auto;
  background: rgba(0, 0, 0, 0.9);
  border-radius: 1em;
  padding: 0.5em;
}
p{
  font-weight: 600;
  font-size: 1.5em;
  line-height: 1.5em;
  margin: 0.2rem;

}
</style>
