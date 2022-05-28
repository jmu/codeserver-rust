FROM rust:latest


# https://github.com/coder/code-server/releases/download/v4.4.0/code-server-4.4.0-linux-arm64.tar.gz
ENV VERSION=4.4.0
ENV PLF=arm64
ENV CODESERVER=https://github.com/cdr/code-server/releases/download/v${VERSION}/code-server-${VERSION}-linux-${PLF}.tar.gz \
   DISABLE_TELEMETRY=true \
   SHELL=/bin/bash

ADD $CODESERVER code-server.tar


COPY config /home/coder/.cargo/

RUN echo "export RUSTUP_DIST_SERVER=https://mirrors.sjtug.sjtu.edu.cn/rust-static" >> ~/.bashrc \
&& echo "export RUSTUP_UPDATE_ROOT=https://mirrors.sjtug.sjtu.edu.cn/rust-static/rustup" >> ~/.bashrc \
&& source ~/.bashrc


RUN mkdir -p code-server \
   && tar -xf code-server.tar -C code-server --strip-components 1 \
   && cp code-server/code-server /usr/local/bin \
   && rm -rf code-server* && \
   apt-get update -y && \
   apt-get upgrade -y && \
   apt-get install -y --no-install-recommends bash git locales htop curl wget less net-tools tmux net-tools && \
   apt-get autoremove -y && \
   rustup component add rls rust-src rust-docs rust-analysis rustfmt && rustup update && \
   cargo install cargo-outdated && cargo install cargo-release && cargo install cargo-update && \
   mkdir -p /home/coder/project 
   #mkdir -p /home/coder/project && \
   #code-server --install-extension rust-lang.rust && \
   #code-server --install-extension humao.rest-client && \
   #code-server --install-extension HookyQR.beautify && \
   #code-server --install-extension liximomo.sftp


WORKDIR /root/project
VOLUME /root/project
EXPOSE 8443
ENTRYPOINT ["code-server"]
