#!/usr/bin/env bash

# for more information see https://hub.docker.com/r/blang/latex

docker run --rm -i --user="$(id -u):$(id -g)" -v "$PWD":/data blang/latex:ubuntu latexmk -pdf main.tex
