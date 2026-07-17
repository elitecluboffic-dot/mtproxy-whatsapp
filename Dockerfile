# Image resmi Meta/WhatsApp
FROM facebook/whatsapp_proxy:latest

# Timpa config resmi dengan versi yang sudah diaktifkan logging-nya.
# Path ini sesuai dengan yang dipakai script "set_public_ip_and_start.sh" resmi
# (baris #PUBLIC_IP tetap dipertahankan supaya proses substitusi IP saat start tetap jalan normal).
COPY proxy_config.cfg /usr/local/etc/haproxy/haproxy.cfg

EXPOSE 80 443 5222 587 7777 8080 8443 8222 8199
