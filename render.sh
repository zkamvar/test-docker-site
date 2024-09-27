#!/usr/bin/env bash
set -e

mkdir -p /site/pages/
cp /site/*md /site/pages/
cp -R /static/* /site/pages/
quarto render /site/pages/
