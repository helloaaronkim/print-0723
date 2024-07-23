#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Deploy all standalone Mule apps to the given environment (not all Mule apps can be deployed to all environments)
#
# Usage  : deploy.sh <env> <aws-access-key-id> <aws-secret-access-key> <client-id>                      <client-secret>                  <secure-props-key>
# Example: deploy.sh prod  A.................W E.....................Z e0............................99 FD............................85 securePropsCryptoKey
#
# Important: To run this script you must have:
# 1. all Mule apps built and packaged

ENV=$1        # Environment identifier
APCID=$2      # Anypoint Platform client ID to register with API Manager for autodiscovery
APSECRET=$3   # Anypoint Platform client secret for client ID
ENCRYPTKEY=$4 # Mule app secure properties en/decryption key
APCACID=$5    # Anypoint Platform Connected app client ID for deployment auth
APCASECRET=$6 # Anypoint Platform Connected app client secret for deployment auth
APCACID=$7    # Anypoint Platform Connected app client ID for deployment auth
APCASECRET=$8 # Anypoint Platform Connected app client secret for deployment auth

UNIT="all possible standalone Mule apps"

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

case $ENV in 
	dev|test|prod)
		echo "Deploying $UNIT to $ENV"
		# all except paypal-fake-api (see below for other environments)
		args="$ENV $APCID $APSECRET $ENCRYPTKEY $APCACID $APCASECRET" 
		./check-in-papi/deploy.sh                  $args
		./flights-management/deploy.sh             $args
		./mobile-check-in-eapi/deploy.sh           $args
		./mobile-notifications-eapp/deploy.sh      $args
		./paypal-sapi/deploy.sh                    $args
		./passenger-data-sapi/deploy.sh            $args
		./flights-management-sapi/deploy.sh   	   $args
		./offline-check-in-sub-handler/deploy.sh   $args
		;;
	sandbox|production)
		echo "Deploying paypal-fake-api to $ENV"
		./paypal-fake-api/deploy.sh $ENV $APCID $APSECRET $ENCRYPTKEY
		;;
	*)
		echo "Unsupported environment $ENV for deploying $UNIT" 1>&2
		exit 1
esac
