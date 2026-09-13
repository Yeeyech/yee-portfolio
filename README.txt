==========================================================
 Yee 作品集 · Vercel 静态部署归档
==========================================================

【归档信息】
· 项目名称        ：Yee Portfolio
· Vercel 公网链接 ：https://yee-portfolio-iota.vercel.app
· 部署完成时间    ：2026-09-13 22:51
· 版本状态        ：已上线（海外可访问；大陆直连需代理）
· 运行环境        ：全球 CDN · 无备案 · 纯静态托管 · 自动 HTTPS

【目录结构】（全部 ASCII / 无空格，符合前置规范）
  index.html               首页（三幕开场 + 长滚动作品集）
  gallery.html             3D 影像环（作品卡浮层内嵌）
  ai-image-workflow.html   AI 图像创作流程页
  graduation-project.html  毕业设计播放器页
  lanyard-badge.js         3D 名片徽章
  media/                   首页三幕图 + 作品卡封面图
  assets/                  字体 / 作品图 / 参考图 / 系列图 / 工作流图 / 视频 / 提示词
  assets/video/electric-toronto.mp4  主背景视频

【部署方式 B · 直接拖拽】
  1. vercel.com 登录
  2. Add New Project
  3. 忽略 Git 导入区，在页面底部找到 Drag and drop your project folder here
  4. 把本文件夹整体拖入，等待上传完成
  5. Project Name 填英文名；Framework Preset 选 Other；Root Directory 用 ./
  6. 点 Deploy，等 30–60 秒
  7. 点 Visit 得到 https://xxx.vercel.app

【后续更新】
  进入 Vercel 项目 → Deployments → Upload → 重新覆盖上传整个文件夹

【上线前提醒】
  1. 头像：about 区引用的 portrait.jpg 当前不存在（页面显示 photo to be
     added 占位，有 WebGL 兜底）。补头像：把照片命名为 portrait.jpg 放进根目录。
  2. 字体授权：assets/fonts/reckless_standard_regular.woff2 是商业字体，
     公开上线前建议替换为自有授权字体或改走 Google Fonts CDN。
  3. 视频体积：约 60 MB，如需更快加载可再压一档（H.264 CRF 23 / AV1）。
