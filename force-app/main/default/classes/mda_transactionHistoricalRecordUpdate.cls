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
        String query = 'Select Id, AQB__VoidedTransaction__r.Id, MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Batch_Item_ID2__c, AQB__Batch__r.AQB__RecordTypeDeveloperName__c, AQB__Instrument__c, AQB__Gift__r.AQB__Instrument__c,  AQB__Gift__r.AQB__MatchLink__r.Id, AQB__ThirdPartyPayoff__c, AQB__FinancialSystemDate__c, MDA_GL_Posting_Type__c,  AQB__DebitAccount__r.AQB__DesignationAccountNumber__c,	MDA_Credit_AccountLookup__c, AQB__DebitAccount__c, AQB__ChartofAccounts__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__r.Id, MDA_Debit_Account__c, AQB__Gift__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c,MDA_Credit_Debit_Account_Error__c, MDA_Credit_Account_Number__c, MDA_Debit_Account_Number__c, AQB__PaymentNumber__c,  AQB__Type__c, AQB__Method__c, AQB__Batch__r.AQB__SourceofData__c,AQB__SourceofData__c, AQB__VoidedTransaction__c, AQB__PledgeStipulation__c, AQB__PledgePayment__c from AQB__Transaction__c WHERE CreatedDate >= 2023-10-17T19:00:00Z';
        if (Test.isRunningTest()){
        	//query += ' LIMIT 100';
            query += 'AND AQB__Reference__c IN :testValues LIMIT 100';
    		}
        
        return Database.getQueryLocator(query); 
    }
     
    global void execute(Database.BatchableContext BC, List<	AQB__Transaction__c> transList) {
      AQB__LLChartofAccounts__c[] coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324'];
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
        Set<String> propertyType = new Set<String>{ 'Real Property', 'Personal Property'};
        Set<String> sourceDataValidation = new Set<String>{'Institutional Lockbox', 'Live Check / Credit Card (MD Anderson Front Office)', 'MDA Treasury'};
            
        List<AQB__Transaction__c> processedRecords = new List<AQB__Transaction__c>();
        List<AQB__Transaction__c> correctTransactions = new List<AQB__Transaction__c>();
        
        for(AQB__Transaction__c trans: transList) {
        trans.MDA_Credit_Debit_Account_Error__c = false;
        //Check Posted Transaction and Batch Status
         if(trans.AQB__FinancialSystemDate__c == NULL ){
        //Check the batch is not closed if it is a closed batch set to MDA_Credit_Debit_Account_Error__c to null
         if(trans.AQB__Batch__r.AQB__RecordTypeDeveloperName__c == 'ClosedBatch'){
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
            recordsProcessed = recordsProcessed + 1;

        }else{  
            //Check for Pledge Offset - No
            //Check Source of Data - Annual Fund 
            //Scenario 1- Annual Fund Source of Data with PAYMENT
            if(trans.AQB__SourceofData__c == 'Annual Fund Lockbox'){ 
                
                    if(trans.AQB__Type__c == 'Payment'){ 
                        if(trans.MDA_Credit_AccountLookup__c == null || trans.MDA_Debit_Account__c == null || trans.MDA_GL_Posting_Type__c != 'Automated'){
                            trans.MDA_Credit_Debit_Account_Error__c = true;
                            recordsProcessed = recordsProcessed + 1;
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
            //Checks GL Data Sources
             else if(dataSource.contains(trans.AQB__Batch__r.AQB__SourceofData__c) == true){
                //Check Payment Type - Grant Payment
                if(trans.AQB__Type__c == 'Grant Payment'){
                    //Check Source of Data Validation
                    if(sourceDataValidation.contains(trans.AQB__Batch__r.AQB__SourceofData__c)){
                       if(trans.MDA_Credit_AccountLookup__c == null || trans.MDA_Debit_Account__c == null || trans.MDA_GL_Posting_Type__c != 'Automated'){
                            trans.MDA_Credit_Debit_Account_Error__c = true;
                            recordsProcessed = recordsProcessed + 1;
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
                            recordsProcessed = recordsProcessed + 1;
                    }
                     
                }
            	
                //Check Payment Type - Payment 
            	  
                else if(trans.AQB__Type__c == 'Payment'){
                    //Scenario 7 - Checks if linked to a pledge payment and pledge stipulation is conditional
                    
                   if(trans.AQB__PledgePayment__c == true && trans.AQB__PledgeStipulation__c == 'Conditional' ){
                        if(paymentMethod4.contains(trans.AQB__Method__c) == true ){
                            if(trans.MDA_Credit_AccountLookup__c == null || trans.MDA_Debit_Account__c == null || trans.MDA_GL_Posting_Type__c != 'Automated'){
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                                recordsProcessed = recordsProcessed + 1;

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
                                recordsProcessed = recordsProcessed + 1; 
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
                                recordsProcessed = recordsProcessed + 1; 
                       }           
                        
                    }
                    //Scenarion 11- Checks for Pledge Payment and Unconditional pledge stipulation
                    if(trans.AQB__PledgePayment__c == true && trans.AQB__PledgeStipulation__c != 'Conditional' ){
                        if(paymentMethod4.contains(trans.AQB__Method__c) == true ){
                            if(trans.MDA_Credit_AccountLookup__c == null || trans.MDA_Debit_Account__c == null || trans.MDA_GL_Posting_Type__c != 'Manual'){
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                                recordsProcessed = recordsProcessed + 1; 
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
                                recordsProcessed = recordsProcessed + 1;
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
                                recordsProcessed = recordsProcessed + 1;
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
               else if(trans.AQB__Type__c == 'Pledge' && trans.AQB__PledgePayment__c == false && trans.AQB__Gift__r.AQB__MatchLink__r.Id != null){
                    trans.AQB__Do_not_push_to_Accounting__c = true;
                    recordsProcessed = recordsProcessed + 1;   
                }
                //--
                else if(!transType2.contains(trans.AQB__Type__c))
                {
                    trans.MDA_Credit_Debit_Account_Error__c = true;
                    recordsProcessed = recordsProcessed + 1;               
                }
            }
            //Checks Non GL Data Sources
            else if(otherDataSource.contains(trans.AQB__Batch__r.AQB__SourceofData__c)){
                //Check Gift in Kind
                        if(trans.AQB__Type__c == 'Payment' && (trans.AQB__Method__c == 'Personal Property' || trans.AQB__Method__c == 'Real Property')){
                            //Check Data Validity
                            if(trans.AQB__Batch__r.AQB__SourceofData__c == 'Gift in Kind Form / Documentation'){
                                //CONFIRM LOGIC
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                                recordsProcessed = recordsProcessed + 1;
                                //CONFIRM LOGIC
                            }else{
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                                recordsProcessed = recordsProcessed + 1; 
                            }         
                        }
                //Check Type of Grant / Grant Payment
                        if(trans.AQB__Type__c == 'Grant' || trans.AQB__Type__c == 'Grant Payment'){
                            //Check Data Validity
                            if(trans.AQB__Batch__r.AQB__SourceofData__c == 'Grants Management System'){
                                 //CONFIRM LOGIC
                                 trans.MDA_Credit_Debit_Account_Error__c = true;
                                 recordsProcessed = recordsProcessed + 1;
                                 //CONFIRM LOGIC
                            } else {
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                                recordsProcessed = recordsProcessed + 1; 
                            }

                        }
                //Check Type of Planned Gift
                        if(trans.AQB__Type__c == 'Pledge' && trans.AQB__PledgeStipulation__c == 'Conditional' && trans.AQB__Gift__r.AQB__Instrument__c != null){
                            //Check Data Validation
                            if(trans.AQB__Batch__r.AQB__SourceofData__c == 'Planned Giving Form / Documentation'){
                                //CONFIRM LOGIC
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                                recordsProcessed = recordsProcessed + 1;
                                //CONFIRM LOGIC

                            }else{
                                trans.MDA_Credit_Debit_Account_Error__c = true;
                                recordsProcessed = recordsProcessed + 1; 
                            }
                        }
             }
        
            // Checks Source of Data of Pledge Form / Documentation
            else if(trans.AQB__Batch__r.AQB__SourceofData__c == 'Pledge Form / Documentation'){
                if(trans.AQB__Type__c != 'Pledge Soft Credit' || trans.AQB__Type__c != 'Pledge' ){
                    trans.MDA_Credit_Debit_Account_Error__c = true;
                    recordsProcessed = recordsProcessed + 1; 

                }
                else if(trans.AQB__Type__c == 'Pledge' && trans.AQB__Instrument__c == null){
                       //--Scenario 21 
                        if(trans.AQB__PledgeStipulation__c == 'Unconditional'){
                            trans.MDA_GL_Posting_Type__c = 'Manual';
                            recordsProcessed = recordsProcessed + 1;               
                        } 
                        //--Scenario 22
                        else if(trans.AQB__PledgeStipulation__c == 'Conditional' || trans.AQB__PledgeStipulation__c == 'Statement of Intent' ){
                            trans.AQB__Do_not_push_to_Accounting__c = true;
                            recordsProcessed = recordsProcessed + 1;
                            
                        } else {
                            trans.MDA_Credit_Debit_Account_Error__c = true;
                            recordsProcessed = recordsProcessed + 1;
                        }
                    }
                 
             }
            //Checks for Adjustment
            else if(trans.AQB__Batch__r.AQB__SourceofData__c == 'Adjustments'){
                //Check Gift in Kind
                //Check Grant/Grant Payment
                //Check Conditinal Pledge
                if((trans.AQB__Type__c == 'Payment' && propertyType.contains(trans.AQB__Method__c)) ||
                   (trans.AQB__Type__c == 'Payment' || trans.AQB__Type__c == 'Grant Payment') ||
                   (trans.AQB__Type__c == 'Pledge' && trans.AQB__PledgeStipulation__c == 'Conditional' && trans.AQB__PledgePayment__c == false))
                {
                    trans.AQB__Do_not_push_to_Accounting__c = false;
                    trans.AQB__FinancialSystemDate__c = null;
                    trans.MDA_Credit_AccountLookup__c = null;
                    trans.MDA_Debit_Account__c = null;
                    trans.MDA_GL_Posting_Type__c = null;
                    trans.MDA_Journal_ID__c = null;
                    trans.MDA_Original_Transaction__c = null;
                    trans.MDA_Related_Void_Transaction__c = null;
                    recordsProcessed = recordsProcessed + 1;
                } else if (trans.AQB__Type__c != 'Soft Credit' || trans.AQB__Type__c != 'Pledge Soft Credit'){
                    //GET RECORDS
                    //GL Adjustments
                    //Adjustments with NO Voided Transaction
                    Id transId = trans.Id;
                    Id batchItem = trans.MDA_Batch_Item_ID2__c;
                    Id gift = trans.AQB__Gift__c;
                    String type = trans.AQB__Type__c;                    
                    AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c WHERE 
                    AQB__Gift__c = :gift 
                    AND MDA_Batch_Item_ID2__c = :batchItem 
                    AND Id != :transId
                    AND AQB__VoidedTransaction__c != null 
                    AND AQB__Type__c = :type];
                    if(correctTrans.size() == 0){
                        for(AQB__Transaction__c trans2: correctTrans){
                            trans.MDA_Credit_Debit_Account_Error__c = true;
                            recordsProcessed = recordsProcessed + 1;
                           
       
                        }
                      
                    }
                    

                }

            } else {
                trans.MDA_Credit_Debit_Account_Error__c = true;
                recordsProcessed = recordsProcessed + 1;
            }

        }
         
            		
  //Checks for Voided Transaction                 
     }else{
        //Check for Grant and Grant Payment
         if(trans.AQB__Type__c == 'Grant Payment' || trans.AQB__Type__c == 'Grant' ){
            trans.AQB__Do_not_push_to_Accounting__c = true;     
         } else if(trans.AQB__Type__c == 'Payment' && propertyType.contains(trans.AQB__Method__c) ){
             //Scenario 26 - Transaction Type of Payment with adjusted pledge payment and conditional pledge stipulation
             // and corrected transaction found
             if(trans.AQB__PledgePayment__c == true && trans.AQB__PledgeStipulation__c == 'Conditional'){
                  //GET RECORDS
                  Id transId = trans.Id;
                  Id batchItem = trans.MDA_Batch_Item_ID2__c;
                  Id gift = trans.AQB__Gift__c;
                  String type = trans.AQB__Type__c;
                  Decimal paymentNumber = trans.AQB__PaymentNumber__c; 
                  Boolean pledgePayment = trans.AQB__PledgePayment__c;                   
                  AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c 
                  WHERE AQB__Gift__c = :gift 
                  AND MDA_Batch_Item_ID2__c = :batchItem 
                  AND Id != :transId
                  AND AQB__Type__c = :type 
                  AND AQB__PaymentNumber__c > :paymentNumber 
                  AND AQB__PledgePayment__c = :pledgePayment]; 
                            
                  if(correctTrans.size() > 0){
                                for(AQB__Transaction__c trans2: correctTrans){
                                trans.AQB__Do_not_push_to_Accounting__c = true;
                                trans2.MDA_Credit_Account_Number__c = trans2.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                                trans2.MDA_Credit_AccountLookup__c = trans2.AQB__ChartofAccounts__c;
                                trans2.MDA_Debit_Account_Number__c = trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c;
                                trans2.MDA_Debit_Account__c = trans.AQB__ChartofAccounts__c;
                                trans2.MDA_GL_Posting_Type__c = 'Automated';
                                trans2.MDA_Original_Transaction__c = trans.AQB__VoidedTransaction__r.Id;
                                trans2.MDA_Related_Void_Transaction__c = trans.Id;
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
                 
             } else if(trans.AQB__PledgePayment__c == true && trans.AQB__PledgeStipulation__c != 'Conditional'){
                           //GET RECORDS
                            Id transId = trans.Id;
                            Id batchItem = trans.MDA_Batch_Item_ID2__c;
                            Id gift = trans.AQB__Gift__c;
                            String type = trans.AQB__Type__c;
                            Decimal paymentNumber = trans.AQB__PaymentNumber__c; 
                            Boolean pledgePayment = trans.AQB__PledgePayment__c;                   
                            AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c 
                            WHERE AQB__Gift__c = :gift AND MDA_Batch_Item_ID2__c = :batchItem AND Id != :transId
                            AND AQB__Type__c = :type AND AQB__PaymentNumber__c > :paymentNumber AND AQB__PledgePayment__c = :pledgePayment];  
                            if(correctTrans.size() > 0){
                                for(AQB__Transaction__c trans2: correctTrans){
                                    trans.AQB__Do_not_push_to_Accounting__c = true;
                                    trans2.MDA_GL_Posting_Type__c = 'Manual';
                                    trans2.MDA_Original_Transaction__c = trans.AQB__VoidedTransaction__r.Id;
                                    trans2.MDA_Related_Void_Transaction__c = transId;
                                    correctTransactions.add(trans2);
                                    recordsProcessed = recordsProcessed + 1;    
                                }
                            
                            }else{
                                trans.MDA_GL_Posting_Type__c = 'Manual';
                                recordsProcessed = recordsProcessed + 1; 
                            }  
                }
             
             else if(trans.AQB__PledgePayment__c == false){
                //Scenario 28 - Transaction Type of Payment with NO adjusted pledge payment 
                //AND corrected transaction found
                Id transId = trans.Id;
                Id batchItem = trans.MDA_Batch_Item_ID2__c;
                Id gift = trans.AQB__Gift__c;
                String type = trans.AQB__Type__c;
                Decimal paymentNumber = trans.AQB__PaymentNumber__c; 
                Boolean pledgePayment = trans.AQB__PledgePayment__c; 
          		AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c 
                WHERE AQB__Gift__c = :gift 
                AND MDA_Batch_Item_ID2__c = :batchItem 
                AND Id != :transId
                AND AQB__Type__c = :type];  
             		if(trans.AQB__PledgePayment__c == false && correctTrans.size() > 0){
                 		for(AQB__Transaction__c trans2: correctTrans){
         				trans.AQB__Do_not_push_to_Accounting__c = true;
                        trans2.MDA_Original_Transaction__c = trans.AQB__VoidedTransaction__r.Id;
                        trans2.MDA_Related_Void_Transaction__c = transId;
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
         } 
         
        //Scenario 31 - Checks Transaction Type of either Grant, Soft Credit and Pledge Soft Credit
         else if(transType.contains(trans.AQB__Type__c) == true){
            trans.AQB__Do_not_push_to_Accounting__c = true;
            recordsProcessed = recordsProcessed + 1; 
         }
         
         //Check Type of Plegde
         else if(trans.AQB__Type__c == 'Pledge' || trans.AQB__Type__c == 'Statement of Intent'){
             if (trans.AQB__PledgeStipulation__c == 'Conditional'){
                trans.AQB__Do_not_push_to_Accounting__c = true;
                recordsProcessed = recordsProcessed + 1;   
             } else if(trans.AQB__PledgeStipulation__c == 'Unconditional'){
                //GET RECORDS
                Id transId = trans.Id;
                Id batchItem = trans.MDA_Batch_Item_ID2__c;
                Id gift = trans.AQB__Gift__c;
                String type = trans.AQB__Type__c;
                Decimal paymentNumber = trans.AQB__PaymentNumber__c; 
                Boolean pledgePayment = trans.AQB__PledgePayment__c;                   
                AQB__Transaction__c[] correctTrans = [Select Id, AQB__ChartofAccounts__c, AQB__DebitAccount__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c from AQB__Transaction__c 
                WHERE AQB__Gift__c = :gift 
                AND MDA_Batch_Item_ID2__c = :batchItem 
                AND Id != :transId
                AND AQB__Type__c = :type 
                AND AQB__PaymentNumber__c > :paymentNumber 
                AND AQB__PledgePayment__c = :pledgePayment];  
                if(correctTrans.size() > 0){
                    for(AQB__Transaction__c trans2: correctTrans){
                        trans.AQB__Do_not_push_to_Accounting__c = true;
                        trans2.MDA_GL_Posting_Type__c = 'Manual';
                        trans2.MDA_Original_Transaction__c = trans.AQB__VoidedTransaction__r.Id;
                        trans2.MDA_Related_Void_Transaction__c = transId;
                        correctTransactions.add(trans2);
                        recordsProcessed = recordsProcessed + 1;    
                    } 
                }else{
                    trans.MDA_GL_Posting_Type__c = 'Manual';
                    recordsProcessed = recordsProcessed + 1; 
                } 

            }else{
             trans.MDA_Credit_Debit_Account_Error__c = true;
             recordsProcessed = recordsProcessed + 1; 
            }

             
         }
         //Check Property
         else if (trans.AQB__Type__c == 'Payment' && propertyType.contains(trans.AQB__Method__c)) {
            trans.AQB__Do_not_push_to_Accounting__c = true;
            recordsProcessed = recordsProcessed + 1;   
            
        }
        //After Checking It Is Not Soft Credit OR ANYTHING ABOVE
        else if (!transType2.contains(trans.AQB__Type__c )){
            trans.MDA_Credit_Debit_Account_Error__c = true;
            recordsProcessed = recordsProcessed + 1; 
        }
      
      }
    }

//Check the batch is not closed if it is not a closed batch set to MDA_Credit_Debit_Account_Error__c to true
   else{
            trans.MDA_Credit_Debit_Account_Error__c = true;
            recordsProcessed = recordsProcessed + 1;   
        }
    }

}

    // Set<AQB__Transaction__c> myset = new Set<AQB__Transaction__c>();
    // List<AQB__Transaction__c> result = new List<AQB__Transaction__c>();
    // myset.addAll(transList);
    // result.addAll(myset);

    // Set<AQB__Transaction__c> myset2 = new Set<AQB__Transaction__c>();
    // List<AQB__Transaction__c> result2 = new List<AQB__Transaction__c>();
    // myset2.addAll(correctTransactions);
    // result2.addAll(myset2);
  
  System.debug(transList.size() +'=====TRANSLIST BATCH SIZE====' + JSON.serializePretty(transList));
  Database.SaveResult[] results = Database.update(transList, false);
  System.debug(correctTransactions.size() +'===== CorrectTrans BATCH SIZE ====' + JSON.serializePretty(correctTransactions));
  Database.SaveResult[] results2 = Database.update(correctTransactions, false);
  

         
    }   
     
    global void finish(Database.BatchableContext BC) {
    System.debug(recordsProcessed + ' records processed');
      
    }

}