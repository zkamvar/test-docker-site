#!/bin/bash -l
set -e
pwd
case $1 in 
  "build")
      Rscript -e "corefast::build('site')"
  ;;
  "hello")
      Rscript -e "corefast::hello()"
  ;;
  *)
      echo "nothing here!"
  ;;
esac
echo "Action complete!"
