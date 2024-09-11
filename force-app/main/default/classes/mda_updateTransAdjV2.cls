global class mda_updateTransAdjV2 implements Database.Batchable<sObject>, Database.Stateful {
   Integer recordsProcessed = 0;
   List<AQB__Transaction__c> transList = new  List<AQB__Transaction__c>();

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select Id, AQB__VoidedTransaction__r.AQB__PledgeStipulation__c, AQB__Batch__r.AQB__BatchType__c,AQB__VoidedTransaction__r.AQB__ChartofAccounts__r.AQB__Category__c, AQB__ChartofAccounts__r.AQB__Category__c,  mda_testRecord__c, AQB__ChartofAccounts__r.AQB__Account_Type__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__r.AQB__Method__c, AQB__VoidedTransaction__r.Id,AQB__VoidedTransaction__r.AQB__SourceofData__c, MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Batch_Item_ID2__c, AQB__Batch__r.AQB__RecordTypeDeveloperName__c, AQB__Instrument__c, AQB__Gift__r.AQB__Instrument__c,  AQB__Gift__r.AQB__MatchLink__r.Id, AQB__ThirdPartyPayoff__c, AQB__FinancialSystemDate__c, MDA_GL_Posting_Type__c,  AQB__DebitAccount__r.AQB__DesignationAccountNumber__c, MDA_Credit_AccountLookup__c, AQB__DebitAccount__c, AQB__ChartofAccounts__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__r.Id, MDA_Debit_Account__c, AQB__Gift__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c,MDA_Credit_Debit_Account_Error__c, AQB__PaymentNumber__c,  AQB__Type__c, AQB__Method__c, AQB__Batch__r.AQB__SourceofData__c,AQB__SourceofData__c, AQB__VoidedTransaction__c, AQB__PledgeStipulation__c, AQB__PledgePayment__c from AQB__Transaction__c WHERE CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z AND AQB__Type__c = \'Payment\' AND AQB__SourceofData__c = \'Adjustments\'';
        if (Test.isRunningTest()){
            query ='Select Id,  AQB__VoidedTransaction__r.AQB__PledgeStipulation__c, AQB__Batch__r.AQB__BatchType__c, AQB__VoidedTransaction__r.AQB__ChartofAccounts__r.AQB__Category__c, AQB__ChartofAccounts__r.AQB__Category__c, mda_testRecord__c,AQB__ChartofAccounts__r.AQB__Account_Type__c,AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__r.AQB__Method__c, AQB__VoidedTransaction__r.Id, AQB__VoidedTransaction__r.AQB__SourceofData__c,  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Batch_Item_ID2__c, AQB__Batch__r.AQB__RecordTypeDeveloperName__c, AQB__Instrument__c, AQB__Gift__r.AQB__Instrument__c,  AQB__Gift__r.AQB__MatchLink__r.Id, AQB__ThirdPartyPayoff__c, AQB__FinancialSystemDate__c, MDA_GL_Posting_Type__c,  AQB__DebitAccount__r.AQB__DesignationAccountNumber__c, MDA_Credit_AccountLookup__c, AQB__DebitAccount__c, AQB__ChartofAccounts__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__r.Id, MDA_Debit_Account__c, AQB__Gift__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c,MDA_Credit_Debit_Account_Error__c, AQB__PaymentNumber__c,  AQB__Type__c, AQB__Method__c, AQB__Batch__r.AQB__SourceofData__c,AQB__SourceofData__c, AQB__VoidedTransaction__c, AQB__PledgeStipulation__c, AQB__PledgePayment__c from AQB__Transaction__c WHERE CreatedDate >= 2023-10-17T19:00:00Z AND AQB__Type__c = \'Payment\' AND AQB__SourceofData__c = \'Adjustments\'';
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
    
        for(AQB__Transaction__c trans: transList) {
            Id transId = trans.Id;
            Id batchItem = trans.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c;
            Id gift = trans.AQB__Gift__c;
            trans.AQB__Do_not_push_to_Accounting__c = false;
            //Scenario 119A - Voided donations that were entered using a GIfts/Pledges Batch Type - linked to the Voided Transaction; Voided Transaction Source of Data is Annual Fund
            if(trans.AQB__VoidedTransaction__c != Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == false 
                && trans.AQB__ThirdPartyPayoff__c == false &&  trans.AQB__ChartofAccounts__r.AQB__Account_Type__c != NULL 
                && designationAccountType.contains(trans.AQB__ChartofAccounts__r.AQB__Account_Type__c) == false
                && trans.AQB__VoidedTransaction__r.AQB__SourceofData__c =='Annual Fund Lockbox' ){
                    
                    
                    AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                                if(correctTrans.size() == 0){
                                    trans.AQB__Do_not_push_to_Accounting__c = false;
                                    trans.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                                    trans.MDA_Credit_AccountLookup__c = coa.Id;
                                    trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                                    trans.MDA_Credit_Debit_Account_Error__c = false;
                                    recordsProcessed += 1;
                                }  
                                
            }
            //119B - Voided donations that were entered using a GIfts/Pledges Batch Type - linked to the Voided Transaction; Voided Transaction Source of Data is Other Sources that Post to GL;  funds received via Credit Card
            if(trans.AQB__VoidedTransaction__c != Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == false 
                && trans.AQB__ThirdPartyPayoff__c == false && trans.AQB__Method__c =='Credit Card' && trans.AQB__ChartofAccounts__r.AQB__Account_Type__c != NULL 
                && designationAccountType.contains(trans.AQB__ChartofAccounts__r.AQB__Account_Type__c) == false
                     ){
                       
                        AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                                    if(correctTrans.size() == 0){
                                        trans.AQB__Do_not_push_to_Accounting__c = false;
                                        trans.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                                        trans.MDA_Credit_AccountLookup__c = coa2.Id;
                                        trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                                        trans.MDA_Credit_Debit_Account_Error__c = false;
                                    }
                        
                    }
            //119C - Voided donations that were entered using a GIfts/Pledges Batch Type - linked to the Voided Transaction; Voided Transaction Source of Data is Other Sources that Post to GL;  funds received via ACH, Cash, Check, PayPal, Securities, Transfer, Wire
            if(trans.AQB__VoidedTransaction__c != Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == false 
                && trans.AQB__ThirdPartyPayoff__c == false && paymentMethod.contains(trans.AQB__Method__c) == true  && trans.AQB__ChartofAccounts__r.AQB__Account_Type__c != NULL 
                && designationAccountType.contains(trans.AQB__ChartofAccounts__r.AQB__Account_Type__c) == false
                && dataSource.contains(trans.AQB__VoidedTransaction__r.AQB__SourceofData__c) == true ){
                   
                    AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                                if(correctTrans.size() == 0){
                                    trans.AQB__Do_not_push_to_Accounting__c = false;
                                    trans.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                                    trans.MDA_Credit_AccountLookup__c = coa3.Id;
                                    trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                                    trans.MDA_Credit_Debit_Account_Error__c = false;
                                }

            }
            //119D -Voided donations that were entered using a GIfts/Pledges Batch Type - linked to the Voided Transaction; Voided Transaction Source of Data is null
            if(trans.AQB__VoidedTransaction__c != Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == false 
            && trans.AQB__ThirdPartyPayoff__c == false  && trans.AQB__VoidedTransaction__r.AQB__SourceofData__c == Null ){
                AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                  
                        if(correctTrans.size() == 0){
                                trans.AQB__Do_not_push_to_Accounting__c = false;
                                trans.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                                trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                            }

            }
            //119E - Voided donations that were entered using a GIfts/Pledges Batch Type - linked to the Voided Transaction; Account Type is Endowment
            if(trans.AQB__VoidedTransaction__c != Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == false 
                    && trans.AQB__ThirdPartyPayoff__c == false 
                    && trans.AQB__ChartofAccounts__r.AQB__Account_Type__c != NULL 
                    && designationAccountType.contains(trans.AQB__ChartofAccounts__r.AQB__Account_Type__c) == true){
                       
                        AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                                    if(correctTrans.size() == 0){
                                        trans.AQB__Do_not_push_to_Accounting__c = true;
                                    
                                    }
                    }
            //119F- Voided donations that were entered using a GIfts/Pledges Batch Type - linked to the Voided Transaction; Account Type is Missing
            if(trans.AQB__VoidedTransaction__c != Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == false 
                    && trans.AQB__ThirdPartyPayoff__c == false 
                    && trans.AQB__ChartofAccounts__r.AQB__Account_Type__c == NULL ){
                        AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                                    if(correctTrans.size() == 0){
                                        trans.AQB__Do_not_push_to_Accounting__c = true;
                                    
                                    }
                    }
            // 120 - Adjusted Donations that were entered using a GIfts/Pledges Batch Type, but is not linked to the Voided Transaction
            if(trans.AQB__VoidedTransaction__c == Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == false 
                && trans.AQB__ThirdPartyPayoff__c == false ){
                    AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                                if(correctTrans.size() == 0){
                                    trans.AQB__Do_not_push_to_Accounting__c = false;
                                    trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                                    trans.MDA_Credit_Debit_Account_Error__c = true;
                                    
                                
                                }
            }
            // 121A-Adjusted pledge payment that were entered using a GIfts/Pledges Batch Type - Conditional Pledge
            if(trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__Type__c == 'Payment' && trans.AQB__PledgePayment__c == true 
                && trans.AQB__ThirdPartyPayoff__c == false && trans.AQB__PledgeStipulation__c == 'Conditional'
                ){
                    trans.AQB__Do_not_push_to_Accounting__c = false;
                    trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                    trans.MDA_Credit_Debit_Account_Error__c = true;              
                }
            //121B-Voided pledge payment that were entered using a GIfts/Pledges Batch Type - Unconditional Pledge
            if(trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__Type__c == 'Payment' && trans.AQB__PledgePayment__c == true 
                && trans.AQB__ThirdPartyPayoff__c == false && trans.AQB__PledgeStipulation__c == 'Unconditional'){ 
                    trans.AQB__Do_not_push_to_Accounting__c = false;
                    trans.MDA_GL_Posting_Type__c = 'Manual-Historical';
                    trans.MDA_Credit_Debit_Account_Error__c = true;
                
                }
            //121C- Voided pledge payment that were entered using a GIfts/Pledges Batch Type - Missing Pledge Type; Voided Transaction is Conditional OR NULL
            if(trans.AQB__VoidedTransaction__c != Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == true 
                    && trans.AQB__ThirdPartyPayoff__c == false && trans.AQB__PledgeStipulation__c == Null
                    && (trans.AQB__VoidedTransaction__r.AQB__PledgeStipulation__c == Null || trans.AQB__VoidedTransaction__r.AQB__PledgeStipulation__c == 'Conditional' ) ){                
                                        trans.AQB__Do_not_push_to_Accounting__c = false;
                                        trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                                        trans.MDA_Credit_Debit_Account_Error__c = true;
                                }


            //121D - Voided pledge payment that were entered using a GIfts/Pledges Batch Type - Missing Pledge Type; Voided Transaction is Unconditional
            if(trans.AQB__VoidedTransaction__c != Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == true 
                    && trans.AQB__ThirdPartyPayoff__c == false && trans.AQB__PledgeStipulation__c == Null
                    && trans.AQB__VoidedTransaction__r.AQB__PledgeStipulation__c == 'Unconditional'){                
                            trans.AQB__Do_not_push_to_Accounting__c = false;
                            trans.MDA_GL_Posting_Type__c = 'Manual-Historical';
                            trans.MDA_Credit_Debit_Account_Error__c = true;
                        }

            
           //122-Adjusted  donation that was entered using a GIfts/Pledges Batch Type - the Void and Correct Feature was Used; This is the Voided Transaction
           if(trans.AQB__VoidedTransaction__c != Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == false 
                    && trans.AQB__ThirdPartyPayoff__c == false && trans.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__r.AQB__Method__c == 'Void'){  
                       
                        AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                                    if(correctTrans.size() > 0){
                                        trans.AQB__Do_not_push_to_Accounting__c = true;
                                    }              
                                        
                                }
            //123A - Adjusted  donation that was entered using a GIfts/Pledges Batch Type - the Void and Correct Feature was Used; This is the Corrected Transaction;  properly linked to the Void Transaction; Old Designation is a Gift Fund, Non-Endowment; New Designation is a Gift Fund, Non-Endowment
            if(trans.AQB__VoidedTransaction__c == Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == false 
                && trans.AQB__ThirdPartyPayoff__c == false 
                && trans.AQB__ChartofAccounts__r.AQB__Category__c == 'Gift Fund' 
                && trans.AQB__ChartofAccounts__r.AQB__Account_Type__c != NULL 
                && designationAccountType.contains(trans.AQB__ChartofAccounts__r.AQB__Account_Type__c) == false
                && trans.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__r.AQB__Method__c == 'Void'
                    ){  
                        AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__r.AQB__Category__c,AQB__ChartofAccounts__r.AQB__Account_Type__c, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                                    if(correctTrans.size() > 0){  
                                        if(correctTrans[0].AQB__ChartofAccounts__r.AQB__Category__c == 'Gift Fund' 
                                            && correctTrans[0].AQB__ChartofAccounts__r.AQB__Account_Type__c != NULL 
                                            && designationAccountType.contains(correctTrans[0].AQB__ChartofAccounts__r.AQB__Account_Type__c) == false)
                                            {             
                                            trans.MDA_Debit_Account__c = correctTrans[0].AQB__ChartofAccounts__c;
                                            trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                                            trans.AQB__Do_not_push_to_Accounting__c = false;
                                            trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                                            trans.MDA_Credit_Debit_Account_Error__c = false;
                                        }
                                    }              
                                        
                                }

            // 123B- Adjusted  donation that was entered using a GIfts/Pledges Batch Type - the Void and Correct Feature was Used; This is the Corrected Transaction; properly  linked to the Void Transaction; Old Designation was a Grant Fund or the New Designation is a Grant Fund
            if(trans.AQB__VoidedTransaction__c == Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == false 
                    && trans.AQB__ThirdPartyPayoff__c == false && 
                    trans.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__r.AQB__Method__c == 'Void'){
                            AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__r.AQB__Category__c, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                            if(correctTrans.size() > 0){  
                                if(trans.AQB__ChartofAccounts__r.AQB__Category__c == 'Grant Fund' || correctTrans[0].AQB__ChartofAccounts__r.AQB__Category__c == 'Grant Fund'){                        
                                    trans.AQB__Do_not_push_to_Accounting__c = false;
                                    trans.MDA_Credit_Debit_Account_Error__c = true;
                                }
                            }   

                    }
            //123C- Adjusted  donation that was entered using a GIfts/Pledges Batch Type - the Void and Correct Feature was Used; This is the Corrected Transaction; properly  linked to the Void Transaction; Old Designation was an Endowment Fund  or the New Designation is an Endowment Fund
            if(trans.AQB__VoidedTransaction__c == Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == false 
                        && trans.AQB__ThirdPartyPayoff__c == false && trans.AQB__ChartofAccounts__r.AQB__Category__c == 'Gift Fund' &&
                        trans.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__r.AQB__Method__c == 'Void'
                    ){    
                        AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__r.AQB__Account_Type__c,AQB__ChartofAccounts__r.AQB__Category__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                                        if(correctTrans.size() > 0){ 
                                            if(correctTrans[0].AQB__ChartofAccounts__r.AQB__Category__c == 'Gift Fund' &&
                                            ((trans.AQB__ChartofAccounts__r.AQB__Account_Type__c != NULL 
                                              && designationAccountType.contains(trans.AQB__ChartofAccounts__r.AQB__Account_Type__c) == true) || (
                                              correctTrans[0].AQB__ChartofAccounts__r.AQB__Account_Type__c != NULL &&
                                              designationAccountType.contains(correctTrans[0].AQB__ChartofAccounts__r.AQB__Account_Type__c) == true)))
                                            
                                            {                   
                                                trans.AQB__Do_not_push_to_Accounting__c = false;
                                                trans.MDA_Credit_Debit_Account_Error__c = true;
                                            }  
                                            }              
                                        
                        }
            //123D- Adjusted  donation that was entered using a GIfts/Pledges Batch Type - the Void and Correct Feature was Used; This is the Corrected Transaction; properly  linked to the Void Transaction; Old Designation was an Endowment Fund  or the New Designation is an Endowment Fund
            if(trans.AQB__VoidedTransaction__c == Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == false 
                            && trans.AQB__ThirdPartyPayoff__c == false && trans.AQB__ChartofAccounts__r.AQB__Category__c == 'Gift Fund' &&
                            trans.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__r.AQB__Method__c == 'Void'){
                                AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__ChartofAccounts__r.AQB__Category__c, AQB__ChartofAccounts__r.AQB__Account_Type__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                                        if(correctTrans.size() > 0){  
                                            if(correctTrans[0].AQB__ChartofAccounts__r.AQB__Category__c == 'Gift Fund' && (trans.AQB__ChartofAccounts__r.AQB__Account_Type__c == NULL || correctTrans[0].AQB__ChartofAccounts__r.AQB__Account_Type__c == NULL)){                  
                                                trans.AQB__Do_not_push_to_Accounting__c = false;
                                            }
                                        } 
                }

            //123E-Adjusted  donation that was entered using a GIfts/Pledges Batch Type - The Void and Correction Feature was NOT USED
            if(trans.AQB__VoidedTransaction__c == Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gifts/Pledges' && trans.AQB__PledgePayment__c == false 
                && trans.AQB__ThirdPartyPayoff__c == false && trans.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__r.AQB__Method__c != 'Void'){
                    AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
                        if(correctTrans.size() > 0){                    
                            trans.AQB__Do_not_push_to_Accounting__c = false;
                        }    
            }
            //124- Gift Corrections using Gift/Pledge Corrections Batch - Voided Transaction
            if(trans.AQB__VoidedTransaction__c != Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gift/Pledge Corrections' && trans.AQB__PledgePayment__c == false 
                && trans.AQB__ThirdPartyPayoff__c == false ){
                    trans.AQB__Do_not_push_to_Accounting__c = true;

            }
            //125- Gift Corrections using Gift/Pledge Corrections Batch - Corrected Transactions
            if(trans.AQB__VoidedTransaction__c == Null && trans.AQB__Type__c == 'Payment' && trans.AQB__Batch__r.AQB__BatchType__c == 'Gift/Pledge Corrections' && trans.AQB__PledgePayment__c == false 
                && trans.AQB__ThirdPartyPayoff__c == false )
                {        
                    AQB__BatchCorrectionTransaction__c glAccount = [Select Id, AQB__OriginalDesignation__c, AQB__Designation__c from AQB__BatchCorrectionTransaction__c  
                    WHERE AQB__LinkToTransaction__c = :trans.Id];
                                        
                    trans.MDA_Debit_Account__c = glAccount.AQB__OriginalDesignation__c;
                    trans.MDA_Credit_AccountLookup__c = glAccount.AQB__Designation__c;