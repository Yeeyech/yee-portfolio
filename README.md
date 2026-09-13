# Portfolio · 叶春福 Yee

New Media Art 作品集网站（纯静态，直接双击 `index.html` 即可看）。

## 页面

| 文件 | 内容 |
|---|---|
| `index.html` | 主页面：首屏三幕介绍 → 完整作品集 → 取得联系 |
| `3D画廊.html` | 3D 影像环画廊（34 件作品，可拖动 / 悬停定格 / 点击进详情） |
| `work.html` | 画廊里点作品后的详情页（`work.html?id=N`） |
| `毕业设计.html` | AI 视频生成流程页（左侧播放器 + 右侧双流程画布） |
| `ai-image-workflow.html` | 标准化迭代 AI 图像创作流程（六步骤时间轴 + 提示词 + 对比滑块） |
| `嵌入版.html` | 实验版：点作品卡弹出浮层，用 iframe 加载对应页面，页面不跳转 |

## 目录

- `media/` — 主页面用到的图
- `assets/` — 字体、34 件作品的展示图与详情大图、各专题页素材
- `lanyard-badge.js` — About 区 3D 吊牌徽章
- `Electric Toronto.mp4` — 首屏背景视频

## 本地预览

直接双击 `index.html`。若浏览器限制了本地文件，可在本目录起一个静态服务：

```bash
npx serve .
```

## 说明

字体与 three.js 来自 CDN，需要联网；断网时页面仍能打开，只是字体会回退成系统字体、3D 徽章不显示。
