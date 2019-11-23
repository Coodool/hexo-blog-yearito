---
title: 证件照PS抠图教程
copyright: true
reward: true
rating: true
related_posts: false
date: 2019-02-20 14:08:08
tags: PS
categories:
---



该教程主要用于修改证件照背景颜色，难点在于头发的抠图处理。整个抠图过程主要分为两部分，第一部分是借助通道提取头发及其他深色部分，第二部分是通过套索选取脸部等浅色部分。

<!-- more -->

详细步骤如下：

首先，在Ps软件中打开将要处理的证件照原图，调出通道面板，依次点击红绿蓝通道，选择一个人物（主要是头发）和背景黑白反差最大的通道，拖动该通道的缩略图到右下角新建通道的图标上从而复制该通道。

![](http://qiniu.yearito.cn/ps-id-photo/image_1.jpg)

选中刚刚复制的通道，按 <kbd>Ctrl</kbd> + <kbd>L</kbd> 调出色阶调节面板，将暗部滑块右移，将亮部滑块左移，可以显著增加明暗对比。

![](http://qiniu.yearito.cn/ps-id-photo/image_2.png)

按 <kbd>B</kbd> 选择画笔工具，调整笔触大小和硬度，设置前景色为黑色，将人物主体中的高光部分涂黑，脸部等和背景色区分不明显的区域可以留待下一部分中用套索勾勒选取处理。

![](http://qiniu.yearito.cn/ps-id-photo/image_3.jpg)

按 <kbd>Ctrl</kbd> + <kbd>I</kbd>  使通道反向，按住 <kbd>Ctrl</kbd> 键点击副本通道将通道作为选取载入。

![](http://qiniu.yearito.cn/ps-id-photo/image_4.jpg)

按 <kbd>Alt</kbd> + <kbd>Ctrl</kbd> + <kbd>R</kbd> 调出调整边缘选项，适当调整参数如下，点击确定。

![](http://qiniu.yearito.cn/ps-id-photo/image_5.png)

点击RGB通道，回到图层面板，按 <kbd>Ctrl</kbd> + <kbd>J</kbd> 从选区复制背景到新图层，隐藏背景图层。

![](http://qiniu.yearito.cn/ps-id-photo/image_6.jpg)

按 <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>N</kbd> 新建一个图层，将图层命名为底色，调整图层顺序，将底色图层置于背景层之上，图层1之下，点击色板面板，吸取红色作为前景色，再按 <kbd>Alt</kbd> + <kbd>Delete</kbd> 用前景色填充图层。

![](http://qiniu.yearito.cn/ps-id-photo/image_7.jpg)

按住 <kbd>Alt</kbd> 键点击背景图层前面的显示/隐藏图层按钮，使得只有背景图层可见，按住 <kbd>Alt</kbd> 键滚动鼠标中键放大图像，按住 <kbd>Shift</kbd> + <kbd>L</kbd> 切换到磁性套索工具，点击左键生成起始锚点，然后鼠标顺着脸部边缘移动，锚点会自动生成并吸附在脸部轮廓上，如果生成了不理想的锚点，可以按 <kbd>Delete</kbd> 删除上一个锚点。

![](http://qiniu.yearito.cn/ps-id-photo/image_8.jpg)

最后，将终点连接到起点或者按 <kbd>Ctrl</kbd> 并点击左键，封闭锚点路径来生成选区。在绘制锚点路径的过程中，可以通过按 + 和-来放大或者缩小图像，也可以按 <kbd>Space</kbd> 切换到抓手工具来拖动图像的位置，这为锚点路径的精确绘制和调整带来了很大的方便。

![](http://qiniu.yearito.cn/ps-id-photo/image_9.jpg)

按 <kbd>Alt</kbd> + <kbd>Ctrl</kbd> + <kbd>R</kbd> 调出调整边缘选项，适当调整参数如下，点击确定。

![](http://qiniu.yearito.cn/ps-id-photo/image_10.jpg)

按 <kbd>Ctrl</kbd> + <kbd>J</kbd> 从选区复制背景到新图层，将新图层置于底色图层之上，图层1之下，并调整图层可见性使得除了背景图层之外的其他图层均可见。

![](http://qiniu.yearito.cn/ps-id-photo/image_11.jpg)

将图像放大，可以观察到，在发丝边缘混杂了原证件照的背景色。

![](http://qiniu.yearito.cn/ps-id-photo/image_12.jpg)


为解决这个问题，我们切换到通道面板，按住 <kbd>Ctrl</kbd> 点击绿通道副本以提取选取，再切换到图层面板，选择图层1，按 <kbd>S</kbd> 切换到仿制图章工具，调整笔触，按住 <kbd>Alt</kbd> 键点击左键在头部轮廓附近适当位置选取仿制源，然后在选区边缘的杂色区域点击左键拖动，直至发丝边缘与背景色完美融合。

![](http://qiniu.yearito.cn/ps-id-photo/image_13.jpg)

按 <kbd>Ctrl</kbd> + <kbd>D</kbd> 取消选区，按 <kbd>Ctrl</kbd> + <kbd>0</kbd> 将图像缩小到适合屏幕，删除绿副本通道，将图像导出为需要的格式，至此就完成了证件照背景色的更改。

![](http://qiniu.yearito.cn/ps-id-photo/image_14.jpg)
