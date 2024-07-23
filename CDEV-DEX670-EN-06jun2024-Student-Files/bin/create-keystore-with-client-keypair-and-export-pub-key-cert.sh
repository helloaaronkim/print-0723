#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# name of the client certificate to be created
# e.g., clients-to-tngaa-nonprod-public
NAME="$1"

# domain to be appended to name of certificate to get CN of certificate
# e.g., lb.anypointdns.net
DOMAIN="$2"

# password for both key and keystore (following PKCS12)
PWD="$3"

# the certificate's CN (alternative names are handled below)
# e.g., clients-to-tngaa-nonprod-public.lb.anypointdns.net
HOST="$NAME.$DOMAIN"

ALTNAMES="DNS:$HOST,DNS:localhost,IP:127.0.0.1"

KEYSTORE="$NAME.p12"
DNAME="cn=$HOST, ou=Training, o=MuleSoft, c=AT"

# create PKCS12 keystore with public/private RSA keypair

echo $'\n'"Creating (after removing) keystore $KEYSTORE with public/private RSA keypair:"$'\n'
rm -f "$KEYSTORE"
keytool -v -genkeypair -keyalg RSA -dname "$DNAME" -ext SAN="$ALTNAMES" -validity 3650 -alias client -keystore "$KEYSTORE" -storetype pkcs12 -storepass "$PWD"
echo $'\n'"!! Now copy $KEYSTORE to src/main of all API clients !!"$'\n'

# export public key certificate in RFC 1421 (PEM) format

PUBCERT="$NAME-pub-key-cert.pem"

echo $'\n'"Exporting certificate with public key to $PUBCERT:"$'\n'
keytool -exportcert -alias client -keystore "$KEYSTORE" -storepass "$PWD" -rfc -file "$PUBCERT"
echo $'\n'"!! Now upload $PUBCERT to the PD to configure mTLS, and copy it to src/test of all API clients !!"$'\n'
