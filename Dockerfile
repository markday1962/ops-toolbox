# Build arguments
ARG ALPINE_VERSION=3.22

FROM alpine:${ALPINE_VERSION}

# Install packages
RUN apk --update --no-cache add jq aws-cli curl wget redis netcat-openbsd tcpdump

# Install argocd
# https://kostis-argo-cd.readthedocs.io/en/refresh-docs/getting_started/install_cli/
RUN ARGOCD_VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" \
| grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/') && curl -sSL -o /tmp/argocd-${ARGOCD_VERSION} \
https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64 \
&& chmod +x /tmp/argocd-${ARGOCD_VERSION} && mv /tmp/argocd-${ARGOCD_VERSION} /usr/local/bin/argocd

# Install kubectl
RUN curl --silent -LO https://storage.googleapis.com/kubernetes-release/release/\
$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
&& chmod +x ./kubectl && mv ./kubectl /usr/local/bin

# Set environment variables
ENV LANG='C.UTF-8'

# Start an interactive sh session by default
CMD ["/bin/sh"]
