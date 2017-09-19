FROM buildpack-deps:stretch

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN apt-get update && apt-get install -y gcc-arm-none-eabi libcurl4-openssl-dev libelf-dev libdw-dev cmake binutils-dev libiberty-dev

RUN set -eux; \
    cd /root; \
    wget https://github.com/SimonKagstrom/kcov/archive/master.tar.gz; \
    tar xzf master.tar.gz; \
    cd kcov-master; \
    mkdir build; \
    cd build; \
    cmake ..; \
    make; \
    make install; \
    cd ../..; \
    rm -rf kcov-master; \
    url="https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"; \
    wget "$url"; \
    rustupSha256='f5833a64fd549971be80fa42cffc6c5e7f51c4f443cd46e90e4c17919c24481f'; \
    echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ls ./rustup-init ; \
    ./rustup-init -y --no-modify-path --default-toolchain nightly-2017-09-18; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    cargo install xargo; \
    cargo install clippy --vers 0.0.162; \
    cargo install cargo-kcov; \
    rustup component add rust-src; \
    rustup --version; \
    cargo --version; \
    rustc --version; \
    xargo --version;

