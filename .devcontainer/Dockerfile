# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.137.0/containers/go/.devcontainer/base.Dockerfile
ARG VARIANT="1"
FROM mcr.microsoft.com/vscode/devcontainers/go:0-${VARIANT}

# [Option] Install Node.js
ARG INSTALL_NODE="true"
ARG NODE_VERSION="lts/*"
RUN if [ "${INSTALL_NODE}" = "true" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends unzip

# [Optional] Uncomment the next line to use go get to install anything else you need
ENV PB_REL="https://github.com/protocolbuffers/protobuf/releases"

ENV PROTOC_HOME=/opt/protoc/

RUN curl -LO $PB_REL/download/v3.15.3/protoc-3.15.3-linux-x86_64.zip \
&& sudo unzip protoc-3.15.3-linux-x86_64.zip -d $PROTOC_HOME \
&& rm protoc-3.15.3-linux-x86_64.zip \
&& chmod -R 777 $PROTOC_HOME/bin \
&& PATH="$PATH:$PROTOC_HOME/bin"

RUN sudo apt install curl gnupg \
&& curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > bazel.gpg \
&& sudo mv bazel.gpg /etc/apt/trusted.gpg.d/ \
&& echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list \
&& sudo apt update -y && sudo apt install -y bazel \
&& sudo apt update -y && sudo apt full-upgrade -y

RUN go get github.com/bazelbuild/buildtools/buildifier \
&& cd /opt \
&& sudo git clone https://github.com/bazelbuild/bazel-watcher \
&& cd bazel-watcher \
&& bazel build //ibazel \
&& sudo ln -s -f /opt/bazel-watcher/bazel-bin/ibazel/linux_amd64_stripped/ibazel /usr/bin/ibazel

RUN sudo apt install -y patch

ENV PATH=$PATH:/opt/bazel-watcher/bazel-bin/ibazel/linux_amd64_stripped

ENV GO111MODULE=on
RUN go get google.golang.org/protobuf/cmd/protoc-gen-go google.golang.org/grpc/cmd/protoc-gen-go-grpc

RUN curl -LO https://github.com/fullstorydev/grpcurl/releases/download/v1.8.0/grpcurl_1.8.0_linux_x86_64.tar.gz \
&& tar -xvf grpcurl_1.8.0_linux_x86_64.tar.gz grpcurl \
&& sudo mv grpcurl /usr/local/bin/

ENV PATH="$PATH:$GOPATH/bin"