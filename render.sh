#!/usr/bin/env bash
set -e

mkdir -p /site/pages/
cp -R /static/* /site/pages/
quarto render /site/pages/
