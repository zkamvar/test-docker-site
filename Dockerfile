FROM ubuntu:jammy
ARG QUARTO_VERSION="1.5.57"
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
RUN useradd -s /bin/bash -m docker \
  && usermod -a -G staff docker \
  && apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  locales \
  wget \
  && rm -rf /var/lib/apt/lists/* \
  && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen en_US.utf8 \
  && /usr/sbin/update-locale LANG=en_US.UTF-8 \
  && wget https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb \
  && dpkg -i quarto-*-linux-amd64.deb

COPY static /static
COPY entrypoint.sh entrypoint.sh
ENTRYPOINT ["sh", "entrypoint.sh"]
