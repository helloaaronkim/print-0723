package com.mulesoft.anypoint.templates;

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

import com.mulesoft.anypoint.tests.yaml.YamlDefinitionBaseTestCase;

import org.junit.Test;

public class ValidateYamlDefinitionTestCase extends YamlDefinitionBaseTestCase {

  @Override
  protected String yamlDefinition() {
    return "custom-message-logging.yaml";
  }

  @Test
  public void checkYamlDefinition() {
    LoggingYamlChecker checker = new LoggingYamlChecker(yamlChecker());
    checker
        .message()
        .conditional()
        .category()
        .level()
        .section("beforeAPI", "Before Calling API", "true")
        .section("afterAPI", "After Calling API", "false")
        .noOther();
  }
}
