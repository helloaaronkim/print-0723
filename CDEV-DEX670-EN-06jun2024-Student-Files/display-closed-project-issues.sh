#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# List all closed ticket IDs for a given GitHub project ID.
#
# Usage: display-closed-project-issues.sh <PROJECT_ID>
# Example: display-closed-project-issues.sh 10

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

PROJECT_ID="$1"  
query='                                              
{
  repository(name: "training-APDevLevel2", owner: "mulesoft-consulting") {
    project(number:'"$PROJECT_ID"') {
      columns(first: 10) {
        edges {
          node {
            cards(first: 100) {
              nodes {
                content {
                  ... on Issue {
                    number,
                    state
                  },
                  ... on PullRequest {
                    number,
                    state
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
'
hub api graphql -f query="$query" | jq -c '.data.repository.project.columns.edges[].node.cards.nodes[].content | select( .state == "CLOSED"  or .state == "MERGED" ).number' | sort -n
