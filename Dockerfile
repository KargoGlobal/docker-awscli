FROM debian:trixie AS production
ARG TARGETARCH

RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install --assume-yes curl jq gpg unzip </dev/null >/dev/null && \
    rm -rf /var/lib/apt/lists/*

COPY aws_cli_installer_public_key.gpg /
RUN INSTRUCTION_SET=$([ $TARGETARCH = "amd64" ] && echo x86_64 || echo aarch64 ) && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-"$INSTRUCTION_SET".zip" -o "awscliv2.zip" && \
    gpg --import /aws_cli_installer_public_key.gpg && \
    curl -o awscliv2.sig https://awscli.amazonaws.com/awscli-exe-linux-$INSTRUCTION_SET.zip.sig && \
    gpg --verify awscliv2.sig awscliv2.zip && \
    unzip -u awscliv2.zip && \
    ./aws/install && \
    aws --version
