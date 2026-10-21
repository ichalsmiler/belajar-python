#!/usr/bin/env bash
# Installer Belajar Python Visual untuk Ubuntu Server (nginx).
# Pemakaian:
#   curl -fsSL https://raw.githubusercontent.com/ichalsmiler/belajar-python/main/install.sh | sudo bash
# Opsi (variabel lingkungan):
#   PORT=8080        port HTTP (default 80)
#   DOMAIN=contoh.id nama domain (default: semua host)
# Jalankan ulang perintah yang sama untuk update ke versi terbaru.
set -euo pipefail

REPO="https://github.com/ichalsmiler/belajar-python.git"
APP_DIR="/var/www/belajar-python"
PORT="${PORT:-80}"
DOMAIN="${DOMAIN:-_}"
SITE="/etc/nginx/sites-available/belajar-python"

if [ "$(id -u)" -ne 0 ]; then
  echo "Jalankan dengan sudo." >&2
  exit 1
fi

echo "==> Memasang nginx dan git"
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y nginx git

echo "==> Mengambil kode ke $APP_DIR"
if [ -d "$APP_DIR/.git" ]; then
  git -C "$APP_DIR" fetch --depth 1 origin main
  git -C "$APP_DIR" reset --hard origin/main
else
  rm -rf "$APP_DIR"
  git clone --depth 1 "$REPO" "$APP_DIR"
fi
chown -R www-data:www-data "$APP_DIR"

echo "==> Menulis konfigurasi nginx (port $PORT, domain $DOMAIN)"
cat > "$SITE" <<EOF
server {
    listen $PORT;
    listen [::]:$PORT;
    server_name $DOMAIN;

    root $APP_DIR;
    index index.html;

    location ~ /\.git { deny all; }
    location / { try_files \$uri \$uri/ /index.html; }
}
EOF
ln -sf "$SITE" /etc/nginx/sites-enabled/belajar-python
if [ "$PORT" = "80" ] && [ "$DOMAIN" = "_" ]; then
  rm -f /etc/nginx/sites-enabled/default
fi

nginx -t
systemctl enable --now nginx
systemctl reload nginx

if command -v ufw >/dev/null && ufw status | grep -q "Status: active"; then
  ufw allow "$PORT/tcp"
fi

IP="$(hostname -I | awk '{print $1}')"
echo
echo "Selesai! Buka: http://${IP}$( [ "$PORT" = "80" ] || echo ":$PORT" )/"
