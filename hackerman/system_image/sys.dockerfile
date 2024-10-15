# NOTE: This is a system image for the hackerman page. This is meant to be compiled using the C2W tool.
# See: https://github.com/ktock/container2wasm
FROM riscv64/alpine:latest

COPY etc /etc
COPY root /root

USER root
WORKDIR /root
ENTRYPOINT ["/bin/sh -l"]