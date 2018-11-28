---
title: Hexo搭建个人博客系列：写作技巧篇
date: 2018-11-20 20:09:52
copyright: true
reward: true
rating: true
related_posts: true
tags: Hexo
categories:
- 技术
- 博客
---

![题图](http://yearito-1256884783.image.myqcloud.com/thumbnails/mist.jpg!thumbnail "Photo by Henri Prestes")

本文介绍Hexo博客的写作技巧。

第一章中介绍了Hexo中写作相关的基本概念，包括三种基本布局，标签与分类，Markdown写作语法。

第二章中介绍了Hexo中常用的内置标签，包括note标签、label标签、button标签、tab标签以及代码块的高级用法，通过使用写作标签可以快速编写样式丰富的文档片段。

第三章中介绍了在文档中插入图片、音乐、视频等多媒体元素的方案。

第四章中根据个人使用经验为大家推荐了几款优雅实用的Markdown写作工具。

<!-- more -->

# 开始写作

在博客目录下执行如下命令新建一篇文章

```
$ hexo new [layout] <title>
```

如果未指定文章的布局（layout），则默认使用 `post` 布局，生成的文档存放于 `source\_posts\` 目录下，打开后使用Markdown语法进行写作，保存后刷新浏览器即可看到文章。

## 布局

布局是什么概念呢，你可以理解为新建文档时的一个模板，基于布局生成的文档将会继承布局的样式。

Hexo默认有三种布局：`post`、 `page` 和 `draft`，用户可以在 `scaffolds` 目录下新建文档来自定义布局格式，还可以修改站点配置文件中的 `default_layout`参数来指定生成文档时的默认布局。

### 文章（post）

基于 `post` 布局生成的文档存在于 `source\_posts\` 目录下，该目录下的文档会作为博客正文显示在网站中。

### 页面（page）

`page` 布局用于生成类似 **首页** 和 **归档** 这样的页面。默认的Next主题样式中只包含首页和归档这两个链接，可以通过修改主题配置文件中的 `menu` 字段来新增更多页面菜单。

``` diff themes\next\_config.yml
menu:
  home: / || home
  about: /about/ || user
+ tags: /tags/ || tags
+ categories: /categories/ || th
+ archives: /archives/ || archive
```

其中，`||` 之前的值表示菜单链接，之后的值表示所用的 `FontAwesome` 图标名称。

刷新页面后即可看到页面内多了几项菜单。

![新增菜单入口](http://yearito-1256884783.image.myqcloud.com/hexo-writing-skills/20181103115805642.png "新增菜单入口")

此时点击 **关于**、**标签** 和 **分类** 都会跳转到404页面，原因是我们只开放了页面入口，却没有创造对应于链接的页面视图，此时就需要通过 `hexo new page <title>` 命令来新建页面。

基于 `page` 布局的新建命令将会在 `source` 目录下新建一个 `<title>` 文件夹，并在该文件夹下创建一个 `index.md` 文件，编辑该文件即可修改页面内容。

例如，通过 `hexo new page tags` 命令将会生成如下目录。

```
.
└──  source             
  ├── _posts          
  └── tags
    └── index.md
```

编辑 `index.md` 文件，在Front-Matter中添加 `type: tags` ，Next主题将自动在该页面内显示标签云。

``` diff source\tags\index.md
  title: 标签
  date: 2018-10-19 22:57:00
+ type: tags
```

{% note info %}
Front-Matter是文件最上方以 `---` 分隔的区域，用于指定本文件的各种参数值
{% endnote %}

在菜单中点击 **标签** 跳转到刚创建的标签页面。

![Hexo 标签页面](http://yearito-1256884783.image.myqcloud.com/hexo-writing-skills/20181104120213426.png "Hexo 标签页面")

同理可通过 `page` 布局生成 **关于** 和 **分类** 两个页面。

### 草稿（draft）

`draft` 布局用于创建草稿，生成的文档存在于 source\\\_drafts\\ 目录中，默认配置下将不会把该目录下的文档渲染到网站中。

通过以下命令将草稿发布为正式文章：

```
$ hexo publish <title>
```

该命令会将 source\\\_drafts\\ 目录下以 <title> 开头的草稿发布到 sources\\\_posts\\ 目录下。另外，`hexo publish *` 会将最新创建的一篇草稿发布为正式文章，并以Front-Matter中的title作为文件名称。

考虑到一些文章可能需要数天才能完成，建议将新建文档时的默认布局设置为 `draft`：

``` diff _config.yml
- default_layout: post
+ default_layout: draft
```

## 标签与分类

我们刚提到了标签，也提到了分类，那么标签和分类是什么，其区别是什么。

标签和分类都是用于对文章进行归档的一种方式，标签是一种列表结构，而分类是一种树结构。我们以人作为例子，从标签的角度考虑，我可以拥有程序员、高颜值、幽默等标签，这些标签之间没有层级关系；从分类的角度考虑，我是亚洲人、中国人、河南人，这些分类之间是有明确的包含关系的。

可以在Front-Matter中添加 `catergories` 和 `tags` 字段为文章添加标签和分类，如我为本文添加了 **Hexo** 和 **Markdown** 两个标签，并将其归类到了 **技术/博客** 类别，对应的Front-Matter结构如下：

```
title: Hexo搭建个人博客系列：写作技巧篇
tags: Hexo Markdown
categories:
- 技术
- 博客
```

## Markdown基本语法

Markdown是一种标记语言，语法简单，易阅读易编写，可以让用户完全脱离鼠标写出样式丰富的文档，广受程序员喜爱，目前许多网站都已经支持通过Markdown语法来写文章或者发表评论。

| 元素     | Markdown语法                              | 效果预览                                               |
| -------- | ----------------------------------------- | ------------------------------------------------------ |
| 标题     | `# 标题1`<br>`## h2`<br>`### h3`          | <div style="font-weight: bold"><div style="font-size: 24px">标题一</div><div style="font-size: 22px">标题二</div><div style="font-size: 20px">标题三</div></div>  |
| 加粗     | `**文字加粗**`                            | **文字加粗**                                           |
| 引用     | `> 引用文字`                              | <blockquote>引用文字</blockquote>                      |
| 有序列表 | `1. 第一项`<br>`2. 第二项`<br>`3. 第三项` | <ol><li>第一项</li><li>第二项</li><li>第三项</li></ol> |
| 无序列表 | `- 第一项`<br>`- 第二项`<br>`- 第三项`    | <ul><li>第一项</li><li>第二项</li><li>第三项</li></ul> |
| 链接     | `[链接](url)`         | [链接](url)                        |
| 图片     | `![图片](image.jpg)`                      |          <i class="fa fa-image"></i>                                             |
| 水平线   | `---`                                     | <hr>                                                   |
| 代码     | <code>\`code\`</code>                     | `code`                                                 |
| 代码块     | <code>\`\`\`code snippet\`\`\`</code>                     |              <figure class="highlight"><table><tbody><tr><td class="code"><pre>code snippet</pre></td></tr></tbody></table></figure>                                   |

{% note info %}
更多语法请参考 [基础语法 | Markdown Guide](https://www.markdownguide.org/basic-syntax) 和 [扩展语法 | Markdown Guide](https://www.markdownguide.org/extended-syntax)
{% endnote %}

# Hexo内置标签

{% note info %}
本章节参考 [Ivan.nginx | Hexo Theme Next主题样式测试](https://almostover.ru/2016-01/hexo-theme-next-test/) 及 [内置标签 - NexT 使用文档](https://theme-next.iissnan.com/tag-plugins.html)
{% endnote %}

## 文本居中标签

居中标签效果如下：

{% centerquote %}我不去想是否能够成功，既然选择了远方，便只顾风雨兼程。{% endcenterquote %}

一般在引用单行文本时使用，如作为文章开篇题词。

可以通过以下几种方式使用该标签：

``` html
<!-- HTML方式: 直接在 Markdown 文件中编写 HTML 来调用 -->
<!-- 其中 class="blockquote-center" 是必须的 -->
<blockquote class="blockquote-center">blah blah blah</blockquote>

<!-- 标签方式 -->
{% centerquote %}blah blah blah{% endcenterquote %}

<!-- 标签别名 -->
{% cq %} blah blah blah {% endcq %}
```

## 代码块进阶用法

可以通过为代码块附加参数的形式为其添加更丰富的信息提示，效果如下：

``` js Hellow World http://yearito.cn 链接地址
console.log("Hello world!");
```

代码块进阶语法规则：

<div style="background-color: #f7f7f7; margin: 20px 0; padding: 10px;border-radius: 5px; font-family: consolas;">
  &#x60;&#x60;&#x60; [language] [title] [url] [link text]<br>
  code snippet <br>
  &#x60;&#x60;&#x60;
</div>

其中，各参数意义如下：

- langugae：语言名称，引导渲染引擎正确解析并高亮显示关键字
- title：代码块标题，将会显示在左上角
- url：链接地址，如果没有指定link text则会在右上角显示link
- link text：链接名称，指定url后有效，将会显示在右上角

url 必须为有效链接地址才会以链接的形式显示在右上角，否则将作为标题显示在左上角。以url为分界，左侧除了第一个单词会被解析为language，其他所有单词都会被解析为title，而右侧的所有单词都会被解析为link text。

如果不想填写title，可以在language和url之间添加至少三个空格。

{% note info %}
代码块支持多种语言高亮预设，详细的语言列表可查看[Ivan.nginx | Hexo代码块中的颜色方案](https://almostover.ru/2016-07/hexo-highlight-code-styles/)。
{% endnote %}

可以在站点配置文件中设置 `highlight.auto_detect: true` 来开启自动语言检测高亮。

``` diff _config.yml
 highlight:
   enable: true
   line_number: false
-  auto_detect: false
+  auto_detect: true
   tab_replace:
```

如果设置语言为diff，可以在代码前添加 `+` 和 `-` 来使用如上所示的高亮增删行提示效果，在展示代码改动痕迹时比较实用。

{% note info %}
更多代码块高亮的个性化设置请参见 [猪猪侠 | Hexo下的语法高亮拓展修改](https://www.ofind.cn/blog/HEXO/HEXO%E4%B8%8B%E7%9A%84%E8%AF%AD%E6%B3%95%E9%AB%98%E4%BA%AE%E6%8B%93%E5%B1%95%E4%BF%AE%E6%94%B9.html#%E8%AE%BE%E7%BD%AE%E4%BB%A3%E7%A0%81%E6%B7%BB%E5%8A%A0%E5%88%A0%E9%99%A4%E6%A0%87%E8%AE%B0)
{% endnote %}

## note标签

通过note标签可以为段落添加背景色，语法如下：

```
{% note [class] %}
文本内容 (支持行内标签)
{% endnote %}
```

支持的class种类包括 `default` `primary` `success` `info` `warning` `danger`，也可以不指定class。

各种class种类的效果如下：

{% note primary %}
**primary** note tag
{% endnote %}

{% note success %}
**success** note tag
{% endnote %}

{% note info %}
**info** note tag
{% endnote %}

{% note warning %}
**warning** note tag
{% endnote %}

{% note danger %}
**danger** note tag
{% endnote %}

{% note %}
undefined class note tag
{% endnote %}

更多配置可在主题配置文件中设置

``` yaml themes\next\_config.yml
note:
  # Note 标签样式预设
  style: modern  # simple | modern | flat | disabled
  icons: false  # 是否显示图标
  border_radius: 3  # 圆角半径
  light_bg_offset: 0  # 默认背景减淡效果，以百分比计算
```

## label标签

通过label标签可以为文字添加背景色，语法如下：

```
{% label [class]@text  %}
```

支持的class种类包括 `default` `primary` `success` `info` `warning` `danger`，默认使用 `default` 作为缺省。

使用示例如下：

``` plain
I heard the echo, {% label default@from the valleys and the heart %}
Open to the lonely soul of {% label info@sickle harvesting %}
Repeat outrightly, but also repeat the well-being of
Eventually {% label warning@swaying in the desert oasis %}
{% label success@I believe %} I am
{% label primary@Born as the bright summer flowers %}
Do not withered undefeated fiery demon rule
Heart rate and breathing to bear {% label danger@the load of the cumbersome %}
Bored
```

{% centerquote %}
I heard the echo, {% label default@from the valleys and the heart %}<br>
Open to the lonely soul of {% label info@sickle harvesting %}<br>
Repeat outrightly, but also repeat the well-being of<br>
Eventually {% label warning@swaying in the desert oasis %}<br>
{% label success@I believe %} I am <br>
{% label primary@Born as the bright summer flowers %}<br>
Do not withered undefeated fiery demon rule<br>
Heart rate and breathing to bear {% label danger@the load of the cumbersome %}<br>
Bored
{% endcenterquote %}

可在主题配置文件中设置 `label: false` 来取消label标签默认CSS样式。

## button按钮

通过button标签可以快速添加带有主题样式的按钮，语法如下：

```
{% button /path/to/url/, text, icon [class], title %}
```

也可简写为：

```
{% btn /path/to/url/, text, icon [class], title %}
```

其中， 图标ID来源于 [FontAwesome](https://fontawesome.com/v4.7.0/icons/) 。

使用示例如下：

```
{% btn #, 文本 %}
{% btn #, 文本 & 标题,, 标题 %}
{% btn #, 文本 & 图标, home %}
{% btn #, 文本 & 大图标 (固定宽度), home fa-fw fa-lg %}
```

<p>{% btn #, 文本 %}</p>
<p>{% btn #, 文本 & 标题,, 标题 %}</p>
<p>{% btn #, 文本 & 图标, home %}</p>
<p>{% btn #, 文本 & 大图标 (固定宽度), home fa-fw fa-lg %}</p>

## tab标签

tab标签用于快速创建tab选项卡，语法如下

``` html
{% tabs [Unique name], [index] %}
  <!-- tab [Tab caption]@[icon] -->
  标签页内容（支持行内标签）
  <!-- endtab -->
{% endtabs %}
```

其中，各参数意义如下：

- Unique name: 全局唯一的Tab名称，将作为各个标签页的id属性前缀
- index: 当前激活的标签页索引，如果未定义则默认选中显示第一个标签页，如果设为-1则默认隐藏所有标签页
- Tab caption: 当前标签页的标题，如果不指定则会以Unique name加上索引作为标题
- icon: 在标签页标题中添加Font awesome图标

使用示例如下：

``` plain
{% tabs Tab标签列表 %}
  <!-- tab 标签页1 -->
    标签页1文本内容
  <!-- endtab -->
  <!-- tab 标签页2 -->
    标签页2文本内容
  <!-- endtab -->
  <!-- tab 标签页3 -->
    标签页3文本内容
  <!-- endtab -->
{% endtabs %}
```

{% tabs Tab标签列表 %}
  <!-- tab 标签页1 -->
    标签页1文本内容
  <!-- endtab -->
  <!-- tab 标签页2 -->
    标签页2文本内容
  <!-- endtab -->
  <!-- tab 标签页3 -->
    标签页3文本内容
  <!-- endtab -->
{% endtabs %}

## 引用站内链接

可以通过如下语法引入站内文章的地址或链接：

```
{% post_path slug %}
{% post_link slug [title] %}
```

其中，`slug` 表示 `_post` 目录下的Markdown文件名。

`post_path` 标签将会渲染为文章的地址，即 `permalink`；而 `post_link` 标签将会渲染为链接，可以通过 `title` 指定链接标题。

如以下标签将会生成 `{% post_path hexo-writing-skills %}`

```
{% post_path hexo-writing-skills %}
```

而以下标签则会生成 {% post_link hexo-writing-skills 链接标题 %}

```
{% post_link hexo-writing-skills 链接标题 %}
```

这种站内引用方式比直接使用url引用的形式更为可靠，因为即使修改了 `permalink` 格式，或者修改了文章的路由地址，只要Markdown文件名没有发生改变，引用链接都不会失效。

## 插入Swig代码

如果需要在页面内插入Swig代码，包括原生HTML代码，JavaScript脚本等，可以通过 raw 标签来禁止Markdown引擎渲染标签内的内容。语法如下：

```
{% raw %}
content
{% endraw %}
```

该标签通常用于在页面内引入三方脚本实现特殊功能，尤其是当该三方脚本尚无相关hexo插件支持的时候，可以通过写原生Web页面的形式引入脚本并编写实现逻辑。

## 插入Gist

如果需要在页面内插入Gist上的代码片段时，可以使用如下标签:

```
{% gist gist_id [filename] %}
```

其中，各参数意义如下：

- gist_id: Gist仓库页面url中最后一段随机字符串
- filename: Gist中的文件名

如果Gist中只有一个文件，可以不用指定filename，也可以通过JavaScript脚本的形式直接引入，如：

``` html
<script src="https://gist.github.com/Coodool/cb4ff46a3523955dd4b918dd775b6774.js"></script>
```

如果Gist中有多个文件，可以在标签内输入filename来指定只引入某个文件，如果没有指定filename，将会引入Gist中的所有文件。另外，引用JavaScript脚本形式无法精确控制只引入某一个文件，将会同时引入Gist中的所有文件。

如果指定了与Gist无法匹配的filename，页面上将不会显示任何标签内容。所以，一般在Gist只有一个文件的情况下无需指定filename。

{% note warning %}
在页面中引入Gist代码段将会同时从github服务器上下载脚本与CSS样式文件，由于国内访问github服务器延迟较高，往往资源文件连接和下载的速度很慢，会阻塞页面的渲染进程导致短时白屏。
{% endnote %}

# 插入多媒体

## 插入图片

Markdown并不会保存插入的图片资源本身，只是记录了获取资源的链接。因此我们需要选择一款合适的图床来支持博客写作，目前各大云服务商都提供了对象存储服务，如七牛云KODO、又拍云USS、腾讯云COS、阿里云OSS等。

所以在Markdown中插入一张图片要分为以下几步来进行：

1. 将图片资源上传到图床中
2. 获取图片外链
3. 插入到Markdown文档中

对于博客这种低频访问的应用场景，各大服务商的服务其实并没有显著的差异，并且前期的使用都提供了免费的流量，所以我认为图床的选择主要参考以下几个方面：

- 图床是否提供了便捷的图形化管理工具用于图片的上传下载？

  如阿里云有ossbrowser，腾讯云有cosbrowser，七牛云有QsunSync等，但就本人使用体验来说，七牛云QsunSync的UI界面确实很拙劣，功能较为单一，而腾讯云cosbrowser的界面就相对美观优雅的多，并以Windows资源管理器的交互方式为用户提供资源的上传、下载和管理服务。

  ![腾讯云COS客户端界面截图](http://yearito-1256884783.image.myqcloud.com/hexo-writing-skills/20181023103058966.png "腾讯云COS客户端界面截图")

- 是否能够方便的插入到Markdown文档中？

  这就和服务商的关系不大了，主要看主流Markdown文档编辑器对各大图床的支持程度。其实关于在Markdown中更便捷的插入图片这事儿，最上心的还是文档编辑器的开发者，为了给用户提供更方便的文档写作体验，各大文档编辑器以及支持了Markdown语法的笔记软件都花了不少心思，解决方案无外乎两种，第一种是内置图片存储服务，如有道云笔记（需付费）、石墨文档，第二种是集成了云服务商的图床服务，如Hexo Editor、Mweb等，前者插入图片方便，适用于个人笔记，而后者能够提供CDN加速服务，适用于博客等公开文档。

  其中Hexo Editor支持腾讯云和七牛云的一键上传服务，MWeb支持Imgur、七牛云、又拍云，也可自定义图床服务。

{% note info %}
本站使用腾讯云COS提供对象存储服务。
{% endnote %}

## 网易云音乐

在网页版云音乐中找到歌曲，点击生成外链播放器：

![获取歌曲外链](http://yearito-1256884783.image.myqcloud.com/hexo-writing-skills/20181104044431732.png "获取歌曲外链")

根据个人喜好选择播放器尺寸和播放模式：

![获取插件代码](http://yearito-1256884783.image.myqcloud.com/hexo-writing-skills/20181104044659251.png "获取插件代码")

将获取到的 `iframe` 代码添加到页面中，默认样式如下：

<div class="fluid-vids" style="position: relative; margin-bottom: 20px; width: 100%; padding-top: 10.75%;"><iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width="329" height="86" src="//music.163.com/outchain/player?type=2&amp;id=34613621&amp;auto=0&amp;height=66" style="width: 100%; height: 100%; position: absolute; top: 0px; left: 0px;">
</iframe></div>

播放器宽度将会被拉长占满整个页宽，看起来有点别扭。查看控制台之后发现 `iframe` 在渲染的时候被处理过，外层包了一个类名为 `fluid-vids` 的 `div` 元素。顺藤摸瓜，找到了相关代码，原来是为了让嵌入的视频支持自适应布局，恰好也将 `music.163.com` 域名包含在了处理逻辑内，只需要将该行删除即可。

``` js themes\next\source\js\src\utils.js
var SUPPORTED_PLAYERS = [
  'www.youtube.com',
  'player.vimeo.com',
  'player.youku.com',
  //'music.163.com',
  'www.tudou.com'
];
```

这样播放器样式就变成左对齐固定宽度了，如果你还想让播放器居中，可以将 `iframe` 包在 `<center>` 标签内。

``` html
<center>
  <iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=329 height=86 src="//music.163.com/outchain/player?type=2&id=34613621&auto=0&height=66"></iframe>
</center>
```

效果如下：

<center>
  <iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=329 height=86 src="//music.163.com/outchain/player?type=2&id=34613621&auto=0&height=66">
  </iframe>
</center>

{% note warning %}
其实这种通过HTML标签实现CSS样式的做法并不合适，写前端代码的时候不推荐这么做，并且HTML5中也已经废除了 `<center>` `<strong>` 等纯粹为了改变样式而存在的HTML标签，HTML标签应该只负责文档结构，所有样式相关的工作应该交给CSS来实现。
{% endnote %}

如果你发现播放器前后都有空行，可以在控制台中查看元素，检查 `iframe` 元素前后是否多了 `<br>` 元素：

![播放器前后空行代码](http://yearito-1256884783.image.myqcloud.com/hexo-writing-skills/20181027111824579.png "播放器前后空行代码")

造成这样的原因是Markdown渲染引擎把 `<center>` 标签和 `<iframe>` 标签之间的回车当作 `<br>` 来处理了。参考链接: [Hexo issues #1388](https://github.com/hexojs/hexo/issues/1388)

简单的解决方案是将HTML标签写到一行内，但这样会降低代码可编辑性。

另外一种方案是在站点配置文件中添加如下代码：

``` yaml _config.yml
marked:
  gfm: true
  breaks: false
```

重启服务器之后更改才会生效。

{% note warning %}
网易云音乐中部分歌曲因版权保护已经无法生成外链了，即使是通过控制台强行拿到外链地址，嵌入网页后也无法播放。
{% endnote%}

## Aplayer音频播放器

[APlayer](https://aplayer.js.org/#/)是由 [DIYgod](https://github.com/DIYgod) 编写的HTML5音频播放器，提供了另一种音频播放方案。

{% note %}
了解诞生背景： [APlayer - 送给小狐狸和小兔子的 HTML5 播放器](https://diygod.me/2167/)
{% endnote%}

借助 [hexo-tag-aplayer](https://github.com/MoePlayer/hexo-tag-aplayer) 插件，可以通过标签的形式方便快捷的插入音频组件。

在站点根目录下执行以下命令：

``` bash
$ npm install hexo-tag-aplayer --save
```

然后在页面中按照以下标签格式插入歌曲链接和相关信息：

```
{% aplayer title author url [picture_url, narrow, autoplay, width:xxx, lrc:xxx] %}
```

其中，各参数意义如下：

- title: 曲目标题
- author: 曲目作者
- url: 音乐文件 URL 地址
- picture_url: (可选) 音乐对应的图片地址
- narrow: （可选）播放器袖珍风格
- autoplay: (可选) 自动播放，移动端浏览器暂时不支持此功能
- width:xxx: (可选) 播放器宽度 (默认: 100%)
- lrc:xxx: （可选）歌词文件 URL 地址

示例效果如下：

{% aplayer "前前世世 -《君の名は。》" "RADWIMPS" "https://moeplayer.b0.upaiyun.com/aplayer/yourname.mp3" "http://pic.5577.com/up/2016-12/201612891712576.png" lrc:"https://moeplayer.b0.upaiyun.com/aplayer/yourname.lrc" %}

当开启 Hexo 的 [文章资源文件夹](https://hexo.io/zh-cn/docs/asset-folders.html#%E6%96%87%E7%AB%A0%E8%B5%84%E6%BA%90%E6%96%87%E4%BB%B6%E5%A4%B9) 功能时，可以将图片、音乐文件、歌词文件放入与文章对应的资源文件夹中，然后直接引用，示例如下：

```
{% aplayer "Caffeine" "Jeff Williams" "caffeine.mp3" "picture.jpg" "lrc:caffeine.txt" %}
```

如果想要统一实现固定宽度和居中样式，可以在自定义样式文件中添加如下样式规则

``` css themes\next\source\css\_custom\custom.styl
//Aplayer 播放器居中
div.aplayer {
  margin: 5px auto;
  max-width: 500px;
}
```

{% note info %}
插入播放列表功能请参考： [hexo-tag-aplayer | With playlist](https://github.com/MoePlayer/hexo-tag-aplayer#with-playlist)
{% endnote %}

## Dpalyer视频播放器

[DPlayer](http://dplayer.js.org/#/) 是一款简洁美观的HTML5视频播放器，同样出自 [DIYgod](https://github.com/DIYgod) 之手，支持弹幕互动。

{% note %}
了解诞生背景： [DPlayer – 最好看的弹幕播放器送给最好看的宫园薰](https://diygod.me/2648/)
{% endnote %}

借助 [hexo-tag-dplayer](https://github.com/MoePlayer/hexo-tag-dplayer) 插件，可以通过标签的形式方便快捷的插入视频组件。

在站点根目录下执行以下命令：

``` bash
$ npm install hexo-tag-dplayer --save
```

然后在页面中按照以下标签格式插入歌曲链接和相关信息：

```
{% dplayer "url=video-url" "pic=image-url" ... ["key=value"] %}
```

此处列举部分重要 `key` 的参数意义:

{% tabs Tab标签列表 %}
  <!-- tab 播放器 -->
    - autoplay：是否开启视频自动播放，默认为 `fasle`
    - loop：是否开启视频循环播放，默认为 `false`
    - screenshot：是否开启截图，默认为 `false`
    - mutex：是否禁止多个播放器同时播放，默认为 `true`
    - dmunlimited：是否开启海量弹幕模式，默认为 `false`
    - preload：预加载模式，可选 `note` `metadata` `auto`
    - theme：主题色
    - lang：语言，可选 `en` `zh-cn` `zh-tw`
    - logo：左上角的Logo
    - volume：默认音量，默认为0.7
    - width：播放器宽度
    - height：播放器长度
  <!-- endtab -->
  <!-- tab 视频 -->
    - url：视频链接
    - pic：视频封面
    - thumbnails：视频缩略图，可以使用 [DPlayer-thumbnails](https://github.com/MoePlayer/DPlayer-thumbnails) 生成
    - vidtype：视频类型，可选 `auto` `hls` `flv` `dash` 或其他自定义类型
  <!-- endtab -->
  <!-- tab 字幕 -->
    - suburl：字幕链接
    - subtype：字幕类型，可选 `webvtt` `ass`，目前只支持 `webvtt`
    - subbottom：字幕距离播放器底部的距离，如 `10px` `10%`
    - subcolor：字幕颜色
  <!-- endtab -->
  <!-- tab 弹幕 -->
    - id：弹幕id
    - api：弹幕api
    - token：弹幕后端验证 token
    - addition：额外外挂弹幕
    - dmuser：弹幕用户名
    - maximum：弹幕最大数量
  <!-- endtab -->
{% endtabs %}

示例效果如下：

{% dplayer "url=https://moeplayer.b0.upaiyun.com/dplayer/hikarunara.mp4"  "pic=https://moeplayer.b0.upaiyun.com/dplayer/hikarunara.png" "loop=yes" "screenshot=true" "theme=#FADFA3" "autoplay=false" %}

也可以通过raw标签引入原生Dplayer以使用更多配置项，示例代码如下：

``` html
{% raw %}
<div id="dplayer" className="dplayer"></div>
<link class="dplayer-css" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/dplayer/dist/DPlayer.min.css">
<script src="https://cdn.jsdelivr.net/npm/dplayer/dist/DPlayer.min.js"></script>
<script>
  var dp = new DPlayer({
    container: document.querySelector('#dplayer'),
    autoplay: false,
    theme: '#FADFA3',
    loop: true,
    screenshot: true,
    hotkey: true,
    logo: 'logo.png',
    volume: 0.7,
    mutex: true,
    video: {
      url: 'demo.mp4',
      pic: 'demo.png',
      thumbnails: 'thumbnails.jpg',
      type: 'auto'
    },
    subtitle: {
      url: 'webvtt.vtt',
      type: 'webvtt',
      fontSize: '25px',
      bottom: '10%',
      color: '#b7daff'
    },
    danmaku: {
      id: 'demo',
      api: 'https://api.prprpr.me/dplayer/',
      token: 'demo',
      maximum: 3000,
      user: 'DIYgod',
      margin: {
        bottom: '15%'
      },
      unlimited: true
    },
    contextmenu: [
      {
        text: 'custom contextmenu',
        link: 'https://github.com/MoePlayer/DPlayer'
      }
    ]
  });
</script>
{% endraw %}
```

{% note info %}
更多配置参数请参考 [Dplayer 官方中文文档](http://dplayer.js.org/#/zh-Hans/?id=%E5%8F%82%E6%95%B0)
{% endnote %}

# 写作工具

Hexo写作必备一款好用的Markdown文档编辑器，下面推荐几款我比较喜欢的。

## Sublime Text 3

![Sublime Text 3 用户界面](http://yearito-1256884783.image.myqcloud.com/hexo-writing-skills/20181106041459974.png "Sublime Text 3 用户界面")

Sublime Text 3 是一款轻量级的文档编辑器，响应速度极快，社区活跃，主题插件也很丰富，在Windows下可以取代记事本成为默认的文档编辑器，也可以通过集成不同的编程依赖包成为功能强大的IDE，还可以搭配上Markdown插件成为网络作家的写作工具。

推荐两个比较实用的Markdown写作插件：Markdown Editing和OmniMarkupPreviewer。

### [Markdown Editing](https://github.com/SublimeText-Markdown/MarkdownEditing)

支持Markdown语法高亮，提供Markdown编辑的快捷键，提供多种主题样式。

| 快捷键                               | 说明                                                               |
| ------------------------------------ | ------------------------------------------------------------------ |
| Ctrl + Alt + V                       | 在选中文本上创建行内链接或将剪贴板内容粘贴为所选文本的行内链接     |
| Ctrl + Alt + R                       | 在选中文本上创建参考式链接或将剪贴板内容粘贴为所选文本的参考式链接 |
| Shift + Win + K                      | 在选中文本上创建行内图片或将剪贴板内容粘贴为所选文本的行内图片     |
| Alt + B                              | 加粗强调，当未选中文本时默认加粗光标所在单词，再次按键取消加粗     |
| Alt + I                              | 斜体强调，当未选中文本时默认倾斜光标所在单词，再次按键取消斜体     |
| Ctrl + 1~6                           | 在空行上添加对应数字级别的标题，选中已有标题时按键可修改标题级别   |
| Alt + Shift + 6                      | 添加脚注                                                           |
| Shift + Tab                          | 折叠/展开当前章节                                                  |
| Ctrl + Shift + Tab                   | 折叠指定级别下的所有章节                                           |
| Ctrl + Alt + Shift + PageUp/PageDown | 跳转到上/下一个同级或更高级的其他标题                              |
| Ctrl + Shift + PageUp/PageDown       | 跳转到上/下一个标题                                                |
| Ctrl + Shift + R                     | 显示Markdown文件标题                                               |

### [OmniMarkupPreviewer](https://github.com/timonwong/OmniMarkupPreviewer)

用于在浏览器中实时预览Markdown文档，用户可以边在Sublime中写作边在浏览器中查看文档的实时变化，而不需要手动刷新浏览器。

| 快捷键         | 说明                   |
| -------------- | ---------------------- |
| Ctrl + Alt + O | 在浏览器中预览         |
| Ctrl + Alt + X | 导出为HMTL             |
| Ctrl + Alt + C | 以HTML格式拷贝到剪贴板 |

{% note warning %}
PlainTasks插件（一款Todo List工具）会与OmniMarkupPreviewer产生冲突，导致OmniMarkupPreviewer功能异常，如编辑后无法实时预览，[资源样式加载错误](https://github.com/timonwong/OmniMarkupPreviewer/issues/111) 等。如果不想卸载PlainTasks，可以在使用OmniMarkupPreviewer时暂时禁用PlainTasks，具体做法为在Sublime Text的User Settings中添加如下代码：
{% endnote %}

``` json
"ignored_packages":[
  "PlainTasks"
],
```

## [Hexo Editor](https://github.com/zhuzhuyule/HexoEditor)

Hexo Editor是专为Hexo博客写作打造的文件编辑器，界面极简美观，支持实时预览，支持图片上传。

![Hexo Editor 用户界面](https://raw.githubusercontent.com/zhuzhuyule/HexoEditor/master/screenshots/main.png "Hexo Editor 用户界面")

{% note warning %}
本人在实际使用过程中发现该软件功能不太稳定，插入图片有时候会卡顿，甚至出现程序崩溃的现象。
{% endnote %}

### 编辑快捷键

| 快捷键           | 说明                     |
| ---------------- | ------------------------ |
| Tab              | 增加缩进                 |
| Shift + Tab      | 减少缩进                 |
| Ctrl + B         | 加粗                     |
| Ctrl + I         | 斜体                     |
| Ctrl + D         | 删除当前行               |
| Ctrl + \`        | 将当前单词标记为代码     |
| Ctrl + L         | 插入无序列表             |
| Ctrl + Alt + L   | 插入有序列表             |
| Ctrl + ]         | 降低标题级别             |
| Ctrl + \[        | 提升标题级别             |
| Ctrl + =         | 插入引用                 |
| Ctrl + U         | 插入链接                 |
| Ctrl + Alt + U   | 插入图片                 |
| Ctrl + T         | 插入表格                 |
| Ctrl + V         | 粘贴为纯文本（去除格式） |
| Shift + Ctrl + V | 粘贴（保留源格式）       |
| Alt + F          | 格式化表格               |

### 操作快捷键

| 快捷键           | 说明                |
| ---------------- | ------------------- |
| Ctrl + N         | 新建Hexo文档        |
| Ctrl + H         | new hexo document   |
| Ctrl + O         | open md document    |
| Ctrl + S         | save md document    |
| Shift + Ctrl + S | save as             |
| Alt + Ctrl + S   | open settings       |
| Ctrl + W         | toggle write mode   |
| Ctrl + P         | toggle preview mode |
| Ctrl + R         | toggle read mode    |

## MWeb

![Mweb 用户界面](http://yearito-1256884783.image.myqcloud.com/hexo-writing-skills/20181023095629471.png "Mweb 用户界面")

MWeb是Mac平台上一款专业的Markdown写作、记笔记、静态博客生成软件，支持图片上传。他的与众不同在于，除了具备一般Markdown编辑器所具有的一切基本功能之外，还支持以下特性：

- 支持LaTeX公式、TOC
- 支持丰富的画图库，如mermaid、Graphviz、echarts、plantuml、流程图、时序图等
- 支持插入图片后自动上传到图床
- 拥有及其强大的发布功能，支持一键发布到各大博客平台和笔记软件中

尽管拥有如此丰富的特性，但界面仍保持清爽简洁，开发者说到：

> 原则上，首先是追求界面简洁和高性能，然后才是强大易用，功能全面。

目前由oulvhai一人独自开发维护。

## [Dillinger](https://dillinger.io/)

一款优雅的在线Markdown编辑器，界面美观简洁。

![Dillinger 用户界面](http://yearito-1256884783.image.myqcloud.com/hexo-writing-skills/20181020114433264.png "Dillinger 用户界面")

# 结束语

本文介绍了Hexo博客的几项关键写作技巧，包括Markdown的基本语法，Hexo主题的内置标签等，本文还介绍了如何在文章中利用图床外链插入图片，如何利用Aplayer / Dplayer等音视频播放器插件在页面内插入多媒体元素等，并列举了几款写作工具以供选择，希望你能从中找到用起来最顺手的一款。如果你有更高级的个性化需求，你可以关注本系列的后续几篇文章：

- 想要进一步美化主题，添加动效以及交互，请参考本系列中的 {% post_link hexo-theme-beautify %}。
- 想要深度定制个性化站点，请参考本系列中的 {% post_link hexo-advanced-settings %}。
- 想要了解如何将站点部署到公网，请参考本系列中的 {% post_link hexo-deploy-to-VPS %}

<div class="reference-linking">参考链接</div>

- [Markdown指南](https://www.markdownguide.org/)
- [NexT使用文档 | 内置标签](https://theme-next.iissnan.com/tag-plugins.html)
- [Ivan.Nginx | Hexo Theme Next主题样式测试](https://almostover.ru/2016-01/hexo-theme-next-test/)
- [Ivan.Nginx | Hexo代码块中的颜色方案](https://almostover.ru/2016-07/hexo-highlight-code-styles/)
- [猪猪侠 | Hexo下的语法高亮拓展修改](https://www.ofind.cn/blog/HEXO/HEXO下的语法高亮拓展修改.html)
- [hexo-tag-aplayer | 中文文档](https://github.com/MoePlayer/hexo-tag-aplayer/blob/master/docs/README-zh_cn.md)
- [hexo-tag-dplayer | README](https://github.com/MoePlayer/hexo-tag-dplayer)
- [Dplayer 官方中文文档](http://dplayer.js.org/#/zh-Hans/)
