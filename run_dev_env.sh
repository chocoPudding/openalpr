#!/bin/bash

workdir=$PWD
user=$(id -u)

run()
{
sudo docker run --user dev -it --security-opt seccomp=unconfined \
   -v $workdir:/srv/workdir \
   -v ~/.vim:/home/dev/.vim \
   -v ~/.vimrc:/home/dev/.vimrc \
   -v ~/.vscode:/home/dev/.vscode \
   -v ~/.bashrc:/home/dev/.bashrc \
   -v $workdir/conan:/home/dev/.conan dev-env
}

build()
{
   sudo docker build -f Dockerfile.devel --build-arg UID=${user} -t dev-env ${workdir}
}

usage()
{
   echo "Usage:"
   echo "      -b/--build : Build dev image"
   echo "      -r/--run: Run dev image"
}

# handle non-option arguments
if [[ $# -lt 1 ]]; then
    usage
    exit 4
fi

for i in "$@"; do
  case $i in
    -b|--build)
      build
      shift
      ;;
    -r|--run)
      run
      shift
      ;;
    *)
      # unknown option
      usage
      ;;
  esac
done

