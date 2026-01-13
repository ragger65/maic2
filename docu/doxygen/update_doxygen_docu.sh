#!/bin/bash
# (Selection of shell)

RM=/bin/rm

$RM -rf html/*
$RM -rf latex/*

cd doxygen-config/

doxygen my_doxygen1.8.1-config.txt

cd ../

echo "==> Done." ;
#
