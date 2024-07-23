package com.mulesoft.training.batch;

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

import org.mule.runtime.api.metadata.TypedValue;

import com.mulesoft.mule.runtime.module.batch.api.record.Record;

public class BatchHelper {

	private BatchHelper(){
		// private util class
	}
	/**
	 * Add a variable with the given name (key) and value to the given batch record.
	 * Returns void to make it absolutely clear to DataWeave that this method has
	 * side effects (namely changing the given record).
	 */
	public static <T> void addVariableToRecord(Record rec, String key, T value) {
		if (rec == null)
			return;

		rec.addVariable(key, TypedValue.of(value));
	}
}
