# Dockerfile for TeamCity Agent - A Tour of C++ Project Environment
FROM jetbrains/teamcity-agent:latest

# Switch to root to install packages
USER root

# Install essential build tools and dependencies
RUN apt-get update && apt-get install -y \
    curl \
    tar \
    zip \
    unzip \
    git \
    pkg-config \
    software-properties-common \
    ninja-build \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Clang (latest version)
RUN apt-get update && apt-get install -y \
    clang \
    clang-tools \
    libc++-dev \
    libc++abi-dev \
    && rm -rf /var/lib/apt/lists/*

# Install CMake 3.20+
# First remove any existing cmake
RUN apt-get update && apt-get remove -y cmake && rm -rf /var/lib/apt/lists/*

# Install CMake from official releases
RUN curl -L https://github.com/Kitware/CMake/releases/download/v3.28.1/cmake-3.28.1-linux-x86_64.sh \
    -o cmake-install.sh && \
    chmod +x cmake-install.sh && \
    ./cmake-install.sh --skip-license --prefix=/usr/local && \
    rm cmake-install.sh

# Install vcpkg
RUN git clone https://github.com/microsoft/vcpkg.git /opt/vcpkg && \
    cd /opt/vcpkg && \
    ./bootstrap-vcpkg.sh && \
    chmod +x /opt/vcpkg/vcpkg

# Set vcpkg environment variable
ENV VCPKG_ROOT=/opt/vcpkg
ENV PATH="${VCPKG_ROOT}:${PATH}"

# Setup vcpkg with proper permissions for buildagent
RUN mkdir -p /opt/vcpkg/downloads && \
    mkdir -p /opt/vcpkg/buildtrees && \
    mkdir -p /opt/vcpkg/packages && \
    mkdir -p /home/buildagent/.cache/vcpkg && \
    chown -R buildagent:buildagent /opt/vcpkg && \
    chmod -R 777 /opt/vcpkg && \
    chown -R buildagent:buildagent /home/buildagent/.cache

# Create a build directory that can be used by the TeamCity agent
RUN mkdir -p /opt/build && \
    chmod 777 /opt/build

# Switch back to the TeamCity agent user
USER buildagent

# Set working directory
WORKDIR /opt/buildAgent