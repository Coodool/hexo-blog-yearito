---
title: Hexo搭建个人博客系列：主题美化篇
date: 2018-11-20 20:09:53
copyright: true
reward: true
rating: true
related_posts: true
tags: Hexo
categories:
- 技术
- 博客
---

![题图](http://yearito-1256884783.image.myqcloud.com/thumbnails/coast.jpg!thumbnail "Photo by Marina Weishaupt")

本文介绍了在Next主题的基础上进一步对博客进行美化的方案，主要包括:

- 在文章末尾添加结束标记
- 修改侧边栏的位置到左边
- 添加不同类型的动态背景效果
- 添加 live2d 看板娘
- 为布局元素添加边缘弹性摆动效果
- 个性化回到顶部按钮
- 添加不同类型的鼠标点击特效
- 评论区输入打字礼花特效

读者可以根据需要选择其中喜欢的方案应用到站点博客中。

<!-- more -->

# 修改博客字体

在 [Google Fonts](https://www.google.com/fonts) 上找到心仪的字体，然后在主题配置文件中为不同的应用场景配置字体：

``` yaml themes\next\_config.yml
font:
  enable: true

  # 外链字体库地址，例如 //fonts.googleapis.com (默认值)
  host:

  # 全局字体，应用在 body 元素上
  global:
    external: true
    family: Monda

  # 标题字体 (h1, h2, h3, h4, h5, h6)
  headings:
    external: true
    family: Roboto Slab

  # 文章字体
  posts:
    external: true
    family:

  # Logo 字体
  logo:
    external: true
    family:

  # 代码字体，应用于 code 以及代码块
  codes:
    external: true
    family:
```

# 文章页末美化

## 为标签添加图标

默认情况下标签前缀是 `#` 字符，用户可以通过修改主题源码将标签的字符前缀改为图标前缀，更改后效果如下：

![标签图标前缀](http://yearito-1256884783.image.myqcloud.com/hexo-theme-beautify/20181113045027074.png "标签图标前缀")

在文章布局模板中找到文末标签相关代码段，将 `#` 换成 `<i class="fa fa-tags"></i>` 即可：

``` diff themes\next\layout\_macro\post.swig
  <footer class="post-footer">
    {% if post.tags and post.tags.length and not is_index %}
      <div class="post-tags">
        {% for tag in post.tags %}
-          <a href="{{ url_for(tag.path) }}" rel="tag"># {{ tag.name }}</a>
+          <a href="{{ url_for(tag.path) }}" rel="tag"><i class="fa fa-tags"></i> {{ tag.name }}</a>
        {% endfor %}
      </div>
    {% endif %}
    ...
  </footer>
```

Next中使用 [FontAwesome](https://fontawesome.com/v4.7.0/icons/) 作为图标库，用户可以在 FontAwesome 上找到心仪的图标来替换标签的字符前缀。

## 添加结束标记

{% note info %}
本章节参考 [asdfv1929 | Hexo NexT主题内给每篇文章后添加结束标语](https://asdfv1929.github.io/2018/01/28/add-the-end/)
{% endnote %}

在文末添加结束标记，效果如下：

![文末结束标记](http://yearito-1256884783.image.myqcloud.com/hexo-theme-beautify/20181113045252399.png "文末结束标记")

新建布局模板文件 post-end-tag.swig，添加如下代码：

``` html themes\next\layout\_macro\post-end-tag.swig
<div>
  {% if not is_index %}
    <div style="text-align:center;color:#bfbfbf;font-size:16px;">
      <span>-------- 本文结束 </span>
      <i class="fa fa-{{ config.post_end_tag.icon }}"></i>
      <span> 感谢阅读 --------</span>
    </div>
  {% endif %}
</div>
```

在文章布局模板中添加如下代码：

``` diff themes\next\layout\_macro\post
{#####################}
{### END POST BODY ###}
{#####################}

+ {% if config.post_end_tag.enabled and not is_index %}
+   <div>
+     {% include 'post-end-tag.swig' %}
+   </div>
+ {% endif %}

{% if theme.wechat_subscriber.enabled and not is_index %}
  <div>
    {% include 'wechat-subscriber.swig' %}
  </div>
{% endif %}
```

在站点配置文件末尾添加如下代码：

``` yaml _config.yml
post_end_tag:
  enabled: true  # 是否开启文末的本文结束标记
  icon: paw # 结束标记之间的图标
```

重启服务器后即可在文末看到结束标记。

# 页面加载进度条

当网络不好的时候可能会在打开站点或跳转文章时出现短暂的白屏，此时如果能有加载进度提示将会提高用户操作体验。

在根目录下执行以下命令安装相关依赖：

```
$ git clone https://github.com/theme-next/theme-next-pace themes/next/source/lib/fancybox
```

在主题配置文件中设置 `pace: true`。

默认提供了多种主题的进度条加载样式，有顶部提示的，有中间提示的，还有全页面遮挡提示的，个人认为默认的进度条效果就恰如其当，既能够在页面空白的时候起到加载作用，也不会因为太过花里胡哨而喧宾夺主，尤其是当你如果使用了不蒜子的站点访问统计的功能的时候，常常会遇到所有资源都加载完毕而不蒜子还在等待响应，如果这个时候在页面较显眼的位置出现一个停滞不前的进度条，很让人抓狂。

# 侧边栏放左边

受 [猪猪侠的博客](https://www.ofind.cn/) 所启发，萌生了想把主题侧边栏放在左侧的想法。

Next主题各系列中只有Pisces和Gemini支持通过主题配置文件来将侧边栏置于左侧或右侧，而Muse和Mist则需要深度修改源码才能实现改变侧边栏位置。

在自定义样式文件中添加如下规则：

``` css themes\next\source\css\_custom\custom.styl
.sidebar-toggle {
  left: 30px;
}

.sidebar {
  left: 0px;
}
```

修改动效脚本代码：

``` diff themes\next\source\js\src\motion.js
$(document)
  .on('sidebar.isShowing', function() {
    NexT.utils.isDesktop() && $('body').velocity('stop').velocity(
-     {paddingRight: SIDEBAR_WIDTH},
+     {paddingLeft: SIDEBAR_WIDTH},
      SIDEBAR_DISPLAY_DURATION
    );
  })
  .on('sidebar.isHiding', function() {
  });
  ...
  hideSidebar: function() {
-   NexT.utils.isDesktop() && $('body').velocity('stop').velocity({paddingRight: 0});
+   NexT.utils.isDesktop() && $('body').velocity('stop').velocity({paddingLeft: 0});
    this.sidebarEl.find('.motion-element').velocity('stop').css('display', 'none');
    this.sidebarEl.velocity('stop').velocity({width: 0}, {display: 'none'});

    sidebarToggleLines.init();
    ...
}
```

如此以来就可以将侧边栏放置在左边了，但当窗口宽度缩小到991px之后会出现样式错误：侧边栏收缩消失但是页面左侧仍留有空白间距，此时修改如下代码即可：

``` diff themes\next\source\css\_common\scaffolding\base.styl
body {
  position: relative; // Required by scrollspy
  font-family: $font-family-base;
  font-size: $font-size-base;
  line-height: $line-height-base;
  color: $text-color;
  background: $body-bg-color;

- +mobile() { padding-left: 0 !important; }
- +tablet() { padding-left: 0 !important; }  
+ +mobile() { padding-right: 0 !important; }
+ +tablet() { padding-right: 0 !important; }
  +desktop-large() { font-size: $font-size-large; }
}
```

# 添加动态背景

Next主题可以通过安装插件快速为站点添加不同效果的动态背景。

## 粒子漂浮聚合

应用效果如下图：

![canvas-nest 动态背景](http://yearito-1256884783.image.myqcloud.com/hexo-theme-beautify/20181115092103046.png "canvas-nest 动态背景")

该功能由 [theme-next-canvas-nest](https://github.com/theme-next/theme-next-canvas-nest) 插件提供，在根目录下执行如下命令：

```
$ git clone https://github.com/theme-next/theme-next-canvas-nest themes/next/source/lib/canvas-nest
```

然后在主题配置文件中设置 `canvas_nest: true` 即可。

Next v6.5.0 及以上版本支持更多的自定义选项：

``` yaml themes\next\_config.yml
canvas_nest:
  enable: true
  onmobile: true # 是否在移动端显示
  color: '0,0,255' # 动态背景中线条的 RGB 颜色
  opacity: 0.5 # 动态背景中线条透明度
  zIndex: -1 # 动态背景的 z-index 属性值
  count: 99 # 动态背景中线条数量
```

## Three 三维动效

[theme-next-three](https://github.com/theme-next/theme-next-three) 插件提供了三个类型的背景动效，应用效果如下：

{% tabs Three 三维动效 %}
  <!-- tab three-waves -->
    ![](http://yearito-1256884783.image.myqcloud.com/hexo-theme-beautify/20181115091950761.png "")
  <!-- endtab -->
  <!-- tab canvas-lines -->
    ![](http://yearito-1256884783.image.myqcloud.com/hexo-theme-beautify/20181115091914602.png "")
  <!-- endtab -->
  <!-- tab canvas-sphere -->
    ![](http://yearito-1256884783.image.myqcloud.com/hexo-theme-beautify/20181115091826700.png "")
  <!-- endtab -->
{% endtabs %}

在根目录下执行如下命令安装相关依赖：

```
$ git clone https://github.com/theme-next/theme-next-three themes/next/source/lib/three
```

然后在主题配置文件中设置开启对应的动效选项即可。

``` yaml themes\next\_config.yml
# JavaScript 3D library.
# Dependencies: https://github.com/theme-next/theme-next-three
# three_waves
three_waves: true
# canvas_lines
canvas_lines: false
# canvas_sphere
canvas_sphere: false
```

{% note info %}
个人认为在站点中添加动态背景并没有实际的意义，只会凭空增加页面内存占用及CPU消耗，所以本站没有添加任何动态背景。
{% endnote %}

## 随机三角丝带

![随机三角丝带](http://yearito-1256884783.image.myqcloud.com/hexo-theme-beautify/evan-you.png "随机三角丝带")

{% note info %}
该功能由 Vue 作者 [尤雨溪](http://evanyou.me/) 首创。本章节中核心代码来源于 [DIYgod](https://diygod.me/) 编写的 [sagiri](
https://github.com/DIYgod/hexo-theme-sagiri) 主题。
{% endnote %}

点击下方按钮下载相应的脚本，并置于 themes\\next\\source\\js\\ 目录下：

<p>
{% btn https://script-1256884783.file.myqcloud.com/evan-you.js, 随机三角丝带, download fa-fw%}
</p>

在主题自定义布局文件中添加以下代码：

``` html themes\next\layout\_custom\custom.swig
{# 随机三角丝带背景 #}
{% if theme.evanyou %}
  <canvas id="evanyou"></canvas>
  <style>
    #evanyou {
      position: fixed;
      width: 100%;
      height: 100%;
      top: 0;
      left: 0;
      z-index: -1;
    }
  </style>
  <script src="/js/evan-you.js"></script>
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
# colorful trilateral riband background
evanyou: true
```

如果从本地加载JS脚本速度较慢，可以考虑将脚本放到CDN上再引入。

# 添加看板娘

{% note info %}
本章节部分内容参考 [FJKang | 添加一个萌物](https://fjkang.github.io/2017/12/08/%E6%B7%BB%E5%8A%A0%E4%B8%80%E4%B8%AA%E8%90%8C%E7%89%A9/)
{% endnote %}

该功能由 [hexo-helper-live2d](https://github.com/EYHN/hexo-helper-live2d) 插件支持，效果如下图：

![live2d 看板娘](http://yearito-1256884783.image.myqcloud.com/hexo-theme-beautify/live2d.gif "live2d 看板娘")

在站点根目录下执行以下命令安装依赖：

```
$ npm install --save hexo-helper-live2d
```

在站点配置文件中添加以下下配置项

``` yaml _config.yml
# Live2D
# https://github.com/EYHN/hexo-helper-live2d
live2d:
  enable: true
  pluginRootPath: live2dw/
  pluginJsPath: lib/
  pluginModelPath: assets/ Relative)

  # 脚本加载源
  scriptFrom: local # 默认从本地加载脚本
  # scriptFrom: jsdelivr # 从 jsdelivr CDN 加载脚本
  # scriptFrom: unpkg # 从 unpkg CDN 加载脚本
  # scriptFrom: https://cdn.jsdelivr.net/npm/live2d-widget@3.x/lib/L2Dwidget.min.js # 从自定义地址加载脚本
  tagMode: false # 只在有 {{ live2d() }} 标签的页面上加载 / 在所有页面上加载
  log: false # 是否在控制台打印日志

  # 选择看板娘模型
  model:
    use: live2d-widget-model-shizuku  # npm package的名字
    # use: wanko # /live2d_models/ 目录下的模型文件夹名称
    # use: ./wives/wanko # 站点根目录下的模型文件夹名称
    # use: https://cdn.jsdelivr.net/npm/live2d-widget-model-wanko@1.0.5/assets/wanko.model.json # 自定义网络数据源
  display:
    position: left # 显示在左边还是右边
    width: 100 # 宽度
    height: 180 # 高度
  mobile:
    show: false
  react:
    opacityDefault: 0.7 # 默认透明度
```

{% note info %}
更多配置参数请查看 [L2Dwidget | live2d-widget.js](https://l2dwidget.js.org/docs/class/src/index.js~L2Dwidget.html#instance-method-init)
{% endnote %}

此时重启服务器暂时还看不到看板娘，需要手动下载或安装模型资源。可以从 [hexo live2d 模型预览](https://huaji8.top/post/live2d-plugin-2.0/) 里找到你喜欢的角色，然后根据 [live2d-widget-models](https://github.com/xiazeyu/live2d-widget-models) 中提供的方法来下载模型数据.

例如通过以下命令下载模型 shizuku：

```
$ npm install live2d-widget-model-shizuku
```

因为修改了站点配置文件，所以需要重启服务器才能预览模型效果。

如果设置了 `live2d.tagMode: true`，则可以在指定页面中插入以下标签：

``` yaml
{{ live2d() }}
```

只有拥有该标签的页面才会渲染live2d模型，这样以来就可以精确控制在哪些页面上显示看板娘了。

如果只想在一级菜单页面上显示看板娘，可以在Header模板中添加以下代码：

``` diff themes\next\layout\_partials\header\index.swig
+ {% if is_index %}
+   {{ live2d() }}
+ {% endif %}
```

{% note info %}
个人认为在文章内出现看板娘将会影响读者注意力的集中，毕竟一篇博客里最重要的是内容，而不是这些花里胡哨转移注意力的东西。所以本站只在一级菜单页面添加了看板娘，文章页面则保持极致精简的阅读体验。
{% endnote %}

经过测试发现 `live2d.mobile.show: false` 并没有生效，暂时没有找到好的解决方法，参考 [EYHN/hexo-helper-live2d Issues #12](https://github.com/EYHN/hexo-helper-live2d/issues/12) 后发现可以在自定义样式文件中添加以下代码来解决：

``` css themes/next/source/css/_custom/custom.styl
#live2dcanvas {
  +mobile() {
    display: none;
  }
  +tablet() {
    display: none;
  }
}
```

{% note info %}
不要乱点不该点的地方，会生气的。
{% endnote %}

# 边缘摆动效果

![wobblewindow 边缘摆动](http://yearito-1256884783.image.myqcloud.com/hexo-theme-beautify/wobblewindow.gif "wobblewindow 边缘摆动")

在 [猪猪侠的博客](https://www.ofind.cn/) 里发现的这种特效，觉得挺有意思的，就从他Github上给扒过来了

点击下方按钮下载脚本，并置于 themes\\next\\source\\js\\ 目录下：

<p>
{% btn https://script-1256884783.file.myqcloud.com/wobblewindow.js, wobblewindow.js, download fa-fw%}
</p>

在主题自定义布局文件中添加以下代码：

``` html themes\next\layout\_script\custom.swig
{# wobble窗口摆动特效 #}
{% if theme.wobble %}
  <script src="/js/wobblewindow"></script>
  <script>
    //只在桌面版网页启用特效
    if( window.innerWidth > 768  ){
      $(document).ready(function () {
        {% if theme.wobble.header %}
          $('#header').wobbleWindow({
            radius: {{ theme.wobble.radius }},
            movementTop: false,
            movementLeft: false,
            movementRight: false,
            debug: false,
          });
        {% endif %}

        {% if theme.wobble.sidebar %}
          $('#sidebar').wobbleWindow({
            radius: {{ theme.wobble.radius }},
            movementLeft: false,
            movementTop: false,
            movementBottom: false,
            position: 'fixed',
            debug: false,
          });
        {% endif %}

        {% if theme.wobble.footer %}
          $('#footer').wobbleWindow({
            radius: {{ theme.wobble.radius }},
            movementBottom: false,
            movementLeft: false,
            movementRight: false,
            offsetX: {{ theme.wobble.offset }},
            position: 'absolute',
            debug: false,
          });
        {% endif %}
      });
    }
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

在自定义样式文件中添加以下样式：

``` css themes\next\source\css\_custom\custom.styl
//窗口波动效果相关样式
if hexo-config('wobble')  {
  .sidebar {
    box-shadow: none;
  }

  .wobbleTransparentBK{
    background-color: rgba(0,0,0,0) !important;
  }

  .wobbleTransparentLine{
    border-color: rgba(0,0,0,0) !important;
  }

  //Next.Muse中为Header和Footer添加背景色
  #header, #footer {
    background-color: rgb(245, 245, 245);
  }

  //防止sidebar和footer同时开启动效时堆叠异常
  #sidebar, header {
    z-index: 1 !important;
  }

  //防止挡住页末文章的阅读全文按钮
  .main {
    padding-bottom: 200px;
  }
}
```

{% note warning %}
Next.Muse主题方案中Header和Footer是没有背景色的，所以需要添加背景色后才能看出边缘摆动效果。另外，实现边缘摆动效果所需的 `z-index` 属性可能会导致元素堆叠异常，需要添加以上样式来矫正。
{% endnote %}

在主题配置文件中添加以下代码：

``` yaml themes\next\_config.yml
# window woblle
wobble:
  enable: true  # 是否开启边缘波动效果
  radius: 50  # 波动半径
  sidebar: true  # 开启侧边栏边缘摆动
  header: true  # 开启头部边缘摆动
  footer: true  # 开启脚部边缘摆动
```

用户可以根据需要在配置文件中为选择开启边缘摆动效果的布局元素。刷新浏览器，然后将鼠标移动到布局边缘上尽情的挑逗它吧。

如果从本地加载JS脚本速度较慢，可以考虑将脚本放到CDN上再引入。

# 个性化回到顶部

从 [DIYgod的博客](https://diygod.me/) 里扒来的，效果如下：

![回到顶部](http://yearito-1256884783.image.myqcloud.com/hexo-theme-beautify/back-to-top.gif "回到顶部")

原理很简单，将 back-to-top 按钮添加图片背景，并添加CSS3动效即可。

首先，找到自己喜欢的图片素材放到 source\\images\\ 目录下。

你可以点击下方按钮下载本站所使用的小猫上吊素材（
小猫咪这么可爱，当然要多放点孜然啦...）

<a class="btn" href="/images/scroll.png" download>
  <i class="fa fa-download fa-fw"></i>
  下载图片
</a>

然后在自定义样式文件中添加如下代码：

``` css themes\next\source\css\_custom\custom.styl
//自定义回到顶部样式
.back-to-top {
  right: 60px;
  width: 70px;  //图片素材宽度
  height: 900px;  //图片素材高度
  top: -900px;
  bottom: unset;
  transition: all .5s ease-in-out;
  background: url("/images/scroll.png");

  //隐藏箭头图标
  > i {
    display: none;
  }

  &.back-to-top-on {
    bottom: unset;
    top: 100vh < (900px + 200px) ? calc( 100vh - 900px - 200px ) : 0px;
  }
}
```

刷新浏览器即可预览效果。

# 鼠标点击特效

从各个站点里搜罗了以下四个比较常用的鼠标点击特效：

{% tabs 鼠标点击特效 %}
  <!-- tab 礼花特效 -->
    ![](http://yearito-1256884783.image.myqcloud.com/hexo-theme-beautify/cursor-fireworks.gif)
  <!-- endtab -->
  <!-- tab 爆炸特效 -->
    ![](http://yearito-1256884783.image.myqcloud.com/hexo-theme-beautify/cursor-explosion.gif)
  <!-- endtab -->
  <!-- tab 浮出爱心 -->
    ![](http://yearito-1256884783.image.myqcloud.com/hexo-theme-beautify/cursor-love.gif)
  <!-- endtab -->
  <!-- tab 浮出文字 -->
    ![](http://yearito-1256884783.image.myqcloud.com/hexo-theme-beautify/cursor-text.gif)
  <!-- endtab -->
{% endtabs %}

点击下方按钮下载相应的脚本，并置于 themes\\next\\source\\js\\cursor\\ 目录下：

<p>
{% btn https://script-1256884783.file.myqcloud.com/cursor/fireworks.js, 礼花特效, download fa-fw%}
{% btn https://script-1256884783.file.myqcloud.com/cursor/explosion.min.js, 爆炸特效, download fa-fw%}
{% btn https://script-1256884783.file.myqcloud.com/cursor/love.min.js, 浮出爱心, download fa-fw%}
{% btn https://script-1256884783.file.myqcloud.com/cursor/text.js, 浮出文字, download fa-fw%}
</p>

在主题自定义布局文件中添加以下代码：

``` html themes\next\layout\_custom\custom.swig
{# 鼠标点击特效 #}
{% if theme.cursor_effect == "fireworks" %}
  <script async src="js/cursor/fireworks.js"></script>
{% elseif theme.cursor_effect == "explosion" %}
  <canvas class="fireworks" style="position: fixed;left: 0;top: 0;z-index: 1; pointer-events: none;" ></canvas>
  <script src="//cdn.bootcss.com/animejs/2.2.0/anime.min.js"></script>
  <script async src="js/cursor/explosion.min.js"></script>
{% elseif theme.cursor_effect == "love" %}
  <script async src="js/cursor/love.min.js"></script>
{% elseif theme.cursor_effect == "text" %}
  <script async src="js/cursor/text.js"></script>
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
# mouse click effect: fireworks | explosion | love | text
cursor_effect: fireworks
```

这样即可在配置文件中一键快速切换鼠标点击特效。

如果从本地加载JS脚本速度较慢，可以考虑将脚本放到CDN上再引入。

# 打字特效

{% note info %}
本章节参考 [千灵夙赋 | Hexo 优化汇总 #31](https://qianling.pw/hexo-optimization/)，原文出自 [龙笑天下 | 给 WordPress 博客网站添加评论输入打字礼花及震动特效](https://www.ilxtx.com/comment-input-effects.html)
{% endnote %}

![打字特效](http://yearito-1256884783.image.myqcloud.com/hexo-theme-beautify/typing-effect.gif "打字特效")

点击下方按钮下载相应的脚本，并置于 themes\\next\\source\\js\\ 目录下：

<p>
{% btn https://script-1256884783.file.myqcloud.com/activate-power-mode.min.js, 打字特效, download fa-fw%}
</p>

在主题自定义布局文件中添加以下代码：

``` html themes\next\layout\_custom\custom.swig
{# 打字特效 #}
{% if theme.typing_effect %}
  <script src="/js/activate-power-mode.min.js"></script>
  <script>
    POWERMODE.colorful = {{ theme.typing_effect.colorful }};
    POWERMODE.shake = {{ theme.typing_effect.shake }};
    document.body.addEventListener('input', POWERMODE);
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
# typing effect
typing_effect:
  colorful: true  # 礼花特效
  shake: false  # 震动特效
```

如果从本地加载JS脚本速度较慢，可以考虑将脚本放到CDN上再引入。

# 结束语

本文记录了本站在Next的基础上的进阶美化方案，除了一些简单的样式修改外，还添加了一些由插件支持的高级动效，包括动态背景、看板娘、边缘摆动、鼠标点击和打字特效等。笔者认为，动效可以使得站点变有趣，但同时也会增加网页的资源消耗，以及影响用户的关注点，有时候会喧宾夺主适得其反，建议珍爱PC资源，合理使用动效。

本文内容仅涉及到主题美化，也就是说仅使得网页看起来更好看或者更炫酷，但并没有使其功能上变得更强大。如果你希望为站点集成更高级的功能，可以关注本系列的后续文章：

- 想要深度定制个性化站点，请参考本系列中的 {% post_link hexo-advanced-settings %}。
- 想要了解如何将站点部署到公网，请参考本系列中的 {% post_link hexo-deploy-to-VPS %}

<div class="reference-linking">参考链接</div>

- [asdfv1929 | Hexo NexT主题内给每篇文章后添加结束标语](https://asdfv1929.github.io/2018/01/28/add-the-end/)
- [FJKang | 添加一个萌物](https://fjkang.github.io/2017/12/08/%E6%B7%BB%E5%8A%A0%E4%B8%80%E4%B8%AA%E8%90%8C%E7%89%A9/)
- [尤雨溪的个人主页](http://evanyou.me/)
- [DIYgod的博客](https://diygod.me/)
- [猪猪侠的博客](https://www.ofind.cn/)
- [千灵夙赋 | Hexo 优化汇总](https://qianling.pw/hexo-optimization/)
- [龙笑天下 | 给 WordPress 博客网站添加评论输入打字礼花及震动特效](https://www.ilxtx.com/comment-input-effects.html)
