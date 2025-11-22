FROM ubuntu:latest

RUN apt update -y && apt install -y curl build-essential musl-tools

RUN --mount=type=bind,source=/palantir-ca-bundle.crt,target=/certs/palantir-ca-bundle.crt \
    mkdir -p /usr/local/share/ca-certificates/palantir && \
    cp /certs/palantir-ca-bundle.crt /usr/local/share/ca-certificates/palantir/palantir-ca-bundle.crt && \
    update-ca-certificates

COPY /code /code

CMD ["bash", "/code/build_script.sh"]
