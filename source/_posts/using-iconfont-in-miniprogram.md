---
title: 如何在微信小程序中引用iconfont图标
tags: 小程序
categories:
  - 技术
  - 小程序
copyright: true
reward: true
rating: true
related_posts: false
date: 2019-01-29 17:04:08
---


![题图](http://yearito-1256884783.image.myqcloud.com/thumbnails/women-with-coffee.jpg!thumbnail "Photo by Mat Szulik")

最近做小程序开发，本来是个私人的小项目，所以一开始都是从 iconfont 上下载png文件再用图片标签引入的，后来想实现图标的点击态变色，发现以前的方案太原始太落后，不好维护，还是得上矢量图形的引入方案。然后就开始尝试照搬Web中引入iconfont图标的解决方案，才发现事情并没有想象的这么简单。

小程序的环境和Web挺有几分相似，但又不是完全一样，所以iconfont推荐的三种方案并不都是可行的，尝试的过程中一路走了不少坑，此文记录探索过程中的思考与感悟。

<!-- more -->

{% note %}
如果对 iconfont的三种图标引入方案不甚了解，可以移步前文查看：{% post_link using-iconfont-in-webpage Web 页面中引用 iconfont 图标 %}。
{% endnote %}

iconfont 提供的三种方案中，Unicode和Font Class都是引入CSS样式通过自定义字体来实现的，Symbol是引入自定义脚本来实现的，我们先来测试一下Font Class方案的可行性。


# Font Class 方案探索

先考虑这样一个问题，能不能直接引入外部的CSS样式文件呢？

答案是不能，[官方给出的信息](https://developers.weixin.qq.com/miniprogram/dev/framework/view/wxss.html) 如下：

> 使用@import语句可以导入外联样式表，@import后跟需要导入的外联样式表的相对路径，用;表示语句结束。

也就是说，只能从**本地**导入**WXSS格式**的样式文件。

我们知道，小程序中的WXSS基本上就是Web中的CSS，支持大多数的CSS选择器和样式，那么我们就试试将Font Class的CSS代码直接拷贝到小程序的WXSS文件中看一下。

将Font Class的样式引用链接复制到浏览器中直接打开：

![Font Class 引用链接](http://yearito-1256884783.image.myqcloud.com/using-iconfont-in-miniprogram/font-class.png "Font Class 引用链接")

在小程序目录下新建WXSS文件，将CSS代码复制进来：

``` css libs\style\iconfont.wxss
@font-face {font-family: "iconfont";
  src: url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.eot?t=1548690018080'); /* IE9 */
  src: url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.eot?t=1548690018080#iefix') format('embedded-opentype'), /* IE6-IE8 */
  url('data:application/x-font-woff2;charset=utf-8;base64,d09GMgAB......TB+KD1yrAQAAAA==') format('woff2'), //内容太长有删减
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

在根目录下的 `app.wxss` 文件中导入该文件：

``` css app.wxss
@import 'libs/style/iconfont.wxss';
```

在测试页面上插入引用标签：

``` html
<i class="iconfont icon-playing"></i>
<i class="iconfont icon-pause"></i>
<i class="iconfont icon-voice"></i>
<i class="iconfont icon-full-screen"></i>
```

在微信开发者工具中查看效果如下：

![Font Class 方案效果](http://yearito-1256884783.image.myqcloud.com/using-iconfont-in-miniprogram/test-font-class.png "Font Class 方案效果")

{% note info %}
得到结论：Font Class方案可行，具体实现步骤如上。
{% endnote %}

此前在网上看到比较主流的说法是：小程序的WXSS文件中 `font-face` 的url不接受http地址作为参数，并给出了通过 [transfonter](https://transfonter.org) 将字体转为base64格式编码再引入的方案。

出于好奇，我就研究了一下这种说法。

当前iconfont的Font Class引用链接中是直接包含了字体的base64格式编码的，不需要再通过 transfonter 网站自行转换了，以上说法应该是基于旧版本的iconfont提出的。关于WXSS的 `font-face` 是否支持http地址作为字体源，我把 iconfont的 Unicode 引用代码复制到了小程序中：

``` CSS libs\style\iconfont.wxss
@font-face {
  font-family: 'iconfont';  
  src: url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.eot');
  src: url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.eot?#iefix') format('embedded-opentype'),
  url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.woff2') format('woff2'),
  url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.woff') format('woff'),
  url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.ttf') format('truetype'),
  url('//at.alicdn.com/t/font_964156_pr9i6o2kmf.svg#iconfont') format('svg');
}
```

{% note info %}
经过测试，发现在WXSS中通过url地址直接引入外部字体的方法是可行的，只是存放字体的服务器需要允许跨域。
{% endnote %}

# Symbol 方案探索

那么iconfont推荐的Symbol方案是否可行呢？

该方案需要在页面中引入JS脚本，所以需要先考虑这样一个问题：能否在小程序中直接引入外部JS脚本？

{% note info %}
答案是不能，小程序只支持通过 require 的方式引入**本地**的JS脚本。就算把Symbol的脚本下载到本地引入也没有意义，因为小程序中压根就不存在window顶级对象，也没有HTML中那一套DOM操作接口，更别提通过JS脚本插入节点元素了。所以这条路是彻底走不通的。
{% endnote %}

# 真机环境下原生组件不显示图标

我曾以为只是这样简单就可以完美解决小程序引入iconfont图标的问题了，我开开心心的在 `live-player` 组件中引用入 `cover-view` 组件和iconfont 图标来控制播放器行为：

``` html
<live-player
  id="live"
  class="live-player"
  src="{{liveStream}}"
  mode="live"
  muted="{{muted}}"
  autoplay
  bindstatechange="statechange"
  binderror="error"
  bindtap="onTapScreen"
>
  <cover-view class="tool">
    <cover-view class="left-section">
      <i class="iconfont {{playing ? 'icon-playing' : 'icon-pause'}}" bindtap="togglePlaying"></i>
      <i class="iconfont icon-refresh" bindtap="refreshLive"></i>
    </cover-view>
    <cover-view class="right-section">
      <cover-view class="switch-line" wx:for="{{liveStream}}" wx:key="unique">{{item.name}}</cover-view>
      <i class="iconfont {{muted ? 'icon-mute' : 'icon-voice'}}" bindtap="toggleVoice"></i>
      <i class="iconfont icon-full-screen" bindtap="toggleFullScreen"></i>
    </cover-view>
  </cover-view>
</live-player>
```

微信开发者工具中显示如下：

![微信开发者工具中的效果](http://yearito-1256884783.image.myqcloud.com/using-iconfont-in-miniprogram/icon-in-devtool.png "微信开发者工具中的效果")

当我在手机上预览的时候就傻了，图标居然不显示了：

![真机调试的效果](http://yearito-1256884783.image.myqcloud.com/using-iconfont-in-miniprogram/icon-in-phone.png "真机调试的效果")

测试了一下真机环境下的普通视图容器中是可以显示icon的，所以首先排除字体引入失败的可能性。

查看官方文档的时候注意到了官方的 [友情提示](https://developers.weixin.qq.com/miniprogram/dev/component/native-component.html)：

> 在工具上，原生组件是用web组件模拟的，因此很多情况并不能很好的还原真机的表现，建议开发者在使用到原生组件时尽量在真机上进行调试。

看来是 live-player 原生组件的问题。

官方对于这一块内容的 [相关描述](https://developers.weixin.qq.com/miniprogram/dev/component/native-component.html) 如下：

> 原生组件是脱离在 WebView 渲染流程外的，层级是最高的，无视其他元素的 z-index 属性。小程序为了解决原生组件层级最高的限制，专门提供了 cover-view 和 cover-image 组件，可以覆盖在部分原生组件上面。

于是我尝试将标签 `<i />` 改为 `<cover-view />` 或 `<button />`，依然没解决问题，真机下还是不显示图标。

然后我开始在社区寻找解决方案，发现还是有不少人遇到了相同的问题的。

其中有人提到是否是 cover-view 不支持伪元素，验证了一下真机环境下确实不显示 `:before` 伪元素中的 `content` 内容，看来开发者工具中对伪元素的支持确实是web组件模拟原生组件留下的副产物。

# Unicode 方案探索

为了绕开这个坑，我又尝试使用iconfont的 Unicode方案，直接在 cover-view 标签内书写 html 转义字符：

``` html
<cover-view class="icon">&#xe616;</cover-view>
```

结果转义字符直接被原封不动的显示出来了，并没有转成图标字体。

经查，小程序中不支持直接使用转义字符，只有 text 标签可以通过设置 decode 属性后来支持转义字符，并且可以解析的转义字符也及其有限：

> decode可以解析的有 `&nbsp;` `&lt;` `&gt;` `&amp;` `&apos;` `&ensp;` `&emsp;`

``` html
<!-- 转义成功 -->
<text decode="true">&lt;</text>

<!-- 转义失败，原样输出 -->
<text decode="true">&#xe616;</text>
```

{% note info %}
因此，由于小程序不支持转义字符，所以Unicode的方案也宣告失败。
{% endnote %}

最后，在一篇社区讨论贴 [cover-view中使用iconfont图标无法显示](https://developers.weixin.qq.com/community/develop/doc/000a60f7d58a982f08d7ddfc456000) 中看到了一个官方的回答：

![官方回答](http://yearito-1256884783.image.myqcloud.com/using-iconfont-in-miniprogram/official-answer.jpg "官方回答")

看来原生组件中的图标引入方案除了 cover-image 标签也别无他法了。

# 结束语

本文探索了iconfont三种引用方案在小程序中的实现可行性：

- 小程序不支持转义字符，所以Unicode方案宣告失败。
- 小程序中可以通过 `font-face` 引入外部字体，所以**Font Class方案可行**。
- 小程序不支持引入外部JS脚本，且没有DOM接口，所以Symbol方案宣告失败。

虽然 Font Class 方案可以在小程序中引入iconfont图标，但是无法应用到原生组件中，原生组件中的图标只能以图像的形式引入。

<div class="reference-linking">参考链接</div>

- [官方文档 | WXSS · 小程序](https://developers.weixin.qq.com/miniprogram/dev/framework/view/wxss.html)
- [官方文档 | 原生组件说明 · 小程序](https://developers.weixin.qq.com/miniprogram/dev/component/native-component.html)
- [微信开放社区 | cover-view中使用iconfont上的图标，真机上不显示问题](https://developers.weixin.qq.com/community/develop/doc/000084d5c9c078c79be6427b156400)
- [微信开放社区 | cover-view中使用iconfont图标无法显示](https://developers.weixin.qq.com/community/develop/doc/000a60f7d58a982f08d7ddfc456000)
