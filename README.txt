==========================================================
  Yee 作品集 · 部署说明
==========================================================

【项目】叶春福 Yee · Portfolio（纯静态站，无构建、无服务器）

【在线地址】
  · GitHub Pages      https://yeeyech.github.io/yee-portfolio/
  · Cloudflare Pages  https://yee-portfolio.pages.dev
  · 自定义域名         https://yeeportfolio.eu.cc

【目录结构】
  index.html                 首页（三幕开场 + 长滚动作品集）
  gallery.html               3D 影像环（作品卡，点击弹出详情）
  ai-image-workflow.html     AI 图像创作流程页
  graduation-project.html    毕业设计 · AI 动画短片
  lanyard-badge.js           3D 名片徽章（首页 about 区使用）
  404.html                   自定义 404 页面
  media/                     首页三幕图 + 作品卡封面图
  assets/                    字体 / 作品图 / 参考图 / 系列图 / 视频 / 提示词
  assets/video/electric-toronto.mp4   主背景视频

【如何更新】
  1. 在本地文件夹改文件并保存。
  2. git add -A && git commit -m "..." && git push origin main
     → GitHub Pages 自动更新（约 1–3 分钟）。
  3. Cloudflare Pages 二选一：
     a) 后台把 GitHub 仓库连上（Git 集成），push 后自动更新；
     b) 直接上传：wrangler pages deploy 本文件夹 --project-name yee-portfolio。

【上线前提醒】
  1. 头像：about 区引用根目录的 portrait.jpg，当前缺失（页面有占位兜底）。
     补头像：把竖版照片命名为 portrait.jpg 放进根目录即可。
  2. AI 流程页的部分参考图 / 系列图为「待替换占位」，替换 assets/reference 与
     assets/series 下的同名图片即可。
  3. 字体授权：assets/fonts/reckless_standard_regular.woff2 为商业字体，
     公开上线前建议替换为自有授权字体或改走 Google Fonts CDN。
  4. 视频体积约 60 MB（主背景），如需更快加载可再压一档。

【国内 / 海外访问】
  · 海外（含泰国）：三个地址均稳定可访问。
  · 中国大陆：*.github.io / *.pages.dev / eu.cc 均属「经常被墙 / 不稳定」，
    国内稳定直连需「国内云 + ICP 备案」，Cloudflare 免费方案无法保证。
