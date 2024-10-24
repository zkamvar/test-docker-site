#!/usr/bin/env bash

branch="${1:-'gh-pages'}"
repo="${2:-missing}"
slug="${3:-missing}"
email="${4:-missing}"
token="${5:-missing}"

if [[ "$branch" == "gh-pages" ]];then
  dir="pages"
else
  dir="data"
fi

cd "$dir" || (echo "Directory '$dir' not found" && exit 1)
git config --global user.name "${slug}[bot]"
git config --global user.email "${email}"
git remote set-url origin "https://${slug}[bot]:${token}@github.com/${repo}.git"
ls
git status
if [[ "$branch" == "gh-pages" ]]; then
  # remove everything in the old site
  git rm -r "*" || echo "nothing to do"
  cp -R ../_site/* .
  touch .nojekyll
  git add . && git commit --amend -m 'deploy'
  git status
  git push --force
else 
  # remove old data
  git rm -r "*" || echo "nothing to do"
  cp -R ../forecasts .
  cp -R ../targets .
  cp ../predtimechart-options.json .
  git add . && git commit --amend -m 'update data'
  git push --force
fi
cd 
