#!/usr/bin/env bash
set -e

cp -R /static/* /site/
quarto render /site/
