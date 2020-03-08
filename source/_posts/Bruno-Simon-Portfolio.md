---
title: 「译」Bruno Simon 作品集案例研究
tags: ThreeJS
categories:
  - 技术
  - 前端
copyright: true
reward: true
rating: true
related_posts: false
date: 2019-11-25 01:19:03
---

{% note info %}
原文链接： [Bruno Simon — Portfolio (case study)](https://medium.com/@bruno_simon/bruno-simon-portfolio-case-study-960402cc259b)
{% endnote %}

![](https://miro.medium.com/max/1076/1*L7quyJ9MJANYzZFnWGf_cQ.png)

🔗 https://bruno-simon.com

老实说，我从未想到大家会这么喜欢它（作品集），并且我至今也没搞清楚是为啥。不过我真的非常高兴以及感激我收到的这些反馈和赞美之词。

一些开发者让我解释我是如何构建它的，这只是一堆简单的技术，我将尝试在此解释清楚。

我尝试尽可能的让它更简单易懂，所以这篇文章应该对于任何一个有数字背景的人都是可读的，即使你不是一个开发者。

我希望你能喜欢这些在我作品集背后的小花絮。

<!-- more -->

# 概念

首先，我打算做一个新颖的、有趣的、可玩的以及易懂的东西。

由于我在去年里一直在用 WebGL，并且作为一个重度玩家，追求游戏概念是一个显而易见的选择。在我还是个孩子的时候，我就一直喜欢玩遥控车，并且我花了大量的时间在 PS 游戏机上玩小汽车。因此，我决定建立一个能够驾驶遥控车到处跑的世界。

一直以来我都发现在 web 中物理引擎并未充分应用，这也是为什么我想让组成我的世界的元素变成可以被撞击。

所有东西都是 3D 世界里的一部分，但是我也要想个办法来引导用户。另外，我决定不设计交互界面以提供一个尽可能沉浸式的用户体验。

至于说灵感，作为 [Gustavo Henrique](https://www.behance.net/guutv) 的粉丝，我决定通过许多平坦但略圆的边缘风格（译注：其实就是低多边形，low-poly 风格）来尝试小巧多彩的建筑群。

我一直都想让我的作品集真正成为个人的，所以我决定完全自己一个人来完成它。

尽管我知道这个项目将会花费很多时间，我也确信我能够得到很多乐趣（相信我，我花了很多时间来在小汽车上耍把戏...）。

我真正相信的是：

> 你能做的最好的游戏，就是那个你花了很长时间去玩的。

# 游戏设置

我们的体验开始于从地面弹出的世界和一个从上面坠落还带着反弹的小汽车，因此用户会注意到物理现象。

<iframe src="https://player.vimeo.com/video/372917971?app_id=122963&referrer=https%3A%2F%2Fmedium.com%2F%40bruno_simon%2Fbruno-simon-portfolio-case-study-960402cc259b" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" width="700" height="394" allowfullscreen></iframe>

唯一的文字是直接写在地面上的说明，邀请用户使用方向键来移动。（没有地方说明，但是你对于习惯于 PC 游戏的玩家 😉，你确实可以通过 WQSD 或者 ZQSD（法式键盘）来控制）。

小车的放置并非是随机选择的：我很想确保在一开始体验的时候就通过撞击标题 "BRUNO SIMON" 来最大化理解元素是可移动的。

为了帮助并引导用户到正确的方向上，我使用了一些技巧：

**瓷砖**就像一条路一样，帮助用户更好的理解在这个方向上能看到更多东西。

![](https://miro.medium.com/max/1600/1*I-OhmrHdVZI3GXMUCxKQgg.png)

**墙** 是边界。

![](https://miro.medium.com/max/1600/1*i7f_f8Ip0KaZZTcM9RqSVg.png)

**路标** 是...呃，你是知道的，就是路标 😅。

![](https://miro.medium.com/max/1600/1*WAClYpGu0XvO-hwE7W5rpQ.png)

**互动区域** 会在你开上去的时候展开，但你也可以用鼠标悬浮在上面。

<iframe src="https://player.vimeo.com/video/372946250?app_id=122963&referrer=https%3A%2F%2Fmedium.com%2F%40bruno_simon%2Fbruno-simon-portfolio-case-study-960402cc259b" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" width="700" height="394" allowfullscreen></iframe>

最后，整个世界划分成了五个区域：

- **开场** 用于学习如何驾驶
- **十字路口** 作为不同区域之间的指引和连接
- **游乐场** 里可以体验物理引擎的乐趣
- **项目** 里是我曾做过的项目（我们别忘记了这是一个作品集...）
- **补充信息** 里介绍了如何联系我

![](https://miro.medium.com/max/1037/1*oVagT0gUVBCIOwDVCy24xg.png)

在我发布我的作品集之后，其中一个被问的最多的问题就是如何在游乐场里跳起来。对于我来说使用 SHIFT 键是理所当然的，但是这对一个非游戏用户来讲并非如此。

所以我决定添加更多的指引（但是为了避免信息泛滥，这些在开场里并非是直接可见的）。

# 调试

为了找到最好的颜色、重力、速度、质量等等，有一个调试面板是很重要的。作为一个保守派的开发者，我使用了大名鼎鼎的 [Dat.GUI](http://workshop.chromeexperiments.com/examples/gui/#1--Basic-Usage)，并保留它一直到项目结束（减少了一些选项）。

![](https://miro.medium.com/max/1700/1*lF1Gt774AjKZH3ezZ3DNTw.png)

从开始一直到结束，我一直在微调这些值以寻找最佳组合。

使用这种调试工具对性能有影响，你需要确保在生产环境中完全禁掉它。一个好的技巧是只让它在特定 URL 上生效，如 https://bruno-simon.com/#debug（如果你也想试试，这个连接仍然有效）。

# 渲染

对于 WebGL 渲染，我使用了 [Three.js](https://threejs.org/)。我已经使用这个库很多年了，并且如果没有它我是没法完成这项工程的。原生的 WebGL 允许最大程度的性能优化，但是为达到同样的效果需要做很多的工作。

Samuel Honigstein ([@samsyyyy](https://twitter.com/samsyyyy)) 给我提供了一个使用 VAO (Vertex Array Object) 开发的 [优化版本](https://github.com/Samsy/threenext)，大幅降低了 WebGL 调用。

我使用了很多技巧来获得这方面的良好帧率，但我们需要理解一个重要的事情，即场景里没有灯光，也没有阴影。至少说没有 "一般意义" 上的灯光和阴影，这只是错觉而已。

## 材质捕捉

我使用一个被称为材质捕捉的很古老但很有效的技术。材质捕捉是用作为对象着色的参考的纹理。

![](https://miro.medium.com/max/1600/1*S1exU9vgdwC9CDCDN3edPw.png)

它使用相对于相机的法线来在提供的纹理上选择颜色。

这个技术的缺点你没法得到动态光线，并且如果你旋转对象，光线将会一直来源于相对于相机的同一个方向。

## 地板

地板是有一个永远填充屏幕的简单平面组成。在 JS 中创建了一个简单的 2x2 的纹理，着色器使用 UVs 来为每个角落着色，此时这些颜色就被自然的内插到整个表面。

```js
const topLeft = new THREE.Color(0x00ffff);
const topRight = new THREE.Color(0xffffff);
const bottomRight = new THREE.Color(0xff00ff);
const bottomLeft = new THREE.Color(0x0000ff);

const data = new Uint8Array([
  Math.round(bottomLeft.r * 255),
  Math.round(bottomLeft.g * 255),
  Math.round(bottomLeft.b * 255),
  Math.round(bottomRight.r * 255),
  Math.round(bottomRight.g * 255),
  Math.round(bottomRight.b * 255),
  Math.round(topLeft.r * 255),
  Math.round(topLeft.g * 255),
  Math.round(topLeft.b * 255),
  Math.round(topRight.r * 255),
  Math.round(topRight.g * 255),
  Math.round(topRight.b * 255)
]);

const backgroundTexture = new THREE.DataTexture(data, 2, 2, THREE.RGBFormat);
backgroundTexture.magFilter = THREE.LinearFilter;
backgroundTexture.needsUpdate = true;

material.uniforms.tBackground.value = backgroundTexture;
```

![](https://miro.medium.com/max/1800/1*6XmPydM51mX0703mun-2dA.png)

## 反射光

为了增加更多真实性以及更好的光线效果，我想增加反射光。由于目前几乎不可能获得具有良好帧率的真正的 WebGL 反射光，所以我需要找到一个解决方案。

因为地板是场景里最突出的形状，并且橘色也很鲜艳，所以我只在伪造了地板上的反射光。

我简单的计算了顶点到地面的距离，然后乘以绝对法线与向上轴的 [标量积](https://en.wikipedia.org/wiki/Dot_product)。基本上，简单点说就是面对地面并越靠近地面越多，橘色就越多。

<iframe src="https://cdn.embedly.com/widgets/media.html?src=https%3A%2F%2Fplayer.vimeo.com%2Fvideo%2F372937178%3Fapp_id%3D122963&dntp=1&url=https%3A%2F%2Fvimeo.com%2F372937178&image=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F830902693_960.jpg&key=a19fcc184b9711e1b4764040d3dc5c07&type=text%2Fhtml&schema=vimeo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" width="700" height="394" allowfullscreen></iframe>

## 阴影

有两种类型的阴影。

### 1—静态元素的静态阴影

我只是在 Blender 中渲染了这些阴影，然后将它们保存为 PNG-8 格式，并尽可能的充分压缩。

![](https://miro.medium.com/max/512/1*NK0m5Jy3Fq_O5-eMd3W7sA.png)

### 2—动态元素的动态阴影

这个实现起来有点技巧。我在每个移动元素下面添加了一个平面，并根据以下内容更新每个平面：

- 相关联物体的转动
- 它的位置
- 它与地面的距离
- 太阳的方向

这些平面上有阴影纹理，并且对象越高，我就更多的降低它的透明度。

<iframe src="https://cdn.embedly.com/widgets/media.html?src=https%3A%2F%2Fplayer.vimeo.com%2Fvideo%2F372938326%3Fapp_id%3D122963&dntp=1&url=https%3A%2F%2Fvimeo.com%2F372938326&image=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F830904723_1280.jpg&key=a19fcc184b9711e1b4764040d3dc5c07&type=text%2Fhtml&schema=vimeo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" width="700" height="394" allowfullscreen></iframe>

## 后期处理

为了改善样式，我在屏幕的顶部和底部添加了简单的垂直和水平模糊。

我还在左边添加了一个巨大的光斑来与假设的太阳光方向匹配，以增加更多的真实感，并带来温暖和良好的感觉。

## 相机

相机是朝着小车并随之移动的单一角度。

然后我添加了一个简单的缓动来平滑运动并使用户感觉到速度。

很多测试人员告诉我项目部分可读性不够。作为一个解决方案，在用户进入这个区的时候，我只是将相机的位置调整到小车的上方并向下看。

<iframe src="https://cdn.embedly.com/widgets/media.html?src=https%3A%2F%2Fplayer.vimeo.com%2Fvideo%2F372940557%3Fapp_id%3D122963&dntp=1&url=https%3A%2F%2Fvimeo.com%2F372940557&image=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F830907729_1280.jpg&key=a19fcc184b9711e1b4764040d3dc5c07&type=text%2Fhtml&schema=vimeo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" width="700" height="394" allowfullscreen></iframe>

我还增加了通过滚轮来缩放的特性来提供可读性。

# 物理引擎

对于物理引擎，我决定找一个 3D 引擎。一种可能的方法是使用 2D 引擎并将物体放在地板上，但是我想要更真实的感觉。

[Cannon.js](https://schteppe.github.io/cannon.js/) 是一个非常不错的库，非常有用，但是它缺乏案例，我花了很多时间在代码库上来搞清楚我应该做什么。我也在玩了几分钟的游戏后经历了掉帧。这是由于对象在默认情况下不休眠。这意味着，如果你撞了每个对象，即使你只是简单的移动，每个对象也都会在每一帧里被检测是否被碰撞。

为了简化物理引擎，我创建了原始形状来匹配更详细的模型。Cannon.js 处理这些原始形状，并且我根据原始坐标来在每一帧里更新 Three.js 世界。

<iframe src="https://player.vimeo.com/video/372941739?app_id=122963&referrer=https%3A%2F%2Fmedium.com%2F%40bruno_simon%2Fbruno-simon-portfolio-case-study-960402cc259b" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" width="700" height="394" allowfullscreen></iframe>

我在没有物理引擎的条件下进行天线动画的处理，以完全按照自己的想法进行操作。我根据小车的相对加速度来旋转天线，然后施加一个力来将它推到中心的后方。天线越远，向后推的力越强。

<iframe src="https://player.vimeo.com/video/372943565?app_id=122963&referrer=https%3A%2F%2Fmedium.com%2F%40bruno_simon%2Fbruno-simon-portfolio-case-study-960402cc259b" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" width="700" height="394" allowfullscreen></iframe>

# 建模

我使用 [Blender](https://www.blender.org/) 来做建模。我已经用了一年了，大多数情况下是 web 项目，我认为它很神奇。它不是最好用的一个，但是一旦你习惯了，它的控制、快捷键、和用户界面都很有道理。

我并非是一个 3D 专家，所以我认为这个作品集一个很好的锻炼的机会。我建模了一切：树、我自己、保龄球、我的狗...是的，我把他也放到了我的作品集里（并且顺便一说他的名字是 Sudo，希望你知道 😉）。

![](https://miro.medium.com/max/2560/1*hUCh6BPUIozDoPG-b6LAWQ.png)

在此过程中，我分别对 5 个区域和一些特定对象建模。

大多数情况下我使用 Eevee。Eevee 是 Blender 的新的实时渲染引擎，它使用 GPU，通常比 Cycles 快。不幸的是，他有一些限制，但是我的场景比较简单所以这并不是个问题。

我通过 GLTF 和 Draco 压缩来导出每个零件。在这种情况下，Draco 是一个真正的游戏规则改变者。根据几何的不同，文件可以减少 50%到 70%的体积。我用法线和碰撞图元导出模型，并尽可能减少数据。

由于技术原因，Eevee 不支持烘焙渲染。幸运的是，Eevee 和 Cycles 都有相似的渲染。我只需要切换到 Cycles 来进行那些我保存在 PNG-8 里的地板阴影的烘焙，然后使用 [tinyPNG](https://tinypng.com/) 来对它进行压缩。

# 声音

可能你已经注意到了，我并非是一个声音设计者。但是我真的觉得必须这样做才能在数字产品中获得完整的沉浸式体验。并且就像我之前说的，我想自己完成这一切 🙂。

为了增加真实感，我需要在声音中增加随机性。举个例子，在真实生活中，如果你尝试在同一个地点以同一个速度来撞击一个砖块两次，发出的声音绝不会完全一样。

我知道 [Howler.js](https://howlerjs.com/) 可以控制声音的速度，所以我决定使用它。

精确的声音如砖块掉落的声音是由以下决定的：

- 物理引擎里的碰撞检测
- 检测速度
- 在一系列多个相似的声音中播放随机一个
- 随机调整音量和速度

然后，我还增加了同时播放声音的限制来防止耳朵流血（太过刺耳）。

对于引擎，我我测试了引擎的多次重复声音，并尝试了不同的速度。

我增加了一个取决于小车加速度的速度变量。

坦白地说，对于结果我仍不是完全满意，但是我相信对于一个非声音设计者来说已经是一个好的开始了...

不幸的是，一些现代浏览器会阻止任何声音的播放，直到用户与页面互动为止，这仅限于触摸和点击（遗憾的是，没有按键交互）。这就是开始时藏在开始按钮背后的故事。但是最后，这是一个增加加载器的绝佳场合，即使整个页面都很轻。

显然，我还要为介绍这个世界找一个声音。在我找寻最佳声效的过程中，我找到了这个很酷的纸展开的声音。我尝试对它进行一点编辑，然后在声音播放时做了一个所有物体从地面升起的动画。我觉得这挺酷的。

# 细节

我是 Metal Gear Solid 系列的一个大粉丝，Hideo Kojima（MGS 的导演兼制片人）教我的一个事就是花费额外的时间在细节上，即使并非所有的用户都会注意到它们。比如：

## 背光灯

你注意到小车的尾灯会在用户倒车或踩刹车时亮起么？

<iframe src="https://player.vimeo.com/video/372943793?app_id=122963&referrer=https%3A%2F%2Fmedium.com%2F%40bruno_simon%2Fbruno-simon-portfolio-case-study-960402cc259b" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" width="700" height="394" allowfullscreen></iframe>

## 会动的标题

可能你看到了这个，页面标题是会动的。如果你往前走，emoji 小车就会往前走，反之亦然。不幸的是，标题没法以很高的频率被更新。

![](https://miro.medium.com/max/322/1*5hxIiD5LEKP3Ug7taN1SHg.gif)

## 砖墙

我通过创建简单函数来简化墙体构建，并建立不同形状的墙。并且事实上正是在这一刻我决定要添加一个游乐场区域。油门踩到底冲过墙体实在是太满足了，不能只有我一个人享受。

我增加了砖块位置的随机性来增加真实感。

<iframe src="https://player.vimeo.com/video/372945050?app_id=122963&referrer=https%3A%2F%2Fmedium.com%2F%40bruno_simon%2Fbruno-simon-portfolio-case-study-960402cc259b" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" width="700" height="394" allowfullscreen></iframe>

## 瓷砖

地面上的瓷砖用来创建道路并指引用户。我简单创建了五个瓷砖，随机的旋转他们，并确保不会有两个一样的瓷砖紧挨着。

## 彩蛋

等等...彩蛋？

# 手机

当我在手机上测试的时候我真的被惊到了，因为帧率并不是那么坏。然而，出于性能和可用性的考虑，我进行了一些优化，比如消除模糊，限制像素比，停用 Three.js 对象的矩阵自动更新。

对于控制，我增加了一些简单的按钮来控制速度以及一个操作手柄来控制转向。我知道我知道，我说了没有界面，但是对于手机来说，除此之外我找不到其他更直观的解决办法了...

# 数量

总而言之，正如很多人一直在问我的那样，这里是一些指标（至今为止）

## 3

这花费了我几个月。我主要是在晚上和周末工作。

## 2.8

整个网站的重量，并且这主要是因为项目图像。

## 160,000

第一周的访问量。

## 54

网站的平均用户留存时间

## 1,700 和 7,100

我 tweet 发文的转发和喜欢次数。这可能不多，但是是我的个人记录。

## 2F830902693_960

第一周内我获得的新的粉丝数量。

# 总结

我想感谢所有给我发送善意消息的人，以及使我日臻完善网站的 Bug 发掘者。我真的对这个作品集所带来的所有积极影响心怀感激，我觉得牺牲我这三个月的社交生活是完全**值得**的 💪。

我希望这篇文章很好理解。

祝福。
