# Stage 1: Build the Go application
FROM docker.io/golang:1.23.6 AS builder

# Set environment variables
ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

# Directory to place source inside the container
WORKDIR /go/src

# Identify the latest release of tailscale, download the source code, and extract it to the /go/src directory
RUN curl -fsSL "https://api.github.com/repos/tailscale/tailscale/tarball/v1.80.0" \
    | tar xzf - -C /go/src --strip-components=1

# Navigate to the directory containing the source code and build it
WORKDIR /go/src/cmd/tsidp
RUN go build -o tsidp .

# Stage 2: Create Runtime Image
FROM docker.io/alpine:3.21.2

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