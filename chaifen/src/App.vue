<script setup>
import { ref, computed, onMounted } from "vue";
import dic from "../public/dic.json";
import tiquVue from "./components/tiqu.vue";
import chaiciVue from "./components/chaici.vue";
import chaijuVue from "./components/chaiju.vue";
onMounted(() => {
  setInterval(() => {
    time.value = new Date().getHours();
  }, 1000);
});
const fanyiqu = ref("");
function fanyi(key) {
  const dicj = dic.filter((i) => {
    if (i[0].toLowerCase() === key) {
      return true;
    }
  });
  if (dicj.length >= 1) {
    fanyiqu.value = dicj
      .map((v, i) => {
        if (i % 2) {
          return " || " + v;
        } else {
          return v;
        }
      })
      .join(" ");
  } else {
    fanyiqu.value = "无结果";
  }
}
const url = ref("");
const pjurl = computed({
  get() {
    return url.value;
  },
  set(juzi) {
    url.value = `https://fanyi.sogou.com/text?keyword=${juzi}&transfrom=auto&transto=zh-CHS&model=general`;
  },
});
function fanyiju(juzi) {
  pjurl.value = juzi;
}
const time = ref();
function input() {}
function focus() {}
function blur() {}
const liuyan = computed({
  get() {
    if (0 <= time.value && time.value <= 5) {
      return "现在是凌晨，好好休息才能事半功倍哦！！！";
    } else if (5 < time.value && time.value <= 10) {
      return "一日之计在于晨，早上好！！！";
    } else if (10 < time.value && time.value <= 12) {
      return "书山有路勤为径，上午好！！！";
    } else if (12 < time.value && time.value <= 15) {
      return "有志者，事竟成，下午好！！！";
    } else if (15 < time.value && time.value <= 18) {
      return "一道残阳铺水中，半江瑟瑟半江红，到傍晚了";
    } else if (18 < time.value && time.value <= 22) {
      return "击破黑夜的幻象，晚上好！！！";
    } else if (22 < time.value && time.value <= 24) {
      return "深夜了，夜阑人静，大地上万物都进入了梦乡";
    }
  },
});
const inputv = ref();
const tiquv = ref({});
const chaiciv = ref([]);
const chaijuv = ref([]);
function tiquc() {
  if (inputv.value === undefined) {
    return;
  }
  qingchu();
  inputv.value.match(/[a-zA-Z]+/g).forEach((element) => {
    element = element.toLowerCase();
    tiquv.value[element] =
      Object.keys(tiquv.value).indexOf(element) == -1 ? 1 : tiquv.value[element] + 1;
  });
  let temp = new Object();
  Object.keys(tiquv.value)
    .sort((a, b) => {
      return tiquv.value[b] - tiquv.value[a];
    })
    .forEach((value) => {
      temp[value] = tiquv.value[value];
    });
  tiquv.value = temp;
}
function chaicic() {
  if (inputv.value === undefined) {
    return;
  }
  qingchu();
  chaiciv.value = inputv.value.match(/[a-zA-Z]+/g);
}
function chaijuc() {
  if (inputv.value === undefined) {
    return;
  }
  qingchu();
  chaijuv.value = inputv.value.match(/[a-zA-Z][a-zA-Z' ]+[a-zA-Z]/g);
}
function qingchuc() {
  qingchu();
  inputv.value = "";
}
function qingchu() {
  tiquv.value = {};
  fanyiqu.value = "";
  url.value = "";
  chaiciv.value = [];
  chaijuv.value = [];
}
</script>
<template>
  <div id="main">
    <h1>单词检索系统</h1>
    <div id="jieshao"></div>
    <textarea
      title="请输入"
      lang="5000"
      id="wenben"
      cols="60"
      rows="15"
      :placeholder="liuyan"
      v-model="inputv"
      @input="input"
      @focus="focus"
      @blur="blur"
    ></textarea>
    <br />
    <div style="display: block; text-align: center">
      <button id="tiqu" @click="tiquc">提取</button>
      <button id="chaifen" @click="chaicic">拆词</button>
      <button id="chaifen" @click="chaijuc">拆句</button>
      <button id="qingchu" @click="qingchuc">清除</button>
    </div>
    <hr style="padding: 1px; margin: 10px" />
    <div id="jieguo">
      <tiquVue :tiquv="tiquv" v-if="Object.keys(tiquv).length > 0"></tiquVue>
      <chaiciVue :chaiciv="chaiciv" @fanyi="fanyi"
        ><div v-text="fanyiqu"></div
      ></chaiciVue>
      <chaijuVue
        :chaijuv="chaijuv"
        :pjurl="pjurl"
        :url="url"
        @fanyiju="fanyiju"
        @fanyijuguanbi="url = ''"
      >
      </chaijuVue>
    </div>
  </div>
</template>

<style scoped>
textarea {
  font-size: 1em;
  font-weight: 900;
  text-align: center;
  line-height: 1em;
  color: rgb(255, 255, 255, 0.85);
  cursor: pointer;
  border-radius: 0.75rem;
  background: rgba(0, 0, 0, 0.85);
  box-shadow: -5px 5px 5px #353535, -5px 5px 5px #ffffff;
  transition: all 0.25s linear;
  border: 15px rgba(171, 223, 248, 0) solid;
}

h1 {
  color: #66ccff;
  text-shadow: 5px 5px 5px #ff0000;
}

button {
  margin: 0.1rem;
  font-size: 1em;
  width: 8rem;
  line-height: 1em;
  color: #ffffff;
  cursor: pointer;
  border-radius: 15px;
  background: rgb(0, 0, 0);
  box-shadow: -0.25rem 0.25rem 0.25rem #353535, -0.25rem 0.25rem 0.25rem #ffffff;
  transition: all 0.25s linear;
  border: 5px rgba(171, 223, 248, 0) solid;
}
</style>
