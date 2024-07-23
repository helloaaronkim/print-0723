#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

#
# Creates TLS-related files (certificates, keystores and truststores) for all private spaces.
# There are two private spaces in front of the Flights Management system:
# - one for the non-prod environments (dev and test) called tngaa-nonprod-public
# - one for the prod environment called tngaa-public
# The files created by this script are:
# - 
#

AWS_ACCESS_KEY="$1" # password for both key and keystore (following PKCS12) for clients to the non-prod PS
AWS_SECRET_KEY="$2" # password for both key and keystore (following PKCS12) for clients to the prod PS

export PS_NON="nonprod-internalps"                # name of the non-prod PS
export PS_PRD="prod-internalps"                   # name of the prod PS
export PS_DOMAIN="anyair.net"                     # name of the vanity domain to CNAME from

scriptdir="$(cd "$(dirname "$0")" && pwd)"

STRC=src/test/resources/certs
mkdir -p "$STRC"

# creating Let's Encrypt files to be uploaded to PS
echo $'\n'"Creating files in $STRC - be sure to get these files from there"$'\n'
docker run -it --rm --name certbot \
    --env AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY" \
    --env AWS_SECRET_ACCESS_KEY="$AWS_SECRET_KEY" \
    -v "$scriptdir/$STRC/letsencrypt:/etc/letsencrypt" \
    -v "$scriptdir/$STRC/letsencrypt:/var/lib/letsencrypt" \
    certbot/dns-route53 certonly \
    -d "$PS_NON.$PS_DOMAIN" \
    -d "*.$PS_NON.$PS_DOMAIN" \
    -d "$PS_PRD.$PS_DOMAIN" \
    -d "*.$PS_PRD.$PS_DOMAIN" \
    -m ryan.carter@mulesoft.com \
    --agree-tos --server https://acme-v02.api.letsencrypt.org/directory
