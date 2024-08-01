/**
 * Apex Class Name: mda_transactionHistoricalRecordUpdate
 *
 * Created Date: February 22, 2024 
 *
 * @description: This class is to update existing records in Transactions- with appropraite debit account values based on given conditions. 
 * 
 * @author: M. Eleanya (Contractor: Precision Partners)
 *
 * Requirements:
 * 1) Excluded transactions - Pledge Soft Credits, GiftSoft Credits, New and Adjusted Pledge Offsets, New Adjusted Third Party Pledge Offsets
 * 2) New and Adjusted Pledges, Matching Gifts, Planned Gifts - Update with DNPTA
 * 3) New and Adjusted Grants - Update with DNPTA
 * 4) Grant Payments where the source is the Click Grants Report - Update with DNPTA
 * 5) Grant Overpayment where the source is the Click Grants Report - Update with DNPTA
 * 6) Gifts in Kind - Update with DNPTA
 * 7) Payments from Caging - Annual Fund Lockbox - Update Debit Account and GL Debit Account with Annual Fund Clearing and GL Credit Account with selected Designation; Posting Type is Automated-Historical
 * 8) Conditional Pledge Payments from Caging - Annual Fund Lockbox - Update Debit Account and GL Debit Account with Annual Fund Clearing and GL Credit Account with selected Designation; Posting Type is Automated-Historical
 * 9) Unconditional Pledge Payments from Caging - Annual Fund Lockbox - Update Debit Account and GL Debit Account with Annual Fund Clearing and GL Credit Account with selected Designation; Posting Type is Manual-Historical
 * 10) Donations from Sources that Post to the GL; funds received via credit card - Update Debit Account and GL Debit Account with Credit Card Clearing and GL Credit Account with selected Designation; Post Type is Automated-Historical
 * 11) Donations from Sources that Post to the GL; funds received via ACH, Cash, Check, PayPal,  Securities, Transfer, Wire - Update Debit Account and GL Debit Account with Cash Clearing and GL Credit Account with selected Designation; Post Type is Automated-Historical
 * 12) Conditional Pledge Payments from Sources that Post to the GL; funds received via credit card - Update Debit Account and GL Debit Account with Credit Card Clearing and GL Credit Account with selected Designation; Post Type is Automated-Historical
 * 13) Conditional Pledge Payments from Sources that Post to the GL; funds received via ACH, Cash, Check, PayPal, Securities, Transfer, Wire - Update Debit Account and GL Debit Account with Cash Clearing and GL Credit Account with selected Designation; Post Type is Automated-Historical
 * 14) Unconditional Pledge Payments from Sources that Post to the GL; funds received via credit card - Update Debit Account and GL Debit Account with Credit Card Clearing and GL Credit Account with selected Designation; Post Type is Manual-Historical
 * 15) Unconditional Pledge Payments from Sources that Post to the GL; funds received via ACH, Cash, Check, PayPal, Securities, Transfer, Wire - Update Debit Account and GL Debit Account with Cash Clearing and GL Credit Account with selected Designation; Post Type is Manual-Historical
 *
 * Modification Log:
 *     Ver      Date              Author                  Modification
 *     1.0      02-22-2024        M. Eleanya              Initial Version
 *     1.1      07-23-2024        M. Eleanya              Added code to update all pledges, matching gifts, and planned gifts; added code to update all new payments  
 *     1.2      07-30-2024        D. Parker               Added comments 
 *
**/


global class mda_transactionHistoricalRecordUpdate implements Database.Batchable<sObject>, Database.Stateful{
   //mda_transactionHistoricalRecordUpdate myBatchObject = new mda_transactionHistoricalRecordUpdate();
   //Id batchId = Database.executeBatch(myBatchObject);
   Integer recordsProcessed = 0;
   List<AQB__Transaction__c> transList = new  List<AQB__Transaction__c>();

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select Id, AQB__Batch__r.AQB__BatchType__c, mda_testRecord__c, AQB__VoidedTransaction__r.Id, MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Batch_Item_ID2__c, AQB__Batch__r.AQB__RecordTypeDeveloperName__c, AQB__Instrument__c, AQB__Gift__r.AQB__Instrument__c,  AQB__Gift__r.AQB__MatchLink__r.Id, AQB__ThirdPartyPayoff__c, AQB__FinancialSystemDate__c, MDA_GL_Posting_Type__c,  AQB__DebitAccount__r.AQB__DesignationAccountNumber__c, MDA_Credit_AccountLookup__c, AQB__DebitAccount__c, AQB__ChartofAccounts__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__r.Id, MDA_Debit_Account__c, AQB__Gift__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c,MDA_Credit_Debit_Account_Error__c, MDA_Credit_Account_Number__c, MDA_Debit_Account_Number__c, AQB__PaymentNumber__c,  AQB__Type__c, AQB__Method__c, AQB__Batch__r.AQB__SourceofData__c,AQB__SourceofData__c, AQB__VoidedTransaction__c, AQB__PledgeStipulation__c, AQB__PledgePayment__c from AQB__Transaction__c WHERE CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z';
        if (Test.isRunningTest()){
            //query += ' LIMIT 100';
            query ='Select Id, mda_testRecord__c, AQB__VoidedTransaction__r.Id, MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Batch_Item_ID2__c, AQB__Batch__r.AQB__RecordTypeDeveloperName__c, AQB__Instrument__c, AQB__Gift__r.AQB__Instrument__c,  AQB__Gift__r.AQB__MatchLink__r.Id, AQB__ThirdPartyPayoff__c, AQB__FinancialSystemDate__c, MDA_GL_Posting_Type__c,  AQB__DebitAccount__r.AQB__DesignationAccountNumber__c, MDA_Credit_AccountLookup__c, AQB__DebitAccount__c, AQB__ChartofAccounts__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__r.Id, MDA_Debit_Account__c, AQB__Gift__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c,MDA_Credit_Debit_Account_Error__c, MDA_Credit_Account_Number__c, MDA_Debit_Account_Number__c, AQB__PaymentNumber__c,  AQB__Type__c, AQB__Method__c, AQB__Batch__r.AQB__SourceofData__c,AQB__SourceofData__c, AQB__VoidedTransaction__c, AQB__PledgeStipulation__c, AQB__PledgePayment__c from AQB__Transaction__c WHERE CreatedDate >= 2023-10-17T19:00:00Z';
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
        Set<String> paymentMethod2 = new Set<String>{'Cash', 'Check','Securities','ACH','Wire','ACH/Wire'};
        Set<String> paymentMethod3 = new Set<String>{'Check','ACH','Wire','ACH/Wire'};
        Set<String> paymentMethod4 = new Set<String>{'Cash','Check','Securities','ACH','Wire','ACH/Wire', 'Paypal'};
        Set<String> transactionType = new Set<String>{'Grant Payment', 'Payment', 'Soft Credit'};
        Set<String> otherDataSource = new Set<String>{'Grants Management System','Gift in Kind Form / Documentation','Planned Giving Form / Documentation'};
        Set<String> transType = new Set<String>{ 'Grant', 'Soft Credit', 'Pledge Soft Credit'};
        Set<String> transType2 = new Set<String>{ 'Soft Credit', 'Pledge Soft Credit'};
        Set<String> pledgeOffset = new Set<String>{ 'Pledge', 'Grant'};
        Set<String> propertyType = new Set<String>{ 'Real Property', 'Personal Property'};
        Set<String> sourceDataValidation = new Set<String>{'Institutional Lockbox', 'Live Check / Credit Card (MD Anderson Front Office)', 'MDA Treasury'};
            
        List<AQB__Transaction__c> processedRecords = new List<AQB__Transaction__c>();
        List<AQB__Transaction__c> correctTransactions = new List<AQB__Transaction__c>();
        //Scenario 105: New and Adjusted Pledges, Matching Gifts, Planned Gifts
        for(AQB__Transaction__c trans: transList) {
            trans.AQB__Do_not_push_to_Accounting__c = false;
            Id transId = trans.Id;
            Id batchItem = trans.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c;
            Id gift = trans.AQB__Gift__c;
            if(trans.AQB__Type__c == 'Pledge' && trans.AQB__ThirdPartyPayoff__c == false && trans.AQB__PledgePayment__c == false ){
                trans.AQB__Do_not_push_to_Accounting__c = true;
                recordsProcessed += 1;
            }
        //Scenario 106: New and Adjusted Grants
            if(trans.AQB__Type__c == 'Grant' && trans.AQB__PledgePayment__c == false && trans.AQB__ThirdPartyPayoff__c == false ){
                trans.AQB__Do_not_push_to_Accounting__c = true;
                recordsProcessed += 1;
            }
        //Scenario 107: Grant Payments where the source is the Click Grants Report 
            if(trans.AQB__SourceofData__c == 'Grants Management System' && trans.AQB__Type__c == 'Grant Payment' ){
                if(trans.AQB__PledgePayment__c = true && trans.AQB__ThirdPartyPayoff__c == false){
                    trans.AQB__Do_not_push_to_Accounting__c = true;
                    recordsProcessed += 1;
        //Scenario 108: Grant Overpayment where the source is the Click Grants Report
                } else if (trans.AQB__PledgePayment__c = false && trans.AQB__ThirdPartyPayoff__c == false){
                    trans.AQB__Do_not_push_to_Accounting__c = true;
                    recordsProcessed += 1;
                }
            }
       //Scenario 109: Gifts in Kind
            if(trans.AQB__Type__c == 'Payment' && trans.AQB__ThirdPartyPayoff__c == false){
                if(trans.AQB__SourceofData__c == 'Gift in Kind Form / Documentation' ){
                    if(trans.AQB__PledgePayment__c == false){
                        trans.AQB__Do_not_push_to_Accounting__c = true;
                        recordsProcessed += 1;
                    }

                }
      //Scenario 110:Payments from Caging - Annual Fund Lockbox    
                if(trans.AQB__SourceofData__c == 'Annual Fund Lockbox'  ){
                    if(trans.AQB__PledgePayment__c == false ){
                        trans.AQB__DebitAccount__c = coa.Id;
                        trans.MDA_Debit_Account__c = coa.Id;
                        trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                        trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                        recordsProcessed += 1;
    //Scenario 111: Conditional Pledge Payments from Caging - Annual Fund Lockbox
                    }else if(trans.AQB__PledgePayment__c == true && trans.AQB__PledgeStipulation__c == 'Conditional'){
                        trans.AQB__DebitAccount__c = coa.Id;
                        trans.MDA_Debit_Account__c = coa.Id;
                        trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                        trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                        recordsProcessed += 1;

    //Scenario 112: Unconditional Pledge Payments from Caging - Annual Fund Lockbox
                    } else if (trans.AQB__PledgePayment__c == true && trans.AQB__PledgeStipulation__c == 'Unconditional'){
                        trans.AQB__DebitAccount__c = coa.Id;
                        trans.MDA_Debit_Account__c = coa.Id;
                        trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                        trans.MDA_GL_Posting_Type__c = 'Manual-Historical';
                        recordsProcessed += 1;
                        

                    }

                }
    //Scenario 113: Donations from Sources that Post to the GL; funds received via credit card           
                if(dataSource.contains(trans.AQB__SourceofData__c) && trans.AQB__PledgePayment__c == false){
                    if(trans.AQB__Method__c == 'Credit Card'){
                            trans.AQB__DebitAccount__c = coa2.Id;
                            trans.MDA_Debit_Account__c = coa2.Id;
                            trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                            trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                            recordsProcessed += 1;
      //Scenario 114: Donations from Sources that Post to the GL; funds received via ACH, Cash, Check, PayPal,Securities, Transfer, Wire                        
                    }else if(paymentMethod.contains(trans.AQB__Method__c )){
                            trans.AQB__DebitAccount__c = coa3.Id;
                            trans.MDA_Debit_Account__c = coa3.Id;
                            trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                            trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                            recordsProcessed += 1;

                    }

                }
     //Scenario 115: Conditional Pledge Payments from Sources that Post to the GL; funds received via credit card        
                if(dataSource.contains(trans.AQB__SourceofData__c) && trans.AQB__PledgePayment__c == true){
                    if(trans.AQB__PledgeStipulation__c == 'Conditional' && trans.AQB__Method__c == 'Credit Card'){
                        trans.AQB__DebitAccount__c = coa2.Id;
                        trans.MDA_Debit_Account__c = coa2.Id;
                        trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                        trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                        recordsProcessed += 1;
    //Scenario 116: Conditional Pledge Payments from Sources that Post to the GL; funds received via ACH, Cash, Check, PayPal, Securities, Transfer, Wire
                    } else if (trans.AQB__PledgeStipulation__c == 'Conditional' && paymentMethod.contains(trans.AQB__Method__c )){
                        trans.AQB__DebitAccount__c = coa3.Id;
                        trans.MDA_Debit_Account__c = coa3.Id;
                        trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                        trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                        recordsProcessed += 1;
    //Scenario 117: Unconditional Pledge Payments from Sources that Post to the GL; funds received via credit card
                    } else if(trans.AQB__PledgeStipulation__c == 'Unconditional' && trans.AQB__Method__c == 'Credit Card'){
                        trans.AQB__DebitAccount__c = coa2.Id;
                        trans.MDA_Debit_Account__c = coa2.Id;
                        trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                        trans.MDA_GL_Posting_Type__c = 'Manual-Historical';
                        recordsProcessed += 1;
    //Scenario 118: Unconditional Pledge Payments from Sources that Post to the GL; funds received via ACH, Cash, Check, PayPal, Securities, Transfer, Wire
                    }else if (trans.AQB__PledgeStipulation__c == 'Unconditional' && paymentMethod.contains(trans.AQB__Method__c )){
                        trans.AQB__DebitAccount__c = coa3.Id;
                        trans.MDA_Debit_Account__c = coa3.Id;
                        trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                        trans.MDA_GL_Posting_Type__c = 'Manual-Historical';
                        recordsProcessed += 1;

                    }


                }
//Adjustments   
                if(trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges'){
                    if(trans.AQB__SourceofData__c == 'Adjustments' && trans.AQB__Type__c =='Payment' && trans.AQB__VoidedTransaction__c != null){             
                        if(trans.AQB__PledgePayment__c == false && trans.AQB__ThirdPartyPayoff__c == false ){
                            AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                                if(correctTrans.size() == 0){
                                    trans.AQB__Do_not_push_to_Accounting__c = false;
                                    trans.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                                    trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                                    trans.MDA_Credit_Debit_Account_Error__c = true;
                            } else {
                                trans.AQB__Do_not_push_to_Accounting__c = true;
                            }
                        } 
                        if(trans.AQB__PledgePayment__c == true && trans.AQB__ThirdPartyPayoff__c == false){
                            AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                            if(correctTrans.size() == 0){
                                trans.AQB__Do_not_push_to_Accounting__c = false;
                                trans.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                                trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                            }
                            
                        }
                     

                
                    }
                    if(trans.AQB__PledgePayment__c == false && trans.AQB__SourceofData__c == 'Adjustments' && trans.AQB__Type__c =='Payment' && trans.AQB__VoidedTransaction__c == null){
                        if(trans.AQB__ThirdPartyPayoff__c == false){
                            AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                            if(correctTrans.size() == 0){
                                trans.AQB__Do_not_push_to_Accounting__c = false;
                                trans.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                                trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                            } else {
                                trans.AQB__Do_not_push_to_Accounting__c = false;
                                trans.MDA_Debit_Account__c = correctTrans[0].AQB__ChartofAccounts__c;
                                trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                                trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                            }
                        }

                    }                
            
            }
            if(trans.AQB__Batch__r.AQB__BatchType__c == 'Gift/Pledge Corrections'){
                if(trans.AQB__ThirdPartyPayoff__c == false && trans.AQB__PledgePayment__c == false && trans.AQB__SourceofData__c == 'Adjustments' && trans.AQB__Type__c =='Payment' && trans.AQB__VoidedTransaction__c != null){
                    trans.AQB__Do_not_push_to_Accounting__c = true;

                } 

                if(trans.AQB__ThirdPartyPayoff__c == false && trans.AQB__PledgePayment__c == false && trans.AQB__SourceofData__c == 'Adjustments' && trans.AQB__Type__c =='Payment' && trans.AQB__VoidedTransaction__c == null){
                    AQB__BatchCorrectionTransaction__c bcTrans = [Select Id, AQB__OriginalDesignation__c,AQB__Designation__c, AQB__LinkToTransaction__c from AQB__BatchCorrectionTransaction__c WHERE AQB__LinkToTransaction__c = :transId];
                    trans.MDA_Debit_Account__c = bcTrans.AQB__OriginalDesignation__c;
                    trans.MDA_Credit_AccountLookup__c = bcTrans.AQB__Designation__c;
                }

            }
        }
       

        }

   
  //System.debug(transList.size() +'=====TRANSLIST BATCH SIZE====' + JSON.serializePretty(transList));
  Database.SaveResult[] results = Database.update(transList, false);
  
         
    }   
     
    global void finish(Database.BatchableContext BC) {
    System.debug(recordsProcessed + ' records processed');
      
    }

}