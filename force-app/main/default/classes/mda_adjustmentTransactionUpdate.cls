global class mda_adjustmentTransactionUpdate implements Database.Batchable<sObject>, Database.Stateful  {
    Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select Id, MDA_Batch_Item_ID2__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c, AQB__Gift__c from AQB__Transaction__c WHERE CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z AND AQB__Batch__r.AQB__BatchType__c = \'Gifts/Pledges\'';
        if (Test.isRunningTest()){
           
            query += 'AND mda_testRecord__c = true';
             query += ' LIMIT 100';
            
            }
        return Database.getQueryLocator(query); 
        
    }
    global void execute(Database.BatchableContext BC, List< AQB__Transaction__c> transList) {
        for(AQB__Transaction__c trans: transList){
            trans.MDA_Batch_Item_ID2__c = trans.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c;
             recordsProcessed += 1;
        }
         Database.SaveResult[] results = Database.update(transList, false);
        
    }
    global void finish(Database.BatchableContext BC) {
    System.debug(recordsProcessed + ' records processed');
      
    }

}