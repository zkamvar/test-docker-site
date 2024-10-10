#!/usr/bin/env bash

branch="${1:-'gh-pages'}"
repo="${2:-missing}"
slug="${3:-missing}"
email="${4:-missing}"
token="${5:-missing}"

if [[ "$branch" == "gh-pages" ]]; then
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
else 
  cd data
  git config --global user.name "${slug}[bot]"
  git config --global user.email "${email}"
  git remote set-url origin "https://${slug}[bot]:${token}@github.com/${repo}.git"
  ls
  git status
  cp -R ../out/* .
  git add . && git commit -m 'update data'
  git push
fi
