#!/usr/bin/env bash
# Installer Belajar Python Visual untuk Ubuntu Server (nginx).
# Pemakaian:
#   curl -fsSL https://raw.githubusercontent.com/ichalsmiler/belajar-python/main/install.sh | sudo bash
# Opsi (variabel lingkungan):
#   PORT=8080        port HTTP (default 80)
#   DOMAIN=contoh.id nama domain (default: semua host)
#   REPLACE_DEFAULT=1 nonaktifkan site "default" bawaan nginx (agar aplikasi
#                    tampil saat server dibuka lewat IP di port 80)
# Jalankan ulang perintah yang sama untuk update ke versi terbaru.
set -euo pipefail

REPO="https://github.com/ichalsmiler/belajar-python.git"
APP_DIR="/var/www/belajar-python"
PORT="${PORT:-80}"
DOMAIN="${DOMAIN:-_}"
REPLACE_DEFAULT="${REPLACE_DEFAULT:-0}"
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
  # Folder dimiliki www-data; tanpa safe.directory git (sebagai root) menolak dengan "dubious ownership".
  git -c safe.directory="$APP_DIR" -C "$APP_DIR" fetch --depth 1 origin main
  git -c safe.directory="$APP_DIR" -C "$APP_DIR" reset --hard origin/main
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
DEFAULT_WARNING=""
if [ -e /etc/nginx/sites-enabled/default ]; then
  if [ "$REPLACE_DEFAULT" = "1" ]; then
    echo "==> Menonaktifkan site default nginx (REPLACE_DEFAULT=1)"
    rm -f /etc/nginx/sites-enabled/default
  elif [ "$PORT" = "80" ] && [ "$DOMAIN" = "_" ]; then
    DEFAULT_WARNING=1
  fi
fi

nginx -t
systemctl enable --now nginx
systemctl reload nginx

if command -v ufw >/dev/null; then
  UFW_STATUS="$(ufw status || true)"
  case "$UFW_STATUS" in
    *"Status: active"*) ufw allow "$PORT/tcp" ;;
  esac
fi

IP="$(hostname -I | awk '{print $1}')"
echo
echo "Selesai! Buka: http://${IP}$( [ "$PORT" = "80" ] || echo ":$PORT" )/"
if [ -n "$DEFAULT_WARNING" ]; then
  echo
  echo "PERHATIAN: site 'default' nginx masih aktif di port 80, jadi alamat IP di atas"
  echo "mungkin masih menampilkan halaman bawaan nginx. Site default TIDAK dihapus."
  echo "Pilih salah satu lalu jalankan ulang installer:"
  echo "  - nonaktifkan site default : ... | sudo REPLACE_DEFAULT=1 bash"
  echo "  - pakai port lain          : ... | sudo PORT=8080 bash"
  echo "  - pakai domain             : ... | sudo DOMAIN=contoh.id bash"
fi
