#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Deploy this Mule app to the given environment using the given configuration
#
# Usage  : deploy.sh <env> <client-id>                      <client-secret>                  <secure-props-key>
# Example: deploy.sh prod  e0............................99 FD............................85 securePropsCryptoKey

ENV=$1        # Environment identifier
APCID=$2      # Anypoint Platform client ID to register with API Manager for autodiscovery
APSECRET=$3   # Anypoint Platform client secret for client ID
ENCRYPTKEY=$4 # Mule app secure properties en/decryption key
APCACID=$5    # Anypoint Platform Connected app client ID for deployment auth
APCASECRET=$6 # Anypoint Platform Connected app client secret for deployment auth

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

UNIT="$(basename $scriptdir)"

isRelease=$(../../../is-release-version.sh)

if [ "$isRelease" == "true" ]; then
	echo "Deploying release version of $UNIT"
	case $ENV in 
		dev|test)
			echo "Deploying $UNIT to $ENV"
			./deploy-to-ch.sh $ENV "-$ENV" 0.1 $APCID $APSECRET $ENCRYPTKEY $APCACID $APCASECRET
			;;
		prod)
			echo "Deploying $UNIT to $ENV"
			./deploy-to-ch.sh $ENV ''      0.5 $APCID $APSECRET $ENCRYPTKEY $APCACID $APCASECRET
			;;
		*)
			echo "Unsupported environment $ENV for deploying $UNIT" 1>&2
			exit 1
	esac
else
	echo "Refusing to deploy snapshot version of $UNIT" 1>&2
fi
