# ============================================================================
#  一键部署到 GitHub Pages
#  ---------------------------------------------------------------------------
#  用法：右键本文件 →「使用 PowerShell 运行」，或在终端执行：
#      powershell -ExecutionPolicy Bypass -File .\deploy.ps1
#
#  前置条件：能访问 github.com（登录和 HTTPS 推送都走它）。
#  如果 github.com 打不开，先开代理/VPN，或看下面的「备用方案」。
# ============================================================================

$ErrorActionPreference = 'Stop'

$GH   = "C:\Program Files\GitHub CLI\gh.exe"
$REPO = "yee25506/portfolio"
$SITE = "https://yee25506.github.io/portfolio/"

Set-Location -Path $PSScriptRoot

Write-Host "`n=== 1/5 检查网络 ===" -ForegroundColor Cyan
try {
  $r = Invoke-WebRequest -Uri "https://github.com" -TimeoutSec 12 -UseBasicParsing -Method Head
  Write-Host "  github.com 可达 (HTTP $($r.StatusCode))" -ForegroundColor Green
} catch {
  Write-Host "  ✗ github.com 不可达：$($_.Exception.Message.Split([char]10)[0])" -ForegroundColor Red
  Write-Host "    登录与 HTTPS 推送都需要它。请先开启代理/VPN 后重跑本脚本。" -ForegroundColor Yellow
  Write-Host "    （本机实测：api.github.com 通，github.com 不通）" -ForegroundColor DarkGray
  exit 1
}

Write-Host "`n=== 2/5 检查 GitHub 登录 ===" -ForegroundColor Cyan
& $GH auth status *> $null
if ($LASTEXITCODE -ne 0) {
  Write-Host "  尚未登录，正在启动浏览器登录流程..." -ForegroundColor Yellow
  & $GH auth login --hostname github.com --git-protocol https --web
  if ($LASTEXITCODE -ne 0) { Write-Host "  ✗ 登录失败" -ForegroundColor Red; exit 1 }
}
& $GH auth status

Write-Host "`n=== 3/5 确认本地仓库状态 ===" -ForegroundColor Cyan
git add -A
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
  git commit -q -m "更新作品集内容"
  Write-Host "  已提交新改动" -ForegroundColor Green
} else {
  Write-Host "  工作区干净，无需提交" -ForegroundColor Green
}

Write-Host "`n=== 4/5 创建仓库并推送 ===" -ForegroundColor Cyan
& $GH repo view $REPO *> $null
if ($LASTEXITCODE -eq 0) {
  Write-Host "  仓库已存在，直接推送" -ForegroundColor Green
  git remote remove origin 2>$null
  git remote add origin "https://github.com/$REPO.git"
  git push -u origin main
} else {
  Write-Host "  仓库不存在，创建并推送（约 108MB，视网速需要几分钟）..." -ForegroundColor Yellow
  & $GH repo create $REPO --public --source=. --remote=origin --push `
      --description "叶春福 Yee · New Media Art 作品集"
}
if ($LASTEXITCODE -ne 0) { Write-Host "  ✗ 推送失败" -ForegroundColor Red; exit 1 }

Write-Host "`n=== 5/5 开启 GitHub Pages ===" -ForegroundColor Cyan
& $GH api -X POST "repos/$REPO/pages" `
    -f "source[branch]=main" -f "source[path]=/" *> $null
if ($LASTEXITCODE -ne 0) {
  Write-Host "  自动开启失败（可能已开启过）。请手动到：" -ForegroundColor Yellow
  Write-Host "  https://github.com/$REPO/settings/pages" -ForegroundColor Yellow
  Write-Host "  Source 选 main / (root) 后保存。" -ForegroundColor Yellow
} else {
  Write-Host "  Pages 已开启" -ForegroundColor Green
}

Write-Host "`n============================================" -ForegroundColor Green
Write-Host " 部署完成，分享网址（首次生效约 1-2 分钟）：" -ForegroundColor Green
Write-Host " $SITE" -ForegroundColor White
Write-Host "============================================`n" -ForegroundColor Green
Start-Process $SITE


# ============================================================================
#  备用方案：github.com 打不开时（本机 api.github.com 和 SSH(22) 是通的）
# ---------------------------------------------------------------------------
#  1) 在能访问 GitHub 的地方（手机流量 / 代理）生成一个 token：
#       https://github.com/settings/tokens  →  Generate new token (classic)
#       勾选 repo 权限即可
#  2) 回到本机执行：
#       $env:GH_TOKEN = "你的token"
#       gh repo create yee25506/portfolio --public --source=. --remote=origin --push
#       gh api -X POST "repos/yee25506/portfolio/pages" -f "source[branch]=main" -f "source[path]=/"
#  3) 用完到 https://github.com/settings/tokens 把该 token 删掉
#
#  之所以需要 token：gh 的浏览器登录走 github.com/login/oauth，而这个端点在
#  本机网络下不通；带 token 则可以只走 api.github.com（本机实测约 100ms，稳定）。
# ============================================================================
