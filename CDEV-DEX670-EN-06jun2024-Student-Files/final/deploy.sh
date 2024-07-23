#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Deploy all deployment units (Mule apps, Docker containers) to the given environment (not all deployment units can be deployed to all environments)
#
# Usage  : deploy.sh <env> <client-id>                      <client-secret>                  <secure-props-key>
# Example: deploy.sh prod  e0............................99 FD............................85 securePropsCryptoKey
#
# Important: To run this script you must have:
# 1. Docker daemon running
# 2. all Mule apps built and packaged

ENV=$1        # Environment identifier
APCID=$2      # Anypoint Platform client ID to register with API Manager for autodiscovery
APSECRET=$3   # Anypoint Platform client secret for client ID
ENCRYPTKEY=$4 # Mule app secure properties en/decryption key
APCACID=$5    # Anypoint Platform Connected app client ID for deployment auth
APCASECRET=$6 # Anypoint Platform Connected app client secret for deployment auth

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

UNIT="all possible deployment units"


./standalone-apps/deploy.sh $ENV $APCID $APSECRET $ENCRYPTKEY