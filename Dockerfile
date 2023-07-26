# First stage: Build the RTSPtoWeb application
FROM golang:latest as builder

WORKDIR /
# Clone the RTSPtoWeb repository
RUN git clone https://github.com/deepch/RTSPtoWeb.git

# Build the application
WORKDIR /RTSPtoWeb
RUN CGO_ENABLED=0 go build

# Second stage: Create the final Docker image
FROM scratch

# Copy the RTSPtoWeb binary from the first stage
COPY --from=builder /RTSPtoWeb/RTSPtoWeb /
# Copy the frontend files
COPY --from=builder /RTSPtoWeb/web /web

# Copy the local config.json to the Docker image
COPY config.json /config.json

# Start the RTSPtoWeb server
CMD ["/RTSPtoWeb", "-config", "/config.json"]
