#!/bin/bash
for i in "$@";
do
  as "$i".asm -o "$i".o
  ld "$i".o -o "$i"
done
