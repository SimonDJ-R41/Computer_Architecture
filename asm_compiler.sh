#!/bin/bash
for i in "$@"
do
  as "$1".asm -o "$1".o
  ld "$1".o -o "$1"
done
