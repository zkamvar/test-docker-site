#!/usr/bin/env bash
set -e

cp -R /static/* /site/pages/
quarto render /site/pages/
