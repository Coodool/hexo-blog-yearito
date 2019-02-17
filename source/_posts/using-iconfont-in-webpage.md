---
title: Web页面中引用iconfont图标
tags:
categories:
  - 技术
  - 前端
copyright: true
reward: true
rating: true
related_posts: false
date: 2019-01-29 13:06:04
---

![iconfont 首页](http://yearito-1256884783.image.myqcloud.com/thumbnails/iconfont.png!thumbnail "iconfont 首页")

阿里妈妈出品的 iconfont 是一个矢量图标管理、交流平台，支持矢量图、位图等格式下载，并提供便捷的前端项目植入引用方法，是当前Web开发中主流的icon解决方案。

<!-- more -->

想要在前端页面中引入图标，一个最原始的做法，就是下载图标的PNG图片格式，然后通过标签引入：

```
<img src="images/icon.png" />
```

当页面中图标数量比较少时，采用这种简单的做法并无不当，但如果项目中图标数量较多，并且应用需求比较复杂的时候，就会暴漏出以下问题：

- PNG图片是位图，缩放页面会导致图片模糊。
- 引入后不方便自由调整图标的大小和颜色，需要在外部编辑修改图片之后重新引入。

一个绝佳的解决方案就是 [iconfont](https://www.iconfont.cn/)，在这个平台上不仅可以找到各种精美小图标，还能方便的集成矢量图标到前端项目中。

官方给出了三种 [Web端引入方案](https://www.iconfont.cn/help/detail?helptype=code)：

# Unicode

这种方案的思路是将图标变成字体引入，然后通过HTML转义字符来引用图标，特点是：

- 可以按照调整字体样式的方法来调整图标样式，如设置 `font-size` 调整尺寸大小，设置 `color` 属性修改图标颜色等。
- 因为是字体，所以不支持多色，这里所说的多色，意思是同一个图标里不允许出现多种颜色。

使用方案如下：

每个图标项目都会自动生成一段唯一的Unicode引用代码（CSS样式），在前端项目中将这段代码引入：

``` css
@font-face {
  font-family: 'iconfont';  /* project id 964156 */
  src: url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.eot');
  src: url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.eot?#iefix') format('embedded-opentype'),
  url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.woff2') format('woff2'),
  url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.woff') format('woff'),
  url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.ttf') format('truetype'),
  url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.svg#iconfont') format('svg');
}

.iconfont{
  font-family:"iconfont" !important;
  font-size:16px;font-style:normal;
  -webkit-font-smoothing: antialiased;
  -webkit-text-stroke-width: 0.2px;
  -moz-osx-font-smoothing: grayscale;
}
```

这里使用 `@font-face` 定义了一种叫做 `iconfont` 的字体（名字可以自定义），这个 `iconfont` 字体就跟微软雅黑、宋体等是一种性质了，为了搞定兼容性问题确保字体引入成功，设置了多种常见格式的字体源引入链接，如 eot、woff、ttf等。

后面这段CSS代码的意思就是，所有类名为 `iconfont` 的元素字体都强制使用 `iconfont` 字体族，这样就为HTML转义符转义为“图标”（本质还是字体，只不过长成了图标的样子）做好了铺垫。

然后在需要插入图标的位置插入如下HTML代码，其中的转义符可以在 iconfont 的各个图标中找到：

``` html
<i class="iconfont">&#x33;</i>
```

![Unicode 引用](http://yearito-1256884783.image.myqcloud.com/using-iconfont-in-webpage/unicode.png "Unicode 引用")

# Font Class

从Unicode的引用方案中我们可以看到，HTML转义符都是形如 `&#***;` 的样式，书写不直观，语义不明确，使用和维护都有诸多不便。于是 iconfont 推出一套语义化的方案，这就是 Font Class。使用方案如下：

直接在前端项目的HTML头部外链iconfont的图标项目CSS文件：

``` html
<link rel="stylesheet" type="text/css" href="//at.alicdn.com/t/font_964156_pr9i6o2kmf.css">
```

然后在需要插入图表的位置插入如下HTML代码，其中的元素类名 `icon-xxx` 可以在iconfont的各个图标中获取：

``` html
<i class="iconfont icon-full-screen"></i>
```

![Font Class 引用](http://yearito-1256884783.image.myqcloud.com/using-iconfont-in-webpage/font-class.png "Font Class 引用")

这个方案只是给Unicode重新包装了一翻，变得更方便使用了而已，为什么这么说呢？我们直接在浏览器中打开这个CSS文件来看看名堂（有删减）：

``` css http://at.alicdn.com/t/font_964156_pr9i6o2kmf.css
@font-face {font-family: "iconfont";
  src: url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.eot?t=1548690018080'); /* IE9 */
  src: url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.eot?t=1548690018080#iefix') format('embedded-opentype'), /* IE6-IE8 */
  url('data:application/x-font-woff2;charset=utf-8;base64,d09GMgAB......TB+KD1yrAQAAAA==') format('woff2'),
  url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.woff?t=1548690018080') format('woff'),
  url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.ttf?t=1548690018080') format('truetype'), /* chrome, firefox, opera, Safari, Android, iOS 4.2+ */
  url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.svg?t=1548690018080#iconfont') format('svg'); /* iOS 4.1- */
}

.iconfont {
  font-family: "iconfont" !important;
  font-size: 16px;
  font-style: normal;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.icon-full-screen:before {
  content: "\e616";
}

.icon-love:before {
  content: "\e71e";
}

.icon-pause:before {
  content: "\e615";
}

.icon-playing:before {
  content: "\e643";
}

.icon-ring:before {
  content: "\e601";
}

.icon-help:before {
  content: "\e609";
}

```

是不是感觉似曾相识，这里将 Unicode 的引入代码统一封装了起来，只不过下面多了一些伪类的样式，其意义就是让你可以通过语义化的方法引用图标，比如你给一个图标元素添加了 `icon-full-screen` 类名，这里 `.icon-full-screen:before` 伪类样式就会帮你在元素中嵌入图标字符。

该方案的本质依旧和Unicode是一致的：图标变字体，再通过HTML转义符插入。所以Unicode方案中提到的无法使用多色图标的问题，这里依然未得到解决。

# Symbol

这是一个可以支持多色图标的方案，官方的说法是：

> 这是一种全新的使用方式，应该说这才是未来的主流，也是平台目前推荐的用法。

{% note %}
没错，这是你没有体验过的船新版本，但是我才不会告诉你，iconfont平台自己用的是unicode和font-class的方案，可能是为了兼容 ie6 ?
{% endnote %}

这回不是引入CSS文件而是引入JS脚本了，其思路是通过JavaScript把图标项目中所有的SVG矢量图形统一添加到页面中并隐藏起来，后续用到图标的地方直接切图引用即可。

使用方案如下：

首先在前端项目的HTML文件中引入iconfont脚本：

``` html
<script type="text/javascript" src="//at.alicdn.com/t/font_964156_pr9i6o2kmf.js"></script>
```

在样式文件中添加如下通用样式规则：

``` css
.icon {
  width: 1em; height: 1em;
  vertical-align: -0.15em;
  fill: currentColor;
  overflow: hidden;
}
```

然后在需要插入图标的位置插入如下HTML代码，其中的图标名 `#icon-xxx` 可以在iconfont的各个图标中获取：

``` html
<svg class="icon" aria-hidden="true">
  <use xlink:href="#icon-xxx"></use>
</svg>
```

![Symbol 引用](http://yearito-1256884783.image.myqcloud.com/using-iconfont-in-webpage/symbol.png "Symbol 引用")

通过这种方案引入 iconfont 图标，会在页面中发现多了一个SVG标签：

![SVG 图标仓库](http://yearito-1256884783.image.myqcloud.com/using-iconfont-in-webpage/svg-palette.png "SVG 图标仓库")

你可以把这个SVG标签理解为一个图标仓库，或者说一个原始画板，其样式被刻意隐藏了起来：

``` css
position: absolute;
width: 0px;
height: 0px;
overflow: hidden;
```

查看页面中引入的图标元素，会发现 `use` 标签里多了相应图标的SVG矢量元素：

![图标元素](http://yearito-1256884783.image.myqcloud.com/using-iconfont-in-webpage/quote-icon.png "图标元素")

可以理解为这里从图标仓库中引用了一份SVG代码以显示图标，这就是Symbol方案的关键所在了。

{% note %}
有兴趣的可以在 [AntDesign Icon](https://ant.design/components/icon/) 页面F12控制台中查看元素构成。
{% endnote %}



<div class="reference-linking">参考链接</div>

- [iconfont 帮助中心 | 代码应用](https://www.iconfont.cn/help/detail?helptype=code)
