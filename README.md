Testing a website builder. 

I am going to try using this as a Docker GitHub action so that it can be portable.

Prior Art: https://respicast.ecdc.europa.eu/forecasts/



## Tools

For this test, I want a proof of concept that just works. I don't want to have to
fiddle around with new-to-me tools... I just want something that works. In that
light, I am going to crib from https://github.com/european-modelling-hubs/covid19-forecast-hub-europe-website,
which uses R Markdown. 

I also want to avoid vendor lock-in, so ironically, I am using Docker (which is in and of itself a vendor).

### Docker Sources for R

There are two main Docker sources for R: R-hub and the Rocker project

#### R-Hub

Website: https://r-hub.github.io/containers/

#### Rocker

Website: https://rocker-project.org/images/

To build

```sh
docker build --platform=linux/amd64 --tag corefast:latest.
```

To run:

```sh
docker run \
  --platform=linux/amd64 \
  --rm \
  --ti \
  -v "$(pwd)":"/site" \
  corefast build
```


