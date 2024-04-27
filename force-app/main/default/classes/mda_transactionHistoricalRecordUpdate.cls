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
 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Set<String> testValues = new Set<String>{'1','2','3','4','5','6','7','8','9',
            									'10','11','12','correctTrans','13',
            									'14','15','16','17','18','19'};
        String query = 'Select Id, AQB__Batch__r.AQB__RecordTypeDeveloperName__c, AQB__FinancialSystemDate__c, MDA_GL_Posting_Type__c,  AQB__DebitAccount__r.AQB__DesignationAccountNumber__c,	MDA_Credit_AccountLookup__c, AQB__DebitAccount__c, AQB__ChartofAccounts__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__r.Id, MDA_Debit_Account__c, AQB__Gift__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c,MDA_Credit_Debit_Account_Error__c, MDA_Credit_Account_Number__c, MDA_Debit_Account_Number__c, AQB__PaymentNumber__c,  AQB__Type__c, AQB__Method__c, AQB__Batch__r.AQB__SourceofData__c,AQB__SourceofData__c, AQB__VoidedTransaction__c, AQB__PledgeStipulation__c, AQB__PledgePayment__c from AQB__Transaction__c WHERE CreatedDate >= 2023-10-17T19:00:00Z';
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
        Set<String> paymentMethod = new Set<String>{'Check','Securities','ACH','Wire','ACH/Wire, Paypal, Transfer'};
        Set<String> paymentMethod2 = new Set<String>{'Cash', 'Check','Securities','ACH','Wire','ACH/Wire'};
        Set<String> transactionType = new Set<String>{'Grant Payment', 'Payment', 'Soft Credit'};
        Set<String> otherDataSource = new Set<String>{'Pledge Form / Documentation','Grants Management System','Gift in Kind Form / Documentation','Adjustments'};
        Set<String> transType = new Set<String>{ 'Grant', 'Soft Credit', 'Pledge Soft Credit'};
        Set<String> transType2 = new Set<String>{ 'Soft Credit', 'Pledge Soft Credit'};
            
        List<AQB__Transaction__c> processedRecords = new List<AQB__Transaction__c>();
        List<AQB__Transaction__c> correctTransactions = new List<AQB__Transaction__c>();
        
        for(AQB__Transaction__c trans: transList) {
         //Check Posted Transaction and Batch Status
         if(trans.AQB__FinancialSystemDate__c == NULL && trans.AQB__Batch__r.AQB__RecordTypeDeveloperName__c != 'ClosedBatch'){
         //Check Voided Transaction
         if(trans.AQB__VoidedTransaction__c == NULL){
            //Check Source of Data - Annual Fund 
            //Scenario 1- Annual Fund Source of Data with PAYMENT
            if(trans.AQB__SourceofData__c == 'Annual Fund Lockbox'){  
                    if(trans.AQB__Type__c == 'Payment'){ 
                       trans.AQB__DebitAccount__c = coa[0].Id;
                       trans.MDA_Debit_Account__c = coa[0].Id;
                       trans.MDA_Debit_Account_Number__c = coa[0].AQB__DesignationAccountNumber__c;
                       trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                       trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                       trans.MDA_GL_Posting_Type__c = 'Automated';
                       recordsProcessed = recordsProcessed + 1;
                   
                    }
                /**Scenario 2
            		 else if(trans.AQB__Type__c != 'Payment' && trans.AQB__Type__c != 'Soft Credit'){
                        trans.MDA_Credit_Debit_Account_Error__c = true;
                        recordsProcessed = recordsProcessed + 1;
                        
                     } **/
                //Scenario 2.5 - Source of Data Annual Fund with Transaction Type of 'Soft Credit' and 'Pledge Soft Credit'
                	 else if(transType2.contains(trans.AQB__Type__c)){
                         trans.AQB__Do_not_push_to_Accounting__c = true;
                         recordsProcessed = recordsProcessed + 1;
                     }
                //Scenario 2.6
                	 else{
                     	trans.MDA_Credit_Debit_Account_Error__c = true;
                	}
                   
        	}
            
             else if(dataSource.contains(trans.AQB__Batch__r.AQB__SourceofData__c) == true){
                //Check Payment Type - Grant Payment
                if(trans.AQB__Type__c == 'Grant Payment'){
                    //Scenario 3
                    if(paymentMethod.contains(trans.AQB__Method__c)){
                   	   trans.AQB__DebitAccount__c = coa3[0].Id;
                       trans.MDA_Debit_Account__c = coa3[0].Id;
                       trans.MDA_Debit_Account_Number__c = coa3[0].AQB__DesignationAccountNumber__c;
                       trans.MDA_Credit_AccountLookup__c  = trans.AQB__ChartofAccounts__c;
                       trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c; 
                       trans.MDA_GL_Posting_Type__c = 'Automated';
                       recordsProcessed = recordsProcessed + 1;
                       
                    } 
                 
                    //Scenario 4
                   
                	else if (paymentMethod.contains(trans.AQB__Method__c) == false && trans.AQB__Method__c !='Soft Credit' ){
                         trans.MDA_Credit_Debit_Account_Error__c = true;
                         recordsProcessed = recordsProcessed + 1;     
                   		}
                    //Scenario 4.5
                    
                    else if(trans.AQB__Method__c == 'Soft Credit'){
                        trans.AQB__Do_not_push_to_Accounting__c = true;
                        recordsProcessed = recordsProcessed + 1;
                    	}
                     
                	}
            	//Check Payment Type - Payment 
            	  
                else if(trans.AQB__Type__c == 'Payment'){
                    //Scenario 5 
                    
                   if(trans.AQB__PledgePayment__c == true && trans.AQB__PledgeStipulation__c == 'Conditional' ){
                        if(paymentMethod2.contains(trans.AQB__Method__c) == true ){
                            trans.AQB__DebitAccount__c = coa3[0].Id;
                       		trans.MDA_Debit_Account__c = coa3[0].Id;
                       		trans.MDA_Debit_Account_Number__c = coa3[0].AQB__DesignationAccountNumber__c;
                       		trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                       		trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;            
                         	trans.MDA_GL_Posting_Type__c = 'Automated';
                            recordsProcessed = recordsProcessed + 1;
                       //Scenario 6    
                       } else if (trans.AQB__Method__c == 'Credit Card'){
                            trans.AQB__DebitAccount__c = coa2[0].Id;
                       		trans.MDA_Debit_Account__c = coa2[0].Id;
                       		trans.MDA_Debit_Account_Number__c = coa2[0].AQB__DesignationAccountNumber__c;
                       		trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                       		trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;    
                            trans.MDA_GL_Posting_Type__c = 'Automated'; 
                           recordsProcessed = recordsProcessed + 1;
                       //Scenario 7     
                       } else if(trans.AQB__Method__c != 'Credit Card' && paymentMethod2.contains(trans.AQB__Method__c) == false && trans.AQB__Method__c != 'Soft Credit') {
                           trans.MDA_Credit_Debit_Account_Error__c = true;
						   recordsProcessed = recordsProcessed + 1;
                          

                       }
                       //Scenario 7.5
                       else if (trans.AQB__Method__c == 'Soft Credit'){
                           trans.AQB__Do_not_push_to_Accounting__c = true;
                           
                       }
                        
                    }
                    //Scenarion 7.6
                    if(trans.AQB__PledgePayment__c == true && trans.AQB__PledgeStipulation__c == 'Unconditional' ){
                        if(paymentMethod2.contains(trans.AQB__Method__c) == true ){
                            trans.AQB__DebitAccount__c = coa3[0].Id;
                       		trans.MDA_Debit_Account__c = coa3[0].Id;
                       		trans.MDA_Debit_Account_Number__c = coa3[0].AQB__DesignationAccountNumber__c;
                       		trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                       		trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;            
                         	trans.MDA_GL_Posting_Type__c = 'Manual';
                            recordsProcessed = recordsProcessed + 1;
                       //Scenario 7.7    
                       } else if (trans.AQB__Method__c == 'Credit Card'){
                            trans.AQB__DebitAccount__c = coa2[0].Id;
                       		trans.MDA_Debit_Account__c = coa2[0].Id;
                       		trans.MDA_Debit_Account_Number__c = coa2[0].AQB__DesignationAccountNumber__c;
                       		trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                       		trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;    
                            trans.MDA_GL_Posting_Type__c = 'Manual'; 
                           recordsProcessed = recordsProcessed + 1;
                       //Scenario 7.8     
                       } else if(trans.AQB__Method__c != 'Credit Card' && paymentMethod2.contains(trans.AQB__Method__c) == false && trans.AQB__Method__c != 'Soft Credit') {
                           trans.MDA_Credit_Debit_Account_Error__c = true;
						   recordsProcessed = recordsProcessed + 1;
                       }
                       //Scenario 7.9
                       else if (trans.AQB__Method__c == 'Soft Credit'){
                           trans.AQB__Do_not_push_to_Accounting__c = true;
                           recordsProcessed = recordsProcessed + 1;
                           
                       }
                        
                    }
                    //Scenario 8 
                   else if(trans.AQB__PledgePayment__c == false){
                        if(paymentMethod2.contains(trans.AQB__Method__c) ){
                            trans.AQB__DebitAccount__c = coa3[0].Id;
                       		trans.MDA_Debit_Account__c = coa3[0].Id;
                       		trans.MDA_Debit_Account_Number__c = coa3[0].AQB__DesignationAccountNumber__c;
                       		trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                       		trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;         
                            trans.MDA_GL_Posting_Type__c = 'Automated';
                            recordsProcessed = recordsProcessed + 1;
                            
                         //Scenario 9  
                       } else if(trans.AQB__Method__c == 'Credit Card'){
                           trans.AQB__DebitAccount__c = coa2[0].Id;
                       	   trans.MDA_Debit_Account__c = coa2[0].Id;
                       	   trans.MDA_Debit_Account_Number__c = coa2[0].AQB__DesignationAccountNumber__c;
                       	   trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                       	   trans.MDA_Credit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;   
                           trans.MDA_GL_Posting_Type__c = 'Automated';
                           recordsProcessed = recordsProcessed + 1;
                           
                              
                          //Scenario 10 
                       } else if(trans.AQB__Method__c != 'Credit Card' && paymentMethod2.contains(trans.AQB__Method__c) == false && trans.AQB__Method__c != 'Soft Credit') {
                          trans.MDA_Credit_Debit_Account_Error__c = true;
                          recordsProcessed = recordsProcessed + 1;
                              
                           //Scenario 10.5  
                       } else if(trans.AQB__Method__c == 'Soft Credit'){
                           trans.AQB__Do_not_push_to_Accounting__c = true;
                           
                       }
                        
                    }
                   
                    
                }
                
                //-- Scenario 11 Check Transaction Type - Any Other Value 
                else if(transactionType.contains(trans.AQB__Type__c) == false){
                    trans.MDA_Credit_Debit_Account_Error__c = true;
                    recordsProcessed = recordsProcessed + 1; 
				                    
                } 
               //--Scenario 11.5 - Checks Transaction Type of Soft Credit, Pledge, Grant, Pledge Soft Credit
               else if(transType.contains(trans.AQB__Type__c)){
                    trans.AQB__Do_not_push_to_Accounting__c = true;
                    recordsProcessed = recordsProcessed + 1;   
                }

            }
            // Checks Source of Data of Planned Giving Form / Documentation
            else if(trans.AQB__Batch__r.AQB__SourceofData__c == 'Planned Giving Form / Documentation'){
                //--Scenario 11.6 
                if(trans.AQB__PledgeStipulation__c == 'Unconditional'){
                      trans.AQB__Do_not_push_to_Accounting__c = true;
                      recordsProcessed = recordsProcessed + 1;
                    
                } 
                //--Scenario 11.7
                else if(trans.AQB__PledgeStipulation__c == 'Conditional'){
                     trans.MDA_GL_Posting_Type__c = 'Manual';
                     recordsProcessed = recordsProcessed + 1;
                    
                }
                 
             }
            //--Scenario 11.7 - Checks Other Source of Data
            else if(otherDataSource.contains(trans.AQB__Batch__r.AQB__SourceofData__c)){
                trans.AQB__Do_not_push_to_Accounting__c = true;
                 
             }
         
            		
  //End of Scenario 0- Checks for Voided Transaction                 
     }else{
         if(trans.AQB__Type__c == 'Grant Payment'){
          Id transId = trans.Id;
          Id batchItem = trans.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c;
          Id gift = trans.AQB__Gift__c;
          AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE AQB__Gift__c = :gift AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :batchItem AND Id != :transId];  
             //Scenario 12 -- Corrected Transaction found for Grant Payment -Update
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
               //Scenario 13 -- No Corrected Transaction found for Grant Payment  
             }else{
                 trans.MDA_Credit_AccountLookup__c = trans.AQB__DebitAccount__c;
                 trans.MDA_Credit_Account_Number__c = trans.AQB__DebitAccount__r.AQB__DesignationAccountNumber__c;
                 trans.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                 trans.MDA_Debit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                 trans.MDA_GL_Posting_Type__c = 'Automated';
                 recordsProcessed = recordsProcessed + 1;
    
             }
             
             
         } else if(trans.AQB__Type__c == 'Payment'){
             //Scenario 14 
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
                    //Scenario15
      			 trans.MDA_Credit_AccountLookup__c = trans.AQB__DebitAccount__c;
                 trans.MDA_Credit_Account_Number__c = trans.AQB__DebitAccount__r.AQB__DesignationAccountNumber__c;
                 trans.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                 trans.MDA_Debit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                 trans.MDA_GL_Posting_Type__c = 'Automated';
                 recordsProcessed = recordsProcessed + 1;
             	}
                 
             }else if(trans.AQB__PledgePayment__c == false){
                 //Scenario 16 
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
                  //Scenario 17 
                 trans.MDA_Credit_AccountLookup__c = trans.AQB__DebitAccount__c;
                 trans.MDA_Credit_Account_Number__c = trans.AQB__DebitAccount__r.AQB__DesignationAccountNumber__c;
                 trans.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                 trans.MDA_Debit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                 trans.MDA_GL_Posting_Type__c = 'Automated';
                 recordsProcessed = recordsProcessed + 1;	
             	}
                 
             }
             
            //Scenario 17.5 - Transaction Type of Payment with FALSE pledge payment and Unconditional stipulation 
            else if(trans.AQB__PledgePayment__c == false && trans.AQB__PledgeStipulation__c == 'Unconditional'){
                	trans.MDA_GL_Posting_Type__c = 'Manual';     
            }
             //Scenario 18 
         } else if(transType.contains(trans.AQB__Type__c) == false){
              trans.MDA_Credit_Debit_Account_Error__c = true;
         }
         
         //Scenario 19- Checks the Trandaction type of PLEDGE for voided transactions 
         else if(trans.AQB__Type__c == 'Pledge' && trans.AQB__PledgeStipulation__c == 'Unconditional'){
             trans.MDA_GL_Posting_Type__c = 'Manual'; 
             
             
         }
      
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