Testing a website builder. 

I am going to try using this as a Docker GitHub action so that it can be portable.

Prior Art: https://respicast.ecdc.europa.eu/forecasts/



## Tools

For this test, I want a proof of concept that just works. I don't want to have to
fiddle around with new-to-me tools... I just want something that works. In that
light, I am going to crib from https://github.com/european-modelling-hubs/covid19-forecast-hub-europe-website,
which uses R Markdown. 

### Website Builder

We will build the website using [quarto](https://quarto.org), as it is one of the most flexible formats for generating static sites.

The idea for this is to have a ready-made template where we can drop in markdown files and get a website out the other end. 

The template for the website lives in `static/`, which contains a quarto project with the following structure

```
static
├── _quarto.yml
├── forecast.qmd
└── resources
    ├── blank.html
    ├── css
    │   └── styles.css
    ├── header.html
    └── predtimechart.js
```

 - `_quarto.yml` is the quarto configuration file
 - `forecast.qmd` is a quarto markdown file that loads the predtimechart script in the header and has a single `#forecastVis_row` that gets replaced on load.
 - `resources/` is a folder that contains the HTML, JavaScript, and CSS for the website style and function (cribbed from european-modelling-hubs website).

> [!NOTE]
> Predtimechart assumes bootstrap 3, but Quarto uses bootstrap 5 with
> a grid system instead of the box model. I have added a couple of JS lines
> to account for that and update the relevant boxes.


### Docker

I want to avoid vendor lock-in, so ironically, I am using Docker (which is in and of itself a vendor).
This docker container is built on the Ubuntu image with quarto.

#### To build the docker container

```sh
docker build --platform=linux/amd64 --tag corefast:latest.
```

To run:

```sh
$ docker run \
  --platform=linux/amd64 \
  --rm \
  --ti \
  -v "$(pwd)":"/site" \
  corefast:latest \
  bash render.sh
```

You will have a new folder called `_site/`in your working directory, which will
contain the rendered dashboard website.

### GitHub Workflow helpers

The idea behind the GitHub workflow is to have a GitHub App that is registered
to the individual repositories with markdown. `getInstallations.py` fetches the
names of the repositories that have the app installed and then that gets fed 
into a github job matrix. Each job has an individual token generated (via
`getToken.py`) so that the built website can be pushed to the github pages
branch. 
