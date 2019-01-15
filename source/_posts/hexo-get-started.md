---
title: Hexo搭建个人博客系列：基础建站篇
date: 2018-11-20 20:09:51
copyright: true
reward: true  
rating: true
related_posts: true
tags: Hexo
categories:
- 技术
- 博客
---

![题图](http://yearito-1256884783.image.myqcloud.com/thumbnails/forest.jpg!thumbnail "Photo by Ronald Jansen")

Hexo是一个高效简洁的静态博客框架，支持Markdown写作语法，插件丰富，主题优雅，部署方便。目前已成为多数人博客建站的选择。

本文为Hexo搭建个人博客系列中的第一篇。第一章中介绍了如何在本地搭建Hexo博客，第二章中介绍了如何安装使用Next主题，第三章和第四章分别介绍了针对于站点和文章详情页的一些基础优化方案。

<!-- more -->

# 开始使用

在命令行中通过npm来安装Hexo：

``` bash
$ npm install -g hexo-cli  
```

`-g` 表示全局安装，会将Hexo命令加入环境变量中，以使其在cmd下有效。

{% note info %}
Hexo依赖于[Node.js](https://nodejs.org/zh-cn/)和[git](https://git-scm.com/download/)，所以在安装Hexo之前先确保已安装了这两项应用。
{% endnote %}

新建博客目录，然后在该路径下执行初始化命令：

``` bash
$ hexo init
```

{% note info %}
官方教程中提到要在项目目录下执行 `npm install` 命令，事实上不必如此，在执行 `hexo init` 的过程中就已经自动安装好了项目依赖。
{% endnote %}

执行完毕后，将会生成以下文件结构：

``` plain
.
├── node_modules       //依赖安装目录
├── scaffolds          //模板文件夹，新建的文章将会从此目录下的文件中继承格式
|   ├── draft.md         //草稿模板
|   ├── page.md          //页面模板
|   └── post.md          //文章模板
├── source             //资源文件夹，用于放置图片、数据、文章等资源
|   └── _posts           //文章目录
├── themes             //主题文件夹
|   └── landscape        //默认主题
├── .gitignore         //指定不纳入git版本控制的文件
├── _config.yml        //站点配置文件
├── db.json            
├── package.json
└── package-lock.json
```

在根目录下执行如下命令启动hexo的内置Web服务器

``` bash
$ hexo server
```

该命令将会调用Markdown引擎解析项目中的博客内容生成网页资源，资源将会存于内存中，所以用户执行完命令之后在项目文件夹中是找不到相关的Web资源目录的。该命令还会启动一个简易的Web服务器用于提供对内存中网页资源的访问（工作机制类似于webpack-dev-server），Web服务器默认监听4000端口，用户可在浏览器中通过地址 `localhost:4000` 访问博客。

![Hexo 默认主题首页](http://yearito-1256884783.image.myqcloud.com/hexo-get-started/20181102070503130.png "Hexo 默认主题首页")

此外，可以通过添加命令行参数来支持高级用法：

- 当4000端口已被其他应用占用时，可以添加 `-p` / `--port` 参数来设置Web服务监听的端口号，如`hexo s -p 8000`
- 默认情况下，hexo监听项目目录的文件变化，用户对于项目文件的任何改动都会触发实时解析编译并更新内存中的网页资源，也就是说，用户在本地修改后刷新浏览器就可以看到改动效果。如果不希望hexo监听项目目录的文件变化，可以添加 `-s` / `--static` 参数，这样本地改动就不会触发hexo实时解析更新。

# 更换Next主题

Next作为一款符合广大程序员审美的主题，还是有着较高的出场率的。Hexo中切换主题的方式非常简单，只需要将主题文件拷贝至根目录下的 `themes` 文件夹中， 然后修改 `_config.yml` 文件中的 `theme` 字段即可。

在根目录下执行以下命令下载主题文件：

```
$ git clone https://github.com/theme-next/hexo-theme-next.git themes/next
```

也可以在 [NexT版本发布页面](https://github.com/theme-next/hexo-theme-next/releases) 手动下载然后解压到根目录下的 `theme` 文件夹下，并将文件夹命名为 `next` 。这里可以看到 `theme` 文件夹下已经有一个名为 `landscape` 的文件夹了，这就是默认主题了。

![NexT 版本发布页面下载链接](http://yearito-1256884783.image.myqcloud.com/hexo-get-started/20181022092625771.png "NexT 版本发布页面下载链接")

{% note warning %}
注意！Next仓库已经从[iissnan/hexo-theme-next](https://github.com/iissnan/hexo-theme-next)转移到了[theme-next/hexo-theme-next](https://github.com/theme-next/hexo-theme-next/releases)，并在新仓库中发布了 v6.x 版本，后续维护也将在新仓库中开展。如果你仍在使用旧仓库中的Next版本，可能会遇到各种Bug。
{% endnote %}

打开站点配置文件，将 `theme` 字段的值修改为 `next`。

``` yaml _config.yml
theme: next
```

这个时候刷新浏览器页面并不会发生变化，需要重启服务器并刷新才能使主题生效。

![Next 主题首页](http://yearito-1256884783.image.myqcloud.com/hexo-get-started/20181102095611506.png "Next 主题首页")

{% note info %}
如果重启服务器仍无效，尝试使用 `hexo clean` 清除缓存
{% endnote %}

Next默认主题风格为Muse，用户可以在主题配置文件中修改 `scheme` 字段以选择自己喜欢的主题风格：

``` yaml themes\next\_config.yml
# Schemes
scheme: Muse
#scheme: Mist
#scheme: Pisces
#scheme: Gemini
```

# 站点优化

根目录下的 \_config.yml 文件负责站点的相关配置，用户可以通过修改该文件来自定义站点内容或功能，修改后需要重启服务器才能看到效果。

本节通过修改站点配置文件完善了网站标题、网站描述、社交链接、站点版权信息、友情链接等，效果如下图：

![站点概览](http://yearito-1256884783.image.myqcloud.com/hexo-get-started/Snipaste_2018-11-17_17-01-51.png "站点概览")


## 完善站点基础信息

在站点配置文件中完善网站基本信息：

``` yaml _config.yml
title: Yearito's Blog  # 站点名称
description: Stay hungry, stay foolish.  # 站点描述
language: zh-CN # 设置网站语言为简体中文
author: yearito  # 作者名称
```

每个字段的冒号与值之间需要**间隔一个空格**。

## 首页显示文章摘要

根据默认的主题配置，首页将会显示每一篇文章的全文，如果想要只显示文章摘要，可以在主题配置文件中做出如下更改：

``` yaml themes\next\_config.yml
auto_excerpt:
  enable: true  # 开启自动摘要提取
  length: 150
```

此时将会从文章中提取150个字符作为摘要。

用户可以在文章中通过 `<!-- more -->` 标记来精确划分摘要信息，标记之前的段落将作为摘要显示在首页。

如果在文章的Front-Matter中有非空的 `description` 字段，则该字段的内容会被作为摘要显示在首页。

## 修改站点页脚

在主题配置文件中修改网站页脚信息：

``` yaml themes\next\_config.yml
footer:  # 底部信息区
  since: 2018  # 建站时间
  icon:
    name: heart   # 图标名称
    animated: true   # 开启动画
    color: "#ff0000"   # 图标颜色

  powered:
    enable: true  # 显示由 Hexo 强力驱动
    version: false  # 隐藏 Hexo 版本号

  theme:
    enable: true  # 显示所用的主题名称
    version: false  # 隐藏主题版本号
```

更改后效果如下：

![站点页脚](http://yearito-1256884783.image.myqcloud.com/hexo-get-started/20181102094925440.png "站点页脚")

## 修改网站Favicon

Favicon即浏览器标签左侧的图标。下载自己喜欢的图标置于 `themes\next\source\images\` 目录下，命名方式参考主题配置文件中的 `favicon` 字段。

``` yaml themes\next\_config.yml
favicon:
  small: /images/favicon-16x16-next.png  # 小图标
  medium: /images/favicon-32x32-next.png  # 大图标
  apple_touch_icon: /images/apple-touch-icon-next.png  # 苹果图标
  safari_pinned_tab: /images/logo.svg  # safari浏览器标签页图标
```

## 添加友链

在主题配置文件中修改相应字段：

``` yaml themes\next\_config.yml
links_icon: link
links_title: 友情链接
links_layout: inline
links:
  yearito: http://yearito.cn/
```

## 添加社交链接

用户可以在主题配置文件中根据样例提示添加个人社交软件链接：

``` yaml themes\next\_config.yml
social:
  GitHub: https://github.com/yourname || github
  E-Mail: mailto:yourname@gmail.com || envelope
  Weibo: https://weibo.com/yourname || weibo
  Google: https://plus.google.com/yourname || google
  Twitter: https://twitter.com/yourname || twitter
  FB Page: https://www.facebook.com/yourname || facebook
  VK Group: https://vk.com/yourname || vk
  StackOverflow: https://stackoverflow.com/yourname || stack-overflow
  YouTube: https://youtube.com/yourname || youtube
  Instagram: https://instagram.com/yourname || instagram
  Skype: skype:yourname?call|chat || skype

social_icons:   
  enable: true  # 显示社交软件图标
  icons_only: false  # 显示图标的同时显示文字
```

如果要取消社交图标前的小圆点，可以在自定义样式文件中添加如下样式规则：

``` css themes/next/source/css/_custom/custom.styl
//隐藏社交图标前的圆点
.links-of-author a,
.links-of-author .exturl {
  &:before {
    display: none;
  }
}
```

## 添加版权协议

在主题配置文件中开启相关字段并选择知识共享协议：

``` yaml themes\next\_config.yml
creative_commons: by-nc-sa
```

## 点击头像回到首页

{% note info %}
本章节参考 [reuixiy | 打造个性超赞博客Hexo+NexT+GitHubPages的超深度优化#5.13](https://reuixiy.github.io/technology/computer/computer-aided-art/2017/06/09/hexo-next-optimization.html)
{% endnote %}

修改侧边栏模板代码:

``` diff themes\next\layout\_macro\sidebar.swig
  {% if theme.avatar.url %}
+   <a href="/">
      <img class="site-author-image" itemprop="image"
        src="{{ url_for( theme.avatar.url | default(theme.images + '/avatar.gif') ) }}"
        alt="{{ author }}" />
+   </a>
  {% endif %}
```

# 文章页优化

主题目录下的 themes\\next\\\_config.yml 文件负责与主题相关的配置，用户可以通过修改该文件来自定义与主题相关的内容或功能，修改后刷新浏览器即可即时生效。

## 修改文章目录导航

### 取消数字编号

在主题配置文件中关闭目录中的数字编号：

``` yaml themes\next\_config.yml
toc:
  number: false  # 关闭目录中的数字编号
```

### 展开全部目录层级

默认情况下文章的多级目录是折叠的，点击才会触发下级菜单的展开，并且并且同时只能展开一个目录分支，这会造成在点击不同目录标题的时候目录跳来跳去。如果你想实现默认展开全部目录的功能，可以在自定义样式文件中添加以下代码：

``` css themes\next\source\css\_custom\custom.styl
//TOC目录默认全部展开
.post-toc .nav .nav-child {
  display: block;
}
```

### 默认展开两级目录

通常文章内会出现多级标题，对应的目录里就会有多级导航出现，这时候一些原本你不希望出现的次要标题也会在目录中出现并且无法折叠。可以通过以下样式实现默认只展开两级目录，这样以来就通过一个折中的方案完美解决了目录折叠的问题。

``` css themes\next\source\css\_custom\custom.styl
//TOC目录默认展开两级
.post-toc .nav .nav-level-1>.nav-child {
  display: block;
}
```

### 只显示两级目录

如果你根本不想让三级及以上的标题出现TOC导航目录中，可以考虑在自定义样式文件中添加以下代码：

``` css themes\next\source\css\_custom\custom.styl
//TOC目录默认只显示两级目录
.nav-level-2 > .nav-child {
  display: none !important;
}
```

### 主动隐藏文章目录

如果你写了一篇并不算长的文章，没有层层嵌套的多级目录结构，此时侧边的文章目录空荡荡的就有点鸡肋了。修改侧边栏布局模板中的相关逻辑代码：

``` diff themes\next\layout\_macro\sidebar.swig
- {% set display_toc = is_post and theme.toc.enable %}
+ {% set display_toc = is_post and theme.toc.enable and not page.hide_toc %}
```

然后就可在 Front-Matter 中设定变量 hide_toc 用于控制是否隐藏侧边目录。

## 修改文章meta信息

默认主题配置中，标题下方会显示文章的创建时间、文章的修改时间、文章分类信息等元数据，用户可以在主题配置文件中自定义设置需要显示的meta元信息：

``` yaml themes\next\_config.yml
post_meta:
  item_text: true  # 显示文字说明
  created_at: true  # 显示文章创建时间
  updated_at:
    enabled: false  # 隐藏文章修改时间
    another_day: true  # 只有当修改时间和创建时间不是同一天的时候才显示
  categories: false  # 隐藏分类信息
```

## 中英文之间自动添加空格

该功能由[pangu](https://github.com/vinta/pangu.js) 提供，在根目录下执行如下命令克隆插件到项目中：

```
$ git clone https://github.com/theme-next/theme-next-pangu.git themes/next/source/lib/pangu
```

在主题配置文件中设置 `pangu: true` 即可启用该动能。

{% note warning %}
不推荐使用 hexo-filter-auto-spacing 实现该功能，该插件会导致目录中带有中英文的标题失效，无法跳转到文章指定章节。
{% endnote %}

## 修正文末导航跳转逻辑

{% note info %}
本章节参考 [reuixiy | 打造个性超赞博客Hexo+NexT+GitHubPages的超深度优化#5.2](https://reuixiy.github.io/technology/computer/computer-aided-art/2017/06/09/hexo-next-optimization.html)
{% endnote %}

如果不是看到reuixiy的文章，可能一辈子都不会注意到这个奇葩的逻辑：文章底部的左侧/右侧箭头分别导航到更旧/更新的文章链接，就好像你在手机相册里左滑却看到了更久以前的照片，细细想想这个逻辑毫无社会主义可言，至少没有中国特色。

修改文章布局模板：

``` diff themes\next\layout\_macro\post.swig
{% if not is_index and (post.prev or post.next) %}
  <div class="post-nav">
    <div class="post-nav-next post-nav-item">
-      {% if post.next %}
+      {% if post.prev %}
-        <a href="{{ url_for(post.next.path) }}" rel="next" title="{{ post.next.title }}">
+        <a href="{{ url_for(post.prev.path) }}" rel="prev" title="{{ post.prev.title }}">
-          <i class="fa fa-chevron-left"></i> {{ post.next.title }}
+          <i class="fa fa-chevron-left"></i> {{ post.prev.title }}
        </a>
      {% endif %}
    </div>

    <span class="post-nav-divider"></span>

    <div class="post-nav-prev post-nav-item">
-      {% if post.prev %}
+      {% if post.next %}
-        <a href="{{ url_for(post.prev.path) }}" rel="prev" title="{{ post.prev.title }}">
+        <a href="{{ url_for(post.next.path) }}" rel="next" title="{{ post.next.title }}">
-          {{ post.prev.title }} <i class="fa fa-chevron-right"></i>
+          {{ post.next.title }} <i class="fa fa-chevron-right"></i>
        </a>
      {% endif %}
    </div>
  </div>
{% endif %}
```

# 结束语

{% note info %}
不同版本的Hexo和Next主题之间配置项可能存在差异，本系列文章中的配置有效性以Hexo v3.7.1和Next v6.4.2为准。
{% endnote %}

至此你已经在本地搭建起了Hexo博客，更换到了Next主题，并对站点进行了一些基本的自定义配置，看起来已经是一个可以正常使用的站点了。但可能仅仅这样还无法满足你的高级需求，你可以关注本系列的后续几篇文章，将分别从不同的角度一步步的帮助你搭建一个功能更加强大，界面更加优雅的个人博客站点：

- 想要了解和写作有关的语法技巧，请参考本系列中的 {% post_link hexo-writing-skills %}。
- 想要进一步美化主题，添加动效以及交互，请参考本系列中的 {% post_link post_link hexo-theme-beautify %}。
- 想要深度定制个性化站点，请参考本系列中的 {% post_link hexo-advanced-settings %}。
- 想要了解如何将站点部署到公网，请参考本系列中的 {% post_link hexo-deploy-to-VPS %}

<div class="reference-linking">参考链接</div>

- [Hexo官方文档](https://hexo.io/zh-cn/docs/)
- [NexT使用文档](https://theme-next.iissnan.com/getting-started.html) （部分章节与 v6.x 配置不兼容）
- [reuixiy | 打造个性超赞博客Hexo+NexT+GitHubPages的超深度优化](https://reuixiy.github.io/technology/computer/computer-aided-art/2017/06/09/hexo-next-optimization.html)
