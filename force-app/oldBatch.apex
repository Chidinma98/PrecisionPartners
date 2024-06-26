
Set<String> propertyType = new Set<String>{ 'Real Property', 'Personal Property'};

Set<String> dataSource = new Set<String>{'Mail','Institutional Lockbox', 'Children\'s Art Project (CAP)', 'Live Check / Credit Card (MD Anderson Front Office)', 
            									'MDA Treasury', 'Special Events Lockbox', 'MDA Cashier Office', 'Online - Donation Sites',
            									'Online - Event Registration Sites', 'Online - Peer 2 Peer Sites', 'UT Foundation'};

Set<String> pledgeOffset = new Set<String>{ 'Pledge', 'Grant'};

Set<String> sourceDataValidation = new Set<String>{'Institutional Lockbox', 'Live Check / Credit Card (MD Anderson Front Office)', 'MDA Treasury'};

//Scenario 1 PLEDGE OFFSET

List<AQB__Transaction__c> transList = [Select Id, AQB__Do_not_push_to_Accounting__c,
AQB__FinancialSystemDate__c, MDA_Credit_AccountLookup__c,
MDA_Debit_Account__c, MDA_GL_Posting_Type__c,
MDA_Journal_ID__c, MDA_Original_Transaction__c,
MDA_Related_Void_Transaction__c from AQB__Transaction__c 
WHERE CreatedDate >= 2023-10-17T19:00:00Z
AND AQB__FinancialSystemDate__c = NULL
AND AQB__Batch__r.AQB__RecordTypeDeveloperName__c = 'ClosedBatch'
AND AQB__VoidedTransaction__c = NULL
AND AQB__PledgePayment__c = true
AND AQB__Type__c IN :pledgeOffset  ];


List<AQB__Transaction__c> transList2 = [Select Id, AQB__Do_not_push_to_Accounting__c,
AQB__FinancialSystemDate__c, MDA_Credit_AccountLookup__c,
MDA_Debit_Account__c, MDA_GL_Posting_Type__c,
MDA_Journal_ID__c, MDA_Original_Transaction__c,
MDA_Related_Void_Transaction__c from AQB__Transaction__c 
WHERE CreatedDate >= 2023-10-17T19:00:00Z
AND AQB__FinancialSystemDate__c = NULL
AND AQB__Batch__r.AQB__RecordTypeDeveloperName__c = 'ClosedBatch'
AND AQB__VoidedTransaction__c = NULL
AND AQB__ThirdPartyPayoff__c = true
AND AQB__Type__c IN :pledgeOffset];


system.debug('LIST 2 Size' + transList2.size());
System.debug(json.serializePretty(transList2));

system.debug('LIST SIZE' + transList.size());
System.debug(json.serializePretty(transList));


// GL DATA SOURCES- GRANT PAYMENT
List<AQB__Transaction__c> transList = [Select Id, AQB__SourceofData__c, AQB__DebitAccount__c, MDA_Debit_Account__c,
MDA_Credit_AccountLookup__c, 	AQB__ACHLastFour__c,  AQB__Type__c, 
MDA_GL_Posting_Type__c, MDA_Credit_Debit_Account_Error__c from AQB__Transaction__c 
WHERE CreatedDate >= 2023-10-17T19:00:00Z
AND AQB__FinancialSystemDate__c = NULL
AND AQB__Batch__r.AQB__RecordTypeDeveloperName__c = 'ClosedBatch'
AND AQB__VoidedTransaction__c = NULL
AND AQB__Type__c = 'Grant Payment'
AND AQB__Batch__r.AQB__SourceofData__c IN :dataSource
AND AQB__Batch__r.AQB__SourceofData__c NOT IN :sourceDataValidation];