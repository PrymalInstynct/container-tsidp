# Stage 1: Build the Go application
FROM docker.io/golang:1.23.4 AS builder

# Set environment variables
ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

# Directory to clone source inside the container
WORKDIR /go/src

# Clone the repository
RUN curl -fsSL "https://github.com/tailscale/tailscale/archive/refs/tags/v1.78.1.tar.gz" \
    | tar xzf - -C /go/src --strip-components=1

# Navigate to the directory containing the source code and build it
WORKDIR /go/src/cmd/tsidp
RUN go build -o tsidp .

# Stage 2: Create Runtime Image
FROM docker.io/alpine:3.21.0

# Set Working Directory
WORKDIR /config/tsidp

# Set environment variables
ENV HOME=.
ENV TS_HOSTNAME=tsidp
ENV TS_AUTHKEY=
ENV TS_STATE_DIR=/config/tsidp
ENV TS_USERSPACE=false
ENV TAILSCALE_USE_WIP_CODE=1

# Create a mountable directory
RUN mkdir -p /config/tsidp
VOLUME /config/tsidp

# Copy the built application from the builder stage
COPY --from=builder /go/src/cmd/tsidp/tsidp /usr/local/bin

# Run the application
CMD ["tsidp"]