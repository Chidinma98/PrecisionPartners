mda_transactionHistoricalRecordUpdate myBatchObject = new mda_transactionHistoricalRecordUpdate();
Id batchId = Database.executeBatch(myBatchObject);
System.debug('HI');