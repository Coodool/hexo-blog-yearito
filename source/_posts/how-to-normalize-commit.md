---
title: 如何规范化 commit 信息
copyright: true
reward: true
rating: true
related_posts: false
date: 2019-12-03 01:12:11
tags: CI/CD
categories:
  - 技术
  - 工程化
---

最近在考虑如何规范化团队成员的提交信息与发布流程，包括以下一些具体的需求：

- 规范 commit 信息的格式
- 版本迭代时自动打 Tag 并生成 CHAGNELOG

<!-- more -->

# 规范

在项目中，我们遵循以下规范：

## 语义化版本

{% note info%}
参考规范：[Semantic Versioning 2.0.0](https://semver.org)
{% endnote %}

版本格式为：主版本号.次版本号.修订号，版本号递增规则如下：

1. 主版本号 [MAJOR]：当你做了不兼容的 API 修改，
2. 次版本号 [MINOR]：当你做了向下兼容的功能性新增，
3. 修订号 [PATCH]：当你做了向下兼容的问题修正。
   先行版本号及版本编译元数据可以加到“主版本号.次版本号.修订号”的后面，作为延伸。

## 提交信息规范

目前社区使用最广泛的的 commit message 规范是 Conventional Commits，由 Angular Commit 规范演变而来。

<!-- 并且配备了非常全的工具：从 git commit 命令行工具 commitizen，到自动生成 CHAGNELOG 文件，以及 commitlint 规范验证工具，覆盖非常全面。 -->

{% note info%}
参考规范：[Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)
{% endnote %}

提交信息的内容结构如下：

```
<type>[optinal scope]: <description>

[optinal body]

[optional footer(s)
```

提交信息的编写规范如下：

1. fix 类型的提交表示在代码库中修复了一个 bug（和语义化版本中的 `PATCH` 相对应）。
2. feat 类型的提交表示在代码库中新增了一个功能（和语义化版本中的 `MINOR` 相对应）。
3. 在正文或脚注的起始位置带有 `BREAKING CHANGE` 表示引入了破坏性 API 变更（和语义化版本中的 `MAJOR` 相对应）。
4. 允许除 fix 和 feat 外的其他类型，如基于 [Angular convention](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines) 的 [@commitlint/config-conventional](https://github.com/conventional-changelog/commitlint/tree/master/%40commitlint/config-conventional) 就推荐了 `build` `chore` `ci` `docs` `style` `refactor` `perf` `test` 等类型。

额外的类型并非是由 conventional commits 强制约束的，并且对于语义化版本无影响（除非包含 BREAKING CHANGE）。

为什么使用 conventional commits？

- 自动化生成 CHAGNELOG。
- 基于提交的类型，自动决定语义化的版本变更。
- 向同事、公众与其他利益关系者传达变化的性质。
- 触发构建和部署流程。
- 让提交历史更加结构化，以便人们对你的项目做出贡献。

说完了规范，我们需要了解如何确保规范 **高效**、**准确** 的执行。

以我们团队目前的现状为例：

1. 虽然提出了 commit 信息的提交规范，但在执行上还是不彻底，如经常出现中英文冒号混用的情况
2. 迭代版本号由人工计算，容易出现纰漏
3. 每次版本迭代时需要手动整理 commit 信息来生成 ChangeLog

所以，在敏捷的开发流程中，一切能够被自动化所取代的人工，都应该被取代。

![](https://blobscdn.gitbook.com/v0/b/gitbook-28427.appspot.com/o/assets%2F-LGsE7zdvzHI5cG-XV6p%2F-LgZJHU7wjHywLK9p0Mz%2F-LSqFWM0RYcz0dv1n7Oc%2Fbender.png?generation=1559682450938503&alt=media)

# 约束提交信息

明文约定是最简单的规范约束了，可以将提交规范写在 `CONTRIBUTING.md` 中，也可以写在 commit template 中，但这种方案依赖于主观意识，约束力很弱，所以有必要借助工具来强制执行。

## 借助工具规范化提交

[commitizen](https://github.com/commitizen/cz-cli) 是最常用的规范化提交工具，它提供的 `git cz` 命令可以取代 `git commit` 命令，来接管你的提交流程，并引导你完成一次合格的符合规范的代码提交。

首先全局安装 commitizen 命令行工具：

```
npm install -g commitizen
```

然后我们需要选择适配器（Adaptor），也即是指定具体的提交规范。举个例子，如果我们的项目要采用 AngularJS 的提交规范，那么我们需要安装如下适配器：

```
commitizen init cz-conventional-changelog --save-dev --save-exact
```

这行命令将会做三件事：

1. 安装 `cz-conventional-changelog` 适配器
2. 将依赖关系保存在 `package.json` 中
3. 在 `package.json` 添加跟属性，如下：

```js package.json
"config": {
  "commitizen": {
    "path": "cz-conventional-changelog"
  }
}
```

此时执行 `git cz` 命令即可看到 conventional-changelog 适配器已经生效了：

![](http://qiniu.yearito.cn/how-to-normalize-commit/commitizen.jpg)

## 可定制的适配器

如果不习惯于 AngularJS 的这套规范，那么我们可以选择 [cz-customizable](https://github.com/leonardoanalista/cz-customizable) 适配器，通过修改配置文件的方式来制定符合本团队的的提交规范。

```
npm install --save-dev cz-customizable
```

修改配置文件以使用 `cz-customizable` 作为适配器：

```js package.json
"config": {
  "commitizen": {
    "path": "node_modules/cz-customizable"
  }
}
```

在项目根目录下新建 `.cz-config.js` 文件作为规范配置文件，并在 [官方案例](https://github.com/leonardoanalista/cz-customizable/blob/master/cz-config-EXAMPLE.js) 的基础上进行修改（[配置选项释义](https://github.com/leonardoanalista/cz-customizable#options)）：

```js .cz-config.js
module.exports = {
  types: [
    { value: "feat", name: "✨ feat: A new feature" },
    { value: "fix", name: "🐞 fix: A bug fix" },
    { value: "docs", name: "📖 docs: Documentation only changes" },
    {
      value: "style",
      name:
        "👚 style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)"
    },
    {
      value: "refactor",
      name:
        "🛠 refactor: A code change that neither fixes a bug nor adds a feature"
    },
    {
      value: "perf",
      name: "🚀 perf: A code change that improves performance"
    },
    { value: "test", name: "💊 test: Adding missing tests" },
    {
      value: "chore",
      name:
        "🗯 chore: Changes to the build process or auxiliary tools and libraries such as documentation generation"
    },
    { value: "revert", name: "⏪ revert: Revert to a commit" },
    { value: "WIP", name: "💪 WIP: Work in progress" }
  ],

  scopes: [],

  allowTicketNumber: false,
  isTicketNumberRequired: false,
  ticketNumberPrefix: "ISSUES-CLOSED",
  ticketNumberRegExp: "\\d{1,5}",

  // override the messages, defaults are as follows
  messages: {
    type: "Select the type of change that you're committing:",
    scope: "\nDenote the SCOPE of this change (optional):",
    // used if allowCustomScopes is true
    customScope: "Denote the SCOPE of this change:",
    subject: "Write a SHORT, IMPERATIVE tense description of the change:\n",
    body:
      'Provide a LONGER description of the change (optional). Use "|" to break new line:\n',
    breaking: "List any BREAKING CHANGES (optional):\n",
    footer:
      "List any ISSUES CLOSED by this change (optional). E.g.: #31, #34:\n",
    confirmCommit: "Are you sure you want to proceed with the commit above?"
  },

  allowCustomScopes: true,
  allowBreakingChanges: ["feat", "fix"],
  // skip any questions you want
  skipQuestions: ["scope", "customScope", "body"],

  // limit subject length
  subjectLimit: 100
  // breaklineChar: '|', // It is supported for fields body and footer.
  // footerPrefix : 'ISSUES CLOS  ED:'
  // askForBreakingChangeFirst : true, // default is false
};
```

## 自定义适配器

如果连自定义适配器都无法满足你的需求了，则可以考虑自己写一个适配器。

先随便 fork 一个适配器到本地，如：

```
git clone git@github.com:Coodool/cz-conventional-changelog.git
```

根据业务修改 `engine.js` 中的各项交互细节和提交规范，发布到 npm 中，然后就和使用其他适配器的方法一样了。

## 内置到 git 工作流中

使用 `git cz` 来替代 `git commit`，看起来不太优雅，有没有办法在通过 `git commit` 提交的时候也能启动 `commitizen` 呢？这样一来，就能确保所有的提交者都必须通过 `commitizen` 来提交了。

我们可以通过 git hooks 和 `--hook` 选项来介入到提交信息流程中，将 `commitizen` 合并到原生的 git 工作流中。这里有两个方案可供选择：

### git hooks

```bash .git/hooks/prepare-commit-msg
#!/bin/bash
+ exec < /dev/tty && node_modules/.bin/git-cz --hook || true
```

### Husky

[Husky](https://github.com/typicode/husky) 提供了一种更方便的处理 git hooks 的方式：

```
npm install --save-dev husky
```

```js package.json
"husky": {
  "hooks": {
    "prepare-commit-msg": "exec < /dev/tty && git cz --hook || true",
  }
}
```

{% note %}
为什么使用 `exec < /dev/tty` 呢？因为默认情况下 git hooks 不是交互式的，这个命令允许用户使用终端与 commitizen 进行交互。
{% endnote %}

## 校验提交信息

`commitizen` 可以帮我们规范提交信息，但它并没有强制约束力。我们可以使用 `conventional-changelog` 生态中的 [commitlint](https://github.com/conventional-changelog/commitlint) 来校验提交信息。

```
npm install --save-dev @commitlint/config-conventional @commitlint/cli
```

其中，`@commitlint/cli` 是命令行工具，`@commitlint/config-conventional` 是推荐的默认规范（基于 Angular 规范）。

相关配置项可以写在如下两个地方：

- 在 `package.json` 中添加 `commitlint` 属性
- 在根目录下添加 `commitlint.config.js` `.commitlintrc.js` `.commitlintrc.json` 或 `.commitlintrc.yml` 文件

```js
module.exports = {
  extends: ["@commitlint/config-conventional"], //继承已有的配置规则
  parserPreset: String,  //解析器
  formatter: String, //格式化输出
  rules Object, //具体的校验规则
  ignores: [Function], //如果需要忽略提交信息，则函数返回True
  defaultIgnores: Boolean //是否使用默认的忽略规则
};
```

`rules` 的配置手册请参见 [reference-rules.md](https://github.com/conventional-changelog/commitlint/blob/master/docs/reference-rules.md)

借助 `husky` 来添加 git hooks，即可在提交信息的时候自动启动 `commitlint`

```json package.json
{
  "husky": {
    "hooks": {
      "commit-msg": "commitlint -E HUSKY_GIT_PARAMS"
    }
  }
}
```

{% note info %}
更多使用说明请参考 [commitlint.js.org](https://commitlint.js.org/)
{% endnote %}

# 规范发布流程

当一个迭代周期结束的时候，我们需要将该周期内的改动梳理出来，然后根据改动内容来决定如何升级版本号。

在此提供三种方案：

- conventional-changelog-cli
- semantic-release
- standard-version

## conventional-changelog-cli

[conventional-changelog-cli](https://github.com/conventional-changelog/conventional-changelog/tree/master/packages/conventional-changelog-cli) 可以用来自动生成 CHAGNELOG：

```
npm install -g conventional-changelog-cli
conventional-changelog -p angular -i CHANGELOG.md -s
```

conventional-changelog-cli 只生成了 CHAGNELOG，但却没有自增版本号，所以我们可以搭配 `npm version` 来弥补其不足。

添加如下脚本：

```js
{
  "scripts": {
    "version": "conventional-changelog -p angular -i CHANGELOG.md -s && git add CHANGELOG.md"
  }
}
```

当需要发布流程的时候，以此执行以下步骤：

1. 提交本地更新
2. 拉取最新的 tags
3. 运行 `npm version [patch|minor|major]` 命令
4. 推送到远程仓库

{% note %}
你可以添加一个 `preversion` 脚本来打包你的项目或者运行测试，也可以添加一个 `postversion` 脚本来清理系统并推送发布和 tags。
{% endnote %}

在执行 `npm version` 的时候会自动产生一次以版本号命名的提交，如果想格式化这个提交的信息，可以在 `.npmrc` 中添加如下内容：

```
tag-version-prefix=""
message="chore(release): %s :tada:"
```

这个方案流程上还不够优雅，因为还没法根据历史提交信息来自动升级版本号，并且还只支持 `angular` `atom` `codemirror` `ember` `eslint` `express` `jquery` `jscs` 和 `jshint` 这几种预设。

所以，conventional-changelog 在 README 文档中给我们推荐了下文两种更高级的方案：

## standard-version

`npm version` 的完美替代品，支持自动版本升级、生成 tag 和 CHAGNELOG。

安装 [standard-version](https://github.com/conventional-changelog/standard-version)：

```
npm install --save-dev standard-version
```

在 `package.json` 中添加如下脚本：

```
{
  "scripts": {
    "release": "standard-version"
  }
}
```

### 工作流

当你需要发布版本的时候，按照如下步骤进行：

1. `npm run release`
2. `git push --follow-tags origin master`

{% note info %}
使用 `--follow-tags` 选项可以将与提交相关的 tags 推送到远程仓库。
{% endnote %}

在这个过程中 `standard-version` 做了些什么呢？

1. 在元数据文件中升级版本号，如 `package.json` `composer.json` 等
2. 使用 [conventional-changelog](https://github.com/conventional-changelog/conventional-changelog) 更新 CHANGELOG.md
3. 提交 `package.json` 和 CHANGELOG.md
4. 打标签

### 配置项

如果需要修改生成 CHANGELOG 的规则，可以根据 [conventional-changelog-config-spec](https://github.com/conventional-changelog/conventional-changelog-config-spec/blob/master/versions/2.1.0/README.md) 中的配置项来进行自定义。

配置规则可以写在如下两个地方：

- 在 `package.json` 中添加 `standard-version` 属性
- 在根目录下添加 `.versionrc` `.versionrc.json` 或 `.versionrc.js` 文件

### 高级用法

`standard-version --no-verify` 可以阻止如 `pre-commit` 等 git hooks，避免触发不必要的测试或校验流程。

以及，支持生命周期脚本来完成定制化需求，如将 issues 的 url 片段从 github 改到 jira：

```js
{
  "standard-version": {
    "scripts": {
      "postchangelog": "replace 'https://github.com/myproject/issues/' 'https://myjira/browse/' CHANGELOG.md"
    }
  }
}
```

## semantic-release

支撑全自动化的打包发布工作流，包括自动升级版本号，生成发布说明，发布软件包。

听起来和 `standard-version` 好像功能很相似，那么两者到底有什么区别呢？

- `standard-version` 只对本地资源做更改：升级版本号，生成 CHANGELOG，打标签，但是并没有涉及到推送远程仓库及软件发布流程（如 `npm publish`）。
- `semantic-release` 可以集成到 CI/CD 工作流中，支持本地开发到远程部署的全流程自动化。

### 使用

安装 [semantic-release](https://github.com/semantic-release/semantic-release)：

```
npm install --save-dev semantic-release
```

### CI

这里解释了如何在 Gitlab CI 流程中集成 `semantic-release`：
[Using semantic-release with GitLab CI](https://github.com/semantic-release/semantic-release/blob/master/docs/recipes/gitlab-ci.md)

```
stages:
    - test
    - release

before_script:
  - npm install

test:
  image: node:8
  stage: test
  script:
    - npm test

publish:
  image: node:8
  stage: release
  script:
    - npx semantic-release
```

### 配置项

`semantic-release` 的 [配置项](https://github.com/semantic-release/semantic-release/blob/master/docs/usage/configuration.md#options)、模式、[插件](https://github.com/semantic-release/semantic-release/blob/master/docs/usage/plugins.md) 可以设置在如下三个地方：

- 根目录下的 `.releaserc` 文件，后缀名可以是 `.yaml` `.yml` `.json` `.js`
- 根目录下的 `release.config.js` 文件
- `package.json` 文件中的 `release` 属性

> 更多内容待实践后补充

<div class="reference-linking">参考链接</div>

- [Semantic Versioning 2.0.0](https://semver.org)
- [commitizen/cz-cli](https://github.com/commitizen/cz-cli)
- [conventional-changelog/conventional-changelog](https://github.com/conventional-changelog/conventional-changelog)
- [conventional-changelog/standard-version](https://github.com/conventional-changelog/standard-version)
- [semantic-release/semantic-release](https://github.com/semantic-release/semantic-release)：
