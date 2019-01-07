---
title: Hexo搭建个人博客系列：部署上线篇
date: 2018-11-20 20:09:55
copyright: true
reward: true
rating: true
related_posts: true
tags: Hexo
categories:
- 技术
- 博客
---

![题图](http://yearito-1256884783.image.myqcloud.com/thumbnails/dolphin.jpg!thumbnail "Photo by Felix Hernandez Dreamphography")

本文主要介绍了在将Hexo博客部署上线过程中将会遇到的一系列问题。

第一章主要介绍了将 Hexo 部署到 VPS 的方案，使得在本地推送更新后自动同步线上内容，部署过程主要分为三步走，首先从本地推送更新到远程仓库，然后触发 Git Hooks 将静态资源部署到 Web 根目录，最后启动 Nginx 服务器。

第二章主要介绍了如何分析页面加载性能瓶颈，并提供了通过CDN和代码压缩合并等方法来优化页面加载速度的方案。

第三章主要介绍了如何将站点提交到各大搜索引擎收录，并讨论了SEO相关话题。

后续章节则零散的介绍了为站点添加404页面和RSS链接。

<!-- more -->

部署个人博客主要有两种方案，一种是托管到Github Pages上，一种是部署到自己的VPS上。

对于Github Pages，优势在于完全免费，部署方便快捷，适用于新手，但一个Github账号只能用来部署一个个人站点。另外，Github服务器在国外，理论上从国内加载站点资源会有延迟，并且由于GFW的存在有时候可能访问不到站点。当然，可以通过Coding Pages来实现国内外双线部署来解决这个问题，详情可以参考网上相关教程。

对于VPS，需要独立购买域名和服务器，还需要熟悉Linux系统的基本操作，但同时也提供了更广的自由度。本篇主要介绍使用VPS部署博客的方案。

# VPS自动部署

{% note info %}
本章节参考 [荔枝 | 通过 Git Hooks 自动部署 Hexo 到 VPS](https://blog.yizhilee.com/post/deploy-hexo-to-vps/)
{% endnote %}

使用VPS部署博客的主要思路分为三步：

- `hexo deploy` 的时候通过git把 public 目录下的博客静态资源推送到远程仓库中
- 推送更新时触发 Git Hooks 将静态资源克隆到网站根目录下
- 使用 nginx 作为Web服务器提供对博客的 HTTP 访问

本文基于腾讯云 Ubuntu 16.04实现自动部署。

## 远程仓库推送

在推送静态资源之前需要做些准备工作，包括基于公钥的ssh通信以及VPS用户和权限管理。

{% note info %}
在进行下一步操作之前请先确认本地已经安装了 [Git](https://git-scm.com/) 和 [Node.js](https://nodejs.org/zh-cn/)。
{% endnote %}

为什么要实现基于公钥的ssh通信？

通常可以使用密码和公钥两种方式登陆VPS，如果在VPS上为某用户添加了授权公钥，则之后每次以该用户身份登陆或者获取授权就无须再重复输入密码了。**Hexo的git自动部署插件不支持使用密码验证授权**，所以要实现基于公钥的ssh通信。

如果尚未生成ssh公钥对，执行如下命令生成新的公钥对：

```
$ ssh-keygen
```

{% note info %}
无须设置公钥密码，否则每次通过公钥登陆的时候都要输入密码。
{% endnote %}

如果是Windows操作系统，此时会在 C:\\Users\\Username\\\.ssh\\ 目录下生成密钥文件 id_rsa 和公钥文件 id_rsa.pub。

腾讯云的默认登陆用户名为ubuntu，在设置根用户密码之前无法切换为根用户，可以通过 `sudo passwd` 命令来设置根用户密码，然后通过 `su` 命令切换到根用户身份。

以管理员权限执行如下命令新建用户并设置密码：

```
$ sudo adduser git
$ sudo passwd git
```

这一步虽然不是必须的，但一般情况下都会单独新建git用户专用于git代码同步，并将远程仓库放在git用户目录下。

为方便后续以git用户身份获取管理员权限来新建目录，此处为其添加管理员操作权限：

```
$ sudo gpasswd -a git sudo
```

{% note info %}
该命令指的是将 git 用户添加到 sudo用户组中，也就使得git用户有了sudo用户组的操作权限。
{% endnote %}

在本地Git Bash中执行如下命令将ssh公钥上传到VPS：

```
$ ssh-copy-id git@yearito.cn
```

{% note info %}
该命令会自动把默认ssh公钥id_rsa.pub中的内容拷贝到git用户目录下的 .ssh/authorized_keys文件中。
{% endnote %}

此时在本地cmd中用git用户登陆VPS将会直接成功登陆而无须输入密码：

```
$ ssh git@yearito.cn
```

在git用户目录下执行如下命令创建远程仓库：

```
$ mkdir blog.yearito.git
$ cd blog.yearito.git
$ git init --bare
```

在本地站点根目录下执行以下命令安装相关依赖：

```
$ npm install hexo-deployer-git --save
```

在本地站点配置文件中添加git远程仓库信息：

``` _config.yaml
deploy:
  type: git
  repo: git@yearito.cn:~/blog.yearito.git
```

此时在站点根目录下执行 `hexo deploy` 命令，如果最后一行出现如下提示：

> <span style="color: green">INFO</span>  Deploy done: git

则说明已经实现本地和VPS远程仓库之间的资源同步了。

{% note info %}
需要注意的是，同步的仅是 public 目录下的静态资源文件，而非整个项目目录。
{% endnote %}

如果在部署过程中出现如下提示：

> The file will have its original line endings in your working directory. <br>
warning: LF will be replaced by CRLF in tags/Hexo/index.html.

这是由 Windows 操作系统和 Linux 操作系统中行尾换行符不一致所引起的，可以通过执行 `git config core.autocrlf false` 来关闭告警。

## Git Hooks 拷贝资源

此时VPS上的远程仓库只是一个裸仓库，无法用于搭建站点服务器。所以我们需要在推送更新的同时触发Git Hooks钩子，来从远程仓库中克隆出完整的博客资源放到Web服务器根目录下。

首先创建Web根目录：

```
$ sudo mkdir /var/www/blog.yearito -p
```

{% note info %}
其中，-p 参数表示若所要建立目录的上层目录目前尚未建立，则一并建立上层目录。
{% endnote %}

然后改变Web根目录的所有者和所有工作组，以使git用户拥有对该目录的操作权限：

```
$ sudo chown git:git -R /var/www/blog.yearito
```

打开到远程仓库中的hooks目录下，默认该目录下是没有post-receive钩子文件的，直接通过 `vim post-receive` 新建该文件并添加以下代码：


``` bash ~/blog.yearito.git/hooks/post-receive
echo "post-receive hook is running..."

GIT_REPO=/home/git/blog.yearito.git
TMP_GIT_CLONE=/tmp/blog.yearito
PUBLIC_WWW=/var/www/blog.yearito

rm -rf $TMP_GIT_CLONE
git clone $GIT_REPO $TMP_GIT_CLONE
rm -rf ${PUBLIC_WWW}/*
cp -rf ${TMP_GIT_CLONE}/* ${PUBLIC_WWW}/
```

{% note info %}
为什么不直接将裸仓库克隆到Web根目录下呢？我之前也一直被这个问题困扰，感觉先克隆到 tmp 目录再拷贝到Web根目录是多此一举。后来我觉得可能是出于项目安全的考虑，在执行cp命令的时候，.git作为隐藏目录不会被拷贝到Web根目录下，也就避免了将整个仓库历史暴漏在Web服务中。
{% endnote %}

输入 `:wq` 保存并退出，此时可以看到 post-receive 文件只有读写权限，没有执行权限：

![修改 post-receive 权限前](http://yearito-1256884783.image.myqcloud.com/hexo-deploy-to-VPS/post-receive-before.png "修改 post-receive 权限前")

执行以下代码：

```
chmod +x post-receive
```

执行后可以看到 post-receive 已获得执行权限：

![修改 post-receive 权限后](http://yearito-1256884783.image.myqcloud.com/hexo-deploy-to-VPS/post-receive-after.png "修改 post-receive 权限后")

然后在本地站点目录下执行 `hexo deploy -g`，如果出现我们之前设定好的 `remote: post-receive hook is running...` 提示，且没有其他权限错误，则说明钩子正确执行了，从远程仓库拷贝资源成功，此时打开 /var/www/blog.yearito/ 目录可以看到完整的博客静态资源文件。

![Git Hooks 拷贝资源成功](http://yearito-1256884783.image.myqcloud.com/hexo-deploy-to-VPS/auto-deploy-success.png "Git Hooks 拷贝资源成功")

## 配置Nginx服务器

将静态资源部署到Web服务器根目录后，接下来要做就是通过配置Nginx来启动Web服务。

切换到根用户并安装Nginx：

```
$ apt-get install nginx
```

成功安装后可以通过 `nginx -v` 查看Nginx版本信息，以及可以通过 `service nginx status` 或者 `systemctl status nginx` 命令来查看Nginx运行状态。

修改nginx配置文件内容，启动80端口的HTTP服务到Web根目录，此处提供最简配置作为参考，读者可以在此基础上自定义：

``` nginx /etc/nginx/nginx.conf
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
  worker_connections  768;
}

http {
  include  mime.types;
  default_type  application/octet-stream;

  sendfile on;

  server {
    listen  80;
    root /var/www/blog.yearito;
  }
}
```

此时通过 `nginx -s reload` 重新加载配置文件，如果此前Nginx服务未启动，则直接执行 `nginx` 命令即可。

执行以下命令设置Nginx开机自动启动：

```
$ systemctl enable nginx
```

此外提供一些其他的Nginx语法命令：

```
nginx -s stop //强制关闭
nginx -s quit //完成当前服务后关闭
nginx -s reload //重新加载配置文件
```

在浏览器中输入VPS域名，即可打开个人博客站点，至此实现了在本地推送更新后自动同步部署线上站点内容的功能。

# 页面加载性能

博客上线后，需要关注页面的加载速度。[Google PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/) 可用于帮助分析网页加载速度瓶颈，该网站将会针对指定域名进行在线测试，并提供一份详细的页面加载分析报告，报告中还会根据页面资源加载情况给出合理的优化建议及预期优化效果，因此用户可以有的放矢的进行性能优化专项整改。

![Google PageSpeed Insights](http://yearito-1256884783.image.myqcloud.com/hexo-deploy-to-VPS/pagespeed-insights.png "Google Pagespeed Insights")

虽然可以从报告中了解到站点的加载性能瓶颈，但是，报告中仅是提供优化建议，具体的落实还须自己实施。本章节主要介绍CDN加速和代码合并压缩两种比较常见的优化方案。

## CDN加速

在控制台的Network Tab页中可以查看到页面加载瀑布流。在此需要勾选 Disable cache 以避免缓存干扰分析。另外，在所有静态资源中，对加载速度影响较大且存在大幅优化空间的主要还是JS脚本，所以我们先拿它开刀。

![页面加载瀑布流](http://yearito-1256884783.image.myqcloud.com/hexo-deploy-to-VPS/before-optimize.png "页面加载瀑布流")

首先理解一下底部信息栏中的这行文字：

> <span style="font-family: Arial">21 / 50 requests | 518 KB / 818KB transferred | Finish: 8.44 s | <span style="color: blue">DOMContentLoaded: 4.36 s</span> | <span style="color: red">Load: 6.80 s</span></span>

主要包括以下几条信息：

- 加载页面总共发起了50次请求，下载了818 KB资源，其中JS脚本资源共计518 KB，占据了21次请求。
- 在 4.36 s 时DOM树渲染完毕（蓝线），此时已经可以看到正常的页面，由于JS脚本会阻塞DOM解析，所以这段时间是包含了JS脚本的下载与执行过程的。
- 在 6.80 s 时所有资源加载完毕（红线），包括异步的脚本和其他非阻塞的页面资源，如图片、CSS文件等。
- 在 8.44 s 时所有HTTP请求响应完毕，包括XHR请求。

{% note info %}
关于 Finish / DOMContentLoaded / Load 的讨论请参见 [How to analyzing Page Speed in Chrome Dev tools](https://stackoverflow.com/questions/31729240/how-to-analyzing-page-speed-in-chrome-dev-tools) 和 [chrome devtools 中 network 一栏中的 Finish 时间代表着什么](https://segmentfault.com/q/1010000011840948/a-1020000011947156)，两者说法不一致，我倾向于认同后者的观点。
{% endnote %}

分析以上页面加载瀑布流可知，DOM树的解析渲染主要是被从VPS本地下载 jquery、velocity、fancybox 等脚本所滞后，所以对症下药，我们可以改为从开源公共CDN加载脚本。

对于在站点中用到的三方插件，在主题配置文件中为其添加CDN加载源：

``` yaml themes\next\_config.yml
vendors:
  jquery: //cdn.jsdelivr.net/npm/jquery@2.1.3/dist/jquery.min.js

  fancybox: https://cdn.jsdelivr.net/npm/@fancyapps/fancybox@3.5.2/dist/jquery.fancybox.min.js
  fancybox_css: https://cdn.jsdelivr.net/npm/@fancyapps/fancybox@3.5.2/dist/jquery.fancybox.min.css

  velocity: https://cdn.jsdelivr.net/npm/velocity-animate@1.2.1/velocity.min.js

  velocity_ui: //cdn.jsdelivr.net/npm/velocity-animate@1.2.1/velocity.ui.min.js

  fontawesome: //cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css

  algolia_instant_js: https://cdn.jsdelivr.net/npm/instantsearch.js@2.4.1/dist/instantsearch.js
  algolia_instant_css: https://cdn.jsdelivr.net/npm/instantsearch.js@2.4.1/dist/instantsearch.min.css

  pace: //cdn.jsdelivr.net/npm/pace-js@1.0.2/pace.min.js
  pace_css: //cdn.jsdelivr.net/npm/pace-js@1.0.2/themes/blue/pace-theme-minimal.css

  pangu: //cdn.jsdelivr.net/npm/pangu@3.3.0/dist/browser/pangu.min.js

  valine: https://cdn.jsdelivr.net/npm/valine@1.3.3/dist/Valine.min.js
```

{% note info %}
主题配置文件中给出的CDN链接示例的版本可能已经落后很久了，请查找并使用最新版的插件CDN链接。
{% endnote %}

比较常用的开源项目CDN服务商主要有unpkg、bootcdn、 cdnjs、jsdelivr 和 cloudflare，用户可以自行在浏览器中检测资源下载速度后做取舍。本站中主要使用 jsdelivr 提供的CDN加速服务。

使用CDN加速后页面加载瀑布流如下：

![CDN加载三方插件后的页面加载瀑布流](http://yearito-1256884783.image.myqcloud.com/hexo-deploy-to-VPS/after-optimize.png "CDN加载三方插件后的页面加载瀑布流")

DOM树的渲染完成时间缩减到了654 ms，**也就是说刷新页面后654 ms后就可以看到页面内容了，相比优化前的4.36 s 有了极大的提升**。

如果开启了Live2D看板娘，一样可以通过将脚本来源改为CDN来完成性能优化：

``` diff _config.yml
  # Live2D
  ## https://github.com/EYHN/hexo-helper-live2d
  live2d:
    enable: true
    pluginRootPath: live2dw/ # Root path of plugin to be on the site (Relative)
    pluginJsPath: lib/ # JavaScript path related to plugin's root (Relative)
    pluginModelPath: assets/ # Relative model path related to plugin's root (Relative)
-   scriptFrom: local # Default
+   scriptFrom: jsdelivr # jsdelivr CDN
    tagMode: true # Whether only to replace live2d tag instead of inject to all pages
    log: false # Whether to show logs in console
    model:
      use: live2d-widget-model-shizuku  # 萌系少女
    display:
      position: left
      width: 100
      height: 180
    mobile:
      show: false
    react:
      opacityDefault: 0.7 # 默认透明度
```

另外，我们注意到，处理 hotjar 的脚本共计耗时 5 s，那么该脚本是否影响到了页面加载性能呢？事实上没有，在HTML结构树中可以找到 hotjar 的脚本引入代码：

``` html
<script async src="https://static.hotjar.com/c/hotjar-1061283.js?sv=6"></script>
```

其中 `async` 属性意味着脚本将以异步形式加载，不会阻塞DOM树的解析和渲染。也就是说该脚本只使得 Load 的完成时间滞后，但没有影响到 DOMContentLoaded 的时间节点。

关于 Hotjar 是否会使得站点加载变慢，Hotjar 官方给出否定的回应，理由如下：

- 通过异步的方式加载脚本
- 脚本使用CDN加速
- 脚本合理利用了浏览器缓存

{% note info %}
更多详情请参考 [Will Hotjar Slow Down My Site?](https://help.hotjar.com/hc/en-us/articles/115009335727-Will-Hotjar-Slow-Down-My-Site-)
{% endnote %}

除了可以使用CDN加速三方插件外，还可以使用CDN域名加速来加速站点静态资源，包括HTML文件、CSS样式、字体文件等，具体操作方案参考VPS服务商说明文档。

CDN域名加速也有几个坑点：

- CDN缓存会导致更新站点后访问到的仍是旧版内容，需要等待缓存刷新后才能看到更新。
- 加速后就不能通过该域名建立ssh连接了，此时 `hexo deploy` 将会出现端口连接超时，可以将远程仓库地址改为真实IP地址来确保推送成功。

## 代码合并压缩

另一种优化页面加载速度的方案是通过删除注释和空格、将长变量名改为短变量名等方式压缩代码体积，从而缩短资源下载时间。

[hexo-all-minifier](https://github.com/chenzhutian/hexo-all-minifier) 插件通过集成下列插件提供一站式的资源压缩服务：

- [hexo-html-minifier](https://github.com/hexojs/hexo-html-minifier): 基于 [HTMLMinifier](https://github.com/kangax/html-minifier) 提供 HTML 压缩服务。
- [hexo-clean-css](https://github.com/hexojs/hexo-clean-css): 基于 [clean-css](https://github.com/jakubpawlowicz/clean-css) 提供 CSS 压缩服务。
- [hexo-uglify](https://github.com/hexojs/hexo-uglify): 基于 [UglifyJS](http://lisperator.net/uglifyjs/) 提供 JS 压缩服务。
- [hexo-imagemin](https://github.com/vseventer/hexo-imagemin): 基于 [imagemin](https://github.com/imagemin/imagemin) 提供图片压缩服务。

此外，该插件还可以把多个JS脚本拼接打包到一个文件中来减少HTTP请求次数，从而减少页面加载时间。

该方案从理论上来讲是有效且可行的，但是和一般的大型软件项目不同，博客项目中的主要资源是Markdown文件解析后的HTML文件，其核心是文本内容而非逻辑代码，压缩空间极其有限，在实际应用过程中效果并不明显，所以本站也就没有应用该插件功能。

# 搜索引擎

## 提交网址

{% note info %}
本节参考 [hexo高阶教程：教你怎么让你的hexo博客在搜索引擎中排第一](https://juejin.im/post/590b451a0ce46300588c43a0)
{% endnote %}

在搜索引擎中输入 site:yearito.cn，会发现暂时还搜不到自己的站点：

![谷歌搜索结果](http://yearito-1256884783.image.myqcloud.com/hexo-deploy-to-VPS/google-search-result.png "谷歌搜索结果")

想要搜到自己的站点，首先要将个人网站提交给搜索引擎收录。针对不同的搜索引擎需要分别提交网址，但提交的步骤是大同小异的：

**第一步：提交网站域名**

注意需要区分输入 http 与 https。

**第二步：验证网站所有权**

一般都包括以下三种验证方法，其本质都是通过一段字符串验证码来验证用户的网站所有权，三种方法任选其一：

- HTML文件验证：将给定的HTML文件上传到站点根目录下（验证码包含在HTML文件中）
- HTML元标签验证：在站点首页中添加给定的 `meta` 标签（验证码包含在 `meta` 标签属性中）
- CNAME验证：添加一个CNAME域名解析记录到指定站点（验证码包含在二级域名中）

Next主题中已经内置集成了各大搜索引擎的HTML元标签验证方案，用户只需获取验证码填写到主题配置文件中并重新打包部署即可完成身份验证。

**第三步：推送或者提交 sitemap**

sitemap，又称站点地图，通常是一个xml格式的文件，最早由谷歌提出，现已被多数引擎所支持。里面包含了站点内的页面列表，帮助搜索引擎理解网站内容的组织架构。

在Hexo中可以通过 [hexo-generator-sitemap](https://github.com/hexojs/hexo-generator-sitemap) 和 [hexo-generator-baidu-sitemap](https://github.com/coneycode/hexo-generator-baidu-sitemap) 两个插件帮助生成通用站点地图和百度专用站点地图文件。

在站点根目录下执行以下命令安装相关依赖：

```
$ npm install hexo-generator-sitemap --save-dev
$ npm install hexo-generator-baidu-sitemap --save-dev
```

之后在执行 `hexo generate` 打包后即可在 public 目录下找到 sitemap.xml 和 baidusitemap.xml 两个文件，将该文件提交到搜索引擎站长后台即可帮助搜索引擎分析收录站点内容，各个搜索引擎收录效率不同，可能需要耐心等上几天。

### 谷歌

在 [Google Search Console](https://search.google.com/search-console) 中提交站点域名，此时会提供几种验证网站所有权的方法，展开 **其他验证方法** 中的 **HTML 标记**，然后将 `meta` 标签的 `content` 属性值复制到主题配置文件中：

![Google 选择验证方式](http://yearito-1256884783.image.myqcloud.com/hexo-deploy-to-VPS/google-verify-site.png "Google 选择验证方式")

``` yaml themes\next\_config.yml
# Google Webmaster tools verification setting
# See: https://www.google.com/webmasters/
google_site_verification: cEGDN99xe2gtAy97He-NH4ihW3Y4GrGQl_xTxp7p3sg
```

执行 `hexo generate deploy` 重新部署站点，此时网站中就已经自动包含了用于验证身份的 `meta` 标签：

``` html
<meta name="google-site-verification" content="u9qDJxSM-SphoS5GXBhunqp1UXBY5H4FT6J1V2LxXqI" />
```

回到 Search Console 页面点击验证按钮，验证成功后将进入控制台，点击左侧 **站点地图** 菜单，在域名后输入 sitemap.xml 并提交，即可添加新的站点地图。

![添加站点地图](http://yearito-1256884783.image.myqcloud.com/hexo-deploy-to-VPS/google-add-sitemap.png "添加站点地图")

在新版的 Search Console 中只能添加站点地图，却没有删除站点地图的接口，后来在 [Google Search Console 删除站点地图方法](https://www.dear.today/731.html) 一文中发现了解决办法：需要在 [旧版 Search Console](www.google.com/webmasters/tools/sitemap-list) 中才能删除。

### 百度

在 [百度搜索资源平台](https://ziyuan.baidu.com/site) 中提交站点域名，勾选站点属性，最后一步中同样会要求验证网站的所有权身份，选择 **HTML标签验证**，然后将 `meta` 标签的 `content` 属性值复制到主题配置文件中：：

![Baidu 选择验证方式](http://yearito-1256884783.image.myqcloud.com/hexo-deploy-to-VPS/baidu-verify-site.png "Baidu 选择验证方式")

``` yaml themes\next\_config.yml
#  Webmaster tools verification setting
# See: https://ziyuan.baidu.com/site/
baidu_site_verification: UHED80Nn65
```

执行 `hexo generate deploy` 重新部署站点，此时网站中就已经自动包含了用于验证身份的 `meta` 标签：

``` html
<meta name="baidu-site-verification" content="UHED80Nn65" />
```

回到百度站长管理平台点击完成验证按钮，验证成功后将进入控制台，在左侧 **数据引入** 菜单下点击 **链接提交**，在此可以看到除了sitemap之外还提供了多种推送站点内容的方案：

- 主动推送：通过API接口推送站点内容，实时性较高
- 自动推送：在网页内添加JS脚本，每当页面被访问的时候会将页面url推送给百度，比较被动
- sitemap：填写站点地图文件地址，百度会周期性的抓取其中的内容进行分析收录，收录效率比较低
- 手动提交：手动填写链接地址进行收录

本站采用主动推送和自动推送相结合的形式推送站点内容。

#### 主动推送

Hexo中可以借助 [hexo-baidu-url-submit](https://github.com/huiwang/hexo-baidu-url-submit) 插件快捷实现主动推送，在根目录下安装相关依赖：

```
$ npm install hexo-baidu-url-submit --save
```

在站点配置文件中添加以下代码：

``` yaml _config.yml
# 百度主动推送
baidu_url_submit:
  count: 100  # 提交最新的一个链接
  host: yearito.cn  # 在百度站长平台中注册的域名
  token: xxxxx  # 请注意这是您的秘钥， 所以请不要把博客源代码发布在公众仓库里!
  path: baidu_urls.txt  # 文本文档的地址， 新链接会保存在此文本文档里
```

然后在站点配置文件中修改部署策略：

``` diff _config.yml
  # Deployment
  ## Docs: https://hexo.io/docs/deployment.html
- deploy:
-   type: git
-   repo: git@yearito.cn:~/blog.yearito.git
+ deploy:
+ - type: git
+   repo: git@yearito.cn:~/blog.yearito.git
+ - type: baidu_url_submitter # 百度
```

每次部署的时候将会自动推送网站内容到百度。

#### 自动推送

Next主题中内置了一键开启百度自动推送的选项：

``` yaml themes\next\_config.yml
# Enable baidu push so that the blog will push the url to baidu automatically which is very helpful for SEO
baidu_push: true
```

开启后将会自动在页面中添加如下脚本用于百度推送：

``` html
<script>
(function(){
  var bp = document.createElement('script');
  var curProtocol = window.location.protocol.split(':')[0];
  if (curProtocol === 'https') {
    bp.src = 'https://zz.bdstatic.com/linksubmit/push.js';
  }
  else {
    bp.src = 'http://push.zhanzhang.baidu.com/push.js';
  }
  var s = document.getElementsByTagName("script")[0];
  s.parentNode.insertBefore(bp, s);
})();
</script>
```

每次访问站点页面都会通过以上脚本推送本页url到百度。

### 必应


在 [必应网站管理员](https://www.bing.com/toolbox/webmaster) 中提交站点域名，此时可以同时输入 sitemap 文件链接，然后同样会进入网站所有权验证页面，在选择二中复制 `meta` 标签的 `content` 属性值到主题配置文件中：

![Bing 选择验证方式](http://yearito-1256884783.image.myqcloud.com/hexo-deploy-to-VPS/bing-verify-site.png "Bing 选择验证方式")

``` yaml themes\next\_config.yml
# Bing Webmaster tools verification setting
# See: https://www.bing.com/webmaster/
bing_site_verification: 538CCB61234CB4A0B1A71C4581705DCD
```

执行 `hexo generate deploy` 重新部署站点，此时网站中就已经自动包含了用于验证身份的 `meta` 标签：

``` html
<meta name="msvalidate.01" content="538CCB61234CB4A0B1A71C4581705DCD" />
```

回到网站管理员页面点击验证按钮，验证成功后将进入控制台，可以在左侧导航菜单中点击 **仪表板** -> **配置我的网站** -> ** Sitemaps** 查看已提交的站点地图文件的解析抓取情况。

## SEO

{% note info %}
本节参考 [Hexo NexT 主题SEO优化指南](https://blog.paddings.cn/2016/08/16/blog/Hexo-NexT-SEO/) 及
[SEO優化：不要使用Meta Keywords關鍵字](https://sofree.cc/meta-keywords/)
{% endnote %}

SEO（Search Engine Optimization）意指搜索引擎优化，可以帮助提高目标网站在搜索引擎中的排名，使得在别人搜索相关内容的时候更容易脱颖而出被人所发现，以提高个人站点的存在价值。

在Hexo中可以从以下几个方面进行简单的优化：

- **开启Next主题内置seo优化**

  在主题配置文件中设置 `seo: true`，将会自动部署Next内置的seo优化方案，比如在 themes\\next\\layout\\\_partials\\footer.swig 为链接添加 `rel="external nofollow"` 属性。

- **修改文章url地址格式**

  默认的文章url地址为 `http://yoursite.com/:year/:month/:day/:title/`，这种url格式层级太多，并且如果文章标题是中文的话可能会发生转义而出现一堆乱码，不利于搜索引擎的爬取分析，因此建议在站点配置中修改 `permalink` 的格式来简化页面url，并尽量采用英文命名Markdown文件。

在一些SEO优化的教程中会提到通过为页面添加 keywords 来影响搜索结果排名，事实上，在早期搜索引擎技术发展尚未成熟的时候，这样的做法确实有效，但当人们发现了这个规律后，就开始添加甚至无关的keywords来影响搜索结果排名，这一标签的滥用极大的降低了搜索引擎的准确度。随后，各大搜索引擎纷纷宣布不再将keywords作为搜索排名权重因子。

如Google就在2009年发布声明：[Google does not use the keywords meta tag in web ranking](https://webmasters.googleblog.com/2009/09/google-does-not-use-keywords-meta-tag.html)。声明中表示Google不会将keywords标签作为网页排名的依据，未来也不会改变这一政策。部分原文摘录如下：

> Our web search (the well-known search at Google.com that hundreds of millions of people use each day) disregards keyword metatags completely. They simply don't have any effect in our search ranking at present.

> Google has ignored the keywords meta tag for years and currently we see no need to change that policy.

而Bing则表示过多的keywords会被作为垃圾讯号，可能导致你的网站被归类为垃圾网站，详见[The Meta Keywords Tag Lives At Bing & Why Only Spammers Should Use It](https://searchengineland.com/the-meta-keywords-tag-lives-at-bing-why-only-spammers-should-use-it-96874)。

说起keywords，不得不提到另外一个与之相关的meta标签description。那么description是否有助于提升搜索排名呢？Google仍然给出了否定的答案：

> Even though we sometimes use the description meta tag for the snippets we show, we still don't use the description meta tag in our ranking.

虽然description不影响搜索排名，但搜索引擎通常会将description作为快照显示在搜索结果页面作为内容补充，因此合适的description还是有助于吸引读者的目光增加网站的点击率的。

![搜索结果快照](http://yearito-1256884783.image.myqcloud.com/hexo-deploy-to-VPS/search-snapshot.png "搜索结果快照")

如果页面上没有description元标签的话，搜索引擎可能会从页面中自动抓取部分内容作为页面描述，至于说抓取质量可就没法保证了。

默认情况下，Next会使用 tags 作为页面 keywords，使用文章前两百个字符作为description。如果文章页面内含有 `<!-- more -->` 内容分隔符，则会使用分隔符之前的正文 description。用户也可以在Front-Matter中添加 keywords 和 description属性来手动指定页面meta标签内容。

![keywords & description](http://yearito-1256884783.image.myqcloud.com/hexo-deploy-to-VPS/keywords-description.png "keywords & description")

越是容易被人为操控的SEO影响因子，影响力就会越来越低，所以：

{% centerquote %}最好的SEO优化是做好内容，最好的加薪办法是做好工作。{% endcenterquote %}

# 404页面

Nginx默认的404页面有些简陋，这里有两种自定义404页面的方案。

**第一种是仍沿用Hexo主题的页面框架，基于 page 布局搭建404页面。**

![基于主题布局的404页面](http://yearito-1256884783.image.myqcloud.com/hexo-deploy-to-VPS/404pages.png "基于主题布局的404页面")

在 source 目录下新建 404.md 文件，添加如下内容：

``` html source\404.md
---
comments: false
---

<p style="text-align:center; font-size: 36px">
  404 页面未找到
</p>

<p style="text-align:center">
  <a class="btn" onclick="window.history.back()">
    <i class="fa fa-angle-double-left fa-fw fa-lg"></i>
    返回
  </a>
  {% btn /, 首页, home fa-fw fa-lg %}
<p>
```

用户可以在此基础上自定义修改显示内容。

**第二种是完全抛弃掉Hexo的框架，搭建一个纯粹的自定义 404 HTML 页面。**

在 source 目录下新建 404.html 文件，自行编写页面结构与样式。你也可以直接在网上搜索404页面模板并下载使用，一般都不会太复杂，一个HTML文件就能搞定。例如 [28 HTML 404 Page Templates](https://freefrontend.com/html-css-404-page-templates/) 中就提供了很多精美的动态404页面。

此时打包的时候Hexo仍会渲染该文件，添加上复杂的主题框架与功能，用户可以修改站点配置文件以跳过渲染该文件：

``` yaml _config.yml
skip_render: 404.html
```

这样以来Hexo在打包的时候就只是将该文件复制到 public 目录下，而不做任何处理了。

以上仅仅是搭建起了404页面，至于如何在服务器返回404响应时重定向到该页面，还要依赖于Nginx的配置规则。修改VPS上的Nginx配置文件，添加一行404页面重定向规则：

``` diff /etc/nginx/nginx.conf
  http {
    include  mime.types;
    default_type  application/octet-stream;

    sendfile on;

    server {
      listen  80;
      root /var/www/blog.yearito;
+     error_page 404 /404.html;      
    }
  }
```

修改后执行 `nginx -s reload` 重新加载配置文件即可生效。

# RSS链接

什么是RSS，RSS有什么用？第一次在别人的博客搭建教程中了解到这个概念的时候，同样的问题也困扰着我。通过订阅网站RSS可以第一时间发现站点内容的更新，而不用自己跑到站点去刷新，这是一个轮询到通知的转变。

{% note  %}
虽然大致知道它的用途，但还是理解不够深刻，读者可以参考 [如何使用RSS | 阮一峰](http://www.ruanyifeng.com/blog/2006/01/rss.html) 来帮助理解这一概念。
{% endnote %}

在站点根目录下执行以下命令安装相关依赖：

```
$ npm install hexo-generator-feed --save
```

然后站点概览中就会自动出现feed链接：

![站点 feed 链接](http://yearito-1256884783.image.myqcloud.com/hexo-deploy-to-VPS/rss-feed.png "站点 feed 链接")

在主题配置文件中不需要设置rss的值，置空即可，如果设置为 `true` 反而会导致如下报错：

> [Unhandled rejection TypeError: path.substring is not a function](https://github.com/iissnan/theme-next-docs/issues/99)

# 结束语

本文介绍了在站点部署上线过程中将会遇到的各种技术问题，包括部署到VPS中的三步实现方案，优化页面加载性能的方法等。至此，Hexo搭建个人博客系列的最后一篇文章也已经完成，本站历经2个月的修修改改后也终于上线与大家见面了。如果你喜欢本站，可以在我的 [Github仓库](http://github.com/Coodool/hexo-blog-yearito) 上Fork或者Star。关于本系列文章如果有什么疑问与指正，也欢迎私信或者评论。

<div class="reference-linking">参考链接</div>

- [荔枝 | 通过 Git Hooks 自动部署 Hexo 到 VPS](https://blog.yizhilee.com/post/deploy-hexo-to-vps/)
- [How to analyzing Page Speed in Chrome Dev tools](https://stackoverflow.com/questions/31729240/how-to-analyzing-page-speed-in-chrome-dev-tools)
- [chrome devtools 中 network 一栏中的 Finish 时间代表着什么](https://segmentfault.com/q/1010000011840948/a-1020000011947156)
- [Will Hotjar Slow Down My Site?](https://help.hotjar.com/hc/en-us/articles/115009335727-Will-Hotjar-Slow-Down-My-Site-)
- [hexo高阶教程：教你怎么让你的hexo博客在搜索引擎中排第一](https://juejin.im/post/590b451a0ce46300588c43a0)
- [Hexo NexT 主题SEO优化指南](https://blog.paddings.cn/2016/08/16/blog/Hexo-NexT-SEO/)
- [SEO優化：不要使用Meta Keywords關鍵字](https://sofree.cc/meta-keywords/)
- [Google does not use the keywords meta tag in web ranking](https://webmasters.googleblog.com/2009/09/google-does-not-use-keywords-meta-tag.html)
- [如何使用RSS | 阮一峰](http://www.ruanyifeng.com/blog/2006/01/rss.html)
