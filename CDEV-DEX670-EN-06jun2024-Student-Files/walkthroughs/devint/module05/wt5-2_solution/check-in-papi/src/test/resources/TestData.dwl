/*-
 * #%L
 * MuleSoft Training - Anypoint Platform Development: Level 2
 * %%
 * Copyright (C) 2019 - 2021 MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
 * %%
 * The software in this package is published under the terms of the
 * Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
 * a copy of which has been included with this distribution in the LICENSE.txt file.
 * #L%
 */
import getResourceAsString from MunitTools 

var pnr              = "N123"
var checkIn          = read(getResourceAsString('json/check-in-by-pnr-request.json'), 'application/json')
var ticket           = read(getResourceAsString('json/flight-management-sapi-get-ticket-by-pnr-response.json'), 'application/json')
var passenger        = read(getResourceAsString('json/passenger-data-sapi-get-passengers-response.json'), 'application/json')
var checkInFMResp    = read(getResourceAsString('json/flight-management-sapi-update-checkins-by-pnr-response.json'), 'application/json')
var regPasDatResp    = read(getResourceAsString('json/passenger-data-sapi-create-flight-by-lno-response.json'), 'application/json')
var createPmtResp    = read(getResourceAsString('json/paypal-sapi-create-payment-response.json'), 'application/json')
var checkInByPNRResp = { paymentID: "PAY-1B56960729604235TKQQIYVY" }
var paymentApproval	          = read(getResourceAsString('json/payment-approval-by-pnr-request.json'), 'application/json')
var paymentApprovalResp       = read(getResourceAsString('json/payment-approval-by-pnr-response.json'), 'application/json')
var updateApprovalResp		  = read(getResourceAsString('json/paypal-sapi-update-payment-approval-response.json'), 'application/json')
