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
import getResourceAsString from MunitTools
// REST API request param
var pnr = "PNR123"
// REST API request body for check-in
var checkIn = read(getResourceAsString(
  'json/check-in-by-pnr-request.json'),
  'application/json')
// SOAP WS request expected to be sent for the above REST API request
var checkInSOAPWSRequ = read(getResourceAsString(
  'xml/checkIn-request.xml'),
  'application/xml')
// SOAP WS response received if check-in OK
var checkInSOAPWSTrueResp = read(getResourceAsString(
  'xml/checkIn-response-true.xml'),
  'application/xml')
// SOAP WS response received if check-in not OK
var checkInSOAPWSFalseResp = read(getResourceAsString(
  'xml/checkIn-response-false.xml'),
  'application/xml')
// SOAP WS response received if communication channel garbled
var checkInSOAPWSGarbageResp = {
	body: {
		thisIs: "garbage",
		isItGarbage: true
	}
}
// SOAP WS request expected to be sent
var getTicketSOAPWSRequ = read(getResourceAsString(
  'xml/getTicketByPNR-request.xml'),
  'application/xml')
// SOAP WS response received if OK
var getTicketSOAPWSOk1Resp = read(getResourceAsString(
  'xml/getTicketByPNR-response-ok.xml'),
  'application/xml')
// REST API response matching the above SOAP WS response
var getTicketOk1Resp = read(getResourceAsString(
  'json/get-ticket-by-pnr-response-ok.json'),
  'application/json')
// SOAP WS request expected to be sent
var registerSOAPWSRequ = read(getResourceAsString(
  'xml/registerForCancellationNotifications-request.xml'),
  'application/xml')
var registerSOAPWSResp = read(getResourceAsString(
  'xml/registerForCancellationNotifications-response.xml'),
  'application/xml')
var cancellationNotification = read(getResourceAsString(
  'xml/cancellation-notification.xml'),
  'application/xml')
var flightCancelledEvent = read(getResourceAsString(
  'json/flight-cancelled-event.json'),
  'application/json')
