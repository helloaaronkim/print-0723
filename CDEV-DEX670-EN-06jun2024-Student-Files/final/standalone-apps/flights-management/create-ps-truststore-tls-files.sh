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

CLI_PWD_NON="$1" # password for both key and keystore (following PKCS12) for clients to the non-prod PS
CLI_PWD_PRD="$2" # password for both key and keystore (following PKCS12) for clients to the prod PS

scriptdir="$(cd "$(dirname "$0")" && pwd)"

export PS_NON="nonprod-internalps"                # name of the non-prod PS
export PS_PRD="prod-internalps"                   # name of the prod PS
export PS_DOMAIN="anyair.net"                     # name of the vanity domain to CNAME from
STRC=src/test/resources/certs
SMRC=src/main/resources/certs
mkdir -p "$STRC"

createCLI="../../../bin/create-keystore-with-client-keypair-and-export-pub-key-cert.sh"

# first the non-prod PS
$createCLI "clients-to-$PS_NON" "$PS_NON.$PS_DOMAIN"  "$CLI_PWD_NON"

# moving files to src/test which are for API clients and not needed by the API implementation
files=$(ls clients-to-*.p12 clients-to-*-pub-key-cert.pem)
echo $'\n'"Moving $files to $STRC - be sure to get these files from there"$'\n'
mv -i $files "$STRC"/

# then the prod PS
$createCLI "clients-to-$PS_PRD" "$PS_PRD.$PS_DOMAIN"   "$CLI_PWD_PRD"

# moving files to src/test which are for API clients and not needed by the API implementation
files=$(ls clients-to-*.p12 clients-to-*-pub-key-cert.pem)
echo $'\n'"Moving $files to $STRC - be sure to get these files from there"$'\n'
mv -i $files "$STRC"/

# replace certs in fms-sapi
cp "$scriptdir/$STRC/clients-to-$PS_NON.p12" "$scriptdir/../flights-management-sapi/$SMRC/" 
wtsdir="$(cd "../../../walkthroughs" && pwd)"
cd $wtsdir
# replace certs in all wts
certfiles=$(find . -type f -name 'clients-to-*.p12' -maxdepth 10 | sort)
echo "Replacing all existing certs"
for f in $certfiles; do
    echo "$(pwd)"
	wt=$(dirname $f)                                    			|| exit 10
	echo "Replacing cert in $wt"                                    || exit 11
	pushd $wt > /dev/null                                   		|| exit 12
    cp "$scriptdir/$STRC/clients-to-$PS_NON.p12" "$wtsdir/$wt/"     || exit 13
    cp "$scriptdir/$STRC/clients-to-$PS_PRD.p12" "$wtsdir/$wt/"     || exit 14 
	popd > /dev/null                                        		|| exit 15
done || exit 1