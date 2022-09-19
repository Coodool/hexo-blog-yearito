---
title: 热门文章Top 10
comments: false
date: 2018-10-30 00:54:50
---

<div id="post-rank"></div>

<script src="https://cdn.jsdelivr.net/npm/leancloud-storage@4.13.2/dist/av-min.js"></script>
<!-- <script src="https://cdn1.lncld.net/static/js/av-core-mini-0.6.1.js"></script> -->
<script type="text/javascript">
  var APP_ID = 'aFFxWQnF1fWvTpBbPeQ777Gi-gzGzoHsz';
  var APP_KEY = 'C6WUNgLD7DXgy3MzxbX804ri';
  var SERVER_URL = 'https://affxwqnf.lc-cn-n1-shared.com';
  //AV.initialize(APP_ID, APP_KEY);
  AV.init({
    appId: APP_ID,
    appKey: APP_KEY,
    serverURL: SERVER_URL
  });

  var query = new AV.Query('Counter');//表名
  query.descending('time'); //结果按阅读次数降序排序
  query.limit(10);  //最终只返回10条结果
  query.find().then( response => {
    var content = response.reduce( (accum, {attributes}) => {
      accum += `<p><div class="prefix">热度 ${attributes.time} ℃</div><div><a href="${attributes.url}">${attributes.title}</a></div></p>`
      return accum;
    },"")
    document.querySelector("#post-rank").innerHTML = content;
  })
  .catch( error => {
    console.log(error);
  });
</script>

<style type="text/css">
  #post-rank {
    text-align: center;
  }
  #post-rank .prefix {
    color: #ff4d4f;
  }
</style>
