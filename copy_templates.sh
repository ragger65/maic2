#!/bin/bash
# (Selection of shell)

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# copy_templates.sh
#
# Description:
#   Making local, not version-controlled copies of the scripts for executing
#   MAIC-2 and the run-specification header files.
#
# Author: Ralf Greve
# Date:   2026-01-16
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CP=/bin/cp

MAIN_DIR="."
HEADER_DIR="${MAIN_DIR}/headers"
TEMPLATE_DIR_NAME="templates"

echo "Copying scripts *.sh"
echo "        from ${MAIN_DIR}/${TEMPLATE_DIR_NAME}"
echo "        to ${MAIN_DIR} ..."
echo " "
$CP -f ${MAIN_DIR}/${TEMPLATE_DIR_NAME}/*.sh ${MAIN_DIR}

echo "Copying run-specification headers *.h"
echo "        from ${HEADER_DIR}/${TEMPLATE_DIR_NAME}"
echo "        to ${HEADER_DIR} ..."
echo " "
$CP -f ${HEADER_DIR}/${TEMPLATE_DIR_NAME}/*.h ${HEADER_DIR}

echo "... done!"
echo " "

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
