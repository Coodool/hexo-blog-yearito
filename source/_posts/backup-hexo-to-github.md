---
title: 实战纪录：将Hexo站点备份到Github上
tags: Hexo
categories:
  - 技术
  - 博客
copyright: true
reward: true
rating: true
related_posts: false
date: 2018-11-29 01:20:39
---


![题图](http://yearito-1256884783.image.myqcloud.com/thumbnails/soldier-on-planet.jpg!thumbnail "Photo by Felix Hernandez Dreamphography")

博客上线后向老婆大肆炫耀，老婆连连夸赞：“好厉害好厉害，老公我也想要！”。然后我就陷入了思考，如何快速给老婆也整个博客出来？直接复制根目录然后粘贴有点太low了，万一爸爸妈妈爷爷姥姥都想要了有点难办。理想的方案是，将博客项目上传到 github 上，然后谁要就去我的仓库里 clone 一份就行了，说起来简单，实操起来还是有不少坑的，于是就有了本文。

<!-- more -->

我们在之前的文章 {% post_link hexo-deploy-to-VPS %} 中提到通过 Git 向VPS同步站点静态资源，需要注意的是，这里同步的仅仅是Hexo编译打包后生成的静态资源，也就是 public 目录下的文件。而我们整个博客项目，包括我们之前添加的脚本和样式，修改过的配置文件，都未做好容灾备份，一但项目丢失就又要花费很大一番功夫来重建。

所以，**将博客项目上传到Github上，不仅可以方便别人clone后快速建站，还能用来备份项目。**

# 准备工作

在本地根目录初始化仓库并做第一次提交：

```
$ git init
$ git add .
$ git commit -a -m "first commit"
```

在Github上新建一个空项目，然后在本地添加远程仓库地址并追踪：

```
$ git remote add origin git@github.com:Coodool/hexo-blog-yearito.git
$ git push --set-upstream origin master
$ git push
```

# Git 子模块

然后我刷新github一看，发现问题了， themes\\next\\ 目录下没有任何文件。刚开始还以为是被git忽略了，打开.gitignore一看没有相关的规则，后来查到了是和 [Submodules（子模块）](https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E5%AD%90%E6%A8%A1%E5%9D%97) 有关。简单来说，子模块就是用来在一个git项目中包含了另一个git项目时处理代码提交逻辑的，或者说为独立两个项目的开发而通过子模块来隔离两个项目的提交内容，这通常发生于在项目目录里执行了 `git clone` 命令。对于本项目来说，就是在博客项目中包含了Next主题项目。

知道了怎么回事，接下来就要解决问题：如何删除子模块将两个项目合并？

在 [How do I add files in Git to the path of a former submodule?](https://stackoverflow.com/questions/16574625/how-do-i-add-files-in-git-to-the-path-of-a-former-submodule/16581096#16581096) 里找到了正解：

```
$ git rm --cached themes\next
```

所查资料中还提到了所有的子模块都会记录在根目录下的 .gitmodules 和 .git\\config 文件中，我在项目中却没有发现 .gitmodules 文件， .git\\config 中也没有相关的子模块记录。想想可能是因为我是在 `git clone` 主题之后才执行的 `git init` 操作的吧，导致没有记录子模块。

后来注意到在本地初始化仓库后执行 `git add .` 命令的时候就已经有提示子模块的问题了，只是当时没细看：

![git add hint](http://yearito-1256884783.image.myqcloud.com/backup-hexo-to-github/git-add-hint.png "git add hint")

# 撤销提交

讲道理这个时候应该重新提交一次就完了，但作为一个有强迫症的人我怎么能容忍我的第一次提交中存在这种纰漏呢，当然要想办法撤销掉了。正常情况下，如果已经push到了远程仓库但合作开发者尚未同步提交的话，可以通过如下方法重写提交历史：

```
$ git reset HEAD^
$ git commit -a -m "message"
$ git push --force
```

{% note danger %}
一般情况下，如果push了就不要用reset来撤销提交了，否则会被同事骂猪队友的。（可以用revert）
{% endnote %}

但是这是第一次提交，`^HEAD` 不管用怎么办呢，在 [How to revert initial git commit?](https://stackoverflow.com/questions/6632191/how-to-revert-initial-git-commit) 中找到了答案：

```
$ git update-ref -d HEAD
```

然后重新提交并强推更新上去：

```
$ git push --force --set-upstream origin master
```

# 结束语

突然想到大学的时候同系一个同学用单片机控制发光二极管阵列来显示文字作为女朋友的生日礼物。大概程序员的爱情就是“老婆，这是我给你整的博客！”不过还好博客是能看得见的东西，脑补了一下搞Linux开发的momo指着shell说：“亲爱的，这是我给你买的VPS！”

哦忘记了，他女朋友是比他还大佬的程序员......

<div class="reference-linking">参考链接</div>

- [How do I add files in Git to the path of a former submodule?](https://stackoverflow.com/questions/16574625/how-do-i-add-files-in-git-to-the-path-of-a-former-submodule/16581096#16581096)
- [How to revert initial git commit?](https://stackoverflow.com/questions/6632191/how-to-revert-initial-git-commit)
