---
title: Git命令行实战：谁动了我的奶酪
tags: Git
categories:
  - 技术
  - Git
copyright: true
reward: true
rating: true
related_posts: true
hide_toc: true
date: 2019-01-18 15:00:50
---

![题图](http://yearito-1256884783.image.myqcloud.com/thumbnails/boat-in-sky.jpg!thumbnail)

工作中遇到了这样一个场景：突然发现自己写的一段代码被人改过，想看看到底是谁改的，改了啥。

本文就基于以上这样一个场景预设介绍一系列相关的Git命令。

<!-- more -->

{% note info %}
首先，需要确认一下代码是真的被同事改动了，还是自己脑子瓦特了。
{% endnote %}

```
$ git blame -L start,end filename
```

- start: 代码片段起始行号
- end: 代码片段结尾行号
- filename: 文件路径

该命令会显示代码段中每一行的最后一次提交信息，包括提交的SHA1、时间、作者。

输出示例：

```
9366598e (nelson 2018-12-26 15:34:54 +0800 48)   componentDidMount() {
f07595e2 (kenny  2019-01-04 12:41:28 +0800 49)     const { schema, params } = this.props;
febe3a3b (kenny  2019-01-04 16:50:46 +0800 50)     AppActions.getGeneralOptions(schema, params);
9366598e (nelson 2018-12-26 15:34:54 +0800 51)   }
```

{% note info %}
仔细一看，果然有猫腻，中间有两行在1月4日被人改过。
{% endnote %}

`git blame` 只能看到谁在什么时间做了改动，至于具体每次提交改了啥，还得求助于 `git log` 命令来查看：

```
$ git log -L start,end:filename
```

- start: 代码片段起始行号
- end: 代码片段结尾行号
- filename: 文件路径

该命令会输出代码段中最近几次改动的diff详情。

输出示例：

``` diff
commit febe3a3b52f1603e176eca0392a7c90df781d41e                                
Author: kenny <example@gmail.com>                                              
Date:   Fri Jan 4 16:50:46 2019 +0800                                          

    commit message

diff --git a/src/components/Select/GeneralSelect.jsx b/src/components/Select/GeneralSelect.jsx
--- a/src/components/Select/GeneralSelect.jsx
+++ b/src/components/Select/GeneralSelect.jsx
@@ -48,10 +48,4 @@                                                    
   componentDidMount() {                                                       
     const { schema, params } = this.props;                                     
-
-    if( !this.state.Options?.[schema] ) {
-      AppActions.getGeneralOptions(schema, params);
-    } else {
-      this.getOptionCallback(this.state.Options[schema])
-    }
-
+    AppActions.getGeneralOptions(schema, params);
   }
```

{% note info %}
一波分析，没能猜透同事的改动意图，然后就需要跟同事正面沟通一下了。沟通结果无非就两种，要么你被他说服了，这事儿就算过了，要么他被你说服了，然后你就会遇到一个新的问题：怎么回滚历史提交中更改的代码块。我们接着往下看。
{% endnote %}

```
$ git reset  (--patch | -p) tree-ish filename
```
- tree-ish: 提交的SHA1标识
- filename: 文件路径

关于该命令，官方文档 [Git Documentation: Git Reset](https://git-scm.com/docs/git-reset#git-reset-emgitresetem--patch-plttree-ishgt--ltpathsgt82308203) 中描述如下：

> Interactively select hunks in the difference between the index and <tree-ish> (defaults to HEAD). The chosen hunks are applied in reverse to the index.

也即，该命令会比较缓存区（Index）和所指定提交（此处手动埋伏笔）之间的差异，并交互式的让用户选择代码区块并应用到缓存区（Index）中。

这里要注意两点：

1. 什么叫交互式的？
2. 应用到 **缓存区（Index）**。

首先来看第一点，什么叫交互式的？

我们来看以上命令的输出示例：

``` diff
diff --git b/src/components/Select/GeneralSelect.jsx a/src/components/Select/GeneralSelect.jsx
index b1bf5ca..73cd634 100644
--- b/src/components/Select/GeneralSelect.jsx
+++ a/src/components/Select/GeneralSelect.jsx
@@ -47,7 +47,13 @@ class GeneralSelect extends Reflux.Component {

   componentDidMount() {
     const { schema, params } = this.props;
-    AppActions.getGeneralOptions(schema, params);
+
+    if( !this.state.Options?.[schema] ) {
+      AppActions.getGeneralOptions(schema, params);
+    } else {
+      this.getOptionCallback(this.state.Options[schema])
+    }
+
   }

Apply this hunk to index [y,n,q,a,d,/,e,?]?
```

注意最后一行，命令并没有直接结束执行，而是等待用户的输入指示。此处提供了一堆可选项的缩写，如果看不懂直接输入 `?` 将会输出命令提示：

```
  y - apply this hunk to index
  n - do not apply this hunk to index
  q - quit; do not apply this hunk or any of the remaining ones
  a - apply this hunk and all later hunks in the file
  d - do not apply this hunk or any of the later hunks in the file
  g - select a hunk to go to
  / - search for a hunk matching the given regex
  j - leave this hunk undecided, see next undecided hunk
  J - leave this hunk undecided, see next hunk
  k - leave this hunk undecided, see previous undecided hunk
  K - leave this hunk undecided, see previous hunk
  s - split the current hunk into smaller hunks
  e - manually edit the current hunk
  ? - print help
```

如果是整个代码段都要回滚，直接输入 `y` 即可，如果要回滚代码段中的指定几行，就要输入 `e` 进入vim环境下的手动编辑模式了，输出示例如下：

```
# Manual hunk edit mode -- see bottom for a quick guide.
@@ -47,7 +47,13 @@ class GeneralSelect extends Reflux.Component {

   componentDidMount() {
     const { schema, params } = this.props;
-    AppActions.getGeneralOptions(schema, params);
+
+    if( !this.state.Options?.[schema] ) {
+      AppActions.getGeneralOptions(schema, params);
+    } else {
+      this.getOptionCallback(this.state.Options[schema])
+    }
+
   }


# ---
# To remove '-' lines, make them ' ' lines (context).
# To remove '+' lines, delete them.
# Lines starting with # will be removed.
#
# If the patch applies cleanly, the edited hunk will immediately be
# marked for applying.
# If it does not apply cleanly, you will be given an opportunity to
# edit again.  If all lines of the hunk are removed, then the edit is
# aborted and the hunk is left unchanged.
```

在这里只给出了部分的修改方法提示，但并不够完善，更详细的说明可以参考官方文档 [Git Documentation: EDITING PATCHES](https://git-scm.com/docs/git-add#_editing_patches)。

我们知道，在Git Diff的输出结果中：

- “-”开头表示被删除的行；
- “+”开头表示新增的行；
- 两行内容相邻又相似，第一行以 “-” 开头，第二行以 “+” 开头，表示该行发生过修改。可以理解为上面两种情况结合所衍生出的深层意义。

那么在手动编辑模式中如何阻止相应修改状态的回滚呢？对应如下：

- 取消回滚中的删除行：将 "-" 改为“  ”（空格）；
- 取消回滚中的新增行：删除掉 “+” 开头的行，或在 “+” 前添加 “#” 符号注释掉。
- 取消回滚中的修改行：将 “-” 改为“  ”（空格），并删除掉 “+” 开头的行（上面两种操作的结合）。

更进一步的，如果想要在Diff范围之外进行额外的改动怎么办？

- 删除行：将行前的“ ”（空格）改为 “-”;
- 新增行：在新增的行前添加 “+”;
- 修改行：将原行前的“ ”（空格）改为 “-”，并在其后新增以 “+” 开头的行输入更改后的行内容。

改完之后退出编辑模式，如果修改成功会直接结束命令，如果输入错误导致修改失败会提示你重新进入编辑模式或放弃回滚区块的编辑。

以上就是代码回滚时的交互式修改。

假设你回滚了代码块，然后在IDE中打开文件，发现并没有看到刚才回滚的代码块，出了什么问题呢？

此时就要提到我们上文所说的第二点了：**回滚应用到了缓存区（Index），而不是工作区（Working dir）**。

也就是说，`git reset -p` 命令并没有改变工作区，工作目录里还是原来的样子，这时如果 `git add` 从工作目录提交改动到 Index，很容易就会将之前回滚的更改又覆盖掉了。如果想要将代码回滚到工作区，还需要将代码从缓存区（Index）检出：

```
$ git checkout filename
```

至此即可完整将历史提交中的某段代码改动回滚到当前工作目录下了。

{% note info %}
插个题外话，还记不记得我们在一开始的时候手动埋下的那个伏笔，我们现在来聊聊获得指定提交的这个过程。
{% endnote %}

一般情况下，我们会使用 `git log -L` 命令来找到对应代码块是在哪一个提交中被改动的，比如说提交 `febe3a3` 中。但是这个提交中的文件内容是已经更改过的了，我们需要回滚的对象应该是这个提交的父级，也就是 `febe3a3^`，对应的命令也就是：

```
$ git reset -p febe3a3^ filename
```

执行命令后，命令行输出 No changes. 哪里出了问题呢？

后来在 [Git Documentation: Revision Selection](https://git-scm.com/book/en/v2/Git-Tools-Revision-Selection) 中发现了这样一行小提示：

> On Windows in cmd.exe, ^ is a special character and needs to be treated differently. You can either double it or put the commit reference in quotes.

也就是说，Windows 命令行中 `^` 是特殊字符，可以通过写两边或者用引号引起来来做特殊处理：

```
$ git show HEAD^     # 无效
$ git show HEAD^^    # 有效
$ git show "HEAD^"   # 有效
```

另外，也可以用 `febe3a3~` 指代父提交。`~` 和 `^` 只在有多个父提交的时候有差别，如合并提交的父提交，关于两者的差别后续会有专门篇幅讲到。

<div class="reference-linking">参考链接</div>

- [Git Documentation: Git Reset](https://git-scm.com/docs/git-reset#git-reset-emgitresetem--patch-plttree-ishgt--ltpathsgt82308203)
- [Git Documentation: EDITING PATCHES](https://git-scm.com/docs/git-add#_editing_patches)
- [Git Documentation: Revision Selection](https://git-scm.com/book/en/v2/Git-Tools-Revision-Selection)
