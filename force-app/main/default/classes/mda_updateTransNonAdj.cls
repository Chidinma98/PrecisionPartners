global class mda_updateTransNonAdj implements Database.Batchable<sObject>, Database.Stateful{
    Integer recordsProcessed = 0;
    List<AQB__Transaction__c> transList = new  List<AQB__Transaction__c>();
    List<AQB__Transaction__c> processedRecords = new List<AQB__Transaction__c>();
    List<AQB__Transaction__c> correctTransactions = new List<AQB__Transaction__c>();
    //Chart Of Accounts List
    AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c 
    WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90-11324' LIMIT 1];
    AQB__LLChartofAccounts__c coa2 = [Select Id, AQB__DesignationAccountNumber__c from AQB__LLChartofAccounts__c 
    WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];
    AQB__LLChartofAccounts__c coa3 = [Select Id, AQB__DesignationAccountNumber__c from AQB__LLChartofAccounts__c 
    WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];  
    //Payment Methods
    Set<String> dataSource = new Set<String>{'Mail','Institutional Lockbox', 'Children\'s Art Project (CAP)', 'Live Check / Credit Card (MD Anderson Front Office)', 
    'MDA Treasury', 'Special Events Lockbox', 'MDA Cashier Office', 'Online - Donation Sites',
     'Online - Peer 2 Peer Sites', 'UT Foundation'};


Set<String> paymentMethod = new Set<String>{'Cash','Check','Securities','ACH','Wire', 'Paypal', 'Transfer'};


    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select Id, AQB__Batch__r.AQB__BatchType__c, mda_testRecord__c, AQB__VoidedTransaction__r.Id, MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Batch_Item_ID2__c, AQB__Batch__r.AQB__RecordTypeDeveloperName__c, AQB__Instrument__c, AQB__Gift__r.AQB__Instrument__c,  AQB__Gift__r.AQB__MatchLink__r.Id, AQB__ThirdPartyPayoff__c, AQB__FinancialSystemDate__c, MDA_GL_Posting_Type__c,  AQB__DebitAccount__r.AQB__DesignationAccountNumber__c, MDA_Credit_AccountLookup__c, AQB__DebitAccount__c, AQB__ChartofAccounts__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__r.Id, MDA_Debit_Account__c, AQB__Gift__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c,MDA_Credit_Debit_Account_Error__c, AQB__PaymentNumber__c,  AQB__Type__c, AQB__Method__c, AQB__Batch__r.AQB__SourceofData__c,AQB__SourceofData__c, AQB__VoidedTransaction__c, AQB__PledgeStipulation__c, AQB__PledgePayment__c from AQB__Transaction__c WHERE CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z';
        if (Test.isRunningTest()){
            //query += ' LIMIT 100';
            query ='Select Id, AQB__Batch__r.AQB__BatchType__c, mda_testRecord__c, AQB__VoidedTransaction__r.Id, MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Batch_Item_ID2__c, AQB__Batch__r.AQB__RecordTypeDeveloperName__c, AQB__Instrument__c, AQB__Gift__r.AQB__Instrument__c,  AQB__Gift__r.AQB__MatchLink__r.Id, AQB__ThirdPartyPayoff__c, AQB__FinancialSystemDate__c, MDA_GL_Posting_Type__c,  AQB__DebitAccount__r.AQB__DesignationAccountNumber__c, MDA_Credit_AccountLookup__c, AQB__DebitAccount__c, AQB__ChartofAccounts__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__r.Id, MDA_Debit_Account__c, AQB__Gift__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c,MDA_Credit_Debit_Account_Error__c, AQB__PaymentNumber__c,  AQB__Type__c, AQB__Method__c, AQB__Batch__r.AQB__SourceofData__c,AQB__SourceofData__c, AQB__VoidedTransaction__c, AQB__PledgeStipulation__c, AQB__PledgePayment__c from AQB__Transaction__c WHERE CreatedDate >= 2023-10-17T19:00:00Z AND mda_testRecord__c = true AND AQB__ChartofAccounts__c != Null';           
            }
        
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext BC, List< AQB__Transaction__c> transList) {
        for(AQB__Transaction__c trans: transList) {
             // 105 - New and Adjusted Pledges, Matching Gifts, Planned Gifts
             if(trans.AQB__Type__c == 'Pledge' && trans.AQB__ThirdPartyPayoff__c == false && trans.AQB__PledgePayment__c == false){
                trans.AQB__Do_not_push_to_Accounting__c = true;
                recordsProcessed +=1;
             }
              //106 - New && Adjusted Grants
              if(trans.AQB__Type__c == 'Grant' && trans.AQB__ThirdPartyPayoff__c == false && trans.AQB__PledgePayment__c == false){
                trans.AQB__Do_not_push_to_Accounting__c = true;
                recordsProcessed +=1;
              }
              //Scenario 107: Grant Payments where the source is the Click Grants Report 
              if(trans.AQB__SourceofData__c == 'Grants Management System' && (trans.AQB__Type__c == 'Grant Payment' || trans.AQB__Type__c == 'Payment') 
                && trans.AQB__PledgePayment__c == true && trans.AQB__ThirdPartyPayoff__c == false){
                trans.AQB__Do_not_push_to_Accounting__c = true;
                recordsProcessed +=1;
              }
              //Scenario 108:Grant Overpayment where the source is the Click Grants Report
              if(trans.AQB__SourceofData__c == 'Grants Management System' && (trans.AQB__Type__c == 'Grant Payment' || trans.AQB__Type__c == 'Payment') 
                && trans.AQB__PledgePayment__c == false && trans.AQB__ThirdPartyPayoff__c == false){
                trans.AQB__Do_not_push_to_Accounting__c = true;
                recordsProcessed +=1;
              }
              //Scenario 109: Gifts in Kind
              if(trans.AQB__Type__c == 'Payment' && trans.AQB__PledgePayment__c == false && trans.AQB__ThirdPartyPayoff__c == false &&
              trans.AQB__SourceofData__c == 'Gift in Kind Form / Documentation'){
                trans.AQB__Do_not_push_to_Accounting__c = true;
                recordsProcessed +=1;
              }
              //Scenario 110:Payments from Caging - Annual Fund Lockbox 
               if(trans.AQB__Type__c == 'Payment' && trans.AQB__PledgePayment__c == false && trans.AQB__ThirdPartyPayoff__c == false && 
                trans.AQB__SourceofData__c == 'Annual Fund Lockbox' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges'){
                trans.MDA_Credit_Debit_Account_Error__c = false;
                trans.AQB__Do_not_push_to_Accounting__c  = false;
                trans.AQB__DebitAccount__c = coa.Id;
                trans.MDA_Debit_Account__c = coa.Id;
                trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                recordsProcessed +=1;
               }
              //Scenario 111: Conditional Pledge Payments from Caging - Annual Fund Lockbox
              if(trans.AQB__Type__c == 'Payment' && trans.AQB__PledgePayment__c == true && trans.AQB__ThirdPartyPayoff__c == false && 
                trans.AQB__SourceofData__c == 'Annual Fund Lockbox' && trans.AQB__PledgeStipulation__c == 'Conditional' &&
                trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges'){
                trans.MDA_Credit_Debit_Account_Error__c = false;
                trans.AQB__Do_not_push_to_Accounting__c  = false;
                trans.AQB__DebitAccount__c = coa.Id;
                trans.MDA_Debit_Account__c = coa.Id;
                trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                recordsProcessed +=1;

              }
            //Scenario 112: Unconditional Pledge Payments from Caging - Annual Fund Lockbox
                if(trans.AQB__Type__c == 'Payment' && trans.AQB__PledgePayment__c == true && trans.AQB__ThirdPartyPayoff__c == false && 
                    trans.AQB__SourceofData__c == 'Annual Fund Lockbox' && trans.AQB__PledgeStipulation__c == 'Unconditional' &&
                    trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges'){
                    trans.MDA_Credit_Debit_Account_Error__c = false;
                    trans.AQB__Do_not_push_to_Accounting__c  = false;
                    trans.AQB__DebitAccount__c = coa.Id;
                    trans.MDA_Debit_Account__c = coa.Id;
                    trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                    trans.MDA_GL_Posting_Type__c = 'Manual-Historical';
                    recordsProcessed +=1;
                    
                }
            //Scenario 113: Donations from Sources that Post to the GL; funds received via credit card 
                if(dataSource.contains(trans.AQB__SourceofData__c) && trans.AQB__PledgePayment__c == false && trans.AQB__ThirdPartyPayoff__c == false
                    && trans.AQB__Method__c == 'Credit Card'  && trans.AQB__Type__c == 'Payment' &&
                    trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges'){
                    trans.MDA_Credit_Debit_Account_Error__c = false;
                    trans.AQB__Do_not_push_to_Accounting__c  = false;
                    trans.AQB__DebitAccount__c = coa2.Id;
                    trans.MDA_Debit_Account__c = coa2.Id;
                    trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                    trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                    recordsProcessed +=1;

                }
            //Scenario 114: Donations from Sources that Post to the GL; funds received via ACH, Cash, Check, PayPal,Securities, Transfer, Wire
                if( dataSource.contains(trans.AQB__SourceofData__c) && trans.AQB__PledgePayment__c == false && trans.AQB__ThirdPartyPayoff__c == false
                    && paymentMethod.contains(trans.AQB__Method__c) && trans.AQB__Type__c == 'Payment' &&
                    trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges'){
                    trans.MDA_Credit_Debit_Account_Error__c = false;
                    trans.AQB__Do_not_push_to_Accounting__c  = false;
                    trans.AQB__DebitAccount__c = coa3.Id;
                    trans.MDA_Debit_Account__c = coa3.Id;
                    trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                    trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                    recordsProcessed +=1;

                }
            //Scenario 115: Conditional Pledge Payments from Sources that Post to the GL; funds received via credit card  
                if(dataSource.contains(trans.AQB__SourceofData__c) && trans.AQB__PledgePayment__c == true && trans.AQB__ThirdPartyPayoff__c == false
                    && trans.AQB__Method__c =='Credit Card' && (trans.AQB__PledgeStipulation__c == 'Conditional' || trans.AQB__PledgeStipulation__c == Null) &&
                    trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__Type__c == 'Payment' ){
                    trans.MDA_Credit_Debit_Account_Error__c = false;
                    trans.AQB__Do_not_push_to_Accounting__c  = false;
                    trans.AQB__DebitAccount__c = coa2.Id;
                    trans.MDA_Debit_Account__c = coa2.Id;
                    trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                    trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                    recordsProcessed +=1;

                }
             //Scenario 116:Conditional Pledge Payments from Sources that Post to the GL; funds received via ACH, Cash, Check, PayPal, Securities, Transfer, Wire  
                if(dataSource.contains(trans.AQB__SourceofData__c) && trans.AQB__PledgePayment__c == true && trans.AQB__ThirdPartyPayoff__c == false
                    && paymentMethod.contains(trans.AQB__Method__c) && (trans.AQB__PledgeStipulation__c == 'Conditional' || trans.AQB__PledgeStipulation__c == Null) &&
                    trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' &&(trans.AQB__Type__c == 'Payment' || trans.AQB__Type__c == 'Grant Payment')){
                    trans.MDA_Credit_Debit_Account_Error__c = false;
                    trans.AQB__Do_not_push_to_Accounting__c  = false;
                    trans.AQB__DebitAccount__c = coa2.Id;
                    trans.MDA_Debit_Account__c = coa2.Id;
                    trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                    trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                    recordsProcessed +=1;
                        
                }
            //Scenario 117:Unconditional Pledge Payments from Sources that Post to the GL; funds received via credit card 
                if(dataSource.contains(trans.AQB__SourceofData__c) && trans.AQB__PledgePayment__c == true && trans.AQB__ThirdPartyPayoff__c == false
                    && trans.AQB__Method__c =='Credit Card' && trans.AQB__PledgeStipulation__c == 'Unconditional' &&
                    trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__Type__c == 'Payment'){
                    trans.MDA_Credit_Debit_Account_Error__c = false;
                    trans.AQB__Do_not_push_to_Accounting__c  = false;
                    trans.AQB__DebitAccount__c = coa2.Id;
                    trans.MDA_Debit_Account__c = coa2.Id;
                    trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                    trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                    recordsProcessed +=1;
                }
             //Scenario 118:Unconditional Pledge Payments from Sources that Post to the GL; funds received via ACH, Cash, Check, PayPal, Securities, Transfer, Wire 
                if(dataSource.contains(trans.AQB__SourceofData__c) && trans.AQB__PledgePayment__c == true && trans.AQB__ThirdPartyPayoff__c == false
                    && paymentMethod.contains(trans.AQB__Method__c) && trans.AQB__PledgeStipulation__c == 'Unconditional' &&
                    trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__Type__c == 'Payment' ){
                    trans.MDA_Credit_Debit_Account_Error__c = false;
                    trans.AQB__Do_not_push_to_Accounting__c  = false;
                    trans.AQB__DebitAccount__c = coa3.Id;
                    trans.MDA_Debit_Account__c = coa3.Id;
                    trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                    trans.MDA_GL_Posting_Type__c = 'Manual-Historical';
                    recordsProcessed +=1;
                }         
        }

        Database.SaveResult[] results = Database.update(transList, false);
    }

    global void finish(Database.BatchableContext BC) {
        System.debug(recordsProcessed + ' records processed');
          
        }
}