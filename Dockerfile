FROM golang:1.11.5 as builder

ENV http_proxy http://192.168.1.166:8123
ENV https_proxy http://192.168.1.166:8123

WORKDIR /go/github.com/panyongde/shippy-user-service

COPY . .

RUN go get
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo .


FROM alpine:latest

RUN apk --no-cache add ca-certificates

RUN mkdir /app
WORKDIR /app
COPY --from=builder /go/github.com/panyongde/shippy-user-service .

CMD ["./shippy-user-service"]
