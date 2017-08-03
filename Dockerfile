# VERSION 1.37.12
FROM debian:8.8
MAINTAINER woshilapin "woshilapin@tuziwo.info"
LABEL version="1.37.12"

RUN DEBIAN_FRONTEND=noninteractive apt update -y && apt upgrade -y
RUN apt install -y curl
RUN apt install -y git-core
RUN apt install -y g++
RUN apt install -y cmake
RUN apt install -y python
RUN apt install -y default-jre

SHELL ["/bin/bash", "-c"]

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN source $HOME/.cargo/env \
		&& rustup install nightly \
		&& rustup default nightly
RUN source $HOME/.cargo/env \
		&& rustup target add asmjs-unknown-emscripten \
		&& rustup target add wasm32-unknown-emscripten

# Install Cmake
RUN curl --silent --show-error --fail --location --output cmake-3.8.2-Linux-x86_64.sh https://cmake.org/files/v3.8/cmake-3.8.2-Linux-x86_64.sh
# Install in /usr/local because /usr/local/bin has precedence over /bin or /usr/bin in default $PATH
RUN sh cmake-3.8.2-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir

# Install Emscripten
RUN curl --output emsdk-portable.tar.gz --location https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz
RUN tar xvzf emsdk-portable.tar.gz
RUN cd emsdk-portable \
		&& source ./emsdk_env.sh \
		&& emsdk update \
		&& emsdk install sdk-incoming-64bit \
		&& emsdk activate sdk-incoming-64bit \
		&& emcc --version
