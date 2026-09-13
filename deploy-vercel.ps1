# ============================================================================
#  一键更新作品集 -> GitHub -> Vercel
#  ---------------------------------------------------------------------------
#  用法：右键本文件 ->「使用 PowerShell 运行」
#
#  【站点入口】index.html = 嵌入版.html 的内容（终稿）。
#     嵌入版.html 是唯一需要维护的源文件，本脚本第 1 步会把它同步到
#     index.html，保证线上根路径呈现的就是终稿效果。
#     旧版纯滚动首页备份为 index-basic.html，不再参与发布。
#
#  【为什么不用 git push】
#     本机 github.com:443 直连超时、走代理被 502 拦截，git push 无法工作；
#     但 api.github.com 可直连。因此改用 GitHub REST API 写入仓库内容。
#
#  【前置】gh CLI 已登录（gh auth status）
# ============================================================================

$ErrorActionPreference = 'Stop'

$SITE   = "C:\Users\17979\Desktop\portfolio-site"
$OWNER  = "Yeeyech"
$REPO   = "yee-portfolio"
$BRANCH = "main"
$SRC    = Join-Path $SITE "嵌入版.html"
$INDEX  = Join-Path $SITE "index.html"
$PUSH   = "C:\Users\17979\.workbuddy\skills\github-push-via-api\scripts\push-via-api.ps1"
$GH     = "C:\Program Files\GitHub CLI\gh.exe"

Set-Location $SITE

Write-Host "`n=== 1/4 同步站点入口（嵌入版.html -> index.html）===" -ForegroundColor Cyan
if (Test-Path -LiteralPath $SRC) {
  $h1 = (Get-FileHash -LiteralPath $SRC   -Algorithm SHA256).Hash
  $h2 = ""
  if (Test-Path -LiteralPath $INDEX) { $h2 = (Get-FileHash -LiteralPath $INDEX -Algorithm SHA256).Hash }
  if ($h1 -ne $h2) {
    Copy-Item -LiteralPath $SRC -Destination $INDEX -Force
    Write-Host "  已同步：index.html 更新为终稿内容" -ForegroundColor Green
  } else {
    Write-Host "  index.html 已是最新终稿，无需同步" -ForegroundColor Green
  }
} else {
  Write-Host "  未找到 嵌入版.html，跳过同步（将直接发布现有 index.html）" -ForegroundColor Yellow
}

Write-Host "`n=== 2/4 提交本地改动 ===" -ForegroundColor Cyan
git add -A
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
  $stamp = Get-Date -Format "yyyy-MM-dd HH:mm"
  git commit -q -m "Update site content ($stamp)"
  Write-Host "  已提交本地改动" -ForegroundColor Green
} else {
  Write-Host "  工作区干净，无新改动" -ForegroundColor Green
}

Write-Host "`n=== 3/4 推送到 GitHub（走 REST API）===" -ForegroundColor Cyan
& $GH auth status 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "  未登录 GitHub，请先执行 gh auth login" -ForegroundColor Red; exit 1 }

& $PUSH -Site $SITE -Owner $OWNER -Repo $REPO -Branch $BRANCH `
        -CommitMessage "Update site content" `
        -LogFile "$SITE\.push.log"

if ($LASTEXITCODE -ne 0) { Write-Host "`n  推送失败，请查看上面的日志" -ForegroundColor Red; exit 1 }
Write-Host "  已推送到 https://github.com/$OWNER/$REPO" -ForegroundColor Green

Write-Host "`n=== 4/4 Vercel ===" -ForegroundColor Cyan
Write-Host "  仓库已更新；Vercel 检测到新提交后会自动重新部署。" -ForegroundColor Green
Start-Process "https://vercel.com/dashboard"

