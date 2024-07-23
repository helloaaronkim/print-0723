#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# In each WT project, create pom.xml from pom-ci.xml following templated instructions in the latter.

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

# iterate over all pom-ci.xml files
ciPOMs=$(find . -type f -name 'pom-ci.xml' -maxdepth 5 | sort)
for ciPOM in $ciPOMs; do
	wt=$(dirname $ciPOM)                                    || exit 10
	echo "Creating pom.xml from pom-ci.xml in $wt"          || exit 11
	pushd $wt > /dev/null                                   || exit 12
	# the 1st replacement can span multiple lines and therefore requires perl for its multi-line regex matching mode (where '.' also matches newlines)
	perl -00pe 's/<!-- to-not-use-in-pom-xml-start -->.*?<!-- to-not-use-in-pom-xml-end -->//gs' pom-ci.xml \
	| sed -e 's,<!-- to-use-in-pom-xml-start ,,g' \
	      -e 's, to-use-in-pom-xml-end -->,,g'    > pom.xml || exit 13
	popd > /dev/null                                        || exit 14
done || exit 1
