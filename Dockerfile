# Build the manager binary
FROM golang:1.10.3 as builder

# Copy in the go src
WORKDIR /go/src/github.com/daisy-ycguo/ingress-source
COPY pkg/    pkg/
COPY cmd/    cmd/
COPY vendor/ vendor/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o manager github.com/daisy-ycguo/ingress-source/cmd/manager

# Copy the controller-manager into a thin image
FROM ubuntu:latest
WORKDIR /
COPY --from=builder /go/src/github.com/daisy-ycguo/ingress-source/manager .
ENTRYPOINT ["/manager"]
