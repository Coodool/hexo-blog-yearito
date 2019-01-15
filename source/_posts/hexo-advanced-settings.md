---
title: Hexo搭建个人博客系列：进阶设置篇
date: 2018-11-20 20:09:54
copyright: true
reward: true
rating: true
related_posts: true
tags: Hexo
categories:
- 技术
- 博客
---

![题图](http://yearito-1256884783.image.myqcloud.com/thumbnails/snow-mountain.jpg!thumbnail "Photo by Przemyslaw Kruk")

本篇文章介绍了如何为Hexo博客集成更多强大的功能。

第一章介绍了在站点中集成基于三方插件的数据统计服务，包括站点PV和PU统计、站点运行时间统计、文章PV统计、站点和文章字数统计等。

第二张介绍了针对于站点的个性化设置方案，包括添加搞怪的网页标题，添加站内搜索功能，添加热门文章排行榜页面，添加豆瓣阅读/电影/游戏等资料页面，添加在线聊天和即时反馈等功能。

第三章介绍了针对于文章页面的个性化设置方案，包括在文章末尾添加评论组件、评分组件、打赏入口、版权声明、推荐文章等，为文章中的图片添加点击灯箱效果，以及为文章设置访问密码。

<!-- more -->

# 数据统计

## 站点访问量统计

该功能由 [不蒜子](http://ibruce.info/2015/04/04/busuanzi/) 提供，效果如下图：

![站点访问统计](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/busuanzi-site-footer.png "站点访问统计")

左侧数据表示独立访客数UV，右侧数据表示网站浏览量PV，访客数和浏览量的区别在于一个用户连续点击n篇文章，会记录n次浏览量，但只记录一次访客数。

{% note %}
由于不蒜子是基于域名来进行统计计算的，所以通过 localhost:4000 端口访问的时候统计数据PV和UV都会异常的大，属于正常现象。
{% endnote %}

在页脚布局模板文件首行添加如下代码：

``` html themes\next\layout\_partial\footer.swig
<script async src="https://dn-lbstatics.qbox.me/busuanzi/2.3/busuanzi.pure.mini.js"></script>
```

在主题配置文件中做出如下修改：

``` yaml themes\next\_config.yml
busuanzi_count:
  enable: true
  total_visitors: true   # 访客数
  total_visitors_icon: user
  total_views: true   # 访问量
  total_views_icon: eye
  post_views: false
  post_views_icon: eye
```

刷新浏览器即可生效。

高阶用法：通过修改代码来自定义统计文案，如果你想使用本站统计文案，需要对不蒜子的代码做出如下修改：

``` diff themes\next\layout\_third-party\analytics\busuanzi-counter.swig
  {% if theme.busuanzi_count.total_visitors %}
-   <span class="site-uv" title="{{ __('footer.total_visitors') }}">
+   <span class="site-uv">
+     {{ __('footer.total_visitors', '<span class="busuanzi-value" id="busuanzi_value_site_uv"></span>') }}
-     <i class="fa fa-{{ theme.busuanzi_count.total_visitors_icon }}"></i>
-     <span class="busuanzi-value" id="busuanzi_value_site_uv"></span>
    </span>
  {% endif %}

  {% if theme.busuanzi_count.total_views %}
-   <span class="site-pv" title="{{ __('footer.total_views') }}">
+   <span class="site-pv">
+     {{ __('footer.total_views', '<span class="busuanzi-value" id="busuanzi_value_site_pv"></span>') }}
-     <i class="fa fa-{{ theme.busuanzi_count.total_views_icon }}"></i>
-     <span class="busuanzi-value" id="busuanzi_value_site_pv"></span>
    </span>
  {% endif %}
```

在自定义样式文件中添加如下样式：

``` css themes/next/source/css/_custom/custom.styl
//修改不蒜子数据颜色
.busuanzi-value {
  color: #1890ff;
}
```

然后修改统计表述文案：

``` yaml themes\next\languages\zh-CN.yml
footer:
  total_views: "历经 %s 次回眸才与你相遇"
  total_visitors: "我的第 %s 位朋友，"
```

## 站点运行时间统计

{% note info %}
本章节受 [reuixiy | 打造个性超赞博客Hexo+NexT+GitHubPages的超深度优化 #5.7](https://reuixiy.github.io/technology/computer/computer-aided-art/2017/06/09/hexo-next-optimization.html) 启发，自行重构了代码逻辑。
{% endnote %}

在站点底部显示站点已运行时间，效果如下：

![站点运行时间](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/site-running-time.png "站点运行时间")

在主题自定义布局文件中添加以下代码：

``` html thems\next\layout\_custom\custom.swig
{# 页脚站点运行时间统计 #}
{% if theme.footer.ages.enable %}
  <script src="https://cdn.jsdelivr.net/npm/moment@2.22.2/moment.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/moment-precise-range-plugin@1.3.0/moment-precise-range.min.js"></script>
  <script>
    function timer() {
      var ages = moment.preciseDiff(moment(),moment({{ theme.footer.ages.birthday }},"YYYYMMDD"));
      ages = ages.replace(/years?/, "年");
      ages = ages.replace(/months?/, "月");
      ages = ages.replace(/days?/, "天");
      ages = ages.replace(/hours?/, "小时");
      ages = ages.replace(/minutes?/, "分");
      ages = ages.replace(/seconds?/, "秒");
      ages = ages.replace(/\d+/g, '<span style="color:{{ theme.footer.ages.color }}">$&</span>');
      div.innerHTML = `{{ __('footer.age')}} ${ages}`;
    }
    var div = document.createElement("div");
    //插入到copyright之后
    var copyright = document.querySelector(".copyright");
    document.querySelector(".footer-inner").insertBefore(div, copyright.nextSibling);
    timer();
    setInterval("timer()",1000)
  </script>
{% endif %}
```

如果 custom.swig 文件不存在，需要手动新建并在布局页面中 body 末尾引入：

``` diff themes\next\layout\_layout.swig
      ...
      {% include '_third-party/exturl.swig' %}
      {% include '_third-party/bookmark.swig' %}
      {% include '_third-party/copy-code.swig' %}

+     {% include '_custom/custom.swig' %}
    </body>
  </html>
```

修改主题配置文件：

``` diff themes\next\_config.yml
  footer:
    ...
+   ages:
+     # site running time
+     enable: true
+     # birthday of your site
+     birthday: 20181001
+     # color of number
+     color: "#1890ff"
```

然后补全对应文案：

``` diff themes\next\languages\zh-CN.yml
  footer:
    powered: "由 %s 强力驱动"
    theme: 主题
+   age: 我已在此等候你
    total_views: "历经 %s 次回眸才与你相遇"
    total_visitors: "我的第 %s 位朋友，"
```

刷新浏览器即可生效。

{% note info %}
日期统计计算功能由 [moment](https://momentjs.com/) 和 [moment-precise-range](https://github.com/codebox/moment-precise-range) 提供，也可用原生JS Date对象来实现。
{% endnote %}

## 文章访问量统计

{% note info %}
本章节参考 [夏末 | 为NexT主题添加文章阅读量统计功能](https://notes.doublemine.me/2015-10-21-%E4%B8%BANexT%E4%B8%BB%E9%A2%98%E6%B7%BB%E5%8A%A0%E6%96%87%E7%AB%A0%E9%98%85%E8%AF%BB%E9%87%8F%E7%BB%9F%E8%AE%A1%E5%8A%9F%E8%83%BD.html#%E9%85%8D%E7%BD%AELeanCloud)
{% endnote %}

该功能基于 [LeanCloud](https://leancloud.cn) 提供后端数据服务，效果如下：

![文章访问量](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/post-pageviews.png "文章访问量")

在LeanCloud上注册账号并创建应用，新建一个名为 Counter 的Class，ACL权限设置为 **无限制**：

![新建Counter类](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/LeanCloud-Counter-class.png "新建Counter类")

{% note info %}
在LeanCloud中的Class可以理解为数据库中的数据表。Counter用于存储记录文章访问量，记录是以url作为唯一依据的，所以根据默认的permalink组成结构，如果你更改了文章的发布日期和标题中的任意一个，都会造成文章阅读数值的清零重计。
{% endnote %}

在控制台的 **设置** -> **应用Key** 中获取App ID和App Key填入到主题配置文件中：

``` yaml themes\next\_config.yml
leancloud_visitors:
  enable: true
  app_id: ***<app_id***
  app_key: ***<app_key>***
  security: false
  betterPerformance: false
```

站点上线后可以在 **设置** -> **安全中心** 中添加博客域名到 Web 安全域名中，设置后仅可在该域名下通过 JavaScript SDK 调用服务器资源，借以保护LeanCloud应用的数据安全。

如果想要自定义PV表述文案，可以修改文章布局模板中的相关代码：

``` diff themes\next\layout\_macro\post.swig
  {# LeanCould PageView #}
    ...
    {% if theme.post_meta.item_text %}
-     <span class="post-meta-item-text">{{__('post.views') + __('symbol.colon') }}</span>
+     <span class="post-meta-item-text">{{__('post.views')}} </span>
    {% endif %}
    <span class="leancloud-visitors-count"></span>
+   <span>℃</span>
    ...
```

修改统计表述文案：

``` yaml themes/next/languages/zh-CN.yml
post:
  views: 热度
```

刷新浏览器即可生效。

如果遇到如下报错，可能是你配置了 `security: true` 但又没有做好安全策略配置。

> 阅读次数： Counter not initialized! See more at console err msg.

有以下两种解决方案：

- 下载安装 [hexo-leancloud-counter-security](https://github.com/theme-next/hexo-leancloud-counter-security) 插件
- 在主题配置中设置 `security: false`

个人推荐第二种，简单粗暴。

除了LeanCloud，不蒜子也能提供文章阅读次数统计，但是不蒜子的统计结果只会在文章页显示，而不会显示在首页列表中，相关讨论可以参见 [阅读计数。对比LeanCloud和不蒜子](https://github.com/iissnan/hexo-theme-next/issues/801)

## 站点及文章字数统计

该功能由 [hexo-symbols-count-time](https://github.com/theme-next/hexo-symbols-count-time) 提供，效果如下图：

![站点字数统计](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/site-word-count.png "站点字数统计")

![文章字数统计](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/post-word-count.png "文章字数统计")

在根目录下执行如下命令安装相关依赖

```
$ npm install hexo-symbols-count-time --save
```

启用该功能需要同时修改站点配置文件和主题配置文件。

将如下配置项添加到**站点配置文件**中，这些配置项主要用于控制每项统计信息是否显示。

``` yaml _config.yml
symbols_count_time:
  symbols: true   # 统计单篇文章字数
  time: false   # 取消估算单篇文章阅读时间
  total_symbols: true  # 统计站点总字数
  total_time: false  # 取消估算站点总阅读时间
```

在**主题配置文件**中做如下修改，这些配置项主要用于控制统计信息的显示样式。

``` yaml themes\next\_config.yml
symbols_count_time:
  separated_meta: false  # 统计信息不换行显示
  item_text_post: true  # 文章统计信息中是否显示“本文字数/阅读时长”等描述文字
  item_text_total: true   # 站点统计信息中是否显示“本文字数/阅读时长”等描述文字
  awl: 4  # Average Word Length：平均字符长度
  wpm: 275  # Words Per Minute：阅读速度
```

汉字的平均字符长度为1.5，如果在文章中使用纯中文进行写作（没有混杂英文），那么推荐设置 `awl: 2` 及 `wpm: 300`，但是如果文章中存在英文，建议设置 `awl: 4` 及 `wpm: 275`。

因为修改了站点配置文件，所以需要重新启动服务器才能生效。

# 站点个性化设置

## 搞怪网页标题

{% note info %}
本章节参考 [DIYgod | 我藏好了哦](https://diygod.me/2153/)
{% endnote %}

离开和进入页面时动态修改Tab标签中的标题。

![搞怪网页标题](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/title-trick.png "搞怪网页标题")

在主题自定义布局文件中添加以下代码：

``` html themes\next\layout\_custom\custom.swig
{# 搞怪网页标题 #}
{% if theme.title_trick.enable %}
  <script>
    var OriginTitile = document.title;
    var titleTime;
    document.addEventListener('visibilitychange', function() {
      if (document.hidden) {
        document.title = '{{ theme.title_trick.leave }}' + OriginTitile;
        clearTimeout(titleTime);
      } else {
        document.title = '{{ theme.title_trick.enter }}' + OriginTitile;
        titleTime = setTimeout(function() {
          document.title = OriginTitile;
        }, 2000);
      }
    });
  </script>
{% endif %}
```

如果 custom.swig 文件不存在，需要手动新建并在布局页面中 body 末尾引入：

``` diff themes\next\layout\_layout.swig
      ...
      {% include '_third-party/exturl.swig' %}
      {% include '_third-party/bookmark.swig' %}
      {% include '_third-party/copy-code.swig' %}

+     {% include '_custom/custom.swig' %}
    </body>
  </html>
```

在主题配置文件中添加以下代码：

``` yaml themes\next\_config.yml
# a trick on website title
title_trick:
  enable: true
  leave: "(つェ⊂)我藏好了哦~"
  enter: "(*´∇｀*) 被你发现啦~"
```

## 站内搜索

该功能由 [hexo-generator-searchdb](https://github.com/theme-next/hexo-generator-searchdb) 提供，效果如下图：

![站内搜索](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/local-search.png "站内搜索")

在根目录下执行以下命令安装相关依赖：

```
$ npm install hexo-generator-searchdb --save
```

在**主题配置**文件中修改相关字段：

``` yaml themes\next\_config.yml
local_search:
  enable: true
  trigger: auto  # 每次输入改变都执行搜索
  top_n_per_article: 3  # 每篇文章显示的搜索结果数量
  unescape: false
```

在**站点配置**文件中添加以下字段：

``` yaml _config.yml
search:
  path: search.xml
  field: post  # 指定搜索范围，可选 post | page | all
  format: html  # 指定页面内容形式，可选 html | raw (Markdown) | excerpt | more
  limit: 10000
```

在自定义样式文件中添加如下样式规则来增加搜索弹窗的页边距：

``` css themes\next\source\css\_custom\custom.styl
//增加搜索弹窗的页边距
.local-search-popup #local-search-result {
  padding: 25px 40px
  height: calc(100% - 95px)
}
```

如果你同时在站点内启用了 wobblewindow 边缘摆动效果，则有可能会出现背景蒙版叠加在弹窗之前的问题，这种层级叠加异常的问题主要是因为 wobblewindow 中修改了弹窗父元素的 `position` 定位和 `z-index` 优先级，目前只能通过修改 localsearch 源码来修复该Bug：

``` diff themes\next\layout\_third-party\search\localsearch.swig
  $.ajax({
    url: path,
    dataType: isXml ? "xml" : "json",
    async: true,
    success: function(res) {
      // get the contents from search data
      isfetched = true;
-     $('.popup').detach().appendTo('.header-inner');
+     $('.popup').detach().appendTo('body');
      var datas = isXml ? $("entry", res).map(function() {
        return {
          title: $("title", this).text(),
          content: $("content",this).text(),
          url: $("url" , this).text()
        };
      }).get() : res;
      ...
```

## 热门文章排行榜

{% note info %}
本章节部分思路参考 [nMask | Hexo搭建博客教程 #7.16](https://thief.one/2017/03/03/Hexo%E6%90%AD%E5%BB%BA%E5%8D%9A%E5%AE%A2%E6%95%99%E7%A8%8B/)，自行进行了代码重构。
{% endnote %}

添加文章阅读次数排行统计页面，效果如下图：

![热门文章排行榜](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/top10.png "热门文章排行榜")

该功能同样是基于LeanCloud提供的后端服务支持。具体实现方案如下：

在站点目录下执行以下命令新建页面

```
$ hexo new page top
```

在主题配置文件中新增一项菜单入口：

``` diff themes\next\_config.yml
  menu:
    home: / || home
+   top: /top/ || signal
    tags: /tags/ || tags
    categories: /categories/ || th
    archives: /archives/ || archive
    about: /about/ || user
```

在语言包中新增菜单中文：

``` diff themes\next\languages\zh-CN.yml
  menu:
    home: 首页
    archives: 归档
    categories: 分类
    tags: 标签
    about: 关于
+   top: 排行榜
```

然后在新增的排行榜页面内添加以下内容：

``` html source\top\index.md
---
title: 热门文章Top 10
comments: false
date: 2018-10-30 00:54:50
---

<div id="post-rank"></div>

<script src="//cdn.jsdelivr.net/npm/leancloud-storage@3.10.0/dist/av-min.js"></script>
<script>
  var APP_ID = ******;  //输入个人LeanCloud账号AppID
  var APP_KEY = ******;  //输入个人LeanCloud账号AppKey
  AV.init({
    appId: APP_ID,
    appKey: APP_KEY
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
```

本是根据 [nMask | Hexo搭建博客教程 #7.16](https://thief.one/2017/03/03/Hexo%E6%90%AD%E5%BB%BA%E5%8D%9A%E5%AE%A2%E6%95%99%E7%A8%8B/) 引入v0.6.1的脚本来实现该功能，结果发现出现如下Bug：

![LeanCloud v0.6.1 Bug](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/LeanCloud-bug.png "LeanCloud v0.6.1 Bug")

后来根据 [LeanCloud | JavaScript SDK 安装指南](https://leancloud.cn/docs/leanstorage_guide-js.html) 引入v3.10.0的最新脚本，使用过程中虽然功能正常，但是控制台有报错信息:

>  Uncaught TypeError: Cannot redefine property: applicationId

## 豆瓣阅读/电影/游戏

{% note info %}
本章节参考 [mythsman/hexo-douban README.md](https://github.com/mythsman/hexo-douban)
{% endnote %}

为站点添加豆瓣阅读/电影/游戏页面，效果如下：

![豆瓣电影](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/douban-movies.png "豆瓣电影")

在根目录下执行以下命令安装相关依赖：

```
$ npm install hexo-douban --save
```

在站点配置文件中添加以下内容：

``` yaml _config.yml
douban:
  user:  # 个人豆瓣ID
  builtin: false
  book:
    title: 'This is my book title'
    quote: 'This is my book quote'
  movie:
    title: 'This is my movie title'
    quote: 'This is my movie quote'
  game:
    title: 'This is my game title'
    quote: 'This is my game quote'
  timeout: 10000
```

- user: 填写豆瓣ID。登陆豆瓣后点击**个人主页**，此时url中最后一段即是用户ID，一般情况下会是一段数字，如果设置了个人域名的话，则个人域名即为ID。
- builtin: 是否将生成页面的功能嵌入 `hexo s` 和 `hexo g` 中。
- timeout: 爬取数据的超时时间。

如果只想生成某一个页面（比如只生成读书页面），把其他的配置项注释掉即可。

在主题配置文件中新增菜单入口：

``` diff themes\next\_config.yml
  menu:
    home: / || home
    tags: /tags/ || tags
    categories: /categories/ || th
    archives: /archives/ || tasks
+   books: /books/ || book  
+   movies: /movies/ || video-camera  
+   games: /games/ || gamepad
```

在语言包中新增菜单中文：

``` diff themes\next\language\zh_CN.yml
  menu:
    home: 首页
    archives: 归档
    categories: 分类
    tags: 标签
+   movies: 电影
+   books: 读书
+   games: 游戏
```

然后在根目录下执行以下命令生成豆瓣阅读/电影/游戏页面：

```
$ hexo douban
```

可选参数:

- -b | \--books: 只生成豆瓣读书页面
- -m | \--movies:  只生成豆瓣电影页面
- -g | \--games: 只生成豆瓣游戏页面

执行命令后，插件会根据用户提供的ID爬取豆瓣中的数据信息并在 `public` 目录下生成对应的页面，当服务器启动或部署后会将页面显示在对应的菜单路由下。

如果在站点配置中设置了 `douban.builtin: false`，则每次豆瓣数据变动后需要手动执行一次 `hexo douban` 来刷新页面数据。如果设置了 `douban.builtin: true`，则每次执行 `hexo s` 和 `hexo g` 的时候将会自动同时执行 `hexo douban` 命令，但这样可能会增加打包编译的时间。建议如果豆瓣数据变动不频繁的情况下该项设为 `false` 即可。

通常大家都喜欢用 `hexo d` 来作为 `hexo deploy` 命令的简化，但是当安装了 `hexo douban` 之后， `hexo d` 就会有歧义而无法执行，因为 `hexo douban` 跟 `hexo deploy` 的Alias都是 `hexo d`。

## 在线聊天

在线聊天算是一个比较成熟的SaaS商业应用了，业内产品如 [Tidio](https://www.tidiochat.com/)、 [TalkJS](https://talkjs.com/)、[Intercom](https://www.intercom.com/)、[tawk.to](https://www.tawk.to/) 等，使用体验都很好，交互界面也很干净别致。经过比较，本站最终选择了 Tidio：

- 在个人博客这种业务场景中，几乎用不到它的收费功能，可以算是终身免费了。
- Tidio提供了多种消息回复渠道，包括网页、桌面应用、iOS/Android APP（需要Google play服务支持）。
- 除了在线聊天，Tidio还可以在线发送邮件，以及关联接收Fackbook消息。
- 在几款产品的界面风格中，还是 Tidio 看起来更加优雅一些，深得我爱。

![Tidio 界面](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/Tidio.png "Tidio 界面")

首先需要[注册Tidio账号](https://www.tidiochat.com/panel/login)，根据引导填写应用信息。进入控制台后，在 **SETTINGS** -> **Developer** -> **Project data** 中获取到Public Key：

![Tidio Public Key](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/tidio-public-key.png "Tidio Public Key")

在主题配置文件下添加以下代码并补全Public Key：

``` yaml themes\next\_config.yml
# Tidio online chat
# see: https://www.tidiochat.com
tidio:
  enable: true
  key:  # Public_Key
```

在主题自定义布局文件中添加以下代码：

``` html themes\next\layout\_custom\custom.swig
{# Tidio 在线联系功能 #}
{% if theme.tidio.enable %}
  <script async src="//code.tidio.co/{{ theme.tidio.key }}.js"></script>
{% endif %}
```

为避免代码加载阻塞页面渲染，需要为脚本添加 `async` 属性使其异步加载。

如果 custom.swig 文件不存在，需要手动新建并在布局页面中 body 末尾引入：

``` diff themes\next\layout\_layout.swig
      ...
      {% include '_third-party/exturl.swig' %}
      {% include '_third-party/bookmark.swig' %}
      {% include '_third-party/copy-code.swig' %}

+     {% include '_custom/custom.swig' %}
    </body>
  </html>
```

刷新页面即可在右下角看到Tidio的会话标志了。接下来可以在Tidio控制台的 **Channel** -> **Live chat** ->  **Appearance** 中根据提示定制聊天对话框的主题外观和语言包：

![定制Tidio样式与功能](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/Tidio-appearance.png "定制Tidio样式与功能")

## 行为监测与反馈

[Hotjar](https://www.hotjar.com/) 是一款轻量级的监测分析工具，能够提供用户行为监测和用户反馈分析，相比Google Analysis而言，它没有复杂的监测指标与分析报表，更加的简单实用，并且为免费用户提供2000pv/day的数据采集服务，适用于小型网站或个人博客的监测分析。

Hotjar主要提供**ANALYTICS**和**FEEDBACK**两大类服务。

ANALYTICS主要用于用户交互行为的监测分析，属于客观分析，包括以下四项具体功能：

- Heatmaps: 通过热力图可视化用户的鼠标交互行为，帮助理解用户动机和需求。
- Recording: 记录用户在站点的行为轨迹，了解应用的可用性以及用户遭遇的问题。
- Funnels: 记录每个页面或者步骤的用户流失率。
- Forms: 记录表单中每一项输入的完成率，完成时间以及用户流失率。

FEEDBACK主要为用户提供反馈渠道，收集用户观点与数据，属于主观分析，包括以下四项具体功能：

- Incoming: 即时反馈，了解用户对页面的评价。
- Polls: 投票反馈，获取某个问题的用户答案。
- Surveys: 问卷调查，以问卷形式获取用户反馈。
- Recruiters: 获取用户信息，招募用户用于用户调查或测试反馈。

Hotjar通过以上八项具体而实用的功能为用户提供主客观相结合的监测分析服务，可以说它是所有轻量级分析工具中唯一做到了主客观相结合的，同时也是所有主客观分析工具中，做的最轻量的。

{% note info %}
更多功能介绍请参考 [Hotjar Features](https://www.hotjar.com/tour)
{% endnote %}

本站点中应用了Incoming即时反馈功能，读者可以通过该渠道评价页面或者提交勘误，点击悬挂在屏幕右侧的Feedback按钮弹出对话框，点击人物头像评价后将会跳转到如下界面：

![Hotjar Incoming Feedback](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/hotjar-feedback.png "Hotjar Incoming Feedback")

你可以在此页面输入反馈内容，并通过点击左下角的按钮在当前页面上标识目标元素，之后 hotjar 会将反馈内容连同带有高亮标识的页面截图一起提交到后台：

![Incoming Feedback with screenshot ](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/hotjar-feedback-screenshot.png "Incoming Feedback with screenshot")

{% note info %}
更多关于 Incoming Feedback 的介绍请参考 [Incoming Feedback by Hotjar](https://www.hotjar.com/incoming-feedback)
{% endnote %}

在站点中集成Hotjar的各项功能，需要先 [注册 Hotjar 账号](https://insights.hotjar.com/register)，根据指引一步步填写站点信息，然后在控制面板首页中获取site ID：

![Hotjar site ID](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/hotjar-site-id.png "Hotjar site ID")

在主题配置文件下添加以下代码并补全site ID：

``` yaml themes\next\_config.yml
# Hotjar
# see: https://www.hotjar.com/
hotjar:
  enable: true
  siteID:  # site ID
```

在主题自定义布局文件中添加以下代码：

``` html themes\next\layout\_custom\custom.swig
{# hotjar 页面反馈 #}
{% if theme.hotjar.enable %}
  <script>
    (function(h,o,t,j,a,r){
      h.hj=h.hj||function(){(h.hj.q=h.hj.q||[]).push(arguments)};
      h._hjSettings={hjid:{{ theme.hotjar.siteID }},hjsv:6};
      a=o.getElementsByTagName('head')[0];
      r=o.createElement('script');r.async=1;
      r.src=t+h._hjSettings.hjid+j+h._hjSettings.hjsv;
      a.appendChild(r);
    })(window,document,'https://static.hotjar.com/c/hotjar-','.js?sv=');
  </script>
{% endif %}
```

如果 custom.swig 文件不存在，需要手动新建并在布局页面中 body 末尾引入：

``` diff themes\next\layout\_layout.swig
      ...
      {% include '_third-party/exturl.swig' %}
      {% include '_third-party/bookmark.swig' %}
      {% include '_third-party/copy-code.swig' %}

+     {% include '_custom/custom.swig' %}
    </body>
  </html>
```

如此即可将 Hotjar 嵌入到站内，接下来在 Hotjar 控制台菜单中点击 Incoming，然后根据引导一步步配置即时反馈服务即可：

![配置 Incoming Feedback](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/hotjar-setup-incoming.png "配置 Incoming Feedback")

{% note info %}
如果你在本站内发现了错别字、病句、失效链接、代码缩进不一致，可以通过页面右侧的Feedback反馈。
{% endnote%}

# 文章页面个性化设置

## 添加评论功能

Next支持多款评论系统：

- [Disqus](https://disqus.com/)：欧美UI风格，支持Tweet、Facebook等国外社交软件的三方登陆和一键分享。 [Demo](https://blog.disqus.com/disqus-welcomes-the-spruce)
- [gitment](https://github.com/imsun/gitment)：必须用github账号登陆才能评论，支持Markdown语法，与github issues页面风格一致 [Demo](https://imsun.github.io/gitment/)
- [Valine](https://valine.js.org/)：支持匿名评论，支持Markdown语法，界面简洁美观
- [畅言](http://changyan.kuaizhan.com/)：国产评论系统，可区分热评和最新评论，论坛贴吧风
- [来必力](https://www.livere.com/)：支持插入图片和GIF，支持国内外多种社交媒体的三方登陆 [Demo](https://www.livere.com/city-demo)

博客的评论系统不需要太过复杂的功能，我的要求是一定要轻量级，足够简洁美观，并且支持Markdown语法，因此我首选Valine和gitment，这两个评论系统都是由国内个人开发的，在此向开发者致敬。

![Valine 评论系统](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/valine-comments.png "Valine 评论系统")

Next已经内置了Valine组件，在主题配置文件中开启评论功能即可，同时，由于Valine是基于Leancloud提供后端服务的，所以需要填写LeanCloud的App ID和App Key。

``` yaml themes\next\_config.yml
valine:
  enable: true
  appid:  ***<app_id***
  appkey: ***<app_key>***
  notify: false  # 收到新评论是否邮件通知
  verify: false  # 是否开启验证码
  placeholder:  # 默认填充文字
  avatar: mm  # 设置默认评论列表
  guest_info: nick,mail  # 评论区头部表单
  pageSize: 10  # 每页评论数
  visitor: true  # 同时开启文章阅读次数统计
```

Valine也附带了阅读统计功能，可以在Valine配置项中设置 `visitor: true` 开启该功能。为避免后端服务冲突，建议不要同时启用Valine的阅读统计功能和 `leancloud_visitors`。

{% note info %}
关于如何在收到评论时发送邮件提醒请参照 [赵俊 | Hexo 优化 --- Valine 扩展之邮件通知](http://www.zhaojun.im/hexo-valine-admin/)
{% endnote %}

Next暂时不支持通过配置的方式隐藏文章标题下的评论数量，如要隐藏，可在自定义样式文件中添加如下代码：

``` css themes/next/source/css/_custom/custom.styl
//屏蔽标题下的评论数量
.post-comments-count {
  display: none;
}
```

如果你是轻度洁癖患者，想要隐藏评论区的浏览器和操作系统版本号以拥有更加干净的评论界面，可在自定义样式文件中添加如下代码：

``` css themes/next/source/css/_custom/custom.styl
//屏蔽评论组件的多余信息
#comments .vsys {
  display: none;
}
```

## 文末版权声明

![文章版权声明](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/post-copyright.png "文章版权声明")

在主题配置文件中开启文章底部的版权声明，版权声明默认使用 [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) 许可协议，用户可以根据自身需要修改 `licence` 字段变更协议。

``` yaml themes\next\_config.yml
post_copyright:
  enable: true
  license: <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/" rel="external nofollow" target="_blank">CC BY-NC-SA 4.0</a>
```

默认版权声明中只有 **本文作者**、**本文链接**、**版权声明** 三项，如果你想添加更多内容，如 **创建时间**、**修改时间**、**引用链接** 等，需要修改版权声明的相关代码：

``` html themes\next\layout\_macro\post-copyright.swig
<!-- JS库 clipboard 拷贝内容到粘贴板-->
<script src="https://cdn.bootcss.com/clipboard.js/2.0.1/clipboard.min.js"></script>

<!-- JS库 sweetalert 显示提示信息-->
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

<ul class="post-copyright">

  <!-- 本文标题 -->
  <li>
    <strong>{{ __('post.copyright.title') + __('symbol.colon') }} </strong>
    {{ post.title }}
  </li>

  <!-- 本文作者 -->
  <li class="post-copyright-author">
    <strong>{{ __('post.copyright.author') + __('symbol.colon') }} </strong>
    {{ post.author | default(author) }}
  </li>

  <!-- 创建时间 -->
  <li>
    <strong>{{ __('post.created') + __('symbol.colon') }} </strong>
    {{ post.date.format("YYYY年MM月DD日 - HH时MM分") }}
  </li>

  <!-- 修改时间 -->
  <li>
    <strong>{{ __('post.modified') + __('symbol.colon') }} </strong>
    {{ post.updated.format("YYYY年MM月DD日 - HH时MM分") }}
  </li>

  <!-- 引用链接 -->
  <li class="post-copyright-link">
    <strong>{{ __('post.copyright.link') + __('symbol.colon') }}</strong>
    <a href="{{ post.url | default(post.permalink) }}" title="{{ post.title }}">{{ post.url | default(post.permalink) }}</a>
    <span class="copy-path"  title="点击复制引用链接"><i style="cursor: pointer" class="fa fa-clipboard" data-clipboard-text="[{{ post.author | default(author) }}'s Blog | {{ post.title }}]({{ post.permalink }})"  aria-label="{{ __('post.copy_success') }}"></i></span>
  </li>

  <!-- 版权声明 -->
  <li class="post-copyright-license">
    <strong>{{ __('post.copyright.license_title') + __('symbol.colon') }} </strong>
    {{ __('post.copyright.license_content', theme.post_copyright.license) }}
  </li>
</ul>

<script>
  var clipboard = new ClipboardJS('.fa-clipboard');
  clipboard.on('success', function(target){
    var message = document.createElement('div');
    message.innerHTML = '<i class="fa fa-check-circle message-icon"></i><span class="message-content">' + target.trigger.getAttribute('aria-label') + '</span>';
    swal({
      content: message,
      className: "copy-success-message",
      timer: 1000,
      button: false
    });
  });
</script>
```

在版权样式文件中添加如下样式：

``` css themes\next\source\css\_common\components\post\post-copyright.styl
.swal-overlay {
  background-color: transparent;
}

.copy-success-message {
  box-shadow: 0px 4px 12px rgba(0,0,0,0.15);
  border-radius: 4px;
  width: auto;  
  margin: 16x 0px;
  vertical-align: top;
}

.copy-success-message .swal-content {
  margin: 0px 0px !important;
  padding: 10px 16px;  
  line-height: 1em;
}

.copy-success-message .message-icon {
  color: #52c41a;
  margin-right: 8px;
}

.copy-success-message .message-content {
  font-size: 14px;
}
```

然后补全版权信息文案字段：

``` yaml themes/next/languages/zh-CN.yml
post:
  created: 创建时间
  modified: 修改时间
  copy_success: 复制成功  
  copyright:
    title: 本文标题
    author: 本文作者
    link: 引用链接
    license_title: 版权声明
    license_content: "本博客所有文章除特别声明外，均采用 %s 许可协议。转载请注明出处！"
```

{% note info %}
点击引用链接后的图标 <i class="fa fa-clipboard"></i> 即可快捷复制Markdown引用链接，并将弹出复制成功的提示语。该功能主要借助 [clipboard](https://clipboardjs.com/) 和 [sweetalert](https://sweetalert.js.org/) 两个js库来实现，并参考 [antDesign | message组件](https://ant.design/components/message/) 重写了弹框样式。
{% endnote %}


在实际使用过程中，并非每篇文章都需要版权声明，如果转载了别人的文章，文末再出现个人版权声明就不太合适。此时可在Front-Matter中设定变量 `copyright` 用于控制是否显示版权信息。修改文章布局模板中相关代码，使得只有当主题配置文件中 `post_copyright.enable` 字段和 `page.copyright` 字段同时为 `true` 时才会插入版权声明：

``` diff themes/next/layout/_macro/post.swig
- {% if theme.post_copyright.enable and not is_index %}
+ {% if theme.post_copyright.enable and page.copyright and not is_index %}
    <div>
      {% include 'post-copyright.swig' with { post: post } %}
    </div>
  {% endif %}
```

为了批量为每篇新文章设定该变量并赋默认值，可以修改草稿模板内容，这样以来每篇草稿发布为正文后都会默认显示底部版权信息：

``` diff scaffolds\draft.md
  title: {{ title }}
  tags:
  categories:
+ copyright: true
```

## 添加打赏功能

![文章打赏功能](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/post-reward.png "文章打赏功能")

启用主题配置文件中的打赏相关字段，并将个人收款码图片置于 themes\\next\\source\\images\\ 目录下，注意保持图片命名与配置文件中一致：

``` yaml themes\next\_config.yml
reward_comment:
wechatpay: /images/wechatpay.png
alipay: /images/alipay.jpg
```

如果要关闭悬停收款码上的文字抖动效果，可以在自定义样式文件中添加以下代码：

``` css themes/next/source/css/_custom/custom.styl
//关闭打赏收款码的文字抖动效果
#QR > div:hover p {
  animation: none;
}
```

并非每个页面都需要开启打赏功能，可以在 Front-Matter 中添加 `reward` 字段来控制是否在本文章中添加打赏信息，然后修改文章布局模板中相关的判定条件：

``` diff themes/next/layout/_macro/post.swig
- {% if (theme.alipay or theme.wechatpay or theme.bitcoin) and not is_index %}
+ {% if ( post.reward and (theme.alipay or theme.wechatpay or theme.bitcoin) and not is_index %}
    <div>
      {% include 'reward.swig' %}
    </div>
  {% endif %}
```

为了方便可在草稿模板 scaffolds\\draft.md 中统一添加 `reward` 字段默认值：

``` diff scaffolds\draft.md
  title: {{ title }}
  tags:
  categories:
+ reward: true
```

## 添加图片灯箱

添加灯箱功能，实现点击图片后放大聚焦图片，并支持幻灯片播放、全屏播放、缩略图、快速分享到社交媒体等，该功能由 [fancyBox](https://github.com/fancyapps/fancybox) 提供，效果如下：

![fancyBox 灯箱](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/fancybox.png "fancyBox 灯箱")


在根目录下执行以下命令安装相关依赖：

```
$ git clone https://github.com/theme-next/theme-next-fancybox3 themes/next/source/lib/fancybox
```

在主题配置文件中设置 `fancybox: true`：

``` yaml themes\next\_config.yml
fancybox: true
```

刷新浏览器即可生效。

## 相关文章推荐

该功能由 [hexo-related-popular-posts](https://github.com/tea3/hexo-related-popular-posts) 插件提供，效果如下：

![相关文章推荐](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/related-post.png "相关文章推荐")

在站点根目录中执行以下命令安装依赖：

```
$ npm install hexo-related-popular-posts --save
```

在主题配置文件中开启相关文章推荐功能：

``` yaml themes\next\_config.yml
related_posts:
  enable: true
  title:  # custom header, leave empty to use the default one
  display_in_home: false
  params:
    maxCount: 5
```

此时会在每篇文章结尾根据标签相关性和内容相关性来推荐相关文章。

事实上并非每篇文章都需要开启该功能，可在文章 Front-Matter 中设置 `related_posts` 字段来控制是否在文末显示相关文章，然后修改文章布局模板中相关的判定条件：

``` diff themes/next/layout/_macro/post.swig
- {% if theme.related_posts.enable and (theme.related_posts.display_in_home or not is_index) %}
+ {% if theme.related_posts.enable and (theme.related_posts.display_in_home or not is_index) and post.related_posts %}
    {% include 'post-related.swig' with { post: post } %}
  {% endif %}
```

为了方便可在草稿模板 scaffolds\\draft.md 中统一添加 `related_posts` 字段默认值：

``` diff scaffolds\draft.md
  title: {{ title }}
  tags:
  categories:
+ related_posts: true
```

## 文章评分

[widgetpack](https://widgetpack.com) 是一款轻量级的插件，提供四项具体的功能：

- Comments: 评论系统，类似于留言板
- Reviews: 评价系统，类似于商品评价
- Rating: 星级评分系统
- Google Reviews: 关联展示Google Rating

Next主题中已经集成了 widgetpack 的星级评分系统，用户无须再安装或引入插件脚本，只需在 widgetpack 中注册账号并修改主题配置即可，应用效果如下：

![文章评分组件](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/rating.png "文章评分组件")

在 [widgetpack](https://widgetpack.com) 中注册账号，根据引导填写应用名称和域名创建应用，创建后可在页面左上角看到应用id。

在主题配置文件中开启评分功能，填写应用id，并设置评分颜色：

``` yaml themes\next\_config.yml
# Star rating support to each article.
# To get your ID visit https://widgetpack.com
rating:
  enable: true
  id:     #<app_id>
  color:  fadb14
```

此时刷新浏览器即可在文章末尾看到空的评分栏了。点击评分发现需要以社交账号登陆，而这些社交账号基本都是facebook、twitter等墙外的社交软件，限制了评分系统可用性，我们可以在 widgetpack 控制台中修改评分认证机制。

在控制台中点击左上角展开菜单，在 **Rating** -> **Setting** 中将 Vote via 选项改为 Device(cookie) 以开启匿名评分，该选项将基于设备认证访问者身份：

![开启匿名评分](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/rate-vote-via.png "开启匿名评分")

用户还可以在该页面设定 star 数量和大小。修改后记得勾选右下角的SAVE SETTING才会生效。

在实际使用过程中，并非每篇文章都需要开启评分。此时可在 Front-Matter 中设定变量 rating 用于控制是否开启评分。修改文章布局模板中相关代码，使得只有当主题配置文件中 `rating.enable` 字段和 `page.rating` 字段同时为 `true` 才会插入评分组件：

``` diff themes\next\layout\_macro\post.swig
  {% if not is_index %}
-  {% if theme.rating.enable or (theme.vkontakte_api.enable and theme.vkontakte_api.like) or (theme.facebook_sdk.enable and theme.facebook_sdk.like_button) or (theme.needmoreshare2.enable and theme.needmoreshare2.postbottom.enable) or (theme.baidushare and theme.baidushare.type === "button" )%}
+  {% if (theme.rating.enable and post.rating) or (theme.vkontakte_api.enable and theme.vkontakte_api.like) or (theme.facebook_sdk.enable and theme.facebook_sdk.like_button) or (theme.needmoreshare2.enable and theme.needmoreshare2.postbottom.enable) or (theme.baidushare and theme.baidushare.type === "button" )%}
    <div class="post-widgets">
    {% if theme.rating.enable %}
      <div class="wp_rating">
        <div id="wpac-rating"></div>
      </div>
    {% endif %}
```

为了批量为每篇新文章设定该变量并赋默认值，可以修改草稿模板内容，这样以来每篇草稿发布后都会默认开启评分：

``` diff scaffolds\draft.md
  title: {{ title }}
  tags:
  categories:
+ rating: true
```

站点上线后，可以在控制台菜单的 **Site** -> **Setting** 中勾选 Private，使得组件只对应用内指定的域名上生效，这样以来即时别人错填了你的id也不会将评分数据误提交到你的应用中了。

{% note info %}
widgetpack 与前文提到的 hotjar 在评价反馈功能上的侧重点不一样，widgetpack 更侧重于对文章的评分，而hotjar侧重于对整个页面的评分，并提供了文字和截图反馈的渠道。
{% endnote %}

## 文章加密访问

该功能由 [hexo-blog-encrypt](https://github.com/MikeCoder/hexo-blog-encrypt) 插件提供，效果如下：

![文章加密](http://yearito-1256884783.image.myqcloud.com/hexo-advanced-settings/post-encrypt.png "文章加密")

在站点根目录中执行以下命令安装依赖：

```
$ npm install hexo-blog-encrypt --save
```

在站点配置文件中添加如下字段：

``` yaml _config.yml
encrypt:
  enable: true
  default_abstract: 此文章已被加密，需要输入密码访问。  //首页文章列表中加密文章的默认描述文案
  default_message: 请输入密码以阅读这篇私密文章。  //文章详情页的密码输入框上的默认描述文案
```

重启服务器，这个时候可能需要经历较长一段时间的加密过程，请耐心等待，加密完成后刷新页面将会显示密码输入框，输入密码后才能继续访问文章内容。

{% note info %}
该功能只会加密文章正文，其他内容如打赏、版权信息、标签等则不会被加密隐藏，这样看起来有点奇怪，所以建议加密文章隐藏掉打赏和版权信息内容。
{% endnote %}

密码输入错误时将会显示浏览器默认告警弹窗，可以使用 [sweetalert](https://sweetalert.js.org/) 来美化错误提示：

在主题自定义布局文件中添加如下代码：

``` html themes\next\layout\_custom\custom.swig
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
```

如果 custom.swig 文件不存在，需要手动新建并在布局页面中 body 末尾引入：

``` diff themes\next\layout\_layout.swig
      ...
      {% include '_third-party/exturl.swig' %}
      {% include '_third-party/bookmark.swig' %}
      {% include '_third-party/copy-code.swig' %}

+     {% include '_custom/custom.swig' %}
    </body>
  </html>
```

在 node_modules 依赖库中修改 hexo-blog-encrypt 源码：

``` diff node_modules\hexo-blog-encrypt\lib\blog.encrypt.js
  ...
  } catch (e) {
-   alert(decryptionError);
+   swal({   
+     text: "密码错误!",
+     icon: "error",
+     className: "password-error",
+     timer: 1000,  
+     button: false
+   });
    console.log(e);
  }
  ...
```

在自定义样式文件中添加如下代码：

``` css themes/next/source/css/_custom/custom.styl
//密码错误sweetalert弹框样式修改
.swal-overlay {
  background-color: transparent;
}

.password-error {
  box-shadow: 0px 4px 12px rgba(0,0,0,0.15);
  border-radius: 4px;
}
```

{% note warning %}
由于是在node_module中修改的依赖文件，一旦更新或者重装依赖都会覆盖修改，需要重新修改一遍。
{% endnote %}

# 结束语

在集成第三方插件或者自定义新功能的过程中我一直试图秉持这些原则：

- 可以在站点配置/主题配置文件中方便快捷的开启/关闭插件服务
- 可以在语言包 zh-CN.yml 中快速修改页面中的自定义文案，而不是在代码中将文字表述写死
- 尽量在自定义样式文件 custom.styl 和自定义布局文件 custom.swig 中添加代码，而非修改主题源码
- 新增文件统一放在 \_custom 目录下

所有以上这些原则，尽管实现起来可能更复杂，需要更多的代码，但都是为了让站点更好维护，更灵活方便。

本文介绍了如何通过修改自定义设置和集成三方插件服务搭建一个功能更加完善的个性化Hexo博客，尽管我们的博客可能已经做的令自己很满意了，但至今仍是只能在本地访问，别人看不到。我们建立博客往往都是希望能将自己的文章分享给他人来创造更多价值，如果想要了解如何将站点部署到公网，请参考本系列中最后一篇文章：{% post_link hexo-deploy-to-VPS %}。

<div class="reference-linking">参考链接</div>

- [reuixiy | 打造个性超赞博客Hexo+NexT+GitHubPages的超深度优化](https://reuixiy.github.io/technology/computer/computer-aided-art/2017/06/09/hexo-next-optimization.html)
- [夏末 | 为NexT主题添加文章阅读量统计功能](https://notes.doublemine.me/2015-10-21-%E4%B8%BANexT%E4%B8%BB%E9%A2%98%E6%B7%BB%E5%8A%A0%E6%96%87%E7%AB%A0%E9%98%85%E8%AF%BB%E9%87%8F%E7%BB%9F%E8%AE%A1%E5%8A%9F%E8%83%BD.html#%E9%85%8D%E7%BD%AELeanCloud)
- [nMask | Hexo搭建博客教程](https://thief.one/2017/03/03/Hexo%E6%90%AD%E5%BB%BA%E5%8D%9A%E5%AE%A2%E6%95%99%E7%A8%8B/)
- [LeanCloud | JavaScript SDK 安装指南](https://leancloud.cn/docs/leanstorage_guide-js.html)
- [DIYgod | 我藏好了哦](https://diygod.me/2153/)
- [mythsman/hexo-douban README.md](https://github.com/mythsman/hexo-douban)
- [asdfv1929 | Hexo NexT主题内接入网页在线联系功能](https://asdfv1929.github.io/2018/01/21/daovoice/)
- [Hotjar Features](https://www.hotjar.com/tour)
- [Incoming Feedback by Hotjar](https://www.hotjar.com/incoming-feedback)
