# FROM rocker/r-ubuntu:latest

# 
FROM ubuntu:jammy
# ## Set a default user. Available via runtime flag `--user docker` 
# ## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
# ## User should also have & own a home directory (for rstudio or linked volumes to work properly). 
RUN useradd -s /bin/bash -m docker \
  && usermod -a -G staff docker

# ## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
# COPY corefast /corefast
# COPY entrypoint.sh /entrypoint.sh

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
#   software-properties-common \
#   dirmngr \
#   ed \
#   gpg-agent \
#   less \
#   locales \
#   vim-tiny \
#   wget \
  ca-certificates
# RUN wget -q -O - https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
#     | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc  \
#   && add-apt-repository --yes "ppa:marutter/rrutter4.0" \
#   && add-apt-repository --yes "ppa:c2d4u.team/c2d4u4.0+" \
#   && add-apt-repository --yes "ppa:edd/misc"
RUN apt-get update && apt-get install -y --no-install-recommends \
  locales \
  pandoc \
  curl \
  libcurl4-openssl-dev \
  gdebi-core \
  && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen en_US.utf8 \
  && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

## This was not needed before but we need it now
ENV DEBIAN_FRONTEND noninteractive

## Otherwise timedatectl will get called which leads to 'no systemd' inside Docker
ENV TZ UTC




ARG QUARTO_VERSION="1.5.57"
RUN curl -o quarto-linux-amd64.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb
# RUN curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN dpkg -i quarto-linux-amd64.deb

# ENTRYPOINT ["sh","/entrypoint.sh"]
CMD ["bash"]
