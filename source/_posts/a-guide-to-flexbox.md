---
title: 【转】CSS3 Flexbox 布局完全指南
tags: CSS
categories:
  - 技术
  - 前端
copyright: false
reward: false
rating: false
related_posts: false
date: 2019-02-18 13:51:55
---

{% note info %}
中文原文：[CSS3 Flexbox 布局完全指南(图解 Flexbox 布局详细教程)](https://www.html.cn/archives/8629)<br />
英文原文：[A Complete Guide to Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)
{% endnote %}

Flexbox 布局（也叫Flex布局，弹性盒子布局）模块（ [W3C 候选推荐](https://www.w3.org/TR/css-flexbox/)，截止到2017年10月）旨在提供一个更有效地布局、对齐方式，并且能够使容器中的子元素大小未知或动态变化情况下仍然能够分配好子元素之间的空间。

Flex 布局的主要思想是使父容器能够调节子元素的宽度/高度（和排列顺序），从而能够最好地填充可用空间（主要是为了适应所有类型的显示设备和屏幕尺寸）。flex布容器能够放大子元素使之尽可能填充可用空间，也可以收缩子元素使之不溢出。

最重要的是，flexbox布局与方向无关，不同于常规布局（基于垂直的块（block）和基于水平的内联（inline））。 虽然传统布局适用于页面，但它们对于大型或复杂的应用程序布局来说缺乏灵活性（特别是在改变方向，调整大小，拉伸，收缩等方面）。

Flexbox布局最适合应用程序的组件和小规模布局，而 [Gird](https://www.html.cn/archives/8510) 布局则适用于较大规模的布局。

<!-- more -->

{% note warning %}
注：CSS Grid VS Flexbox 比较及适用情况可以查看 [这篇文章](https://www.html.cn/archives/8675) 中 “CSS Grid VS Flexbox VS Table 布局，比较及适用情况” 部分。
{% endnote %}

# 基础知识和术语

flexbox 布局是一个完整的布局模块而不是一个单独的属性，因此它涉及很多东西，包括它的整个属性集。 其中有的属性是在容器（container，也可以叫做父元素，称为flex container）上设置的，有的则是在容器的子元素（item，也可以叫做子元素，称为flex items）设置。

{% note warning %}
注：本文统一翻译成 “flex 容器” 和 “flex 项”
{% endnote %}

如果 “常规”布局基于 block(块) 和 inline(内联) 流动方向，flex 布局则是基于 “flex-flow(弹性流动)” 方向。请在规范中看一下这个图片，解释flex布局背后的主要思想。

![basic-terminology](https://css-tricks.com/wp-content/uploads/2018/11/00-basic-terminology.svg)

在flex布局中，flex 项（就是子元素）要么按照 main axis(主轴)（从 main-start 到 main-end ）排布，要么按照cross axis(交叉轴) (从 cross-start 到cross-end)排布。

- main axis: flex 容器的主轴，flex 项沿着主轴排布，注意主轴不一定是水平的，主轴是水平还是垂直取决于 flex-direction 属性（见下文）。
- main-start|main-end: 分别表示主轴的开始位置和结束位置，flex 项在容器中会从 main-start 到 main-end 排布。
- main size: flex 项占据主轴的宽度或高度。flex 项的 main size 属性是要么是“宽度”，要么是“高度”，这取决于主轴方向。
- cross axis: 垂直于主轴的轴线称为交叉轴，其方向取决于主轴方向。
- cross-start|cross-end: 分别表示交叉轴的开始位置和结束位置。flex 项在交叉轴上的排布从 cross-start 开始位置到 cross-end 结束位置。
- cross size: flex 项占据交叉轴的宽度或高度。flex 项的 cross size 属性是要么是“宽度”，要么是“高度”，这取决于交叉轴方向。

# 父元素属性(flex container)

<img src="https://css-tricks.com/wp-content/uploads/2018/10/01-container.svg" alt="flex container" width="50%"/>

## display

用来定义一个 flex 容器。如果设置为 `flex` 则容器呈现为块状元素，设置为 `inline-flex` 则容器呈现为行内元素。它为所有直接子元素提供了 flex 上下文。

``` css
.container {
  display: flex; /* or inline-flex */
}
```

请注意，CSS 列对 flex 容器没有影响。

## flex-direction

<img src="https://css-tricks.com/wp-content/uploads/2018/10/flex-direction.svg" alt="flex-direction" width="50%"/>

flex-direction 属性确立了主轴，从而定义了 flex 项在 flex 容器中的排布方向。 Flexbox 是单向布局，有些时候我们也称作一维布局。 可以将 flex 项视为主要沿着水平行或垂直列排布。

``` css
.container {
  flex-direction: row | row-reverse | column | column-reverse;
}
```

- `row` (默认值) :行排布。在 `ltr` (left to right， 从左到右)排版方式下，flex 项从左到右排列，在 `rtl` (right to left， 从右到左)排版方式下，flex 项从右到左排列。
- `row-reverse`: 反向行排布，即 `row` 的反方向，在 `ltr` 中从右向左，在 `rtl` 中从左到右。
- `column`: 列排布，与 `row` 相似，但是 flex 项从上到下排布。
- `column-reverse`: 反向列排布，即 `column` 反方向，与 `row-reverse` 相似，只是 flex 项从上到下排布。

## flex-wrap

<img src="https://css-tricks.com/wp-content/uploads/2018/10/flex-wrap.svg" alt="flex-wrap" width="50%"/>


默认情况下，flex 项会尽可能地尝试排在同一行上（行或列），通过设置 `flex-wrap` 来决定 flex 项是否允需要换行。

``` css
.container{
  flex-wrap: nowrap | wrap | wrap-reverse;
}
```

- `nowrap` (默认值) : 所有的 flex 项都会在同一行上排布，也就是我们常说的单行，或不换行。
- `wrap`: flex 项将从上到下根据实际情况排布再多行上，也就是我们常说的多行，或会换行。
- `wrap-reverse`: flex 项将 从下到上 根据实际情况排布再多行上折行。

这里有一些 [`flex-wrap` 的可视化示例](https://css-tricks.com/almanac/properties/f/flex-wrap/)

## flex-flow （适用于父级 flex 容器）

这是 `flex-direction` 和 `flex-wrap` 属性的缩写形式。同时定义 flex 容器的主轴和交叉轴。默认是 `row nowrap`。

``` css
flex-flow: <‘flex-direction’> || <‘flex-wrap’>
```

## justify-content

<img src="https://css-tricks.com/wp-content/uploads/2018/10/justify-content.svg" alt="justify-content" width="50%"/>

`justify-content` 属性定义了flex 项沿主轴方向的对齐方式。当一行中的所有 flex 项都是固定大小，或者是灵活大小但已经达到最大 main size 时，它可以帮助分配主轴上的剩余空间。当 flex 项溢出主轴的时候，它还可以用来控制flex 项的对齐方式。

``` css
.container {
  justify-content: flex-start | flex-end | center | space-between | space-around | space-evenly;
}
```

- `flex-start` (默认值) : flex 项从主轴的开始位置（main-start）开始排布。
- `flex-end` : flex 项从主轴的结束位置（main-end）开始排布。
- `center`: flex 项沿主轴居中排布。
- `space-between`: flex 项沿主轴均匀排布，即我们常说的沿主轴 两端对齐 ，第一个flex 项在主轴开始位置，最后一个flex 项在主轴结束位置。
- `space-around`: flex 项沿主轴均匀排布。要注意的是 flex 项看起来间隙是不均匀的，因为所有 flex 项两边的空间是相等的。第一项在容器边缘有一个单位的空间，但是在两个 flex 项之间有两个单位的间隙，因为每个 flex 项的两侧都有一个单位的间隙。
- `space-evenly`: 任何两个 flex 项之间的间距（以及到 flex 容器边缘的空间）相等。
{% note warning %}
注：该属性以前很少看到，原因是以前浏览器不支持，chrome 也是 60 版本之后才支持。延伸一下，`align-content: space-evenly` 也是这个逻辑。[Demo 示例](https://codepen.io/feiwen8772/pen/rQEoBp)。
{% endnote %}

## align-items

<img src="https://css-tricks.com/wp-content/uploads/2018/10/align-items.svg" alt="align-items" width="50%"/>

`align-items` 定义了 flex 项如何沿当前行在交叉轴上排布的默认行为。可以将其视为交叉轴（垂直于主轴）上的对齐方式。

``` css
.container {
  align-items: flex-start | flex-end | center | baseline | stretch;
}
```

- `stretch` (默认值) : 拉伸 flex 项以填充整个容器。（仍会受限于 `min-width` / `max-width` 等属性）
- `flex-start`: flex 项按照交叉轴的开始位置（cross-start）对齐。
- `flex-end`: flex 项按照交叉轴的结束位置（cross-end）对齐。
- `center`: flex 项以交叉轴为中心，居中对齐。
- `baseline`: flex 项按照他们的文字基线对齐。

## align-content

<img src="https://css-tricks.com/wp-content/uploads/2018/10/align-content.svg" alt="align-content" width="50%"/>


当交叉轴上有剩余空间时，`align-content` 可以设置 flex 容器中的 行 在交叉轴上如何分配剩余空间，类似于 `justify-content` 在主轴上对齐单个 flex 项的方式。

**注意**：当只有一行 flex 项时，此属性不起作用。

``` css
.container {
  align-content: flex-start | flex-end | center | space-between | space-around | stretch;
}
```

- flex-start：多行在容器的开始位置排布。
- flex-end：多行在容器的结束位置排布。
- center：多行在容器的总结位置排布。
- space-between：多行均匀分布；第一行分布在容器的开始位置，最后一行分布在容器的结束位置。
- space-around: 多行均匀分布，并且每行的间距（包括离容器边缘的间距）相同。
- strech (默认值)：多行拉伸以填充满整个剩余空间。

# flex 项属性 (flex items)

<img src="https://css-tricks.com/wp-content/uploads/2018/10/02-items.svg" alt="flex items" width="50%"/>

## order

<img src="https://css-tricks.com/wp-content/uploads/2018/10/order.svg" alt="order" width="50%"/>

默认情况下，flex 项按源（HTML结构）顺序排布。但是，`order` 属性可以控制它们在 flex 容器中的显示顺序。

``` css
.item {
  order: <integer>;  /* 默认值是 0 */
}
```

## flex-grow

<img src="https://css-tricks.com/wp-content/uploads/2018/10/flex-grow.svg" alt="flex-grow" width="50%"/>

`flex-grow` 定义了 flex 项在有可用剩余空间时拉伸比例。它接受的值作为比例，无单位。它规定了 flex 项应该占 flex 容器中可用空间的比例。

如果所有 flex 项的 `flex-grow` 都设置为 1 ，则父容器中的剩余空间将平均分配给所有子项。 如果其中一个子项的值为 2 ，则该子项占用的剩余空间是其他子项的两倍（或者至少会尽力获得）。

``` css
.item {
  flex-grow: <number>; /* default 0 */
}
```

注：负值对于 `flex-grow` 无效。

{% note warning %}
举个例子帮助理解：

比如我们得 flex 容器中有 6 个 flex 项，每个 flex 项的 `flex-grow` 初始值都是 1。如果我们将每个 flex 项的 `flex-grow` 相加起来，总和为 6。因此 flex 容器的总宽度被平均分成了 6 份。每个 flex 项增长到填充容器可用空间的1/6。

当我们将第 3 个 flex 项的 `flex-grow` 设置为 2 时，flex 容器现在被分成了 7 等份，因为所有 `flex-grow` 属性是：1 + 1 + 2 + 1 + 1 + 1。第 3 个 flex 项占了整个容器空间的 2/7，其他的占了 1/7。

具体可以查看 [【Flex布局教程】更多关于Flexbox布局如何工作的 – 用大彩图和GIF动画解释](https://www.html.cn/archives/7236) 中的 “属性 #2: Flex Grow（拉伸）”
{% endnote %}

## flex-shrink

`flex-shrink` 定义了 flex 项的收缩的能力。

{% note warning %}
注：与 `flex-grow` 拉伸正好相反，`flex-shrink` 决定 flex 项允许收缩多少比例。
{% endnote %}

``` css
.item {
  flex-shrink: <number>; /* default 1 */
}
```

注：负值对于 `flex-shrink` 无效。

## flex-basis

`flex-basis` 定义了在分配剩余空间之前 flex 项默认的大小。可以设置为某个长度值（e.g. 20%, 5rem等）或者关键字。关键字 `auto` 意味着 flex 项会按照其本来的大小显示（暂时由 `main-size` 关键字完成，直到弃用）。关键字 `content` 意味着根据内容来确定大小——这个关键字到目前没有被很好地支持，所以测试起来比较困难，与 `content` 的类似的关键字还有 `max-content`, `min-content`, `fit-content`。

``` css
.item {
  flex-basis: <length> | auto; /* default auto */
}
```

如果设置为 `0` , 则 flex 项内容周围的空隙不会根据 `flex-grow` 按比例分配，如果设置为 `auto`，则 flex 项周围额外的空袭会根据 `flex-grow` 按照比例分配，[如图](https://www.w3.org/TR/css-flexbox-1/images/rel-vs-abs-flex.svg)。

## flex

`flex` 是 `flex-grow`、`flex-shrink`、`flex-basis` 三个属性的缩写。其中第二个和第三个参数（`flex-shrink` 和 `flex-basis`）是可选的。默认值为 `0 1 auto`。

``` css
.item {
  flex: none | [ < 'flex-grow'> < 'flex-shrink'>? || < 'flex-basis'> ]
}
```

推荐使用缩写形式而不是单独地设置每一个属性，缩写形式中会更加智能地计算出相关值。

## align-self

<img src="https://css-tricks.com/wp-content/uploads/2018/10/align-self.svg" alt="align-self" width="50%"/>

`align-self` 属性允许某个单独的 flex 项覆盖默认的对齐方式（或由 `align-items` 指定的对齐方式）。

具体的属性值得含义可以参考 `align-items` 的解释。

``` css
.item {
  align-self: auto | flex-start | flex-end | center | baseline | stretch;
}
```

注意 `float`，`clear` 和 `vertical-align` 对 flex 项没有任何作用。


# 示例

我们从一个非常非常简单的例子开始，解决一个几乎每天会遇到的问题：水平垂直居中。如果使用flexbox 布局会非常简单。

``` css
.parent {
  display: flex;
  height: 300px; /* 随意设定大小 */
}

.child {
  width: 100px;  /* 随意设定大小，比父元素要小 */
  height: 100px; /* 同上 */
  margin: auto;  /* 见证奇迹的时刻 */
}
```

这依赖于在 flex 容器中设置 `margin` 为 `auto` 会自动吸收额外空间。 因此，设置水平垂直的 `margin` 都为 `auto` 会使flex 项在水平垂直方向上都完美居中。

现在我们考虑用更多的属性。考虑有 6 个有固定的尺寸的 flex 项，但是我们希望他们能够在改变浏览器宽度的时候仍然可以在水平轴上完美地显示（没有使用媒体查询（media queries））。

``` css
.flex-container {
  /* 首先我们先创建一个flex布局上下文 */
  display: flex;

  /* 然后我们定义flex方向和是否允许flex 项换行
   * 注意这与以下代码等价：
   * flex-direction: row;
   * flex-wrap: wrap;
   */
  flex-flow: row wrap;

  /* 然后我们定义在剩余空间上flex 项如何排布 */
  justify-content: space-around;
}
```

完成。剩下的就是一些其他样式如颜色的设置了。下面是在 CodePen 中实现的这个例子。一定要去 CodePen，并尝试调整你的窗口看看会发生什么。

<p class="codepen" data-height="500" data-theme-id="0" data-default-tab="css,result" data-user="css-tricks" data-slug-hash="EKEYob" style="height: 500px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid black; margin: 1em 0; padding: 1em;" data-pen-title="Demo Flexbox 1">
  <span>See the Pen <a href="https://codepen.io/team/css-tricks/pen/EKEYob/">
  Demo Flexbox 1</a> by CSS-Tricks (<a href="https://codepen.io/css-tricks">@css-tricks</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

让我们再尝试一些别的东西。假设我们有一个向右对齐的导航栏在我们网页的最上端，但是我们希望它在中屏上显示时为居中，在小屏上显示为单列。同样使用flex布局，实现起来会很简单。

``` css
/* 大屏 */
.navigation {
  display: flex;
  flex-flow: row wrap;
  /* 这里设置对齐主轴方向的末端 */
  justify-content: flex-end;
}

/* 中屏 */
@media all and (max-width: 800px) {
  .navigation {
    /* 当在中屏上，设置居中，并设置剩余空间环绕在flex 项左右 */
    justify-content: space-around;
  }
}

/* 小屏 */
@media all and (max-width: 500px) {
  .navigation {
    /* 在小屏上，我们不在使用行作为主轴，而以列为主轴 */
    flex-direction: column;
  }
}
```

<p class="codepen" data-height="500" data-theme-id="0" data-default-tab="result" data-user="css-tricks" data-slug-hash="YqaKYR" style="height: 500px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid black; margin: 1em 0; padding: 1em;" data-pen-title="Demo Flexbox 2">
  <span>See the Pen <a href="https://codepen.io/team/css-tricks/pen/YqaKYR/">
  Demo Flexbox 2</a> by CSS-Tricks (<a href="https://codepen.io/css-tricks">@css-tricks</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

我们通过灵活使用 flexbox 布局尝试一些更好玩的布局。来做一个移动优先的 3 列布局并带有全屏宽的header和footer。

``` css
.wrapper {
  display: flex;
  flex-flow: row wrap;
}

/* 我们要告诉所有的flex 项宽度 100% */
.wrapper > * {
  flex: 1 100%;
}

/* 移动优先依赖于源代码默认的渲染顺序
 * in this case:
 * 1. header
 * 2. nav
 * 3. main
 * 4. aside
 * 5. footer
 */

/* 中屏 */
@media all and (min-width: 600px) {
  /* 我们要告诉两边的sidebar共享一个行 */
  .aside { flex: 1 auto; }
}

/* 大屏幕 */
@media all and (min-width: 800px) {
  /* 通过order设定各个面板的渲染顺序
   * 告诉主要面板元素占用侧栏两倍的空间
   */
  .main { flex: 2 0px; }

  .aside-1 { order: 1; }
  .main    { order: 2; }
  .aside-2 { order: 3; }
  .footer  { order: 4; }
}
```

<p class="codepen" data-height="500" data-theme-id="0" data-default-tab="result" data-user="chriscoyier" data-slug-hash="vWEMWw" style="height: 500px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid black; margin: 1em 0; padding: 1em;" data-pen-title="Demo Flexbox 3">
  <span>See the Pen <a href="https://codepen.io/chriscoyier/pen/vWEMWw/">
  Demo Flexbox 3</a> by Chris Coyier  (<a href="https://codepen.io/chriscoyier">@chriscoyier</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

# 浏览器前缀

Flexbox 布局需要一些浏览器前缀来最大力度地兼容大多数的浏览器。Flex布局的前缀不只是在属性前面添加浏览器前缀，不同浏览器下的属性名和属性值都不同，这是因为Flexbox布局的标准一直在变，一共有 "old", "tweener", 和 "new" 三个版本。

可能处理前缀的最好方法是使用新的语法书写CSS并通过 Autoprefixer 运行CSS，能够很好地处理这个问题。

另外，这里有一个Sass中 `@mixin` 来处理一些前缀，也可以给你一些处理前缀的启发：

``` scss
@mixin flexbox() {
  display: -webkit-box;
  display: -moz-box;
  display: -ms-flexbox;
  display: -webkit-flex;
  display: flex;
}

@mixin flex($values) {
  -webkit-box-flex: $values;
  -moz-box-flex:  $values;
  -webkit-flex:  $values;
  -ms-flex:  $values;
  flex:  $values;
}

@mixin order($val) {
  -webkit-box-ordinal-group: $val;  
  -moz-box-ordinal-group: $val;     
  -ms-flex-order: $val;     
  -webkit-order: $val;  
  order: $val;
}

.wrapper {
  @include flexbox();
}

.item {
  @include flex(1 200px);
  @include order(2);
}
```

# 相关属性

- [A Complete Guide to Grid](https://css-tricks.com/snippets/css/complete-guide-grid/)
- 网格属性, 比如 [grid-row / grid-column](A Complete Guide to Grid)

# 其他资源

- [Flexbox in the CSS specifications](http://www.w3.org/TR/css3-flexbox/)
- [Flexbox at MDN](https://developer.mozilla.org/en-US/docs/CSS/Tutorials/Using_CSS_flexible_boxes)
- [Flexbox at Opera](http://dev.opera.com/articles/view/flexbox-basics/)
- [Diving into Flexbox by Bocoup](http://weblog.bocoup.com/dive-into-flexbox/)
- [Mixing syntaxes for best browser support on CSS-Tricks](https://css-tricks.com/using-flexbox/)
- [Flexbox by Raphael Goetter (FR)](http://www.alsacreations.com/tuto/lire/1493-css3-flexbox-layout-module.html)
- [Flexplorer by Bennett Feely](http://bennettfeely.com/flexplorer/)

# Bugs

我见过的最棒的flexbox bug总结是Philip Walton 和 Greg Whitworth的 [Flexbugs](https://github.com/philipwalton/flexbugs)，是开源的，你可以在上面跟踪动态。

# 浏览器支持

首先看一下 flexbox 布局的三个版本

- (new)是指标准中最近的语法(e.g. display:flex;)。
- (tweener)是指2011年以后非官方的临时版本(e.g. display:flexbox;)。
- (old)是指2009年以后的旧语法(e.g. display:box;)

| Chrome |	Safari | 	Firefox | Opera	 | IE	 | Android	| iOS |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 20- (old) <br/> 21+ (new) |  3.1+ (old) <br/> 3.1+ (old) | 2-21 (old) <br/> 22+ (new) | 12.1+ (new) | 10 (tweener) <br/> 11+ (new) | 2.1+ (old) <br/> 4.4+ (new) | 3.2+ (old) <br/> 7.1+ (new) |

Blackberry browser 10+ 支持新语法。

更多混合使用语法达到最佳浏览器兼容，可以参考 [这篇文章 (CSS-Tricks)](https://css-tricks.com/using-flexbox/) 或者 [这篇文章 (DevOpera)](http://dev.opera.com/articles/view/advanced-cross-browser-flexbox/#fallbacks)。
