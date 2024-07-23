#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Deploy the entire application network, i.e., all deployment units (Mule apps, Docker containers) to all environments.
#
# Usage  : deploy-the-entire-application-network.sh <client-id>                      <client-secret>                  <secure-props-key>
# Example: deploy-the-entire-application-network.sh e0............................99 FD............................85 securePropsCryptoKey
#
# Important: To run this script you must have:
# 1. Docker daemon running
# 2. all Mule apps built and packaged

APCID=$1      # Anypoint Platform client ID to register with API Manager for autodiscovery
APSECRET=$2   # Anypoint Platform client secret for client ID
ENCRYPTKEY=$3 # Mule app secure properties en/decryption key

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

# Deploy dependencies to Exchange
./deploy-parent-poms.sh
./solutions/apps-commons/deploy.sh    
./solutions/resilience-mule-extension/deploy.sh    
./solutions/api-policies/custom-message-logging-policy/deploy.sh   

# Deploy apps to Exchange
./solutions/check-in-papi/deploy-to-exchange.sh                $ENCRYPTKEY
./solutions/flights-management/deploy-to-exchange.sh           $ENCRYPTKEY
./solutions/mobile-check-in-eapi/deploy-to-exchange.sh         $ENCRYPTKEY
./solutions/mobile-notifications-eapp/deploy-to-exchange.sh    $ENCRYPTKEY
./solutions/paypal-sapi/deploy-to-exchange.sh                  $ENCRYPTKEY
./solutions/assenger-data-sapi/deploy-to-exchange.sh           $ENCRYPTKEY
./solutions/flights-management-sapi/deploy-to-exchange.sh      $ENCRYPTKEY
./solutions/offline-check-in-sub-handler/deploy-to-exchange.sh $ENCRYPTKEY
./solutions/paypal-fake-api/deploy-to-exchange.sh              $ENCRYPTKEY

# Deploy apps to Runtimes
args="$APCID $APSECRET $ENCRYPTKEY"

./deploy.sh sandbox    $args # paypal-fake-api
./deploy.sh dev        $args # all other deployment units
./deploy.sh test       $args # all other deployment units

./deploy.sh production $args # paypal-fake-api
./deploy.sh prod       $args # all other deployment units
