#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Returns true if this Maven project's version is a release version, such as 1.0.8,
# returns false if it is a snapshot version, such as 1.0.8-SNAPSHOT.
#
# Usage: is-release-version.sh

scriptdir="$(cd "$(dirname "$0")" && pwd)"

# no-fail grep: a grep that does not return exit code 1 when it doesn't find any matching line
# normal grep returns 1 if no match is found, causing this script to exit immediately (-e and pipefail are set)
# nfgrep behaves like grep but returns exit code 0 if no matching lines are found
nfgrep() {
	grep "$@" || [[ $? == 1 ]]
}

sts="$scriptdir/etc/settings.xml"
mvns="mvn -s $sts -fn -U"

filter() {
	grep 'Building ' | nfgrep '\-SNAPSHOT'
}

snap=$($mvns help:help -Dmaven.clean.failOnError=false | filter)
if [ -z "$snap" ]; then
	# Maven project version does not include -SNAPSHOT: assume it's a release version
	echo true
else
	# Maven project version includes -SNAPSHOT: it's a snapshot version and not a release version
	echo false
fi
