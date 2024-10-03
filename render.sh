#!/usr/bin/env bash
set -e

ORG=${1:-"hubverse-org"}
REPO=${2:-"hub-dashboard-predtimechart"}
BRANCH=${3:-"main"}
DIR=${4:-""}
if [[ $ORG == "hubverse-org" && $REPO == "hub-dashboard-predtimechart" ]]; then
  DIR="demo/"
fi
ROOT="https://raw.githubusercontent.com/$ORG/$REPO/refs/heads/$BRANCH/$DIR"

cp -R /static/* /site/pages/
sed -i -E "s+\{ROOT\}+$ROOT+" /site/pages/resources/predtimechart.js
quarto render /site/pages/
