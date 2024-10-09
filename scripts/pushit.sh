#!/usr/bin/env bash

repo="${1:-missing}"
slug="${2:-missing}"
email="${3:-missing}"
token="${4:-missing}"

cd pages
git config --global user.name "${slug}[bot]"
git config --global user.email "${email}"
git remote set-url origin "https://${slug}[bot]:${token}@github.com/${repo}.git"
ls
git status
# remove everything in the old site
git rm -r "*" || echo "nothing to do"
cp -R ../_site/* .
touch .nojekyll
git add . && git commit --amend -m 'deploy'
git status
git push --force
cd 
