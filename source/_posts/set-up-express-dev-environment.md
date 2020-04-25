---
title: 搭建支持热重载以及 babel 的 Express 开发环境
tags:
  - nodejs
  - express
categories:
  - 技术
  - 后端
copyright: true
reward: true
rating: true
related_posts: false
date: 2019-11-17 22:58:05
---

在搭建基于 Express 的后端 Node 服务器过程中，我有两个基本的需求：

- hotReload：热重载，一旦修改了代码之后服务器能自动重启。
- 支持 ES6 特性：能够使用一些方便的 ES6 以及 ES7 语法。

本文记录实现这两个需求的步骤。

<!-- more -->

# 热重载

对于 hotReload，可以通过 nodemon 来就监听文件的修改，然后自动重启服务器：

```
npm install -g nodemon
```

修改 npm 脚本：

```json package.json
"scripts": {
  "dev": "nodemon ./bin/www"
}
```

# ES6 特性

可以通过 babel 将代码中的 ES6 语法转换成 ES5 语法。在 nodeJS 环境中进行 ES6 代码的转换可以使用 babel-node 命令行工具，它除了有 nodeJS 的功能之外，还会在运行脚本之前对代码进行编译（编译结果存储与内存之中）。

{% centerquote %}
[@babel/node](https://babeljs.io/docs/en/babel-node)：babel-node is a CLI that works exactly the same as the Node.js CLI, with the added benefit of compiling with Babel presets and plugins before running it.
{% endcenterquote %}

安装 babel 的相关依赖

```
npm install --save-dev @babel/core @babel/cli @babel/preset-env @babel/node
```

{% note warning %}
注意：使用 ATOM 编辑器的情况下，是会阻止文件从外部被修改的，也就是说，如果打开了 package.json 文件，此时执行 `npm install --save-dev` 命令之后，package.json 的 devDependencies 字段并不会记录所安装的依赖项。
{% endnote %}

配置 babel 的预设和插件：

```json .babelrc
{
  "presets": ["@babel/preset-env"]
}
```

为了使得 babel 和 nodemon 能够配合起来使用，我们的 package.json 脚本要采用如下的配置：

```json package.json
"scripts": {
  "dev": "nodemon bin/server.js --exec babel-node"
}
```

但是，在生产环境中我们却不应该使用 babel-node，因为编译结果是保存在内存中的，这会消耗大量的内存，并且每次启动服务器时都会对整个 APP 重新执行一次编译，这将带来服务器启动时的性能损耗。

{% centerquote %}
[@babel/node](https://babeljs.io/docs/en/babel-node)：You should not be using babel-node in production. It is unnecessarily heavy, with high memory usage due to the cache being stored in memory. You will also always experience a startup performance penalty as the entire app needs to be compiled on the fly.
{% endcenterquote %}

推荐的做法是，通过 babel 命令行工具将源代码编译并保存到磁盘中，然后直接从编译后的入口启动应用：

```json package.json
"scripts": {
  "dev": "nodemon src/bin/server.js --exec babel-node",
  "build": "babel src -d dist",
  "clean": "rm -rf build/*",
  "start": "forever dist/bin/server.js"
}
```

当然，通过 Express generator 工具默认生成的项目目录中可能不是这样来组织文件结构的，我们需要将各种 js 文件归类到 src 目录下，作为 babel 的编译范围目标。另外，需要将 `/bin/www` 文件改名为 `/bin/server.js` 这种以 js 为后缀的文件名，以便 babel 识别。

<div class="reference-linking">参考链接</div>

- [@babel/node 官方文档](https://babeljs.io/docs/en/babel-node)
- [example-node-server](https://github.com/babel/example-node-server)
