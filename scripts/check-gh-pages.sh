#!/usr/bin/env bash

repo="${1:-missing}"
slug="${2:-missing}"
email="${3:-missing}"
token="${4:-missing}"


exists=$(gh api -X GET "repos/${repo}/branches" --jq '.[].name | select(. == "gh-pages")')
if [[ "$exists" != "gh-pages" ]]; then
  tmp=$(mktemp --directory)
  cd "$tmp"
  git config --global user.name "${slug}[bot]"
  git config --global user.email "${email}"
  git init
  git switch -c gh-pages
  git remote add origin https://${slug}[bot]:${token}@github.com/${repo}.git
  git commit --allow-empty -m 'initial gh-pages commit'
  git push --set-upstream origin gh-pages
  cd
fi
