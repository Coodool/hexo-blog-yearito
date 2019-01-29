---
title: 常用的Git命令及其应用场景
tags: Git
categories:
  - 技术
  - Git
copyright: true
reward: true
rating: true
related_posts: true
date: 2019-01-16 15:12:15
---

![题图](http://yearito-1256884783.image.myqcloud.com/thumbnails/room-setting.jpg!thumbnail "Photo by Lorenzo Pennati
")

Git GUI 客户端和众多IDE都已经通过图形化的操作方式集成了Git的常用功能，但作为程序员，还是应该通过命令行解决问题，知其然，知其所以然。

本文基于简单应用场景储备Git命令，持续更新...

<!-- more -->

# 提交增删行数统计

统计提交中代码行的增删情况，可以体现最近每次提交的工作量。

```
$ git log --stat
```

输出示例：

```
commit ca82a6dff817ec66f44342007202690a93763949
Author: Scott Chacon <schacon@gee-mail.com>
Date:   Mon Mar 17 21:52:11 2008 -0700

    changed the version number

 Rakefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
Author: Scott Chacon <schacon@gee-mail.com>
Date:   Sat Mar 15 16:40:33 2008 -0700

    removed unnecessary test code

 lib/simplegit.rb |    5 -----
 1 file changed, 5 deletions(-)

commit a11bef06a3f659402fe7563abf99ad00de2209e6
Author: Scott Chacon <schacon@gee-mail.com>
Date:   Sat Mar 15 10:31:28 2008 -0700

    first commit

 README           |    6 ++++++
 Rakefile         |   23 +++++++++++++++++++++++
 lib/simplegit.rb |   25 +++++++++++++++++++++++++
 3 files changed, 54 insertions(+)
```

# 图形化查看分支提交日志

命令行版的 `gitk`。

```
$ git log --oneline --all --graph --decorate
```

输出示例：

```
*   9269419 (HEAD -> master, origin/master) add hide_toc schema
|\
| *   fe1180f modify css rules
| * | c69b90a shorten post end tag
* | | 18c37d5 add css rules
| |/
|/|
* | e935db4 update about page
* | 8f76861 update post
|/
* bbe785c (release/master) update posts
*   a52bc0c fixed bug
|\
| * 20b0c15 adjust footer layout
* | 3e583ca add annotation
```
