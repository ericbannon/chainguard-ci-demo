FROM cgr.dev/chainguard/curl:latest-dev AS builder

USER root
WORKDIR /usr/local/bin
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl


FROM bannimal/kaniko-kubectl-agent:latest

COPY --from=builder /usr/local/bin/kubectl /usr/local/bin/kubectl

ENTRYPOINT ["/kaniko/executor"]