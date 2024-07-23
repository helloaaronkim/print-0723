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

import com.mulesoft.anypoint.tests.yaml.checker.YamlChecker;

public class LoggingYamlChecker {

  private YamlChecker checker;

  public LoggingYamlChecker(YamlChecker checker) {
    this.checker = checker;
  }

  public LoggingYamlChecker message() {
    checker = checker.property("message").name("Message")
        .description("Mule expression meant for meaningful non-sensitive functional messages.\n" +
            "e.g. #['Request received from Customer with ID:' ++ (vars.customerID default 1234']\n")
        .type("expression")
        .obligatory()
        .and();
    return this;
  }

  public LoggingYamlChecker conditional() {
    checker = checker.property("conditional").name("Conditional")
        .description("Mule Expression to filter which messages to log.\n" +
            "e.g. #[attributes.headers['id']==1]\n")
        .type("expression")
        .and();
    return this;
  }

  public LoggingYamlChecker category() {
    checker = checker.property("category").name("Category")
        .description("Prefix in the log sentence that usually contains package + class where the log is executed. The category will be\n"
            + "org.mule.runtime.logging.policy-<policy id> plus this field value if any\n")
        .type("string")
        .and();
    return this;
  }

  public LoggingYamlChecker level() {
    checker = checker.property("level").name("Level")
        .description("INFO, WARN, ERROR or DEBUG\n")
        .type("radio")
        .defaultValue("INFO")
        .obligatory().and();
    return this;
  }

  public LoggingYamlChecker section(String section, String name, String value) {
    checker = checker.property(section).name(name)
        .type("boolean")
        .defaultValue(value)
        .obligatory().and();
    return this;
  }

  public void noOther() {
    checker.noOther();
  }
}
