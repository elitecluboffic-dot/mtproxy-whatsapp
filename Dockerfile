# Image resmi dari Meta/WhatsApp, sudah include HAProxy yang bicara
# protokol WhatsApp asli (Jabber/XMPP untuk chat, HTTPS untuk media).
# Source: https://github.com/WhatsApp/proxy
FROM facebook/whatsapp_proxy:latest

# Port-port yang disediakan image ini:
#   80    -> HTTP biasa
#   443   -> HTTPS (chat, terenkripsi) <-- dipakai untuk field "Port chat" + centang "Gunakan TLS"
#   5222  -> Jabber/XMPP polos (tanpa TLS)
#   587/7777 -> trafik media (*.whatsapp.net)
#   8080/8443/8222 -> SAMA seperti di atas, TAPI mengharapkan PROXY protocol header
#                     dari load balancer di depannya. JANGAN dipakai kalau expose langsung
#                     ke internet tanpa LB — koneksi akan diputus sebelum handshake selesai.
#   8199  -> statistik HAProxy (monitoring, sebaiknya jangan diexpose publik)

EXPOSE 80 443 5222 587 7777
