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
import * from bat::BDD
import * from bat::Assertions
---
suite("Health Checks") in [
    it must "alive and ready" in [
        ["alive", "ready"] map (check) ->
            GET `$(config.url)/$(check)`
            with {
                headers: {
                    "x-correlation-id": "$(config.api)-$(config.env)-$(check)-$(uuid())"
                }
            }
            assert [
                $.response.status            mustEqual 200,
                $.response.payload as String mustEqual "UP"
            ]
    ], 
    it must "check-in" in [
        PUT `$(config.url)/api/v1/tickets/PNR123/checkin` 
        with {
            headers: { "Content-Type": "application/json" , "x-correlation-id": ("${project.name}-$(config.env)-check-in-ready-" ++ uuid())},
	        body  : "{\"lastName\":\"Mule\",\"numBags\":2}" as Binary {encoding: "UTF-8"} 
        } 
        assert [ 
            $.response.status mustEqual 200
        ]
    ]

]
