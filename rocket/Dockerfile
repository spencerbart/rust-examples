#Not many modifications needed, just the ones below
FROM rust:1 as builder
WORKDIR /app
COPY . .
RUN cargo install --path .


FROM debian:buster-slim as runner
#You need to update below with the name of your project
COPY --from=builder /usr/local/cargo/bin/{PROJECT_NAME_HERE} /usr/local/bin/{PROJECT_NAME_HERE}
ENV ROCKET_ADDRESS=0.0.0.0
EXPOSE 8000
CMD [{PROJECT_NAME_HERE}]