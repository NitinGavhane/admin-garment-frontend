#!/usr/bin/env bash
# Redeploy the ADMIN web app to AWS (build -> S3 -> clear CloudFront cache).
# Run:  bash frontend/deploy-web.sh
set -euo pipefail

AWS="/c/Program Files/Amazon/AWSCLIV2/aws.exe"   # aws CLI is not on PATH in Git Bash
BUCKET="dristi-admin-web-078525505229"
DIST_ID="E3BVP4DZHKPN5L"
REGION="ap-south-1"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "==> Building admin web..."
flutter build web --release --no-tree-shake-icons

echo "==> Uploading to S3..."
"$AWS" s3 sync build/web "s3://$BUCKET" --delete --only-show-errors --region "$REGION"

echo "==> Invalidating CloudFront cache (so users get the new version)..."
"$AWS" cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "/*" --query "Invalidation.Status" --output text

echo "==> Done. Live at https://d30ai0wvr18s47.cloudfront.net (cache clears in ~1-2 min)"
