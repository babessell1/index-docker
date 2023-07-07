# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    samtools \
    parallel

# Change to your working directory
WORKDIR /usr/local/bin

# Set the entrypoint command
CMD ["run_index.sh"]