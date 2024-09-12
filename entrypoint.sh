#!/bin/bash -l
set -e
case $1 in 
  "build")
      Rscript -e "corefast::build()"
  ;;
  "hello")
      Rscript -e "corefast::hello()"
  ;;
  *)
      echo "nothing here!"
  ;;
esac
echo "Action complete!"
