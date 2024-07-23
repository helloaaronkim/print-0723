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
var tokens = [
	'kas8392.QISKEkdls8345_Zsrq9cK9hNsqrEU9xem4QJ6sQa36VHfyuBe',
	'8s9kaj3.SDkkd4145_ZsrqVh38sjdhNsqrEU9xem4QJ6sQa36VHfyuBes',
	'l2k28ss.sid3fjfd5_Zsrq9cK9hNsqrSTfu8ji334EEVW83hjskShnodE',
	'j383fhf.kdks8925WWr8345_Zsrq9cK9hNsl928xmm4sisFJE89l9fE32',
	'sslei4u.RE48292_Zsrq9cK9hSHs90dkfj3EU9xem4QJ481oj469245hj',
	'482slsk.QISKEkdls8345_Zsrq9cK9hNsqrEU9xem4Qsod844D382fjff'
]

fun randomToken() = tokens[randomInt(sizeOf(tokens))]

fun isValidToken(t) = tokens contains t
