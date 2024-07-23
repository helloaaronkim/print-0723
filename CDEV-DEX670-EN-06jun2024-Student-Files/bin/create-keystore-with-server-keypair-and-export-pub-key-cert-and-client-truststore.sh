#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Mule app name
# e.g., template-api
APP="$1"

# password for both key and keystore (following PKCS12)
PWD="$2"

# host or IP address of HTTP server, becomes CN (alternative names are handled below)
# e.g., tngaa-template-api.usa-e1.cloudhub.io
HOST1="tngaa-$APP.usa-e1.cloudhub.io"
HOST2="tngaa-$APP.usa-e2.cloudhub.io"

ALTNAMES="DNS:$HOST1,DNS:localhost,IP:127.0.0.1"

KEYSTORE="$APP.p12"
DNAME="cn=$HOST1, ou=Training, o=MuleSoft, c=AT"

# create PKCS12 keystore with public/private RSA keypair

echo $'\n'"Creating (after removing) $KEYSTORE:"$'\n'
rm -f "$KEYSTORE"
keytool -v -genkeypair -keyalg RSA -dname "$DNAME" -ext SAN="$ALTNAMES" -validity 3650 -alias server -keystore "$KEYSTORE" -storetype pkcs12 -storepass "$PWD"

# export public key certificate in RFC 1421 (PEM) format

PUBCERT="$APP-pub-key-cert.pem"

echo $'\n'"Exporting certificate with public key to $PUBCERT:"$'\n'
keytool -exportcert -alias server -keystore "$KEYSTORE" -storepass "$PWD" -rfc -file "$PUBCERT"

# create PKCS12 keystore, to be used as client truststore, containing public key certificate

TRUSTSTORE="$APP-client-trust.p12"

echo $'\n'"Creating (after removing) $TRUSTSTORE containing $PUBCERT:"$'\n'
rm -f "$TRUSTSTORE"
keytool -v -noprompt -importcert -file "$PUBCERT" -alias server -keystore "$TRUSTSTORE" -storetype pkcs12 -storepass "$PWD"
