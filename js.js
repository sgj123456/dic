var main = document.getElementById('main')
var zi = document.getElementById('zi')
var jieshao = document.getElementById('jieshao')
var wenben = document.getElementById('wenben')
var jieguo = document.getElementById('jieguo')
var tiqu = document.getElementById('tiqu')
var chaifendanci = document.getElementById('chaifendanci')
var chaifenjuzi = document.getElementById('chaifenjuzi')
var qingchu = document.getElementById('qingchu')
function dancitiqu(zhengze) {
    var obj = {}
    wenben.value.match(zhengze).forEach(i => {
        i = i.toLowerCase()
        if (Object.keys(obj).indexOf(i) == -1) {
            obj[i] = 1
        } else {
            obj[i] += 1
        }
    });
    return obj
}
tiqu.onclick = function () {
    var obj = new Object()
    obj = dancitiqu(/[a-zA-Z]+/g)
    var temp = new Object()
    arr = (Object.keys(obj).sort((a, b) => {
        return obj[b] - obj[a]
    }))
    arr.forEach(i => {
        temp[i] = obj[i]
    })
    obj = temp
    var fei = "iframe.src='https://cn.bing.com/dict/search?q='+this.innerText;zi.style.display='block';main.style.display='none';"
    var wenzi = '<p>提取成功,点击单词查看翻译</p>'
    var wenzia = new String()
    var wenzib = new String()
    for (let temp in obj) {
        wenzia = '<td><button type="button" class="bth" onclick=' + fei + '>' + temp + '</button></td>'
        wenzib = '<td>' + obj[temp] + '</td>'
        wenzi += '<tr>' + wenzia + wenzib + '</tr>'
    }
    var timu = '<tr><th>单词</th><th>次数</th></tr>'
    jieguo.innerHTML = '<table border="0">' + timu + wenzi + "</table>"
}

chaifendanci.onclick = function () {
    var fei = "iframe.src='https://fanyi.sogou.com/text?keyword='+this.innerText;zi.style.display='block';main.style.display='none';"
    var wenzi = ''
    var arr = wenben.value.match(/[a-zA-Z']+/g)
    for (let temp of arr) {
        wenzi += '<button type="button" class="bthchai" onclick=' + fei + '>' + temp + '</button>'
    }
    jieguo.innerHTML = wenzi
}

chaifenjuzi.onclick = function () {
    var fei = "iframe.src='https://fanyi.sogou.com/text?keyword='+this.innerText;zi.style.display='block';main.style.display='none';"
    wenzi = ""
    var arr = wenben.value.match(/[a-zA-Z][a-zA-Z' ]+[a-zA-Z]/g)
    for (let temp of arr) {
        wenzi += '<button type="button" class="bthchai" onclick=' + fei + '>' + temp + '</button>'
    }
    jieguo.innerHTML = wenzi

}
qingchu.onclick = function () {
    wenben.value = ''
    jieguo.innerText = ''
}