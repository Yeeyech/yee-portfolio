# ============================================================================
#  作品集网站 · 推送到 GitHub（供 Vercel 部署）
#  ---------------------------------------------------------------------------
#  目标仓库：https://github.com/Yeeyech/yee-portfolio.git
#  用法：右键本文件 →「使用 PowerShell 运行」，或在终端执行：
#      powershell -ExecutionPolicy Bypass -File .\deploy-vercel.ps1
#
#  本脚本只负责「把代码推上 GitHub」这一段。
#  推送完成后到 Vercel 导入该仓库即可生成分享链接。
# ============================================================================

$ErrorActionPreference = 'Stop'

$GH     = "C:\Program Files\GitHub CLI\gh.exe"
$REPO   = "Yeeyech/yee-portfolio"
$BRANCH = "main"

Set-Location -Path $PSScriptRoot

# 清掉可能拦截 git 的代理环境变量（本机曾出现 502 CONNECT tunnel failed）
Remove-Item Env:HTTP_PROXY  -ErrorAction SilentlyContinue
Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue

Write-Host "`n=== 1/5 检查网络 ===" -ForegroundColor Cyan
foreach ($u in @("https://github.com", "https://api.github.com")) {
  try {
    $r = Invoke-WebRequest -Uri $u -Method Head -TimeoutSec 15 -UseBasicParsing
    Write-Host ("  OK   {0}   HTTP {1}" -f $u, $r.StatusCode) -ForegroundColor Green
  } catch {
    Write-Host ("  X    {0}   不可达" -f $u) -ForegroundColor Red
    Write-Host "       请先开启代理/VPN 再重跑本脚本。" -ForegroundColor Yellow
    exit 1
  }
}

Write-Host "`n=== 2/5 检查 GitHub 登录 ===" -ForegroundColor Cyan
& $GH auth status *> $null
if ($LASTEXITCODE -ne 0) {
  Write-Host "  未登录，启动浏览器授权（按提示在网页里输入一次性验证码）..." -ForegroundColor Yellow
  & $GH auth login --hostname github.com --git-protocol https --web
  if ($LASTEXITCODE -ne 0) { Write-Host "  X 登录失败" -ForegroundColor Red; exit 1 }
}
& $GH auth status

Write-Host "`n=== 3/5 提交本地改动 ===" -ForegroundColor Cyan
$email = (git config user.email)
if ($email -eq "yee@example.com" -or -not $email) {
  Write-Host "  ! 提交邮箱仍是占位符：$email" -ForegroundColor Yellow
  Write-Host "    GitHub 不会把提交关联到你的账号，建议先执行：" -ForegroundColor Yellow
  Write-Host "    git config user.email \"你的GitHub邮箱\"" -ForegroundColor Yellow
}
git add -A
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
  git commit -q -m "更新作品集内容"
  Write-Host "  已提交新改动" -ForegroundColor Green
} else {
  Write-Host "  工作区干净，无需提交" -ForegroundColor Green
}

Write-Host "`n=== 4/5 关联远程仓库 ===" -ForegroundColor Cyan
git remote remove origin 2>$null
git remote add origin "https://github.com/$REPO.git"
git remote -v

Write-Host "`n=== 5/5 推送到 GitHub ===" -ForegroundColor Cyan
Write-Host "  仓库约 87 MB，首次推送视网速需要 1-5 分钟，请勿中断..." -ForegroundColor DarkGray
git push -u origin $BRANCH
if ($LASTEXITCODE -ne 0) { Write-Host "  X 推送失败，把上面的报错发我" -ForegroundColor Red; exit 1 }

Write-Host "`n============================================" -ForegroundColor Green
Write-Host " 代码已推送：https://github.com/$REPO" -ForegroundColor Green
Write-Host " 下一步：在 Vercel 导入这个仓库即可上线" -ForegroundColor Green
Write-Host "============================================`n" -ForegroundColor Green

Start-Process "https://vercel.com/new"

