#!/usr/bin/env bash
# 部署脚本：将本目录静态文件上传到宝塔网站根目录
# 用法：bash deploy.sh
# 连接方式：本机 ~/.ssh/config 已配置 Host fdeline，直接用 ssh fdeline
# 说明：服务器未安装 rsync，这里用 scp；仅上传站点资源，排除 .workbuddy / deploy.sh / *.md

SSH_HOST="fdeline"
REMOTE_ROOT="/www/wwwroot/www.fdeline.com"
LOCAL_DIR="$(cd "$(dirname "$0")" && pwd)"

# 需要上传的文件/目录（保持站点最小集，不含文档与脚本）
FILES=(index.html 404.html sitemap.xml site.webmanifest assets blog)

set -e
echo ">> 上传 $LOCAL_DIR -> $SSH_HOST:$REMOTE_ROOT"
ssh "$SSH_HOST" "mkdir -p $REMOTE_ROOT"
scp -q -r "${FILES[@]/#/$LOCAL_DIR/}" "$SSH_HOST:$REMOTE_ROOT/"
ssh "$SSH_HOST" "chown -R www:www $REMOTE_ROOT 2>/dev/null; chmod -R 755 $REMOTE_ROOT; echo perms-ok"
echo ">> 完成。请到浏览器访问 https://www.fdeline.com 确认；若改过 nginx 配置记得 nginx -t && nginx -s reload。"
