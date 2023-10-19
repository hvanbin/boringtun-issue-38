FROM rust:slim AS builder

WORKDIR /src
COPY . .
RUN cargo build --offline --release \
    && strip ./target/release/boringtun-cli

FROM debian:stable-slim
LABEL name="boringtun-cli"
WORKDIR /app
COPY --from=builder /src/target/release/boringtun-cli /app

ENV WG_LOG_LEVEL=info \
    WG_THREADS=4 \
    INTERFACE_NAME=wg0

ENTRYPOINT [ "/app/boringtun-cli", "--foreground", "$INTERFACE_NAME", "--disable-drop-privileges" ]
