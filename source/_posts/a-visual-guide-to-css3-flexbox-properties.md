---
title: 【转】CSS3 Flexbox 属性可视化指南
tags: CSS
categories:
  - 技术
  - 前端
copyright: false
reward: false
rating: false
related_posts: false
date: 2019-02-18 12:19:31
---

![](https://scotch-res.cloudinary.com/image/upload/w_900,q_auto:good,f_auto/media/https://scotch.io/wp-content/uploads/2015/04/A-Vusial-Guide-to-CSS3-Flexbox-Layout-and-Properties.png)

{% note info %}
中文原文：[【Flexbox布局教程】CSS3 Flexbox属性可视化指南](https://www.html.cn/archives/5744)<br />
英文原文：[A Visual Guide to CSS3 Flexbox Properties](https://scotch.io/tutorials/a-visual-guide-to-css3-flexbox-properties)
{% endnote %}

Flexbox 布局（国内很多人称为弹性布局）正式的全称为 [CSS Flexible Box](http://www.w3.org/TR/css-flexbox/) 布局模块，它是CSS3新增的一种布局模式。它可以很方便地用来改善动态或未知大小的元素的对齐，方向和顺序等等。flex容器的主要特性是它可以调整其子元素的宽度或高度去填充可用的空白区，以最优的方式达到兼容不同屏幕大小。

很多设计人员和开发人员发现使用Flexbox来布局很容易，可以使用更少的代码，更简单的方式实现更复杂的布局，也使整个开发过程更为简单。Flexbox布局算法不同于那些基于垂直或水平的块或内联布局。Flexbox布局应该用于小的应用程序组件之中，而新的CSS 网格布局模块正在兴起，来处理大规模布局。

本指南将以可视化的方式重点介绍 flex 属性是如何影响布局的，不是解释 flex 属性是如何工作。

<!-- more -->

# 基础

在我们开始介绍 flexbox属性之前，让我们先稍微介绍一下 flexbox模型。flex布局由被称为 **flex container（flex容器）** 的父容器和被称为 **flex item（flex项）** 的直接子元素构成。

在上面的图片中，您可以看到用于描述 flex container（flex容器） 及其子元素的属性和术语。关于他们意义的更多信息，请阅读 [W3C flexbox模型](https://www.w3.org/TR/css-flexbox/#box-model) 的官方文档。

{% note warning %}
注：要是看英文比较吃力，你可以查看 [《Flexbox布局（CSS3 弹性布局，Flexible Box）之 基本概念解析》](https://www.html.cn/archives/5741) 这篇文章。
{% endnote %}

从2009年的最初草案开始，flexbox布局经历了多次迭代和几个版本的语法变更，所以为了避免混乱，我们将只使用最新的工作草案（2014年9月）中的语法。如果你需要维护旧的浏览器兼容性，你可以阅读 [这篇文章](https://css-tricks.com/using-flexbox/)，了解如何以最好的方式做到这一点。

{% note warning %}
注：目前解决flexbox版本兼容性问题，一般可以使用 [Autoprefixer](https://github.com/postcss/autoprefixer) 后处理程序来实现css3代码自动补全；
如果你使用 Sass，也可以使用 `@mixin` （混入）来解决 flexbox版本兼容，推荐一个github项目：[sass-flex-mixin](https://github.com/mastastealth/sass-flex-mixin)。
{% endnote %}

浏览器对最新flexbox规范的支持情况：

- Chrome 29+
- Firefox 28+
- Internet Explorer 11+
- Opera 17+
- Safari 6.1+ (加前缀 `-webkit-`)
- Android 4.4+
- iOS 7.1+ (加前缀 `-webkit-`)

如果你需要查看更多浏览器兼容性，你可以看 [这里](http://caniuse.com/flexbox)。

# 使用

使用flexbox布局只要在父级HTML元素上设置 `display` 属性：

``` css
.flex-container {
  display: -webkit-flex; /* Safari */
  display: flex;
}
```

或者如果你想将它像一个内联元素显示使用：

``` css
.flex-container {
  display: -webkit-inline-flex; /* Safari */
  display: inline-flex;
}
```

**注意**：这是需要你在父容器上设置的唯一属性，并且其所有直接子元素将自动成为 flex item（flex项）。

有几种方法可以将 flexbox 属性进行分组，迄今为止，我发现的了解 flexbox 选项的最简单的方法是将 flexbox 属性分成 flex container（flex容器）和 flex item（flex项） 两组。下面，我们将按照这两个分组解释每个flexbox 属性是如何在视觉上影响布局的。

# Flexbox container 属性

## flex-direction

这个属性通过设置 flex container（flex容器） 的主轴方向，来指定 flex item（flex项） 在 flex container（flex容器） 中是如何布局的。flex item（flex项） 可以在两个主轴方向上排列布局，水平横向和垂直纵向两种。

属性值：

``` css
.flex-container {
  -webkit-flex-direction: row; /* Safari */
  flex-direction:         row;
}
```

值为 `row` 方向，那么在 `ltr` 上下文中，所有 flex item（flex项） 从左到右排成一行。如图：

![flexbox-flex-direction-row](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-flex-direction-row.jpg)

``` css
.flex-container {
  -webkit-flex-direction: row-reverse; /* Safari */
  flex-direction:         row-reverse;
}
```

值为 `row-reverse` 方向，那么在 `ltr` 上下文中，所有 flex item（flex项） 从右到左排成一行。如图：

![flexbox-flex-direction-row-reverse](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-flex-direction-row-reverse.jpg)


``` css
.flex-container {
  -webkit-flex-direction: column; /* Safari */
  flex-direction:         column;
}
```

值为 `column` 方向，那么所有 flex item（flex项） 从上到下排成一列。如图：

![flexbox-flex-direction-column](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-flex-direction-column.jpg)

``` css
.flex-container {
  -webkit-flex-direction: column-reverse; /* Safari */
  flex-direction:         column-reverse;
}
```

值为 `column-reverse` 方向，那么所有 flex item（flex项） 从下到上排成一列。如图：

![flexbox-flex-direction-column-reverse](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-flex-direction-column-reverse.jpg)

**默认值**： `row`

**注意**：`row` 和 `row-reverse` 的排列方式取决于 [书写模式](https://developer.mozilla.org/zh-CN/docs/Web/CSS/writing-mode)，所以如果是在 `rtl` 上下文中，它们会反向排序。

## flex-wrap

默认情况下，flexbox 理念是将容器中的所有子元素设置在一行中。`flex-wrap` 属性可以控制 flex container（flex容器） 以单行还是多行布局其flex item（flex项），以及在新行上的排列方向。

属性值：

``` css
.flex-container {
  -webkit-flex-wrap: nowrap; /* Safari */
  flex-wrap:         nowrap;
}
```

flex item（flex项） 会显示成一行，默认情况下，它们会自动伸缩，以适应 flex container（flex容器）的宽度。如图：

![flexbox-flex-wrap-nowrap](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-flex-wrap-nowrap.jpg)

``` css
.flex-container {
  -webkit-flex-wrap: wrap; /* Safari */
  flex-wrap:         wrap;
}
```

flex item（flex项）会在flex container（flex容器）中， 按照从左到右，从上到下的顺序显示成多行。如图：

![flexbox-flex-wrap-wrap](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-flex-wrap-wrap.jpg)


``` css
.flex-container {
  -webkit-flex-wrap: wrap-reverse; /* Safari */
  flex-wrap:         wrap-reverse;
}
```

flex item（flex项）会在flex container（flex容器）中， 按照从左到右，从下到上的顺序显示成多行。如图：

![flexbox-flex-wrap-wrap-reverse](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-flex-wrap-wrap-reverse.jpg)

**默认值**： `nowrap`

**注意**：这些属性取决于 [书写模式](https://developer.mozilla.org/zh-CN/docs/Web/CSS/writing-mode)，所以如果是在 `rtl` 上下文中，它们会反向排序。

## flex-flow

这个属性是设置 `flex-direction` 和 `flex-wrap` 属性的速记写法（简写或缩写）。

属性值：

``` css
.flex-container {
  -webkit-flex-flow:  || ; /* Safari */
  flex-flow:          || ;
}
```

默认值： `row` `nowrap`

## justify-content

`justify-content` 属性用来指定 flex item（flex项）在当前 flex container（flex容器）主轴线（main axis）上的对齐方式。当所有flex item（flex项）都在同一行并且不可伸缩，或是可伸缩但已经达到它们最大尺寸的时候，它可以分配主轴线（main axis）上的剩余空间。

属性值：

``` css
.flex-container {
  -webkit-justify-content: flex-start; /* Safari */
  justify-content:         flex-start;
}
```

在 `ltr` 上下文中， flex item（flex项）会在 flex container（flex容器）中靠左对齐。如图：

![flexbox-justify-content-flex-start](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-justify-content-flex-start.jpg)

``` css
.flex-container {
  -webkit-justify-content: flex-end; /* Safari */
  justify-content:         flex-end;
}
```

在 `ltr` 上下文中， flex item（flex项）会在 flex container（flex容器）中靠右对齐。如图：

![flexbox-justify-content-flex-end](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-justify-content-flex-end.jpg)

``` css
.flex-container {
  -webkit-justify-content: center; /* Safari */
  justify-content:         center;
}
```

flex item（flex项）会在 flex container（flex容器）中靠中间对齐（居中对齐）。如图：

![flexbox-justify-content-center](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-justify-content-center.jpg)

``` css
.flex-container {
  -webkit-justify-content: space-between; /* Safari */
  justify-content:         space-between;
}
```

flex item（flex项）之间以相等的间距显示，第一个和最后一个flex item（flex项）会在 flex container（flex容器）中靠两侧边缘对齐（注：类似于常说的两端对齐）。如图：

![flexbox-justify-content-space-between](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-justify-content-space-between.jpg)

``` css
.flex-container {
  -webkit-justify-content: space-around; /* Safari */
  justify-content:         space-around;
}
```

flex item（flex项）以相同的空间间隔显示，甚至第一个和最后一个flex item（flex项）。如图：

![flexbox-justify-content-space-around](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-justify-content-space-around.jpg)

默认值： `flex-start`

{% note warning %}
注：上面都是flex container（flex容器）主轴线横向的例子，即 `flex-direction:row;`，纵向的例子可以使用 `flex-direction:column;` 试试。
{% endnote %}

## align-items
flex item（flex项）可以在 flex container（flex容器）的当前交叉轴（cross axis）上对齐方式，类似于 `justify-content`，但是在垂直方向。
此属性设置所有flex item（flex项）的默认对齐方式，并且包括匿名元素。

{% note warning %}
注：`justify-content` 是设置flex item（flex项）在主轴线（main axis）上的对齐方式；`align-items` 是设置flex item（flex项）在交叉轴（cross axis）上对齐方式。
{% endnote %}

属性值：

``` css
.flex-container {
  -webkit-align-items: stretch; /* Safari */
  align-items:         stretch;
}
```

flex item（flex项）会从cross start到cross end结束，填满整个 flex container（flex容器）的高度（或宽度）。如图：

![flexbox-align-items-stretch](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-align-items-stretch.jpg)

{% note warning %}
注：这里解释一下填满整个 flex container（flex容器）的宽度的情况：
当 `flex-direction:column;` 或者 `flex-direction:column-reverse;` 时，将flex item（flex项）的宽度设置 `auto` 或者 `100%` 就可以了。
{% endnote %}


``` css
.flex-container {
  -webkit-align-items: flex-start; /* Safari */
  align-items:         flex-start;
}
```

flex item（flex项）会以flex container（flex容器） 的交叉轴起始(cross start)线对齐。如图：

![flexbox-align-items-flex-start](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-align-items-flex-start.jpg)

``` css
.flex-container {
  -webkit-align-items: flex-end; /* Safari */
  align-items:         flex-end;
}
```

flex item（flex项）会以flex container（flex容器） 的交叉轴结尾（cross end）线对齐。如图：

![flexbox-align-items-flex-end](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-align-items-flex-end.jpg)

``` css
.flex-container {
  -webkit-align-items: center; /* Safari */
  align-items: center;
}
```

flex item（flex项）会以flex container（flex容器） 的交叉轴（cross axis）的中间对齐。如图：

![flexbox-align-items-center](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-align-items-center.jpg)

``` css
.flex-container {
  -webkit-align-items: baseline; /* Safari */
  align-items:         baseline;
}
```

flex item（flex项）会按照她们的文本基线（baseline）对齐。

![flexbox-align-items-baseline](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-align-items-baseline.jpg)


{% note warning %}
注：文本基线（英语：Baseline）指的是多数字母排列的基准线,，详细说明请查看 [维基百科中关于Baseline的说明](https://zh.wikipedia.org/zh-cn/%E5%9F%BA%E7%B7%9A)
{% endnote %}

**默认值**： `stretch`

**注意**：有关于文本基线计算的更多说明可以查看 [这里](https://www.w3.org/TR/css-flexbox/#flex-baselines)。

## align-content

当flex container（flex容器）的交叉轴（cross axis）上存在多余空间（注：未被填充满）时，`align-content` 属性可以控制 flex item（flex项）在 flex container（flex容器）的交叉轴（cross axis）上的对齐方式。类似于 `justify-content` 在主轴（main axis）方向上各个 flex item（flex项）的对齐。

属性值：

``` css
.flex-container {
  -webkit-align-content: stretch; /* Safari */
  align-content:         stretch;
}
```

flex item（flex项）在每行flex item（flex项）的后面都显示分布式空间。如图：

![flexbox-align-content-stretch](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-align-content-stretch.jpg)

``` css
.flex-container {
  -webkit-align-content: flex-start; /* Safari */
  align-content:         flex-start;
}
```

flex item（flex项）会堆砌在flex container（flex容器）的交叉轴（cross axis）的起始位置上。如图：

![flexbox-align-content-flex-start](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-align-content-flex-start.jpg)

``` css
.flex-container {
  -webkit-align-content: flex-end; /* Safari */
  align-content:         flex-end;
}
```

flex item（flex项）会堆砌在 flex container（flex容器）的交叉轴（cross axis）的结束位置上。如图：

![flexbox-align-content-flex-end](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-align-content-flex-end.jpg)

``` css
.flex-container {
  -webkit-align-content: center; /* Safari */
  align-content:         center;
}
```

flex item（flex项）会堆砌在flex container（flex容器）的交叉轴（cross axis）的居中位置上。如图：

![flexbox-align-content-center](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-align-content-center.jpg)

``` css
.flex-container {
  -webkit-align-content: space-between; /* Safari */
  align-content:         space-between;
}
```

flex item（flex项）的行与行之间以相等的间隔显示，第一行和最后一行分别显示在flex container（flex容器）的交叉轴（cross axis）的两端。如图：

![flexbox-align-content-space-between](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-align-content-space-between.jpg)

``` css
.flex-container {
  -webkit-align-content: space-around; /* Safari */
  align-content:         space-around;
}
```

flex item（flex项）的每一行以相等的间隔显示。如图：

![flexbox-align-content-space-around](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-align-content-space-around.jpg)

**默认值**： `stretch`

**注意**：这个属性只有当 flex container（flex容器）有多行 flex item（flex项）时才生效，如果只有一行，那么这个属性没有效果。

## flex container（flex容器）的注意点

- 所有的 `column-*` 属性在flex container（flex容器）上都不会有效果
- `::first-line` 与 `::first-letter` 伪类在flex container（flex容器）上不会被应用。

# Flex item（flex项）的属性

## order

`order` 属性用来控制 flex container（flex容器）中 flex item（flex项）的排列顺序。默认情况下，以它们被添加到 flex container（flex容器）中的顺序排序（注：可以理解为以HTML结构的顺序排序）。

属性值：

``` css
.flex-item {
  -webkit-order: ; /* Safari */
  order:         ;
}
```

flex item（flex项）可以使用这个简单的属性重新排序，而不需要重新修改HTML代码。

![flexbox-order](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-order.jpg)

**默认值**： `0`

## flex-grow

当 flex container（flex容器）存在剩余空间时，可以用 `flex-grow` 这个属性来确定 flex item（flex项）的拉伸比例。

属性值：

``` css
.flex-item {
  -webkit-flex-grow: ; /* Safari */
  flex-grow:         ;
}
````

如果所有 flex item（flex项）具有相同的 `flex-grow` 值，那么所有 flex item（flex项）在 flex container（flex容器）中具有相同的大小。

![flexbox-flex-grow-1](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-flex-grow-1.jpg)

第二个 flex item（flex项） 相对于其他 flex item（flex项） 占用更多空间。

![flexbox-flex-grow-2](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-flex-grow-2.jpg)

**默认值**： `0`

**注意**：负数值无效。

## flex-shrink

当 flex container（flex容器）空间不足时，可以用 `flex-shrink` 这个属性来确定 flex item（flex项）的收缩比例。

属性值：

``` css
.flex-item {
  -webkit-flex-shrink: ; /* Safari */
  flex-shrink:         ;
}
```

默认情况下，所有 flex item（flex项）都可以收缩，但如果我们将它设置为 `0`（不收缩），它们将保持原来的大小。

![flexbox-flex-shrink](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-flex-shrink.jpg)

**默认值**： `1`

**注意**：负数值无效。

## flex-basis

这个属性看作width和height属性相同的值，并在 flex 伸缩比例分配剩余空间之前，指定 flex item（flex项）的初始主要大小。

{% note warning %}
注： `flex-grow` 和 `flex-shrink` 伸缩比例分配剩余空间之前。
{% endnote %}

属性值：

``` css
.flex-item {
  -webkit-flex-basis: auto | <width>; /* Safari */
  flex-basis:         auto | <width>;
}
```

`flex-basis` 指定了第4个 flex item（flex项）元素的初始大小。如图：

![flexbox-flex-basis](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-flex-basis.jpg)

**默认值**： `1`

**注意**： `auto` 值存在一个 [问题](https://www.w3.org/TR/css-flexbox/#valdef-flex-basis-main-size)，将在未来解决。

## flex

这个属性是 `flex-grow`，`flex-shrink` 和 `flex-basis` 属性的速记写法（简写或缩写）。 除了其他值，它也可以设置为 `auto`(即：`1 1 auto`)和 `none`(即：`0 0 auto`)。

``` css
.flex-item {
  -webkit-flex: none | auto | [  ? ||  ]; /* Safari */
  flex:         none | auto | [  ? ||  ];
}
```

**默认值**： `0 1 auto`

**注意**：W3C鼓励使用 flex 简写，而不是每个属性都分开写，因为速记正确地重置了未指定的属性，以适应 [常见用途](https://www.w3.org/TR/css-flexbox/#flex-common)。

## align-self

这个 `align-self` 属性允许覆盖单个的 flex item（flex项）默认对齐方式（或由 `align-items` 指定的值）。请参阅 [flex container（flex容器）的 `align-items` 说明](https://www.html.cn/archives/5744#align-items) 以了解可用的值。

属性值：

``` css
.flex-item {
  -webkit-align-self: auto | flex-start | flex-end | center | baseline | stretch; /* Safari */
  align-self:         auto | flex-start | flex-end | center | baseline | stretch;
}
```

第3和第4个 flex item（flex项）通过 `align-self` 属性覆盖了其默认的对齐方式。如图：

![flexbox-align-self](http://css88.b0.upaiyun.com/css88/2016/10/flexbox-align-self.jpg)

**默认值**： `auto`

**注意**：`align-self` 取值为 `auto` 值时，其值被计算为父级元素的 `align-items` 属性的值，或者如果元素没有父元素，那么其值为 `stretch`。

## flex item（flex项）的注意点

- `float`, `clear` 和 `vertical-align` 在flex item（flex项）上都不会起作用，也不会让它脱离文档流。

# Flexbox 演习场

这是一个 flex 演习场，在这里你可以玩完不同的flex属性，并探索flexbox布局的力量。你可以结合多个flex属性来获取更加复杂的布局。

<p class="codepen" data-height="600" data-theme-id="0" data-default-tab="result" data-user="justd" data-slug-hash="yydezN" style="height: 600px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid black; margin: 1em 0; padding: 1em;" data-pen-title="Flexbox Properties Demonstration">
  <span>See the Pen <a href="https://codepen.io/justd/pen/yydezN/">
  Flexbox Properties Demonstration</a> by Dimitar (<a href="https://codepen.io/justd">@justd</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

你也可以点击 [这里](https://demos.scotch.io/visual-guide-to-css3-flexbox-flexbox-playground/demos/) 在全屏模式下查看，或者在 [github](https://github.com/imjustd/flexbox-playground) 上获取源码。
