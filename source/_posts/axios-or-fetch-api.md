---
title: 「译」axios和fetch，我们应该用哪个？
tags: JavaScript 翻译
categories:
  - 技术
  - 前端
copyright: true
reward: true
rating: true
related_posts: false
date: 2019-11-17 12:40:28
---

{% note info %}
原文链接： [Axios or fetch(): Which should you use?](https://blog.logrocket.com/axios-or-fetch-api/)
{% endnote %}

Axios 一直是我开发项目时发送 HTTP 请求的首选。最近看到一篇外文博客里，详细介绍了如何在使用 fetch 的时候实现 Axios 的一些关键特性，以使我们能够方便的过渡到 fetch 这一原生 API 上。

<!-- more -->

---

在我最近的一篇文章 [如何像一个老手一样通过 Axios 发送 HTTP 请求](https://blog.logrocket.com/how-to-make-http-requests-like-a-pro-with-axios/#new_tab) 中，我讨论了使用 Axios 的好处。然而 Axios 并非总是理想的解决方案，有时还有其他更好的做法来发送 HTTP 请求。

毫无疑问，由于更易使用，一些开发者更喜欢 Axios 而非原生的内置 API。但也有很多人高估了这个库的必要性。`fecth()` API 能够完美复现 Axios 的关键特性，并且它还有一个额外的优点：已内置在所有现代浏览器里。

# 基本语法

在我们进一步深入 Axios 的更多高级特性之前，我们先来比较一下它和 `fetch()` 的基本语法。这里展示了你该如何通过 Axios 发送一个带有自定义头部信息的 POST 请求到一个 URL 地址。Axios 将会帮你自动把响应数据转成 JSON 格式。

```js
// axios
const options = {
  url: "http://localhost/test.htm",
  method: "POST",
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json;charset=UTF-8"
  },
  data: {
    a: 10,
    b: 20
  }
};

axios(options).then(response => {
  console.log(response.status);
});
```

现在我们将这份代码与 `fetch()` 版本的代码比较一下：

```js
// fetch()
const url = "http://localhost/test.htm";
const options = {
  method: "POST",
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json;charset=UTF-8"
  },
  body: JSON.stringify({
    a: 10,
    b: 20
  })
};

fetch(url, options).then(response => {
  console.log(response.status);
});
```

注意：

- 为发送数据，`fetch()` 使用的是 body 属性，而 Axios 使用的是 data 属性
- `fetch()` 中的数据需要处理为字符串
- 在 `fetch()` 中， URL 是作为一个参数传递的，然而在 Axios 中，URL 是被放在 options 对象中传入的

# 向后兼容性

Axios 的一个主要卖点即是它广泛的浏览器兼容性，即使是如 IE11 这样的老浏览器也能正常运行 Axios。另一方面，`fetch()` 只支持 Chrome 42+, FireFox 39+, Edge 14+ 以及 Safari 10.1+。（你可以在 [Can I use](https://caniuse.com/#search=Fetch) 里查看完整的兼容性表）

如何向后兼容性是你使用 Axios 的唯一理由，那其实你不是真的需要一个 HTTP 库。作为替代，你可以在不支持 `fetch()` 的浏览器上使用 [这样](https://github.com/github/fetch) 的 polyfill 以实现类似的功能。要开始使用这样的 fetch polyfill，通过 npm 命令安装它：

```
npm install whatwg-fetch --save
```

然后你可以像这样发送请求：

```
import 'whatwg-fetch'
window.fetch(...)
```

记住，在老式浏览器上你可能还需要一个 promise 的 polyfill。

# 响应超时

在 Axios 中设置响应超时很简单，这也成为了开发者选择它的另外一个原因。你可以在配置对象中设置 `timeout` 属性以设置请求终止的毫秒数，例如：

```js
axios({
  method: "post",
  url: "/login",
  timeout: 4000, // 4 seconds timeout
  data: {
    firstName: "David",
    lastName: "Pollock"
  }
})
  .then(response => {
    /* handle the response */
  })
  .catch(error => console.error("timeout exceeded"));
```

`fetch()` 通过 `AbortController` 接口来提供类似的功能。虽然不如 Axios 来的那么简单：

```js
const controller = new AbortController();
const options = {
  method: "POST",
  signal: controller.signal,
  body: JSON.stringify({
    firstName: "David",
    lastName: "Pollock"
  })
};
const promise = fetch("/login", options);
const timeoutId = setTimeout(() => controller.abort(), 4000);

promise
  .then(response => {
    /* handle the response */
  })
  .catch(error => console.error("timeout exceeded"));
```

这里，我们通过 `AbortController.AbortController()` 构造函数创建一个 `AbortController`，之后我们将用这个对象取消请求。`signal` 是 `AbortController` 的一个只读属性，提供了与请求通信或取消的方法。如果服务器在 4 秒内没有响应，`controller.abort()` 就会被调用，然后通信操作会被终止。

# 自动 JSON 数据转换

正如我们之前说过的，Axios 在发送请求的时候会自动将数据字符串化（尽管你也可以覆写默认的行为来定义一个不同的转换机制）。但当使用 `fetch()` 的时候，你需要手动做这个事。比较一下：

```js
// axios
axios.get("https://api.github.com/orgs/axios").then(
  response => {
    console.log(response.data);
  },
  error => {
    console.log(error);
  }
);

// fetch()
fetch("https://api.github.com/orgs/axios")
  .then(response => response.json()) // one extra step
  .then(data => {
    console.log(data);
  })
  .catch(error => console.error(error));
```

数据自动转换是一个不错的功能，但再一次的，这并不是什么你在 `fetch()` 里做不了的东西。

# HTTP 拦截器

Axios 的一个关键特性即是它拦截 HTTP 请求的能力。HTTP 拦截器在你需要测试或改变从你的应用到服务器（反之亦然）的 HTTP 请求的时候派得上用场（例如，日志、权限认证等）。有了拦截器，你不再需要为每个 HTTP 请求写单独的代码。

这里展示了你该如何在 Axios 里生命一个请求拦截器：

```js
axios.interceptors.request.use(config => {
  // log a message before any HTTP request is sent
  console.log("Request was sent");

  return config;
});

// sent a GET request
axios.get("https://api.github.com/users/sideshowbarker").then(response => {
  console.log(response.data);
});
```

在这里，`axios.interceptors.request.use()` 方法用来定义一段在 HTTP 请求发送之前的代码逻辑。

默认情况下，`fetch()` 并没有提供一个拦截 HTTP 的方法，但是想出一个变通的办法并不难。你可以像这样覆写全局的 fetch 方法来定义一个你自己的拦截器：

```js
fetch = (originalFetch => {
  return (...arguments) => {
    const result = originalFetch.apply(this, arguments);
    return result.then(console.log("Request was sent"));
  };
})(fetch);

fetch("https://api.github.com/orgs/axios")
  .then(response => response.json())
  .then(data => {
    console.log(data);
  });
```

# 下载进度

进度指示器在下载大型资源的时候非常有用，尤其是那些网速较慢的用户。以前，JavaScript 开发者使用`XMLHttpRequest.onprogress`回调处理器来实现进度指示器。

[Fetch API](https://blog.logrocket.com/patterns-for-data-fetching-in-react-981ced7e5c56/) 没有 `onprogress` 处理器。取而代之的是，它通过响应对象的 body 属性提供了一个`ReadableStream`的实例。

下面的例子展示了通过使用 `ReadableStream` 来为用户在图像下载过程中提供即时反馈：

```html
// original code: https://github.com/AnthumChris/fetch-progress-indicators

<div id="progress" src="">progress</div>
<img id="img" />

<script>
  "use strict";

  const element = document.getElementById("progress");

  fetch("https://fetch-progress.anthum.com/30kbps/images/sunrise-baseline.jpg")
    .then(response => {
      if (!response.ok) {
        throw Error(response.status + " " + response.statusText);
      }

      // ensure ReadableStream is supported
      if (!response.body) {
        throw Error("ReadableStream not yet supported in this browser.");
      }

      // store the size of the entity-body, in bytes
      const contentLength = response.headers.get("content-length");

      // ensure contentLength is available
      if (!contentLength) {
        throw Error("Content-Length response header unavailable");
      }

      // parse the integer into a base-10 number
      const total = parseInt(contentLength, 10);

      let loaded = 0;

      return new Response(
        // create and return a readable stream
        new ReadableStream({
          start(controller) {
            const reader = response.body.getReader();

            read();
            function read() {
              reader
                .read()
                .then(({ done, value }) => {
                  if (done) {
                    controller.close();
                    return;
                  }
                  loaded += value.byteLength;
                  progress({ loaded, total });
                  controller.enqueue(value);
                  read();
                })
                .catch(error => {
                  console.error(error);
                  controller.error(error);
                });
            }
          }
        })
      );
    })
    .then(response =>
      // construct a blob from the data
      response.blob()
    )
    .then(data => {
      // insert the downloaded image into the page
      document.getElementById("img").src = URL.createObjectURL(data);
    })
    .catch(error => {
      console.error(error);
    });

  function progress({ loaded, total }) {
    element.innerHTML = Math.round((loaded / total) * 100) + "%";
  }
</script>
```

在 Axios 中实现一个进度指示器更加简单，尤其是当你使用了 [Axios Progress Bar](https://github.com/rikmms/progress-bar-4-axios/) 模块。首先，你需要包含以下样式和脚本：

```html
<link
  rel="stylesheet"
  type="text/css"
  href="https://cdn.rawgit.com/rikmms/progress-bar-4-axios/0a3acf92/dist/nprogress.css"
/>

<script src="https://cdn.rawgit.com/rikmms/progress-bar-4-axios/0a3acf92/dist/index.js"></script>
```

然后你可以像以下这样来实现进度条：

```html
<img id="img" />

<script>
  loadProgressBar();

  const url =
    "https://fetch-progress.anthum.com/30kbps/images/sunrise-baseline.jpg";

  function downloadFile(url) {
    axios
      .get(url, { responseType: "blob" })
      .then(response => {
        const reader = new window.FileReader();
        reader.readAsDataURL(response.data);
        reader.onload = () => {
          document.getElementById("img").setAttribute("src", reader.result);
        };
      })
      .catch(error => {
        console.log(error);
      });
  }

  downloadFile(url);
</script>
```

这段代码使用了 `FileReader` 去异步读取下载的图像。 `readAsDataURL` 方法以 base64 格式来返回图像数据，然后嵌入到 `img` 标签的 `src` 属性以展示图像。

# 并行请求

为同时发送多个请求，Axios 提供了`axios.all()`方法。只要传递一个请求数组到这个方法，再使用 `axios.spread()` 来将响应数组的属性指定到不同的变量：

```js
axios
  .all([
    axios.get("https://api.github.com/users/iliakan"),
    axios.get("https://api.github.com/users/taylorotwell")
  ])
  .then(
    axios.spread((obj1, obj2) => {
      // Both requests are now complete
      console.log(
        obj1.data.login +
          " has " +
          obj1.data.public_repos +
          " public repos on GitHub"
      );
      console.log(
        obj2.data.login +
          " has " +
          obj2.data.public_repos +
          " public repos on GitHub"
      );
    })
  );
```

你可以通过内置的 `Promise.all()` 方法来实现相同的结果。将 fetch 请求作为数组传递给 `Promise.all()`。然后，通过 `async` 函数处理响应，如下：

```js
Promise.all([
  fetch("https://api.github.com/users/iliakan"),
  fetch("https://api.github.com/users/taylorotwell")
])
  .then(async ([res1, res2]) => {
    const a = await res1.json();
    const b = await res2.json();
    console.log(a.login + " has " + a.public_repos + " public repos on GitHub");
    console.log(b.login + " has " + b.public_repos + " public repos on GitHub");
  })
  .catch(error => {
    console.log(error);
  });
```

# 结论

Axios 在紧密的包装中为大多数的 HTTP 通信提供了易于使用的的 API。但是，如果你更喜欢坚持原生 API，那就没什么能够阻挡你实现 Axios 的特性的。

如文中讨论的，我们在使用浏览器提供的 `fetch()` 方法时完全有能力复现 Axios 的关键特性。最后，是否值得加载一个客户端 HTTP API 取决于你是否能舒服的使用内置 API 工作。
