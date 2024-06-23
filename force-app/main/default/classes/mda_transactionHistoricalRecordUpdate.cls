/**
 * Apex Class Name: mda_transactionHistoricalRecordUpdate
 *
 * Created Date: February 26, 2024 
 *
 * @description: This class is to update existing records in Transactions- with appropraite debit account values based on given conditions. 
 * @author: M. Eleanya (Contractor: Precision Partners)
 *
**/


global class mda_transactionHistoricalRecordUpdate implements Database.Batchable<sObject>, Database.Stateful{
   //mda_transactionHistoricalRecordUpdate myBatchObject = new mda_transactionHistoricalRecordUpdate();
   //Id batchId = Database.executeBatch(myBatchObject);
   Integer recordsProcessed = 0;
   List<AQB__Transaction__c> transList = new  List<AQB__Transaction__c>();
   public static  Set<String>  getNum(Integer num) {
    Set<String> container = new Set<String>{};

        for (Integer i = 0; i<= num; i++){
            String num2 = String.valueOf(i);
            container.add(num2);
            }
            container.add('correctTrans');
        return container; 
    }
  
 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Set<String> testValues = getNum(33);
        String query = 'Select Id, AQB__Batch__r.AQB__RecordTypeDeveloperName__c, AQB__Gift__r.AQB__MatchLink__r.Id, AQB__ThirdPartyPayoff__c, AQB__FinancialSystemDate__c, MDA_GL_Posting_Type__c,  AQB__DebitAccount__r.AQB__DesignationAccountNumber__c,	MDA_Credit_AccountLookup__c, AQB__DebitAccount__c, AQB__ChartofAccounts__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__r.Id, MDA_Debit_Account__c, AQB__Gift__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c,MDA_Credit_Debit_Account_Error__c, MDA_Credit_Account_Number__c, MDA_Debit_Account_Number__c, AQB__PaymentNumber__c,  AQB__Type__c, AQB__Method__c, AQB__Batch__r.AQB__SourceofData__c,AQB__SourceofData__c, AQB__VoidedTransaction__c, AQB__PledgeStipulation__c, AQB__PledgePayment__c from AQB__Transaction__c WHERE CreatedDate >= 2023-10-17T19:00:00Z';
        if (Test.isRunningTest()){
        	//query += ' LIMIT 100';
            query += 'AND AQB__Reference__c IN :testValues LIMIT 100';
    		}
        
        return Database.getQueryLocator(query); 
    }
     
    global void execute(Database.BatchableContext BC, List<	AQB__Transaction__c> transList) {
      AQB__LLChartofAccounts__c[] coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108380-19-11324'];
      AQB__LLChartofAccounts__c[] coa2 = [Select Id, AQB__DesignationAccountNumber__c from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19'];
      AQB__LLChartofAccounts__c[] coa3 = [Select Id, AQB__DesignationAccountNumber__c from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90'];  
      
        Set<String> dataSource = new Set<String>{'Mail','Institutional Lockbox', 'Children\'s Art Project (CAP)', 'Live Check / Credit Card (MD Anderson Front Office)', 
            									'MDA Treasury', 'Special Events Lockbox', 'MDA Cashier Office', 'Online - Donation Sites',
            									'Online - Event Registration Sites', 'Online - Peer 2 Peer Sites', 'UT Foundation'};
        Set<String> paymentMethod = new Set<String>{'Cash','Check','Securities','ACH','Wire','ACH/Wire', 'Paypal', 'Transfer'};
        Set<String> paymentMethod2 = new Set<String>{'Cash', 'Check','Securities','ACH','Wire','ACH/Wire'};
        Set<String> paymentMethod3 = new Set<String>{'Check','ACH','Wire','ACH/Wire'};
        Set<String> paymentMethod4 = new Set<String>{'Cash','Check','Securities','ACH','Wire','ACH/Wire', 'Paypal'};
        Set<String> transactionType = new Set<String>{'Grant Payment', 'Payment', 'Soft Credit'};
        Set<String> otherDataSource = new Set<String>{'Grants Management System','Gift in Kind Form / Documentation','Planned Giving Form / Documentation'};
        Set<String> transType = new Set<String>{ 'Grant', 'Soft Credit', 'Pledge Soft Credit'};
        Set<String> transType2 = new Set<String>{ 'Soft Credit', 'Pledge Soft Credit'};
        Set<String> pledgeOffset = new Set<String>{ 'Pledge', 'Grant'};
        Set<String> sourceDataValidation = new Set<String>{'Institutional Lockbox', 'Live Check / Credit Card (MD Anderson Front Office)', 'MDA Treasury'};
            
        List<AQB__Transaction__c> processedRecords = new List<AQB__Transaction__c>();
        List<AQB__Transaction__c> correctTransactions = new List<AQB__Transaction__c>();
        
        for(AQB__Transaction__c trans: transList) {
        trans.MDA_Credit_Debit_Account_Error__c = false;
        //Check Posted Transaction and Batch Status
         if(trans.AQB__FinancialSystemDate__c == NULL ){
        //Check the batch is not closed if it is a closed batch set to MDA_Credit_Debit_Account_Error__c to null
         if(trans.AQB__Batch__r.AQB__RecordTypeDeveloperName__c != 'ClosedBatch'){
        //Check Voided Transaction
         if(trans.AQB__VoidedTransaction__c == NULL){
        //Check for Pledge Offset - Yes
        if((trans.AQB__PledgePayment__c == true && pledgeOffset.contains(trans.AQB__Type__c)) || (trans.AQB__ThirdPartyPayoff__c == true && pledgeOffset.contains(trans.AQB__Type__c))){
            trans.AQB__Do_not_push_to_Accounting__c = false;
            trans.AQB__FinancialSystemDate__c = null;
            trans.MDA_Credit_AccountLookup__c = null;
            trans.MDA_Debit_Account__c = null;
            trans.MDA_GL_Posting_Type__c = null;
            trans.MDA_Journal_ID__c = null;
            trans.MDA_Original_Transaction__c = null;
            trans.MDA_Related_Void_Transaction__c = null;
        }else{  
            //Check for Pledge Offset - No
            //Check Source of Data - Annual Fund 
            //Scenario 1- Annual Fund Source of Data with PAYMENT
            if(trans.AQB__SourceofData__c == 'Annual Fund Lockbox'){ 
                    if(trans.AQB__Type__c == 'Payment'){ 
                        if(trans.MDA_Credit_AccountLookup__c == null || trans.MDA_Debit_Account__c == null || trans.MDA_GL_Posting_Type__c != 'Automated'){
                            trans.MDA_Credit_Debit_Account_Error__c = true;
                        } else {
                            trans.AQB__DebitAccount__c = coa[0].Id;
                            trans.MDA_Debit_Account__c = coa[0].Id;
                            trans.MDA_Debit_Account_Number__c = coa[0].AQB__DesignationAccountNumber__c;
                            trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                            trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                            trans.MDA_GL_Posting_Type__c = 'Automated';
                            recordsProcessed = recordsProcessed + 1;
                        }
                   
                    }
                //Scenario 2 - Source of Data Annual Fund with Transaction Type of 'Soft Credit' and 'Pledge Soft Credit'
                	 else if(transType2.contains(trans.AQB__Type__c) == false){
                         trans.MDA_Credit_Debit_Account_Error__c = true;
                         recordsProcessed = recordsProcessed + 1;
                       
                     }
                   
        	}
            
             else if(dataSource.contains(trans.AQB__Batch__r.AQB__SourceofData__c) == true){
                //Check Payment Type - Grant Payment
                if(trans.AQB__Type__c == 'Grant Payment'){
                    //Check Source of Data Validation
                    if(sourceDataValidation.contains(trans.AQB__Batch__r.AQB__SourceofData__c)){
                       if(trans.MDA_Credit_AccountLookup__c == null || trans.MDA_Debit_Account__c == null || trans.MDA_GL_Posting_Type__c != 'Automated'){
                            trans.MDA_Credit_Debit_Account_Error__c = true;
                       }else{
                            trans.AQB__DebitAccount__c = coa3[0].Id;
                            trans.MDA_Debit_Account__c = coa3[0].Id;
                            trans.MDA_Debit_Account_Number__c = coa3[0].AQB__DesignationAccountNumber__c;
                            trans.MDA_Credit_AccountLookup__c  = trans.AQB__ChartofAccounts__c;
                            trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c; 
                            trans.MDA_GL_Posting_Type__c = 'Automated';
                            recordsProcessed = recordsProcessed + 1;
                        }
                    //Scenario for invalid source of data  
                    }else{
                            trans.MDA_Credit_Debit_Account_Error__c = true;
                    }
                     
                }
            	
                //Check Payment Type - Payment 
            	  
                else if(trans.AQB__Type__c == 'Payment'){
                    //Scenario 7 - Checks if linked to a pledge payment and pledge stipulation is conditional
                    
                   if(trans.AQB__PledgePayment__c == true && trans.AQB__PledgeStipulation__c == 'Conditional' ){
                        if(paymentMethod4.contains(trans.AQB__Method__c) == true ){
                            if(trans.MDA_Credit_AccountLookup__c == null || trans.MDA_Debit_Account__c == null || trans.MDA_GL_Posting_Type__c != 'Automated'){
                                trans.MDA_Credit_Debit_Account_Error__c = true;

                            }else{
                                trans.AQB__DebitAccount__c = coa3[0].Id;
                                trans.MDA_Debit_Account__c = coa3[0].Id;
                                trans.MDA_Debit_Account_Number__c = coa3[0].AQB__DesignationAccountNumber__c;
                                trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                                trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;            
                                trans.MDA_GL_Posting_Type__c = 'Automated';
                                recordsProcessed = recordsProcessed + 1;
                            }
                        //Scenario 8  - Checks if linked to a pledge payment and pledge stipulation is conditional with method of credit card  
                       } else if (trans.AQB__Method__c == 'Credit Card'){
                            if(trans.MDA_Credit_AccountLookup__c == null || trans.MDA_Debit_Account__c == null || trans.MDA_GL_Posting_Type__c != 'Automated'){
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                            }else {
                                trans.AQB__DebitAccount__c = coa2[0].Id;
                                trans.MDA_Debit_Account__c = coa2[0].Id;
                                trans.MDA_Debit_Account_Number__c = coa2[0].AQB__DesignationAccountNumber__c;
                                trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                                trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;    
                                trans.MDA_GL_Posting_Type__c = 'Automated'; 
                                recordsProcessed = recordsProcessed + 1;
                                    }
                         
                       } else {
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                       }           
                        
                    }
                    //Scenarion 11- Checks for Pledge Payment and Unconditional pledge stipulation
                    if(trans.AQB__PledgePayment__c == true && trans.AQB__PledgeStipulation__c != 'Conditional' ){
                        if(paymentMethod4.contains(trans.AQB__Method__c) == true ){
                            if(trans.MDA_Credit_AccountLookup__c == null || trans.MDA_Debit_Account__c == null || trans.MDA_GL_Posting_Type__c != 'Manual'){
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                            }else{
                                trans.AQB__DebitAccount__c = coa3[0].Id;
                                trans.MDA_Debit_Account__c = coa3[0].Id;
                                trans.MDA_Debit_Account_Number__c = coa3[0].AQB__DesignationAccountNumber__c;
                                trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                                trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;            
                                trans.MDA_GL_Posting_Type__c = 'Manual';
                                recordsProcessed = recordsProcessed + 1;
                            }
                       //Scenario 12- Checks for Pledge Payment and Unconditional pledge stipulation with payment method of credit card    
                       } else if (trans.AQB__Method__c == 'Credit Card'){
                            if(trans.MDA_Credit_AccountLookup__c == null || trans.MDA_Debit_Account__c == null ){
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                            }else{
                                trans.AQB__DebitAccount__c = coa2[0].Id;
                                trans.MDA_Debit_Account__c = coa2[0].Id;
                                trans.MDA_Debit_Account_Number__c = coa2[0].AQB__DesignationAccountNumber__c;
                                trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                                trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;    
                                trans.MDA_GL_Posting_Type__c = 'Manual'; 
                                recordsProcessed = recordsProcessed + 1;
                                }
                       } else {
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                                recordsProcessed = recordsProcessed + 1;
                       }
                        
                    }
                    //Scenario 15 - Checks for false pledge payment
                   else if(trans.AQB__PledgePayment__c == false){
                        if(paymentMethod.contains(trans.AQB__Method__c) ){
                            if(trans.MDA_Credit_AccountLookup__c == null || trans.MDA_Debit_Account__c == null || trans.MDA_GL_Posting_Type__c != 'Automated'){
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                            }else{
                                    trans.AQB__DebitAccount__c = coa3[0].Id;
                                    trans.MDA_Debit_Account__c = coa3[0].Id;
                                    trans.MDA_Debit_Account_Number__c = coa3[0].AQB__DesignationAccountNumber__c;
                                    trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                                    trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;         
                                    trans.MDA_GL_Posting_Type__c = 'Automated';
                                    recordsProcessed = recordsProcessed + 1;
                            }
                            
                         //Scenario 16 - Checks for false pledge payment and payment method of Credit Card
                       } else if(trans.AQB__Method__c == 'Credit Card'){
                            if(trans.MDA_Credit_AccountLookup__c == null || trans.MDA_Debit_Account__c == null || trans.MDA_GL_Posting_Type__c != 'Automated'){
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                            }else{
                                trans.AQB__DebitAccount__c = coa2[0].Id;
                                trans.MDA_Debit_Account__c = coa2[0].Id;
                                trans.MDA_Debit_Account_Number__c = coa2[0].AQB__DesignationAccountNumber__c;
                                trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                                trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;   
                                trans.MDA_GL_Posting_Type__c = 'Automated';
                                recordsProcessed = recordsProcessed + 1;
                                }
                           
                       }else {
                            trans.MDA_Credit_Debit_Account_Error__c = true;
                            recordsProcessed = recordsProcessed + 1;
                       }
                        
                    }
                   
                    
                }
               //--Check for matching Gift
               else if(trans.AQB__Type__c == 'Pledge' && trans.AQB__PledgePayment__c == false && trans.AQB__Gift__r.AQB__MatchLink__r.Id =! null){
                    trans.AQB__Do_not_push_to_Accounting__c = true;
                    recordsProcessed = recordsProcessed + 1;   
                }
                //--Scenario 20 - Checks transaction type of anything besides what is included above
                else{
                    system.debug('Enters Scenario 20');
                    trans.MDA_Credit_Debit_Account_Error__c = true;
                    recordsProcessed = recordsProcessed + 1; 
                 
                }

            }
            // Checks Source of Data of Pledge Form / Documentation
            else if(trans.AQB__Batch__r.AQB__SourceofData__c == 'Pledge Form / Documentation'){
                //--Scenario 21 
                if(trans.AQB__PledgeStipulation__c == 'Unconditional'){
                      trans.AQB__Do_not_push_to_Accounting__c = true;
                      recordsProcessed = recordsProcessed + 1;
                    
                } 
                //--Scenario 22
                else if(trans.AQB__PledgeStipulation__c == 'Conditional'){
                     trans.MDA_GL_Posting_Type__c = 'Manual';
                     recordsProcessed = recordsProcessed + 1;
                    
                }
                 
             }
            //--Scenario 23 - Checks Other Source of Data
            else if(otherDataSource.contains(trans.AQB__Batch__r.AQB__SourceofData__c)){
                trans.AQB__Do_not_push_to_Accounting__c = true;
                 
             }

        }
         
            		
  //Checks for Voided Transaction                 
     }else{
         if(trans.AQB__Type__c == 'Grant Payment'){
          Id transId = trans.Id;
          Id batchItem = trans.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c;
          Id gift = trans.AQB__Gift__c;
          AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
             //Scenario 24 -- Transaction Type of Grant Payment with Corrected Transaction found 
             if(correctTrans.size() > 0){
                 for(AQB__Transaction__c trans2: correctTrans){
                     trans.AQB__Do_not_push_to_Accounting__c = true;
                     trans2.MDA_Credit_Account_Number__c = trans2.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                     trans2.MDA_Credit_AccountLookup__c = trans2.AQB__ChartofAccounts__c;
                     trans2.MDA_Debit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                     trans2.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                     trans2.MDA_GL_Posting_Type__c = 'Automated';
                     recordsProcessed = recordsProcessed + 1;
					 correctTransactions.add(trans2);

                 }
               //Scenario 25 -- No Corrected Transaction found for Grant Payment  
             }else{
                 trans.MDA_Credit_AccountLookup__c = trans.AQB__DebitAccount__c;
                 trans.MDA_Credit_Account_Number__c = trans.AQB__DebitAccount__r.AQB__DesignationAccountNumber__c;
                 trans.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                 trans.MDA_Debit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                 trans.MDA_GL_Posting_Type__c = 'Automated';
                 recordsProcessed = recordsProcessed + 1;
    
             }
             
             
         } else if(trans.AQB__Type__c == 'Payment'){
             //Scenario 26 - Transaction Type of Payment with adjusted pledge payment and conditional pledge stipulation
             // and corrected transaction found
             if(trans.AQB__PledgePayment__c == true && trans.AQB__PledgeStipulation__c == 'Conditional'){
                Id transId = trans.Id;
          		Id batchItem = trans.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c;
          		Id gift = trans.AQB__Gift__c;
          		AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
             		if(correctTrans.size() > 0){
                 		for(AQB__Transaction__c trans2: correctTrans){
              			trans.AQB__Do_not_push_to_Accounting__c = true;
                     	trans2.MDA_Credit_Account_Number__c = trans2.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                     	trans2.MDA_Credit_AccountLookup__c = trans2.AQB__ChartofAccounts__c;
                     	trans2.MDA_Debit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                     	trans2.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                        trans2.MDA_GL_Posting_Type__c = 'Automated';
                     	recordsProcessed = recordsProcessed + 1;
					 	correctTransactions.add(trans2);					                     
                 	}
                 
             	}else{
                //Scenario 27 - Transaction Type of Payment with adjusted pledge payment and conditional pledge stipulation
                // and no corrected transaction found
      			 trans.MDA_Credit_AccountLookup__c = trans.AQB__DebitAccount__c;
                 trans.MDA_Credit_Account_Number__c = trans.AQB__DebitAccount__r.AQB__DesignationAccountNumber__c;
                 trans.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                 trans.MDA_Debit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                 trans.MDA_GL_Posting_Type__c = 'Automated';
                 recordsProcessed = recordsProcessed + 1;
             	}
                 
             }else if(trans.AQB__PledgePayment__c == false){
                //Scenario 28 - Transaction Type of Payment with NO adjusted pledge payment 
                //AND corrected transaction found
          		Id transId = trans.Id;
          		Id batchItem = trans.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c;
          		Id gift = trans.AQB__Gift__c;
          		AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
             		if(trans.AQB__PledgePayment__c == false && correctTrans.size() > 0){
                 		for(AQB__Transaction__c trans2: correctTrans){
         				trans.AQB__Do_not_push_to_Accounting__c = true;
                     	trans2.MDA_Credit_Account_Number__c = trans2.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                     	trans2.MDA_Credit_AccountLookup__c = trans2.AQB__ChartofAccounts__c;
                     	trans2.MDA_Debit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                     	trans2.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                        trans2.MDA_GL_Posting_Type__c = 'Automated';
                     	recordsProcessed = recordsProcessed + 1;
					 	correctTransactions.add(trans2);								                     
                 	}
                 
             	}else{
                //Scenario 29 - Transaction Type of Payment with NO adjusted pledge payment 
                //AND NO corrected transaction found
                 trans.MDA_Credit_AccountLookup__c = trans.AQB__DebitAccount__c;
                 trans.MDA_Credit_Account_Number__c = trans.AQB__DebitAccount__r.AQB__DesignationAccountNumber__c;
                 trans.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                 trans.MDA_Debit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                 trans.MDA_GL_Posting_Type__c = 'Automated';
                 recordsProcessed = recordsProcessed + 1;	
             	}
                 
             }
             
            //Scenario 30 - Transaction Type of Payment with True pledge payment and stipulation that is anything but conditional
            else if(trans.AQB__PledgePayment__c == true && trans.AQB__PledgeStipulation__c != 'Conditional'){
                	trans.MDA_GL_Posting_Type__c = 'Manual';     
            }
         
        //Scenario 31 - Checks Transaction Type of either Grant, Soft Credit and Pledge Soft Credit
         } else if(transType.contains(trans.AQB__Type__c) == true){
            trans.AQB__Do_not_push_to_Accounting__c = true;
         }
         
         //Scenario 32- Checks the Trandaction type of PLEDGE for voided transactions 
         else if(trans.AQB__Type__c == 'Pledge' && trans.AQB__PledgeStipulation__c == 'Unconditional'){
             trans.MDA_GL_Posting_Type__c = 'Manual';    
             
         }//Scenario 33- Checks the Trandaction type of anything but what is above
         else {
            trans.MDA_Credit_Debit_Account_Error__c = true;  
            
        }
      
      }
    }

//Check the batch is not closed if it is a closed batch set to MDA_Credit_Debit_Account_Error__c to true
        else{
            trans.MDA_Credit_Debit_Account_Error__c = true;  
        }
    }
}
        
  Database.SaveResult[] results = Database.update(transList, false);
  Database.SaveResult[] results2 = Database.update(correctTransactions, false);
  

         
    }   
     
    global void finish(Database.BatchableContext BC) {
    System.debug(recordsProcessed + ' records processed');
      
    }

}