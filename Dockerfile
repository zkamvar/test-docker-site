FROM rhub/r-minimal

COPY corefast /pkg
COPY entrypoint.sh /entrypoint.sh

RUN apt-get update && apt-get install -y --no-install-recommends \
    pandoc \
    pandoc-citeproc \
    curl \
    gdebi-core \
    && rm -rf /var/lib/apt/lists/*

RUN installr -d -t "openssl-dev libgit2-dev" -a "openssl libgit2" local::/pkg

ARG QUARTO_VERSION="1.5.57"
RUN curl -o quarto-linux-amd64.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb
# RUN curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN gdebi --non-interactive quarto-linux-amd64.deb

ENTRYPOINT ["sh","/entrypoint.sh"]
CMD ["bash"]
