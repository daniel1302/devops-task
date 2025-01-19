FROM golang:1.23 AS builder

COPY ./ /app/

WORKDIR /app

RUN go build -o /api-bin ./...

FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
        curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /api-bin /api-bin

EXPOSE 8081

ENTRYPOINT ["/api-bin"]
