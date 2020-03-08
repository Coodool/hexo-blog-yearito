---
title: 「译」GraphQL与REST，优势是什么
tags: 翻译
categories:
  - 技术
  - 前端
copyright: true
reward: true
rating: true
related_posts: false
hide_toc: true
date: 2019-11-23 23:28:54
---


{% note info %}
原文链接： [GraphQL vs. REST: What’s The Advantage?](https://www.manifold.co/blog/graphql-vs-rest-whats-the-advantage)
{% endnote %}

由 Facebook 开创的 [GraphQL](https://graphql.org/)，自 2015 年面世以来就一直在改进着 web 和原生应用。相比较于传统的 REST API，它的几个优势也使得其使用率迅速提升。

<!-- more -->

# 优势 1：更少的数据

大多数你消费的目标数据来源于某个地方的数据库。如果你正好在 SQL 数据库上工作，你应该知道，只请求你所需要的字段比请求所有的字段要更高效。

在 REST 的体系中，几乎不可能只指定你需要的字段。结果，你通常会获取比你所需要的更多的数据。如果你需要一次获得多条记录，这时你就需要处理一个指数级的问题。

在 Manifold，我们与所有 REST 终端返回的数据做斗争。

## REST

```
https://api.catalog.manifold.co/v1/products
```

这个链接返回 `141 KB` 的 JSON 数据，并且这还不是我们最重的终端。（我们最重的 REST 终端返回 1M 以上的 JSON 数据！）对于这个终端，任何时候我们需要任意产品的数据的时候，这份数据都会装载到客户端里。并且，在 REST 工作的方式中，这只是我们需要渲染一个页面所需的几个调用中的一个。

相比于我们的 GraphQL 终端：

```
//request
{
  products(first: 100) {
    edgets {
      node {
        displayName
        logoUrl
        tagline
      }
    }
  }
}

//response
{
  "data": {
    "products": {
      "edges": [
        {
          "node": {
            "displayName": "Dumper",
            "logoUrl": "https://cdn.manifold.co/providers/dumper/logos/512x512_2.png",
            "tagline": "Off-site backup-as-a-service for MySQL, PostgreSQL, MongoDB and Redis."
          }
        },
        {
          "node": {
            "displayName": "Blitline",
            "logoUrl": "https://cdn.manifold.co/providers/blitline/logos/blitline.png",
            "tagline": "Premium image processing and rasterization API for enterprise systems"
          }
        },
        ...
      ]
    }
  }
}
```

如果我们只需要三个字段，我们的 GraphQL 终端只返回我们所需要的，并且只有 `9.4 KB`，比 REST 要小 95%。

此外，很多时候我们需要通过后续的 REST 请求来获取一个产品的计划数据（我们将在接下来谈到链式）。对于我们查询的每个产品，我们有时候也需要查询它的计划。这是一个示例，关于如何将这些多重查询结合成一个 GraphQL 查询（以及一些其他用于比较的场景）：

| 场景                | REST 数据量 | GraphQL 数据量 | 降低 |
| ------------------- | ----------- | -------------- | ---- |
| 所有产品 + 所有计划 | `562.4 KB`  | `15.4 KB`      | 97%  |
| 所有产品            | `141 KB`    | `9.4 KB`       | 95%  |
| 单个产品            | `4.1 KB`    | `0.2 KB`       | 95%  |

并且思考一下：这节约的只是针对一个用户的。想象一下大规模应用后它将带来什么：技能降低加载时间，又能降低带宽占用。

# 优势 2：组合请求

GraphQL 另外一个重要的优势即是其组合多个请求的能力。如果你之前使用过 REST，你可能常常经历链式调用的痛苦：

1. 我们需要展示一个团队，先来调用 `/team/:id` 请求。
2. 每个 `team` 拥有一系列的 `userIDs`。对于每个团队用户，我们需要调用 `/user/:id` 请求对于每个这些 ID。
3. 我们还想要展示有哪些其他的队伍上也包含了这个 `user`。此时我们针对每个团队、每个用户再次调用 `/team/:id`。

让我们把它加起来：

```
/team/:id  1
/user/:id  n (n: 团队里成员的数量)
/team/:id  n × t (t: 每个用户的团队数量)
```

如果这是一个拥有 20 个用户的团队，每个用户有三个团队，那么我们需要发送 81 个 REST 请求来渲染一个视图。

的确我们可以找到优化这个 REST 链的方法，但是我们需要手动去做，并且可能是仅仅针对于这个场景的。这些优化在 REST 里并非是天生免费的。

幸运的是，在 GraphQL 里是很简单的。这里展示了你可以如何将这些 REST 请求组合在同一个 GraphQL 查询中：

```
query TEAM_USERS {
  team(id: $teamID) {
    users {
      edges {
        node {
          avatarURL
          displayName
          teams {
            edges {
              node {
                displayName
              }
            }
          }
        }
      }
    }
  }
}
```

在 GraphQL 里，你可以在一个请求里完成所有上述工作。只需要管理一个请求，而非三个不同的递归查询，这就说明了使用 GraphQL 不仅提升了性能，也降低了前端应用的代码复杂度。

## 关于查询复杂度的一个注解

既然 GraphQL 可以方便的将 models 联系起来，并且你可以从一个 model 上查询另一个 model，这里有一个与你的 GraphQL 服务器相关的东西叫做“复杂度”，它会影响到性能。与在 SQL 查询语句中的 JOINs 并不是免费的，GraphQL 分解器也是如此。当我们通过在 GraphQL 中嵌套来从获取一个远程的 model 的时候，我们称之为“分解”（resolving）。

比如说，在我们想象的用户/团队场景中，你可能注意到了，从团队查用户或者从用户查团队都很爽，但是如果你一直这样链式调用：用户-团队-用户-团队，你会注意到在到达一定程度后出现延迟。多少延迟，以及在什么级别会出现延迟取决于你的 GraphQL 服务器、中间件以及数据库结构。但是不管你的配置如何，我们都建议你将查询深度限制在一个合适的级别上：既能避免出现昂贵的查询，又能给予你应用中灵活性。（比如说十级深度）

# 优势 3：订阅

GraphQL 的最后一个优势就是订阅：发送查询或修改并且自动更新的能力。通常这些会在 GraphQL 服务器端通过 [WebSockets](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API) 来实现。

当我们想使用 GraphQL 创造一个聊天应用的时候，我们可能会像下面这样写：

```
subscription MESSAGES() {
  messagesSubscribe(last: 200) {
    edges {
      node {
        text
        author {
          avatarURL
          userName
        }
      }
    }
  }
}
```

在我们的应用中， `messageSubscribe.edges` 可能是一个在新消息送达的时候会自动更新的消息数组。如果没有订阅机制，我们可能需要每秒发送一次或更多的请求，这会导致短时间内出现上百次的调用。

有了订阅机制，只有当消息发送或接收到的时候才会打开连接并传输数据。

为了发挥订阅的全部优势，你需要使用一个客户端来支撑。最流行的客户端如 [Apollo Client](https://www.apollographql.com/docs/react/) 等已经内置了订阅。

关于 GraphQL 的订阅可以做什么，这里有一个有趣的例子，请打开 [Eve Porcello](https://twitter.com/eveporcello) 在 React Rally 2018 的讲话，五个参与者通过订阅创建了即时音乐。点开视频，从 `22:45` 开始看。（她的讲解一直持续到演示结束）：

<iframe width="700" height="394" src="https://www.youtube.com/embed/F_M8v6MK0Sc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

# REST 有什么优势么？

我们已经在此讲了很多 GraphQL 的好处了，那么 REST 保留了什么优势么？平心而论， GraphQL 是建立在 REST 的基础上的，所以它的设计是一个向前的迭代。REST 已经是现在 web 最有影响力、最基本的构成了，并且没有它的存在也不会有 GraphQL。所以考虑到 REST 的影响力，公平地说，GraphQL 是在 REST 上的一个显著提升，这个提升体现在几乎所有的方面。

对于 Manifold 里的我们，我们没发现 GraphQL 有什么缺失的特性。我们在移植过程中最大的痛点即是所有新技术都将面临的问题：工具仍在成熟中。并非是每个你想在其中建立 GraphQL 服务器的语言都具有你需要的所有特性。对于运行 [Go](https://golang.org/) 微服务栈的我们来说，Go 相较于基于 Node.js 的 Apollo 服务器来说缺少了很多特性。（但是考虑到包括性能在内的几个原因我们仍选择了 Go）。

我们最终选择了在 [99designs/gqlgen](https://github.com/99designs/gqlgen) 上搭建 GraphQL 服务，再配上一些特殊的工具来使得简化分页和数据库优化。

我们有信心 GraphQL 社区将会迎头赶上，但是在 2019 年你还不能在 GraphQL 客户端和工具中体验和 REST 一样的多样性和完备性。

# 结论

这是我们在生产中应用 GraphQL 而非 REST 的最大的三个优势，你的呢？

如果你对 GraphQL 有更多的兴趣，我们推荐如下的资源：

- [GraphQL Weekly](https://www.graphqlweekly.com/): 一个 GraphQL 的每周时报，包括文章、库和建议
- [GraphQL Summit](https://summit.graphql.com/): GraphQL 的年会，通常在 San Francisco
- [Apollo Community](https://spectrum.chat/apollo): 一个讨论 GraphQL、分享知识或者提问问题的好地方。运行在 [Spectrum](https://spectrum.chat/) 上：一个为开源而生的免费、开放性的讨论平台。
