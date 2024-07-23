#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Create settings.xml from settings.xml.template replacing placeholders with actual credentials passed on command-line.
#
# Usage  : create-settings-xml-from-template.sh <username-for-releases-ee-repo>        <password-for-releases-ee-repo>      \
#                                               <username-for-default-exchange>        <password-for-default-exchange>      \
#                                               <username-for-anyairline-exchange>     <password-for-anyairline-exchange>.  \
#                                               <username-for-deplopyment-exchange>    <password-for-deployment-exchange>
# Example: create-settings-xml-from-template.sh usernameForMuleSoftReleasesEERepo      passwdForMuleSoftReleasesEERepo      \
#                                               usernameForDefaultExchangeMavenRepo    passwdForDefaultExchangeMavenRepo    \
#                                               usernameForAnyAirlineExchangeMavenRepo passwdForAnyAirlineExchangeMavenRepo \
#                                               usernameForDeploymentxchangeMavenRepo    passwdForDeploymentExchangeMavenRepo

EE_UNAME="$1"        	  # username for releases-ee repo
EE_PASSW="$2"        	  # password for releases-ee repo
DEF_EXCHG_UNAME="$3" 	  # username for default Anypoint Exchange with anypoint-exchange-v3 server entry
DEF_EXCHG_PASSW="$4" 	  # password for default Anypoint Exchange with anypoint-exchange-v3 server entry
AA_EXCHG_UNAME="$5"  	  # username for AnyAirline Anypoint Exchange
AA_EXCHG_PASSW="$6"       # password for AnyAirline Anypoint Exchange
DPL_EXCHG_UNAME="$7"  	  # username for deployment to Anypoint Exchange
DPL_EXCHG_PASSW="$8"      # password for deployment to Anypoint Exchange

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

sed -e 's,{{ee.uname}},'"$EE_UNAME"',g'               		\
    -e 's,{{ee.passw}},'"$EE_PASSW"',g'               		\
    -e 's,{{def.exchg.uname}},'"$DEF_EXCHG_UNAME"',g' 		\
    -e 's,{{def.exchg.passw}},'"$DEF_EXCHG_PASSW"',g' 		\
    -e 's,{{aa.exchg.uname}},'"$AA_EXCHG_UNAME"',g'   		\
    -e 's,{{aa.exchg.passw}},'"$AA_EXCHG_PASSW"',g'   		\
    -e 's,{{dpl.exchg.uname}},'"$DPL_EXCHG_UNAME"',g'       \
    -e 's,{{dpl.exchg.passw}},'"$DPL_EXCHG_PASSW"',g'       \
    settings.xml.template > settings.xml
