FROM rust:1 as builder
WORKDIR /app
COPY . .
RUN cargo install --path .


FROM debian:buster-slim as runner
COPY --from=builder /usr/local/cargo/bin/rust_poc /usr/local/bin/rust_poc
ENV ROCKET_ADDRESS=0.0.0.0
EXPOSE 8000
CMD ["rust_poc"]