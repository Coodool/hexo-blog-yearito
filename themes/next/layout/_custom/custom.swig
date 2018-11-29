<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

{# 页面加载时header高度收缩动效 #}
<script>
  $(document).ready(function () {
    $(".header-inner").animate({padding: "25px 0 25px"}, 1000);
  });
</script>

{# 页脚站点运行时间统计 #}
{% if theme.footer.ages.enable %}
  <script src="https://cdn.jsdelivr.net/npm/moment@2.22.2/moment.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/moment-precise-range-plugin@1.3.0/moment-precise-range.min.js"></script>
  <script>
    function timer() {
      var ages = moment.preciseDiff(moment(),moment({{ theme.footer.ages.birthday }},"YYYYMMDD"));
      ages = ages.replace(/years?/, "年");
      ages = ages.replace(/months?/, "月");
      ages = ages.replace(/days?/, "天");
      ages = ages.replace(/hours?/, "小时");
      ages = ages.replace(/minutes?/, "分");
      ages = ages.replace(/seconds?/, "秒");
      ages = ages.replace(/\d+/g, '<span style="color:{{ theme.footer.ages.color }}">$&</span>');
      div.innerHTML = `{{ __('footer.age')}} ${ages}`;
    }
    var div = document.createElement("div");

    //插入到copyright之后
    var copyright = document.querySelector(".copyright");
    document.querySelector(".footer-inner").insertBefore(div, copyright.nextSibling);

    //插入到卜蒜子之后
    //document.querySelector(".footer-inner").appendChild(div);

    timer();
    setInterval("timer()",1000)
  </script>
{% endif %}

{# wobble窗口摆动特效 #}
{% if theme.wobble.enable %}
  <script src="https://script-1256884783.file.myqcloud.com/wobblewindow.js"></script>
  <script>
    //只在桌面版网页启用特效
    if( window.innerWidth > 768  ){
      $(document).ready(function () {
        {% if theme.wobble.header %}
          $('#header').wobbleWindow({
            radius: {{ theme.wobble.radius }},
            movementTop: false,
            movementLeft: false,
            movementRight: false,
            debug: false,
          });
        {% endif %}

        {% if theme.wobble.sidebar %}
          $('#sidebar').wobbleWindow({
            radius: {{ theme.wobble.radius }},
            movementLeft: false,
            movementTop: false,
            movementBottom: false,
            position: 'fixed',
            debug: false,
          });
        {% endif %}

        {% if theme.wobble.footer %}
          $('#footer').wobbleWindow({
            radius: {{ theme.wobble.radius }},
            movementBottom: false,
            movementLeft: false,
            movementRight: false,
            position: 'absolute',
            debug: false,
          });
        {% endif %}
      });
    }
  </script>
{% endif %}

{# hotjar 页面反馈 #}
{% if theme.hotjar.enable %}
  <script>
    (function(h,o,t,j,a,r){
      h.hj=h.hj||function(){(h.hj.q=h.hj.q||[]).push(arguments)};
      h._hjSettings={hjid:{{ theme.hotjar.siteID }},hjsv:6};
      a=o.getElementsByTagName('head')[0];
      r=o.createElement('script');r.async=1;
      r.src=t+h._hjSettings.hjid+j+h._hjSettings.hjsv;
      a.appendChild(r);
    })(window,document,'https://static.hotjar.com/c/hotjar-','.js?sv=');
  </script>
{% endif %}

{# Tidio 在线联系功能 #}
{% if theme.tidio.enable %}
  <script async src="//code.tidio.co/{{ theme.tidio.key }}.js"></script>
{% endif %}

{# 鼠标点击特效 #}
{% if theme.cursor_effect == "fireworks" %}
  <script async src="https://script-1256884783.file.myqcloud.com/cursor/fireworks.js"></script>
{% elseif theme.cursor_effect == "explosion" %}
  <canvas class="fireworks" style="position: fixed;left: 0;top: 0;z-index: 1; pointer-events: none;" ></canvas>
  <script src="//cdn.bootcss.com/animejs/2.2.0/anime.min.js"></script>
  <script async src="https://script-1256884783.file.myqcloud.com/cursor/explosion.min.js"></script>
{% elseif theme.cursor_effect == "love" %}
  <script async src="https://script-1256884783.file.myqcloud.com/cursor/love.min.js"></script>
{% elseif theme.cursor_effect == "text" %}
  <script async src="https://script-1256884783.file.myqcloud.com/cursor/text.js"></script>
{% endif %}

{# 打字特效 #}
{% if theme.typing_effect %}
  <script src="https://script-1256884783.file.myqcloud.com/activate-power-mode.min.js"></script>
  <script>
    POWERMODE.colorful = {{ theme.typing_effect.colorful }};
    POWERMODE.shake = {{ theme.typing_effect.shake }};
    document.body.addEventListener('input', POWERMODE);
  </script>
{% endif %}

{# 随机三角丝带背景 #}
{% if theme.evanyou %}
  <canvas id="evanyou"></canvas>
  <style>
    #evanyou {
      position: fixed;
      width: 100%;
      height: 100%;
      top: 0;
      left: 0;
      z-index: -1;
    }
  </style>
  <script src="https://script-1256884783.file.myqcloud.com/evan-you.js"></script>
{% endif %}


{# 搞怪网页标题 #}
{% if theme.title_trick.enable %}
  <script>
    var OriginTitile = document.title;
    var titleTime;
    document.addEventListener('visibilitychange', function() {
      if (document.hidden) {
        document.title = '{{ theme.title_trick.leave }}' + OriginTitile;
        clearTimeout(titleTime);
      } else {
        document.title = '{{ theme.title_trick.enter }}' + OriginTitile;
        titleTime = setTimeout(function() {
          document.title = OriginTitile;
        }, 2000);
      }
    });
  </script>
{% endif %}
