global  class mda_contactHistoricalUpdate implements Database.Batchable<sObject>, Database.Stateful{
    Integer recordsProcessed = 0;
   //mda_contactHistoricalUpdate myBatchObject = new mda_contactHistoricalUpdate();
   //Id batchId = Database.executeBatch(myBatchObject);
   //1746 records processed
    global Database.QueryLocator start(Database.BatchableContext BC) {  
        String query = 'Select Id, AQB__AwardGiftCredit__c, AQB__PrimaryGiftRecognitionCredit_Percent__c, AQB__SecondaryGiftRecognitionCreditPercent__c, AQB__IsPrimaryContact__c from Contact WHERE AQB__PrimaryGiftRecognitionCredit_Percent__c = 0 AND AQB__SecondaryGiftRecognitionCreditPercent__c = 0' ;
        if (Test.isRunningTest()){        
    		}       
        return Database.getQueryLocator(query); 
    }

    global void execute(Database.BatchableContext BC, List<Contact> contactList) {
        for(Contact con: contactList){
            if(con.AQB__IsPrimaryContact__c == 'Yes'){
                con.AQB__PrimaryGiftRecognitionCredit_Percent__c = 100;
                con.AQB__SecondaryGiftRecognitionCreditPercent__c = 100;
                recordsProcessed += 1;
            } else{
                con.AQB__PrimaryGiftRecognitionCredit_Percent__c = 0;
                con.AQB__SecondaryGiftRecognitionCreditPercent__c = 100;
                recordsProcessed += 1;
            }
            con.AQB__AwardGiftCredit__c = true;

        }
        try{
            Database.SaveResult[] results = Database.update(contactList, false);
        }catch(Exception e){
            System.debug(e.getMessage());

        }

    }
    global void finish(Database.BatchableContext BC) {
        System.debug(recordsProcessed + ' records processed');
          
    }
 
}