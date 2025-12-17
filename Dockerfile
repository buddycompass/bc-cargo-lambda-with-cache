# syntax=docker/dockerfile:1.7

ARG CARGO_LAMBDA_VERSION=1.7.0
ARG CARGO_CHEF_VERSION=0.1.73
ARG SCCACHE_VERSION=0.12.0
ARG MOLD_VERSION=2.40.4
ARG SCCACHE_DIR=/sccache

FROM ghcr.io/cargo-lambda/cargo-lambda:${CARGO_LAMBDA_VERSION}
ARG CARGO_CHEF_VERSION
ARG SCCACHE_VERSION
ARG MOLD_VERSION
ARG SCCACHE_DIR

# ---- tools ------------------------------------------------
  
RUN cargo install cargo-chef --version ${CARGO_CHEF_VERSION} --locked

RUN ARCH=$(uname -m) \
 && curl -L https://github.com/mozilla/sccache/releases/download/v${SCCACHE_VERSION}/sccache-v${SCCACHE_VERSION}-${ARCH}-unknown-linux-musl.tar.gz \
 | tar xz \
 && cp sccache-*/sccache /usr/local/bin/ \
 && rm -rf sccache-*

RUN ARCH=$(uname -m) \
 && curl -L https://github.com/rui314/mold/releases/download/v${MOLD_VERSION}/mold-${MOLD_VERSION}-${ARCH}-linux.tar.gz \
 | tar xz \
 && cp mold-*/bin/* /usr/local/bin/ \
 && rm -rf mold-*

# ---- env --------------------------------------------------

ENV RUSTC_WRAPPER=sccache \
    SCCACHE_DIR=${SCCACHE_DIR} \
    CARGO_INCREMENTAL=0 \
    RUSTFLAGS="-C link-arg=-fuse-ld=mold"