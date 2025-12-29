# Build stage
FROM debian:bookworm-slim AS builder

ARG ZOLA_VERSION="0.19.2"
ARG ARCH="x86_64"

RUN apt update && apt install -y wget && rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/getzola/zola/releases/download/v${ZOLA_VERSION}/zola-v${ZOLA_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz
RUN tar -xzf zola-v${ZOLA_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz -C /usr/local/bin/ && \
    rm zola-v${ZOLA_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz

COPY zola/ /www.ac-room.org/
WORKDIR /www.ac-room.org/
RUN zola build

# Run stage
FROM nginx:1.27-alpine
COPY --from=builder /www.ac-room.org/public/ /usr/share/nginx/html/
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
