Set<String> propertyType = new Set<String>{ 'Real Property', 'Personal Property'};

Set<String> dataSource = new Set<String>{'Mail','Institutional Lockbox', 'Children\'s Art Project (CAP)', 'Live Check / Credit Card (MD Anderson Front Office)', 
            									'MDA Treasury', 'Special Events Lockbox', 'MDA Cashier Office', 'Online - Donation Sites',
            									'Online - Event Registration Sites', 'Online - Peer 2 Peer Sites', 'UT Foundation'};

Set<String> pledgeOffset = new Set<String>{ 'Pledge', 'Grant'};

Set<String> sourceDataValidation = new Set<String>{'Institutional Lockbox', 'Live Check / Credit Card (MD Anderson Front Office)', 'MDA Treasury'};


List<AQB__Transaction__c> transList = [Select Id, AQB__SourceofData__c, AQB__DebitAccount__c, MDA_Debit_Account__c,
MDA_Credit_AccountLookup__c, AQB__ACHLastFour__c,  AQB__Type__c, 
MDA_GL_Posting_Type__c, MDA_Credit_Debit_Account_Error__c from AQB__Transaction__c 
WHERE CreatedDate >= 2023-10-17T19:00:00Z
AND AQB__FinancialSystemDate__c = NULL
AND AQB__Batch__r.AQB__RecordTypeDeveloperName__c = 'ClosedBatch'
AND AQB__VoidedTransaction__c = NULL
AND AQB__Batch__r.AQB__SourceofData__c = 'Adjustments'];


System.debug('LIST SIZE ====>' + transList.size());
System.debug(JSON.serializePretty(transList));