# Image resmi dari Meta/WhatsApp, sudah include HAProxy yang bicara
# protokol WhatsApp asli (Jabber/XMPP untuk chat, HTTPS untuk media).
# Source: https://github.com/WhatsApp/proxy
FROM facebook/whatsapp_proxy:latest

# Port-port yang disediakan image ini:
#   80    -> HTTP biasa
#   443   -> HTTPS (chat, terenkripsi) <-- dipakai untuk field "Port chat" + centang "Gunakan TLS"
#   5222  -> Jabber/XMPP polos (tanpa TLS)
#   587/7777 -> trafik media (*.whatsapp.net)
#   8080/8443/8222 -> sama seperti di atas tapi expect PROXY protocol (load balancer)
#   8199  -> statistik HAProxy (monitoring)
#
# Rekomendasi resmi: untuk expose ke IP publik cukup pakai 443 (chat) dan 587 (media).
EXPOSE 80 443 5222 587 7777 8080 8443 8222 8199
