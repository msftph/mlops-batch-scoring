# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.154.2/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version: bionic, focal
ARG VARIANT="focal"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# Install the terraform gpg key
# Install the microsoft gpg key
# Install the apt-add-repository command
# Install the hashicorp apt repository
# Install the microsoft apt repository
# Install terraform, pip3, azure cli
# Install azureml sdk
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
RUN curl -sL  https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install --no-install-recommends software-properties-common ca-certificates curl apt-transport-https lsb-release gnupg
RUN apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main"
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install --no-install-recommends python3-pip terraform azure-cli
RUN pip3 install azureml-sdk