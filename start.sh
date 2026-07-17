#!/bin/bash
set -e

# ==================== Konfigurasi SOCKS5 (WhatsApp Proxy) ====================
SOCKS_PORT="${SOCKS_PORT:-1080}"
SOCKS_USER="${SOCKS_USER:-}"
SOCKS_PASS="${SOCKS_PASS:-}"
MAXCONN="${MAXCONN:-200}"

if [ -z "$SOCKS_USER" ] || [ -z "$SOCKS_PASS" ]; then
    echo "[WA-Proxy] WARNING: SOCKS_USER / SOCKS_PASS belum di-set!"
    echo "[WA-Proxy] Proxy akan jalan TANPA AUTH (open proxy, siapa saja bisa pakai)."
    echo "[WA-Proxy] Sangat disarankan set SOCKS_USER dan SOCKS_PASS di environment variable."
fi

# Ambil IP internal container
LOCAL_IP=$(hostname -I | awk '{print $1}')

# Ambil IP publik Railway via metadata atau fallback ke ipify
if [ -n "$RAILWAY_PUBLIC_DOMAIN" ]; then
    PUBLIC_IP=$(getent hosts "$RAILWAY_PUBLIC_DOMAIN" | awk '{print $1}' | head -1)
else
    PUBLIC_IP=$(curl -s https://api.ipify.org 2>/dev/null || echo "")
fi

echo "[WA-Proxy] ============================================"
echo "[WA-Proxy] Starting WhatsApp SOCKS5 Proxy..."
echo "[WA-Proxy] Port      : $SOCKS_PORT"
echo "[WA-Proxy] Max Conn  : $MAXCONN"
if [ -n "$SOCKS_USER" ] && [ -n "$SOCKS_PASS" ]; then
    echo "[WA-Proxy] Auth      : $SOCKS_USER / (password di-set)"
else
    echo "[WA-Proxy] Auth      : (tidak ada)"
fi
echo "[WA-Proxy] Local IP  : $LOCAL_IP"
echo "[WA-Proxy] Public IP : $PUBLIC_IP"
echo "[WA-Proxy] ============================================"
echo "[WA-Proxy] Cara pakai di WhatsApp:"
echo "[WA-Proxy]   Settings -> Storage and Data -> Proxy -> Use Proxy"
echo "[WA-Proxy]   Masukkan: ${PUBLIC_IP:-<PUBLIC_IP>}:${SOCKS_PORT}"
echo "[WA-Proxy] ============================================"

CONF_FILE=/tmp/3proxy.cfg
{
  echo "daemon"
  echo "maxconn $MAXCONN"
  echo "nserver 1.1.1.1"
  echo "nserver 8.8.8.8"
  echo "nscache 65536"
  echo "timeouts 1 5 30 60 180 1800 15 60"
  if [ -n "$SOCKS_USER" ] && [ -n "$SOCKS_PASS" ]; then
    echo "auth strong"
    echo "users $SOCKS_USER:CL:$SOCKS_PASS"
    echo "allow $SOCKS_USER"
  else
    echo "auth none"
  fi
  echo "socks -p$SOCKS_PORT"
} > "$CONF_FILE"

exec /usr/local/bin/3proxy "$CONF_FILE"
