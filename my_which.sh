#!/bin/bash

which $1  >/dev/null 2>&1

if [ $? -gt 0 ]; then
  echo ".nothing-${1}"
else
  which $1
fi
