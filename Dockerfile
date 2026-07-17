# ---- Build stage: compile 3proxy dari source ----
FROM debian:bookworm-slim AS build

RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/3proxy/3proxy.git /opt/3proxy
WORKDIR /opt/3proxy
RUN make -f Makefile.Linux

# ---- Runtime stage ----
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/3proxy/bin/3proxy /usr/local/bin/3proxy

WORKDIR /opt/whatsapp-proxy
COPY start.sh ./start.sh
RUN chmod +x ./start.sh /usr/local/bin/3proxy

# Port SOCKS5 (diatur juga lewat env SOCKS_PORT)
EXPOSE 1080

ENTRYPOINT ["./start.sh"]
