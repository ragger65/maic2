#!/bin/bash
# (Selection of shell)

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# copy_templates.sh
#
# Description:
#   Making local, not version-controlled copies of the
#   run-specification header files.
#
# Author: Ralf Greve
# Date:   2026-01-15
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CP=/bin/cp

MAIN_DIR="."
HEADER_DIR="${MAIN_DIR}/headers"
TEMPLATE_DIR_NAME="templates"

echo "Copying run-specification headers *.h"
echo "        from ${HEADER_DIR}/${TEMPLATE_DIR_NAME}"
echo "        to ${HEADER_DIR} ..."
echo " "
$CP -f ${HEADER_DIR}/${TEMPLATE_DIR_NAME}/*.h ${HEADER_DIR}

echo "... done!"
echo " "

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
