FROM rocker/verse:latest

COPY ./corefast /corefast
COPY entrypoint.sh /entrypoint.sh

RUN install2.r pak
RUN Rscript -e "pak::pak('/corefast')"

ENTRYPOINT ["sh","/entrypoint.sh"]
