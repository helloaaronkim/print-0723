/*-
 * #%L
 * MuleSoft Training - Anypoint Platform Development: Level 2
 * %%
 * Copyright (C) 2019 - 2023 MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
 * %%
 * The software in this package is published under the terms of the
 * Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
 * a copy of which has been included with this distribution in the LICENSE.txt file.
 * #L%
 */
import * from bat::BDD
import * from bat::Assertions
---
suite("${project.name}-prod") in [
  GET `https://tngaa-${project.name}.us-e1.cloudhub.io/alive` with { "headers": {"x-correlation-id": ("${project.name}-prod-alive-" ++ uuid())} } assert [ $.response.status mustEqual 200 ],
  GET `https://tngaa-${project.name}.us-e1.cloudhub.io/ready` with { "headers": {"x-correlation-id": ("${project.name}-prod-ready-" ++ uuid())} } assert [ $.response.status mustEqual 200 ]
]
