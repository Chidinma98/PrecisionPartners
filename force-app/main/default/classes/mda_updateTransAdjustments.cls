global class  mda_updateTransAdjustments implements Database.Batchable<sObject>, Database.Stateful {
   Integer recordsProcessed = 0;
   List<AQB__Transaction__c> transList = new  List<AQB__Transaction__c>();

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select Id, AQB__Batch__r.AQB__BatchType__c, mda_testRecord__c, AQB__VoidedTransaction__r.Id, MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Batch_Item_ID2__c, AQB__Batch__r.AQB__RecordTypeDeveloperName__c, AQB__Instrument__c, AQB__Gift__r.AQB__Instrument__c,  AQB__Gift__r.AQB__MatchLink__r.Id, AQB__ThirdPartyPayoff__c, AQB__FinancialSystemDate__c, MDA_GL_Posting_Type__c,  AQB__DebitAccount__r.AQB__DesignationAccountNumber__c, MDA_Credit_AccountLookup__c, AQB__DebitAccount__c, AQB__ChartofAccounts__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__r.Id, MDA_Debit_Account__c, AQB__Gift__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c,MDA_Credit_Debit_Account_Error__c, AQB__PaymentNumber__c,  AQB__Type__c, AQB__Method__c, AQB__Batch__r.AQB__SourceofData__c,AQB__SourceofData__c, AQB__VoidedTransaction__c, AQB__PledgeStipulation__c, AQB__PledgePayment__c from AQB__Transaction__c WHERE CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z AND AQB__Type__c = \'Payment\' AND AQB__SourceofData__c = \'Adjustments\'';
        if (Test.isRunningTest()){
            query ='Select Id, AQB__Batch__r.AQB__BatchType__c, mda_testRecord__c, AQB__VoidedTransaction__r.Id, MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Batch_Item_ID2__c, AQB__Batch__r.AQB__RecordTypeDeveloperName__c, AQB__Instrument__c, AQB__Gift__r.AQB__Instrument__c,  AQB__Gift__r.AQB__MatchLink__r.Id, AQB__ThirdPartyPayoff__c, AQB__FinancialSystemDate__c, MDA_GL_Posting_Type__c,  AQB__DebitAccount__r.AQB__DesignationAccountNumber__c, MDA_Credit_AccountLookup__c, AQB__DebitAccount__c, AQB__ChartofAccounts__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__r.Id, MDA_Debit_Account__c, AQB__Gift__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c,MDA_Credit_Debit_Account_Error__c, AQB__PaymentNumber__c,  AQB__Type__c, AQB__Method__c, AQB__Batch__r.AQB__SourceofData__c,AQB__SourceofData__c, AQB__VoidedTransaction__c, AQB__PledgeStipulation__c, AQB__PledgePayment__c from AQB__Transaction__c WHERE CreatedDate >= 2023-10-17T19:00:00Z AND AQB__Type__c = \'Payment\' AND AQB__SourceofData__c = \'Adjustments\'';
            query += 'AND mda_testRecord__c = true';
            }
        
        return Database.getQueryLocator(query); 
    }

    global void execute(Database.BatchableContext BC, List< AQB__Transaction__c> transList) {
        AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c 
        WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90-11324' LIMIT 1];
        AQB__LLChartofAccounts__c coa2 = [Select Id, AQB__DesignationAccountNumber__c from AQB__LLChartofAccounts__c 
        WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];
        AQB__LLChartofAccounts__c coa3 = [Select Id, AQB__DesignationAccountNumber__c from AQB__LLChartofAccounts__c 
        WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1]; 
        Set<String> dataSource = new Set<String>{'Mail','Institutional Lockbox', 'Children\'s Art Project (CAP)', 'Live Check / Credit Card (MD Anderson Front Office)', 
                                                'MDA Treasury', 'Special Events Lockbox', 'MDA Cashier Office', 'Online - Donation Sites',
                                                 'Online - Peer 2 Peer Sites', 'UT Foundation'}; 
        Set<String> paymentMethod = new Set<String>{'Cash','Check','Securities','ACH','Wire', 'Paypal', 'Transfer'};
        Set<String> designationAccountType = new Set<String>{'Endowment','Quasi Endowment'};    
    
    //{trans.AQB__Batch__r.AQB__BatchType__c, trans.AQB__PledgePayment__c, trans.AQB__ThirdPartyPayoff__c,
    //trans.AQB__Type__c,trans.AQB__Method__c  }
        for(AQB__Transaction__c trans: transList) {
            Id transId = trans.Id;
            Id batchItem = trans.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c;
            Id gift = trans.AQB__Gift__c;
            trans.AQB__Do_not_push_to_Accounting__c = false;
//Scenario 119A - Voided donations that were entered using a GIfts/Pledges Batch Type - linked to the Voided Transaction; Voided Transaction Source of Data is Annual Fund
        if(trans.AQB__VoidedTransaction__c != Null){
                    if(trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == false 
                    && trans.AQB__ThirdPartyPayoff__c == false && trans.AQB__ChartofAccounts__r.AQB__Account_Type__c != NULL 
                    && designationAccountType.contains(trans.AQB__ChartofAccounts__r.AQB__Account_Type__c) == false
                    && trans.AQB__VoidedTransaction__r.AQB__SourceofData__c =='Annual Fund Lockbox' ){
                        AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                                    if(correctTrans.size() == 0){
                                        trans.AQB__Do_not_push_to_Accounting__c = false;
                                        trans.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                                        trans.MDA_Credit_AccountLookup__c = coa.Id;
                                        trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                                        trans.MDA_Credit_Debit_Account_Error__c = true;
                                    }
                        
                    }
                }
        if(trans.AQB__VoidedTransaction__c == Null){

        }




    }
    
    
    }

    global void finish(Database.BatchableContext BC) {
        System.debug(recordsProcessed + ' records processed');
          
        }
}