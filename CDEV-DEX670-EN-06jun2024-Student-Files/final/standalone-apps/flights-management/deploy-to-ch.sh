#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Deploy this Mule app to the given CloudHub environment using the given configuration
#
# Usage  : deploy-to-ch.sh <env> <suffix> <vcores> <client-id>                      <client-secret>                  <secure-props-key>  <ch-private-space>
# Example: deploy-to-ch.sh prod  ''       0.1         e0............................99 FD............................85 securePropsCryptoKey nonprod-internalps

ENV=$1        # Environment identifier, only for the Mule app properties files selection, NOT for AP environment
SUFFIX=$2     # Mule app name suffix
CHVCORES=$3   # CloudHub vCores type (0.1, 0.5, ...)
APCID=$4      # Anypoint Platform client ID to register with API Manager for autodiscovery
APSECRET=$5   # Anypoint Platform client secret for client ID
ENCRYPTKEY=$6 # Mule app secure properties en/decryption key
APCACID=$7    # Anypoint Platform Connected app client ID for deployment auth
APCASECRET=$8 # Anypoint Platform Connected app client secret for deployment auth
CHSPACE=$9    # Private space ID

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

sts="$scriptdir/../../../etc/settings.xml"
mvns="mvn -s $sts -ff -U -DskipTests=true"

echo Confiuguration environment  : $ENV
echo Mule app name suffix        : $SUFFIX
echo Anypoint Platform region    : $CHSPACE
echo CloudHub vCores             : $CHVCORES
echo Anypoint Platform client ID : $APCID

$mvns clean deploy -DmuleDeploy\
      -Ddeployment.env=$ENV -Ddeployment.suffix=$SUFFIX \
      -Dch.space=$CHSPACE -Dch.vCores=$CHVCORES \
      -Dap.client_id=$APCID -Dap.client_secret=$APSECRET \
      -Dap.ca.client_id=$APCACID -Dap.ca.client_secret=$APCASECRET \
      -Dencrypt.key=$ENCRYPTKEY

		