---
title: Sublime Text 3 快捷键汇总
tags: 快捷键
categories:
  - 工作
  - 效率
copyright: true
reward: true
rating: true
related_posts: false
date: 2019-02-19 23:52:09
---

常用 Sublime Text 3 快捷键。

<!-- more -->

# 选择类

快捷键 | 说明
:--- | :---
<kbd>Ctrl</kbd> + <kbd>D</kbd> | 选中光标所在单位上的单词，如果光标位于单词前后，重复则会选中下一个相同的单词；如果光标已选中单词，重复则会选中下一个相同的字符串（即使该字符串位于其他单词中）
<kbd>Ctrl</kbd> + <kbd>K</kbd> + <kbd>D</kbd> | 在重复 <kbd>Ctrl</kbd> + <kbd>D</kbd> 的过程中跳过单词或字符串的选择
<kbd>Alt</kbd> + <kbd>F3</kbd> | 选中文本按下快捷键，即可一次性选择全部的相同文本进行同时编辑<br />举例：快速选中并更改所有相同的变量名、函数名等
<kbd>Shift</kbd> + <kbd>Right Button</kbd> | 拖动选取用于矩形选择，功能与鼠标中键拖动相同
<kbd>Ctrl</kbd> + <kbd>L</kbd> | 选中整行，重复则扩展选择下一行，功能与 <kbd>Shift</kbd> + <kbd>↓</kbd> 相同
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>L</kbd> | 先选中多行，再按下快捷键，会在每行行尾插入光标，即可同时编辑这些行
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>M</kbd> | 扩展选中范围至匹配括号，重复则继续扩展<br />举例：快速选中删除函数中的代码，重写函数体代码或重写括号内里的内容
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Space</kbd> | 扩展选中范围至作用域，重复则继续扩展
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>J</kbd> | 扩展选中范围至缩进，重复则继续扩展（以缩进层级为依据向外层层选中）
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>A</kbd> | 扩展选中范围至标签，重复则继续扩展（一般用于html文件）
<kbd>Ctrl</kbd> + <kbd>Enter</kbd> | 在下一行插入新行，即使光标不在行尾，也能快速向下插入一行
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Enter</kbd> | 在上一行插入新行，即使光标不在行首，也能快速向上插入一行
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>[</kbd> | 选中代码，按下快捷键，折叠代码
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>]</kbd> | 选中代码，按下快捷键，展开代码
<kbd>Ctrl</kbd> + <kbd>K</kbd> + <kbd>0</kbd> / <kbd>J</kbd> | 展开所有折叠代码
<kbd>Ctrl</kbd> + <kbd>←</kbd> | 向左单位性地移动光标，快速移动光标
<kbd>Ctrl</kbd> + <kbd>→</kbd> | 向右单位性地移动光标，快速移动光标
<kbd>Shift</kbd> + <kbd>↑</kbd> | 向上选中多行
<kbd>Shift</kbd> + <kbd>↓</kbd> | 向下选中多行
<kbd>Shift</kbd> + <kbd>←</kbd> | 向左选中文本
<kbd>Shift</kbd> + <kbd>→</kbd> | 向右选中文本
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>←</kbd> | 向左单位性地选中文本
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>→</kbd> | 向右单位性地选中文本
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>↑</kbd> | 将光标所在行和上一行代码互换（将光标所在行插入到上一行之前）
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>↓</kbd> | 将光标所在行和下一行代码互换（将光标所在行插入到下一行之后）
<kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>↑</kbd> | 向上添加多行光标，用于多行编辑
<kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>↓</kbd> | 向下添加多行光标，用于多行编辑
<kbd>Ctrl</kbd> + <kbd>Left Button</kbd> | 添加多行光标，用于多行编辑

# 编辑类

快捷键 | 说明
:--- | :---
<kbd>Ctrl</kbd> + <kbd>J</kbd> | 将下一行添加到本行末尾，或将选中的多行合并为一行<br />举例：将多行格式的CSS属性合并为一行
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>V</kbd> | 粘贴时保留原有缩进
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>D</kbd> | 复制光标所在整行，插入到下一行
<kbd>Tab</kbd> | 向右缩进
<kbd>Shift</kbd> + <kbd>Tab</kbd> | 向左缩进
<kbd>Ctrl</kbd> + <kbd>[</kbd> | 整行向左缩进
<kbd>Ctrl</kbd> + <kbd>]</kbd> | 整行向右缩进
<kbd>Ctrl</kbd> + <kbd>K</kbd> + <kbd>Backspace</kbd> | 从光标处开始删除代码至行首
<kbd>Ctrl</kbd> + <kbd>K</kbd> + <kbd>K</kbd> | 从光标处开始删除代码至行尾
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>K</kbd> | 删除整行
<kbd>Ctrl</kbd> + <kbd>/</kbd> | 注释单行
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>/</kbd> | 注释多行
<kbd>Ctrl</kbd> + <kbd>K</kbd> + <kbd>U</kbd> | 转换大写
<kbd>Ctrl</kbd> + <kbd>K</kbd> + <kbd>L</kbd> | 转换小写
<kbd>Ctrl</kbd> + <kbd>T</kbd> | 左右字母互换
<kbd>Alt</kbd> + <kbd>.</kbd> | 关闭当前html标签
<kbd>F6</kbd> | 单词检测拼写

# 查找类

快捷键 | 说明
:--- | :---
<kbd>Ctrl</kbd> + <kbd>F</kbd> | 打开底部搜索框，查找关键字
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>F</kbd> | 在文件夹内的所有文件范围内查找
<kbd>F3</kbd> | 查找下一个
<kbd>Shift</kbd> + <kbd>F3</kbd> | 查找上一个
<kbd>Ctrl</kbd> + <kbd>E</kbd> | 缓存用于查找的内容，方便之后的查找
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>E</kbd> | 缓存用于替换的内容，方便之后的替换
<kbd>Ctrl</kbd> + <kbd>H</kbd> | 打开底部搜索框，替换关键字
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>H</kbd> | 依次替换关键字
<kbd>Ctrl</kbd> + <kbd>P</kbd> | 跳转到文件或定位到其他位置：<li>输入当前项目中的文件名跳转到文件</li><li>输入 @ 和关键字定位到文件中的函数</li><li>输入 ： 和数字，定位到文件中的行号</li><li>输入 # 和关键字定位到变量名、属性名
<kbd>Ctrl</kbd> + <kbd>G</kbd> | 定位到文件中的行号
<kbd>Ctrl</kbd> + <kbd>R</kbd> | 定位到文件中的函数
<kbd>Ctrl</kbd> + <kbd>:</kbd> | 定位到文件中的变量名、属性名
<kbd>Ctrl</kbd> + <kbd>F2</kbd> | 设置/取消定位标记
<kbd>F2</kbd> | 跳转到下一个定位标记处
<kbd>Shift</kbd> + <kbd>F2</kbd> | 跳转到上一个定位标记处
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>F2</kbd> | 清楚所有定位标记
<kbd>Ctrl</kbd> + <kbd>M</kbd> | 定位到匹配的括号
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> | 打开命令框。<br />举例：输入关键字，调用Sublime Text或插件的功能，如使用package安装插件
<kbd>Esc</kbd> | 退出光标多行选择，退出搜索框，命令框等

# 显示类

快捷键 | 说明
:--- | :---
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>N</kbd> | 新建程序窗口
<kbd>Ctrl</kbd> + <kbd>N</kbd> | 新建标签页
<kbd>Ctrl</kbd> + <kbd>W</kbd> | 关闭当前标签页
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd> | 关闭程序窗口
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd> | 打开最后一次关闭的标签页
<kbd>Ctrl</kbd> + <kbd>Tab</kbd> | 循环遍历标签页，功能同<kbd>Ctrl</kbd> + <kbd>PageDown</kbd>
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Tab</kbd> | 反向循环遍历标签页，功能同 <kbd>Ctrl</kbd> + <kbd>PageUp</kbd>
<kbd>Ctrl</kbd> + <kbd>PageDown</kbd> | 循环遍历标签页，功能同 <kbd>Ctrl</kbd> + <kbd>Tab</kbd>
<kbd>Ctrl</kbd> + <kbd>PageUp</kbd> | 反向循环遍历标签页，功能同 <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Tab</kbd>
<kbd>Alt</kbd> + <kbd>Num</kbd> | 聚焦于标签页Num
<kbd>Ctrl</kbd> + <kbd>Num</kbd> | 聚焦于窗格Num
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Num</kbd> | 将标签页移动至窗格Num
<kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>1</kbd> | 窗口分屏，恢复默认1屏
<kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>2</kbd> | 左右分屏-2列
<kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>3</kbd> | 左右分屏-3列
<kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>4</kbd> | 左右分屏-4列
<kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>5</kbd> | 等分4屏
<kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>8</kbd> | 垂直分屏-2行
<kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>9</kbd> | 垂直分屏-3行
<kbd>Ctrl</kbd> + <kbd>K</kbd> + <kbd>B</kbd> | 开启/关闭侧边栏
<kbd>Ctrl</kbd> + <kbd>\`</kbd> | 显示控制台
<kbd>F11</kbd> | 全屏模式
<kbd>Shift</kbd> + <kbd>F11</kbd> | 沉浸模式
