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
%dw 2.0
output plain/text
---
"/* Groovy template script that creates new users on Jenkins server
Existing users will simply have their password overwritten
*/

import hudson.security.HudsonPrivateSecurityRealm

def instance = Jenkins.getInstance()
instance.setSecurityRealm(hudsonRealm)

def hudsonRealm = new HudsonPrivateSecurityRealm(false)

//Create accounts such as
//hudsonRealm.createAccount('mark', 'mark')

//Afterwards save the Jenkins instance
//instance.save()

"
