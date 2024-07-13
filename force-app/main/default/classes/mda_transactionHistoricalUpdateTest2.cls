/**
 * Apex Class Name      : mda_transactionHistoricalUpdateTest
 * Created Date         : February 26, 2024 
 * @description         : This class is used to test code for mda_transactionHistoricalRecordUpdate.
 * @author              : M. Eleanya (Contractor: Precision Partners) 
**/


@isTest(seeAllData=True)
public class mda_transactionHistoricalUpdateTest2 {

/**
 * @description:pledgeOffsetYes
 * @Comments: Check situation where Pledge Offset is Yes
**/     
static testmethod void pledgeOffsetYes(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Annual Fund Lockbox',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
    AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__PledgePayment__c = true;
    trans1.AQB__Type__c ='Grant';

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
    AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
    MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true LIMIT 1]; 
    System.assertEquals(false, trans.AQB__Do_not_push_to_Accounting__c);
    System.assertEquals(null, trans.AQB__FinancialSystemDate__c );
    System.assertEquals(null, trans.MDA_Credit_AccountLookup__c);
    System.assertEquals(null, trans.MDA_Debit_Account__c);
    System.assertEquals(null, trans.MDA_GL_Posting_Type__c);
    System.assertEquals(null, trans.MDA_Journal_ID__c);
    System.assertEquals(null, trans.MDA_Original_Transaction__c);
    System.assertEquals(null, trans.MDA_Related_Void_Transaction__c);      
} 


/**
 * @description:annualFundwithPayment
 * @Comments: Check situation where Batch Source of Data is "Annual Fund Lockbox" and Transaction Type is "Payment"
 * Data source of "Annual Fund" with Type of "Payment"
**/     
    static testmethod void annualFundwithPayment(){
        //ADD BATCH DATA
    	AQB__Batch__c batch = mda_TestDataFactory.createBatch('Annual Fund Lockbox',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
        //Query COA        
      	AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324' LIMIT 1];

        //Add Transactions
        AQB__Transaction__c trans1 = new AQB__Transaction__c();
        trans1.AQB__Account__c = acc.Id; 
        trans1.AQB__Date__c = date.today();
        trans1.AQB__FinancialSystemDate__c = NULL;
        trans1.mda_testRecord__c = true;
        trans1.AQB__Type__c = 'Payment'; 
		trans1.AQB__Batch__c = batch.Id;
        trans1.AQB__VoidedTransaction__c = NULL;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id; 
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest();  
        
        AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        mda_testRecord__c = true LIMIT 1]; 
        System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);      
    } 

/**
 * @description:annualFundwithPaymentnotnull
 * @Comments: Check situation where Batch Source of Data is "Annual Fund Lockbox" and Transaction Type is "Payment"
 * Data source of "Annual Fund" with Type of "Payment"
**/     
static testmethod void annualFundwithPaymentnotNull(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Annual Fund Lockbox',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
     AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.MDA_GL_Posting_Type__c = 'Automated';
    trans1.MDA_Credit_AccountLookup__c = coa.Id;
    trans1.MDA_Debit_Account__c= coa.Id ;


    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true LIMIT 1]; 
    System.assertEquals(coa.Id, trans.AQB__DebitAccount__c);
    System.assertEquals(coa.Id, trans.MDA_Debit_Account__c); 
    System.assertEquals(coa.AQB__DesignationAccountNumber__c,  trans.MDA_Debit_Account_Number__c); 
    System.assertEquals(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c); 
    System.assertEquals(trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, trans.MDA_Credit_Account_Number__c); 
    System.assertEquals('Automated', trans.MDA_GL_Posting_Type__c);      
} 

/**
 * @description:annualFundwithTransfer
 * @Comments: Check situation where Batch Source of Data is "Annual Fund Lockbox" and Transaction Type is "Payment"
 * Data source of "Annual Fund" with Type of "Payment"
**/     
static testmethod void annualFundwithTransfer(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Annual Fund Lockbox',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
     AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Transfer';
   


    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true LIMIT 1]; 
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);    
}




 /**
  * @description:glWithGrantPaymentNull
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of Grant Payment and Null Values
 **/
    static testmethod void glWithGrantPaymentNull(){
        //ADD BATCH DATA
    	AQB__Batch__c batch = mda_TestDataFactory.createBatch('MDA Treasury',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
        //Query COA        
      	AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

        //Add Transactions
        AQB__Transaction__c trans1 = new AQB__Transaction__c();
        trans1.AQB__Account__c = acc.Id; 
        trans1.AQB__Date__c = date.today();
        trans1.AQB__FinancialSystemDate__c = NULL;
        trans1.mda_testRecord__c = true;
        trans1.AQB__Batch__c = batch.Id;
        trans1.AQB__VoidedTransaction__c = NULL;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id;
        trans1.AQB__Type__c = 'Grant Payment';
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest();  
        
        AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        mda_testRecord__c = true LIMIT 1];       
        System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);
       

   	
    }
    
/**
  * @description:glWithGrantPaymentNonNull
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of Grant Payment and Non Null Values
 **/
static testmethod void glWithGrantPaymentNonNull(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('MDA Treasury',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Grant Payment';
    trans1.MDA_GL_Posting_Type__c = 'Automated';
    trans1.MDA_Credit_AccountLookup__c = coa.Id;
    trans1.MDA_Debit_Account__c= coa.Id ;

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true LIMIT 1];       
    System.assertEquals(coa.Id, trans.AQB__DebitAccount__c);
    System.assertEquals(coa.Id, trans.MDA_Debit_Account__c);
    System.assertEquals(coa.AQB__DesignationAccountNumber__c, trans.MDA_Debit_Account_Number__c);
    System.assertEquals(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    System.assertEquals(trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c,  trans.MDA_Credit_Account_Number__c);
    System.assertEquals('Automated', trans.MDA_GL_Posting_Type__c);
   
}


 /**
  * @description:glWithGrantPaymentMail
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of Grant Payment and Null Values
 **/
static testmethod void glWithGrantPaymentMail(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Grant Payment';

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true LIMIT 1];       
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);   
   
}


 /**
  * @description:mailPaymentwithConditionalnull
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of Conditional Payment 
 **/

    static testmethod void mailPaymentwithConditionalnull(){
        //ADD BATCH DATA
    	AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
        //Query COA        
      	AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

        //Add Transactions
        AQB__Transaction__c trans1 = new AQB__Transaction__c();
        trans1.AQB__Account__c = acc.Id; 
        trans1.AQB__Date__c = date.today();
        trans1.AQB__FinancialSystemDate__c = NULL;
        trans1.mda_testRecord__c = true;
        trans1.AQB__Batch__c = batch.Id;
        trans1.AQB__VoidedTransaction__c = NULL;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id;
        trans1.AQB__Type__c = 'Payment';
        trans1.AQB__PledgePayment__c = true;
        trans1.AQB__PledgeStipulation__c = 'Conditional';
        trans1.AQB__Method__c = 'Cash';
       

 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest();  
        
        AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        mda_testRecord__c = true  LIMIT 1];       
        System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);

   	
    }
    
/**
  * @description:mailPaymentwithConditionalnotNull
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of Unconditional Payment 
 **/

 static testmethod void mailPaymentwithConditionalnotNull(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__PledgePayment__c = true;
    trans1.AQB__PledgeStipulation__c = 'Conditional';
    trans1.AQB__Method__c = 'Cash';
    trans1.MDA_GL_Posting_Type__c = 'Automated';
    trans1.MDA_Credit_AccountLookup__c = coa.Id;
    trans1.MDA_Debit_Account__c= coa.Id ;


    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(coa.Id, trans.AQB__DebitAccount__c);
    System.assertEquals(coa.Id, trans.MDA_Debit_Account__c);
    System.assertEquals(coa.AQB__DesignationAccountNumber__c, trans.MDA_Debit_Account_Number__c);
    System.assertEquals(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    System.assertEquals(trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c,trans.MDA_Credit_Account_Number__c);
    System.assertEquals('Automated', trans.MDA_GL_Posting_Type__c);

   
}


 /**
  * @description:mailPaymentwithConditionalnullCC
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of Conditional Payment and method is credit card
 **/

 static testmethod void mailPaymentwithConditionalnullCC(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__PledgePayment__c = true;
    trans1.AQB__PledgeStipulation__c = 'Conditional';
    trans1.AQB__Method__c = 'Credit Card';
   


    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);

   
}


 /**
  * @description:mailPaymentwithConditionalnonNullCC
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of Conditional Payment and method is credit card
 **/

 static testmethod void mailPaymentwithConditionalnonNullCC(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__PledgePayment__c = true;
    trans1.AQB__PledgeStipulation__c = 'Conditional';
    trans1.MDA_GL_Posting_Type__c = 'Automated';
    trans1.MDA_Credit_AccountLookup__c = coa.Id;
    trans1.MDA_Debit_Account__c= coa.Id ;
    trans1.AQB__Method__c = 'Credit Card';
   


    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(coa.Id, trans.AQB__DebitAccount__c);
    System.assertEquals(coa.Id, trans.MDA_Debit_Account__c);
    System.assertEquals(coa.AQB__DesignationAccountNumber__c, trans.MDA_Debit_Account_Number__c);
    System.assertEquals(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    System.assertEquals(trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c,trans.MDA_Credit_Account_Number__c);
    System.assertEquals('Automated', trans.MDA_GL_Posting_Type__c);

   
}


 /**
  * @description:mailPaymentwithConditional
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of Conditional Payment 
 **/

 static testmethod void mailPaymentwithConditional(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__PledgePayment__c = true;
    trans1.AQB__PledgeStipulation__c = 'Conditional';
    trans1.AQB__Method__c = 'Transfer';
   

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);

   
}


 /**
  * @description:mailPaymentwithUnconditionalnull
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of Unconditional Payment 
 **/

 static testmethod void mailPaymentwithUnconditionalnull(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__PledgePayment__c = true;
    trans1.AQB__PledgeStipulation__c = 'Unconditional';
    trans1.AQB__Method__c = 'Cash';
   


    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);

   
}

/**
  * @description:mailPaymentwithUnconditionalnotNull
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of Unconditional Payment 
 **/

 static testmethod void mailPaymentwithUnConditionalnotNull(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__PledgePayment__c = true;
    trans1.AQB__PledgeStipulation__c = 'Unconditional';
    trans1.AQB__Method__c = 'Cash';
    trans1.MDA_GL_Posting_Type__c = 'Manual';
    trans1.MDA_Credit_AccountLookup__c = coa.Id;
    trans1.MDA_Debit_Account__c= coa.Id ;


    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];  
    
    System.assertEquals(coa.Id, trans.AQB__DebitAccount__c);
    System.assertEquals(coa.Id, trans.MDA_Debit_Account__c);
    System.assertEquals(coa.AQB__DesignationAccountNumber__c, trans.MDA_Debit_Account_Number__c);
    System.assertEquals(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    System.assertEquals(trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c,trans.MDA_Credit_Account_Number__c);
    System.assertEquals('Manual', trans.MDA_GL_Posting_Type__c);

   
}


 /**
  * @description:mailPaymentwithUnconditionalnullCC
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of Unconditional Payment and method is credit card
 **/

 static testmethod void mailPaymentwithUnconditionalnullCC(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__PledgePayment__c = true;
    trans1.AQB__PledgeStipulation__c = 'Unconditional';
    trans1.AQB__Method__c = 'Credit Card';
   


    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);

   
}


 /**
  * @description:mailPaymentwithUnconditionalnonNullCC
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of Conditional Payment and method is credit card
 **/

 static testmethod void mailPaymentwithUnconditionalnonNullCC(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__PledgePayment__c = true;
    trans1.AQB__PledgeStipulation__c = 'Unconditional';
    trans1.MDA_GL_Posting_Type__c = 'Manual';
    trans1.MDA_Credit_AccountLookup__c = coa.Id;
    trans1.MDA_Debit_Account__c= coa.Id ;
    trans1.AQB__Method__c = 'Credit Card';
   


    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(coa.Id, trans.AQB__DebitAccount__c);
    System.assertEquals(coa.Id, trans.MDA_Debit_Account__c);
    System.assertEquals(coa.AQB__DesignationAccountNumber__c, trans.MDA_Debit_Account_Number__c);
    System.assertEquals(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    System.assertEquals(trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c,trans.MDA_Credit_Account_Number__c);
    System.assertEquals('Manual', trans.MDA_GL_Posting_Type__c);
   
}


 /**
  * @description:mailPaymentwithUnconditional
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of Unconditional Payment 
 **/

 static testmethod void mailPaymentwithUnonditional(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__PledgePayment__c = true;
    trans1.AQB__PledgeStipulation__c = 'Unconditional';
    trans1.AQB__Method__c = 'Transfer';
   

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);
   
}


/**
  * @description:mailPaymentwithFalsePledgenull
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of False Pledge Payment 
 **/

 static testmethod void mailPaymentwithFalsePledgenull(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__PledgePayment__c = false;
    trans1.AQB__Method__c = 'Cash';
   

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);

   
}

 /**
  * @description:mailPaymentwithFalsePledgeNotnull
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of False Pledge Payment
 **/

 static testmethod void mailPaymentwithFalsePledgeNotnull(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__PledgePayment__c = false;
    trans1.AQB__Method__c = 'Cash';
    trans1.MDA_GL_Posting_Type__c = 'Automated';
    trans1.MDA_Credit_AccountLookup__c = coa.Id;
    trans1.MDA_Debit_Account__c= coa.Id ;
 
   


    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(coa.Id, trans.AQB__DebitAccount__c);
    System.assertEquals(coa.Id, trans.MDA_Debit_Account__c);
    System.assertEquals(coa.AQB__DesignationAccountNumber__c, trans.MDA_Debit_Account_Number__c);
    System.assertEquals(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    System.assertEquals(trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c,trans.MDA_Credit_Account_Number__c);
    System.assertEquals('Automated', trans.MDA_GL_Posting_Type__c);
   
}


 /**
  * @description:mailPaymentwithfalsePledgenullCC
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of false pledge and null Credit Card
 **/

 static testmethod void mailPaymentwithfalsePledgenullCC(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__PledgePayment__c = false;
    trans1.AQB__Method__c = 'Credit Card';
   


    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);

   
}


/**
  * @description:mailPaymentwithfalsePledgenonNullCC
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of False Pledge and method is credit card
 **/

 static testmethod void mailPaymentwithfalsePledgenonNullCC(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__PledgePayment__c = false;
    trans1.MDA_GL_Posting_Type__c = 'Automated';
    trans1.MDA_Credit_AccountLookup__c = coa.Id;
    trans1.MDA_Debit_Account__c= coa.Id ;
    trans1.AQB__Method__c = 'Credit Card';
   

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(coa.Id, trans.AQB__DebitAccount__c);
    System.assertEquals(coa.Id, trans.MDA_Debit_Account__c);
    System.assertEquals(coa.AQB__DesignationAccountNumber__c, trans.MDA_Debit_Account_Number__c);
    System.assertEquals(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    System.assertEquals(trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c,trans.MDA_Credit_Account_Number__c);
    System.assertEquals('Automated', trans.MDA_GL_Posting_Type__c);
   
}

 /**
  * @description:mailPaymentfalsePledge
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of false pledge
 **/

 static testmethod void mailPaymentfalsePledge(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__PledgePayment__c = false;
    trans1.AQB__Method__c = 'Transfer';
   

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);
   
}


 /**
  * @description:checkMatchingGift
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source and there is a matching gift
 **/

 static testmethod void checkMatchingGift(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
    AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];
    //Get Gift
    AQB__Gift__c gift = mda_TestDataFactory.getMatchedGift();
 
  

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Gift__c = gift.Id;
    trans1.AQB__PledgePayment__c = false;
    trans1.AQB__Method__c = 'Pledge';
    trans1.AQB__Type__c = 'Pledge';
   

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id,AQB__Gift__r.AQB__MatchLink__r.Id , AQB__Do_not_push_to_Accounting__c, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1]; 
    
    System.assertEquals(true, trans.AQB__Do_not_push_to_Accounting__c);
   
}

 /**
  * @description:mailPaymentfalsePledge
  * @Comments: Check situation where Batch Source of Data 
  * is a GL Source with type of false pledge
 **/

 static testmethod void mailTransfer(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Transfer';

   

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);
   
}

 /**
  * @description:nonGLgiftInKind
  * @Comments: Check situation where Batch Source of Data 
  * is a NON GL Source 
 **/

 static testmethod void nonGLgiftInKind(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Gift in Kind Form / Documentation',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__Method__c = 'Personal Property';

   

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);
   
}

/**
  * @description:nonGLpledgeDocumentation
  * @Comments: Check situation where Batch Source of Data 
  * is a NON GL Source 
 **/

 static testmethod void nonGLpledgeDocumentation(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Planned Giving Form / Documentation',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__Method__c = 'Personal Property';

   

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);
   
}


/**
  * @description:nonGLpledgeDocumentation
  * @Comments: Check situation where Batch Source of Data 
  * is a NON GL Source 
 **/

 static testmethod void nonGLgrantManagement(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Grants Management System',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Grant';


   

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);
   
}

/**
  * @description:nonGLplannedGiving
  * @Comments: Check situation where Batch Source of Data 
  * is a NON GL Source 
 **/

 static testmethod void nonGLplannedGiving(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Planned Giving Form / Documentation',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
    AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Grant';
   

   

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);
   
}

/**
  * @description:nonGLpledgeDocumentationPledge
  * @Comments: Check situation where Batch Source of Data 
  * is a NON GL Source 
 **/

 static testmethod void nonGLpledgeDocumentationPledge(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Pledge Form / Documentation',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
    AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__Type__c = 'Soft Credit';
   

   

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true, trans.MDA_Credit_Debit_Account_Error__c);
   
}


/**
  * @description:nonGLpledgeDocumentationInstrument
  * @Comments: Check situation where Batch Source of Data 
  * is a NON GL Source 
 **/

 //DEACTIVATE FLOW BEFORE TESTING
 static testmethod void nonGLpledgeDocumentationInstrument(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Pledge Form / Documentation',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
    AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__Type__c = 'Pledge';
    trans1.AQB__Method__c = 'Pledge';
    trans1.AQB__Instrument__c = null;
    trans1.AQB__PledgeStipulation__c = 'Unconditional';
   

    insert trans1;

    System.debug('transaction' + trans1);
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals('Manual',  trans.MDA_GL_Posting_Type__c);
   
}



/**
  * @description:nonGLpledgeDocumentationInstrument
  * @Comments: Check situation where Batch Source of Data 
  * is a NON GL Source 
 **/

 static testmethod void nonGLpledgeDocumentationConditional(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Pledge Form / Documentation',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
    AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__Type__c = 'Pledge';
    trans1.AQB__Method__c = 'Pledge';
    trans1.AQB__Instrument__c = null;
    trans1.AQB__PledgeStipulation__c = 'Conditional';
   

    insert trans1;

    System.debug('transaction' + trans1);
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true,  trans.AQB__Do_not_push_to_Accounting__c);
   
}

 //DEACTIVATE FLOW BEFORE TESTING

/**
  * @description:nonGLpledgeDocumentationNoStipulation
  * @Comments: Check situation where Batch Source of Data 
  * is a NON GL Source 
 **/

 static testmethod void nonGLpledgeDocumentationNoStipulation(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Pledge Form / Documentation',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
    AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__Type__c = 'Pledge';
    //trans1.AQB__Method__c = 'Pledge';
    trans1.AQB__Instrument__c = null;
    trans1.AQB__PledgeStipulation__c = null;
   

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true,  trans.MDA_Credit_Debit_Account_Error__c);
   
}



/**
  * @description:adjustmentWtPayment
  * @Comments: Check situation where Batch Source of Data 
  * is a NON GL Source 
 **/

 static testmethod void adjustmentWtPayment(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Adjustments',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
    AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__Method__c = 'Real Property';

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
    AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
    MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true LIMIT 1];       
    System.assertEquals(false, trans.AQB__Do_not_push_to_Accounting__c);
    System.assertEquals(null, trans.AQB__FinancialSystemDate__c );
    System.assertEquals(null, trans.MDA_Credit_AccountLookup__c);
    System.assertEquals(null, trans.MDA_Debit_Account__c);
    System.assertEquals(null, trans.MDA_GL_Posting_Type__c);
    System.assertEquals(null, trans.MDA_Journal_ID__c);
    System.assertEquals(null, trans.MDA_Original_Transaction__c);
    System.assertEquals(null, trans.MDA_Related_Void_Transaction__c);     
   
}


/**
  * @description:adjustmentWtGrant
  * @Comments: Check situation where Batch Source of Data 
  * is a NON GL Source 
 **/

 static testmethod void adjustmentWtGrant(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Adjustments',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
    AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];



    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__Type__c = 'Grant';
    

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true,  trans.MDA_Credit_Debit_Account_Error__c); 
   
}


/**
  * @description:noDataSource
  * @Comments: Check situation where Batch Source of Data does not exist
 **/

 
 static testmethod void noDataSource(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Adjustments',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
    AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Batch__c = NULL;
    trans1.AQB__VoidedTransaction__c = NULL;
    trans1.AQB__Acknowledgement__c = ack.Id; 
   
    

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true  LIMIT 1];       
    System.assertEquals(true,  trans.MDA_Credit_Debit_Account_Error__c); 
   
}


// /**
//  * @description:voidedTranswtGrant
//  * @Comments: Check situation where Transaction is  - Voided Transaction and Transaction Type is "Grant Payment"
// **/
    static testmethod void voidedTranswtGrant(){
        //ADD BATCH DATA
    	AQB__Batch__c batch = mda_TestDataFactory.createBatch('Online - Donation Sites',true);
        //CREATE ACCOUNT
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
        //Get Voided Transaction Record
        AQB__Transaction__c transVoid = mda_TestDataFactory.chooseVoidedTransaction();
        //Get Correct Transaction
        AQB__Transaction__c correctTrans = mda_TestDataFactory.createMatchingTransaction();
        //Get Gift
        AQB__Gift__c gift = mda_TestDataFactory.getGift();
      
        //Query COA        
      	AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];

        //Add Transactions
        AQB__Transaction__c trans1 = new AQB__Transaction__c();
       
        trans1.AQB__Account__c = acc.Id; 
        trans1.AQB__Date__c = date.today();
        trans1.AQB__FinancialSystemDate__c = NULL;
        trans1.mda_testRecord__c = true;
        trans1.AQB__Acknowledgement__c = ack.Id;
        trans1.AQB__VoidedTransaction__c = transVoid.Id;
        trans1.AQB__Batch__c = batch.Id;
        trans1.AQB__Type__c = 'Grant Payment';
  
        insert trans1;
        

        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest(); 
        
        
        AQB__Transaction__c trans =[Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        mda_testRecord__c = true  LIMIT 1];    
        
        System.assertEquals(true, trans.AQB__Do_not_push_to_Accounting__c);
        
    }
 //DeActivate Flow   
// /**
//  * @description:voidedTranswtPayment
//  * @Comments: Check situation where Transaction is  - Voided Transaction and Transaction Type is "Grant Payment"
// **/
    static testmethod void voidedTranswtPayment(){
        //ADD BATCH DATA
    	AQB__Batch__c batch = mda_TestDataFactory.createBatch('Online - Donation Sites',true);
        //CREATE ACCOUNT
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
        //Get Voided Transaction Record
        AQB__Transaction__c transVoid = mda_TestDataFactory.chooseVoidedTransaction();
        //Get Correct Transaction
        AQB__Transaction__c correctTrans = mda_TestDataFactory.createMatchingTransactionPledge();
        //Get Gift
        AQB__Gift__c gift = mda_TestDataFactory.getGift();
      
        //Query COA        
      	AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];
        

        //Add Transactions
        AQB__Transaction__c trans1 = new AQB__Transaction__c();
       
        trans1.AQB__Account__c = acc.Id; 
        trans1.AQB__Date__c = date.today();
        trans1.AQB__FinancialSystemDate__c = NULL;
        trans1.mda_testRecord__c = true;
        trans1.AQB__Acknowledgement__c = ack.Id;
        trans1.AQB__VoidedTransaction__c = transVoid.Id;
        trans1.AQB__Batch__c = batch.Id;
        // 
        //trans1.AQB__Type__c = 'Payment';
        trans1.AQB__Method__c = 'Real Property';
        //trans1.AQB__PledgePayment__c = true;
        trans1.AQB__PledgeStipulation__c = 'Conditional';
        //
        trans1.AQB__Gift__c = correctTrans.AQB__Gift__c;
        trans1.MDA_Batch_Item_ID2__c = correctTrans.MDA_Batch_Item_ID2__c;
        trans1.AQB__Type__c = correctTrans.AQB__Type__c;
        trans1.AQB__PaymentNumber__c = correctTrans.AQB__PaymentNumber__c - 10;
  
        insert trans1;
        

        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest(); 
        
        AQB__Transaction__c trans2 =[Select Id, AQB__Type__c, AQB__PledgePayment__c,  AQB__Do_not_push_to_Accounting__c, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        mda_testRecord__c = true  AND AQB__VoidedTransaction__c= NULL  LIMIT 1]; 

        System.debug('correct trans  ' + trans2);
        
        AQB__Transaction__c trans =[Select Id, AQB__Type__c, AQB__PledgePayment__c, AQB__PledgeStipulation__c, AQB__Do_not_push_to_Accounting__c, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        mda_testRecord__c = true AND AQB__VoidedTransaction__c != NULL  LIMIT 1];    
        
        System.debug('original trans  ' + trans);

        System.assertEquals(true, trans.AQB__Do_not_push_to_Accounting__c);
        System.assertEquals(trans2.MDA_Credit_Account_Number__c, trans2.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
        System.assertEquals(trans2.MDA_Credit_AccountLookup__c, trans2.AQB__ChartofAccounts__c);
        System.assertEquals(trans2.MDA_Debit_Account_Number__c, trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
        System.assertEquals(trans2.MDA_Debit_Account__c, trans.AQB__ChartofAccounts__c);
        System.assertEquals('Automated',trans2.MDA_GL_Posting_Type__c);
        System.assertEquals(trans2.MDA_Original_Transaction__c, trans.AQB__VoidedTransaction__r.Id);
        System.assertEquals(trans2.MDA_Related_Void_Transaction__c,trans.Id);
        
    }
 //DeActivate Flow 

// /**
//  * @description:voidedTranswtPaymenNoCorrect
//  * @Comments: Check situation where Transaction is  - Voided Transaction and Transaction Type is "Grant Payment"
// **/
static testmethod void voidedTranswtPaymenNoCorrect(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Online - Donation Sites',true);
    //CREATE ACCOUNT
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
    //Get Voided Transaction Record
    AQB__Transaction__c transVoid = mda_TestDataFactory.chooseVoidedTransaction();
    //Get Correct Transaction
    //AQB__Transaction__c correctTrans = mda_TestDataFactory.createMatchingTransactionPledge();
    //Get Gift
    AQB__Gift__c gift = mda_TestDataFactory.getGift();
  
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];
    

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
   
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__FinancialSystemDate__c = NULL;
    trans1.mda_testRecord__c = true;
    trans1.AQB__Acknowledgement__c = ack.Id;
    trans1.AQB__VoidedTransaction__c = transVoid.Id;
    trans1.AQB__Batch__c = batch.Id;
    // 
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__Method__c = 'Real Property';
    trans1.AQB__PledgePayment__c = true;
    trans1.AQB__PledgeStipulation__c = 'Conditional';
    //
 

    insert trans1;
    

    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest(); 
    
    // AQB__Transaction__c trans2 =[Select Id, AQB__Type__c, AQB__PledgePayment__c,  AQB__Do_not_push_to_Accounting__c, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    // mda_testRecord__c = true  AND AQB__VoidedTransaction__c= NULL  LIMIT 1]; 

    // System.debug('correct trans  ' + trans2);
    
    AQB__Transaction__c trans =[Select Id, AQB__Type__c, AQB__PledgePayment__c, AQB__PledgeStipulation__c, AQB__Do_not_push_to_Accounting__c, MDA_Credit_Debit_Account_Error__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true AND AQB__VoidedTransaction__c != NULL  LIMIT 1];    
    
    System.debug('original trans  ' + trans);

    System.assertEquals(trans.MDA_Credit_AccountLookup__c, trans.AQB__DebitAccount__c);
    System.AssertEquals(trans.MDA_Credit_Account_Number__c, trans.AQB__DebitAccount__r.AQB__DesignationAccountNumber__c);
    System.assertEquals(trans.MDA_Debit_Account__c, trans.AQB__ChartofAccounts__c);
    System.assertEquals(trans.MDA_Debit_Account_Number__c, trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
    System.assertEquals('Automated', trans.MDA_GL_Posting_Type__c );
    
}


    

// /**
//  * @description:Scenario 26
//  * @Comments: Check situation where Transaction is "Null", there is a "Corrected Transaction" 
//  * and Transaction Type is "Payment"
// **/
    static testmethod void scenario26(){
        //ADD BATCH DATA
    	//AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
        //Get Voided Transaction Record
        AQB__Transaction__c transVoid = mda_TestDataFactory.chooseVoidedTransaction();
        //Get Correct Transaction
        AQB__Transaction__c correctTrans = mda_TestDataFactory.createMatchingTransaction();
        //Get Gift
        AQB__Gift__c gift = mda_TestDataFactory.getGift();
        
        
        
        //Query COA        
      	AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];

        //Add Transactions
        AQB__Transaction__c trans1 = new AQB__Transaction__c();
        trans1.AQB__Account__c = acc.Id; 
        trans1.AQB__Date__c = date.today();
        trans1.AQB__Reference__c= '26';
        trans1.AQB__Type__c = 'Payment';
        trans1.AQB__VoidedTransaction__c = transVoid.Id;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id;
        trans1.AQB__OriginatingBatchItemTransaction__c = correctTrans.AQB__OriginatingBatchItemTransaction__c;
        trans1.AQB__Gift__c = correctTrans.AQB__Gift__c;
        trans1.AQB__PledgePayment__c = true;
        trans1.AQB__PledgeStipulation__c = 'Conditional';
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest(); 
        
        
        AQB__Transaction__c trans =[Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '26' LIMIT 1];
        
        AQB__Transaction__c uCorrectTrans =[Select Id, MDA_GL_Posting_Type__c, AQB__DebitAccount__c, MDA_Credit_Account_Number__c, MDA_Credit_AccountLookup__c, MDA_Debit_Account_Number__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= 'correctTrans' LIMIT 1];
  
        System.assertEquals(trans.AQB__Do_not_push_to_Accounting__c, True);
        System.assertEquals(uCorrectTrans.MDA_Credit_Account_Number__c, uCorrectTrans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
        System.assertEquals(uCorrectTrans.MDA_Credit_AccountLookup__c, uCorrectTrans.AQB__ChartofAccounts__c);
        System.assertEquals(uCorrectTrans.MDA_Debit_Account_Number__c, trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
        System.assertEquals(uCorrectTrans.MDA_Debit_Account__c, trans.AQB__ChartofAccounts__c);
        System.assertEquals(uCorrectTrans.MDA_GL_Posting_Type__c, 'Automated');
      
    }

// /**
//  * @description:Scenario 27
//  * @Comments: Check situation where Transaction is "Null", there is not a "Corrected Transaction" 
//  * and Transaction Type is "Payment"
// **/

    static testmethod void scenario27(){
        //ADD BATCH DATA
    	//AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
        //Get Voided Transaction Record
        AQB__Transaction__c transVoid = mda_TestDataFactory.chooseVoidedTransaction();
        //Get Correct Transaction
        AQB__Transaction__c correctTrans = mda_TestDataFactory.createMatchingTransaction();
        //Get Gift
        AQB__Gift__c gift = mda_TestDataFactory.getGift();
        
        
        
        //Query COA        
      	AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];

        //Add Transactions
        AQB__Transaction__c trans1 = new AQB__Transaction__c();
        trans1.AQB__Account__c = acc.Id; 
        trans1.AQB__Date__c = date.today();
        trans1.AQB__Reference__c= '27';
        trans1.AQB__Type__c = 'Payment';
        trans1.AQB__VoidedTransaction__c = transVoid.Id;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id;
        trans1.AQB__PledgePayment__c = true;
        trans1.AQB__PledgeStipulation__c = 'Conditional';
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest(); 
        
        
        AQB__Transaction__c trans =[Select Id,AQB__DebitAccount__c, MDA_GL_Posting_Type__c, AQB__DebitAccount__r.AQB__DesignationAccountNumber__c, AQB__Do_not_push_to_Accounting__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '27' LIMIT 1];

  
		System.assertEquals(trans.MDA_Credit_AccountLookup__c, trans.AQB__DebitAccount__c);
        System.assertEquals(trans.MDA_Credit_Account_Number__c, trans.AQB__DebitAccount__r.AQB__DesignationAccountNumber__c);
        System.assertEquals(trans.MDA_Debit_Account__c, trans.AQB__ChartofAccounts__c);
        System.assertEquals(trans.MDA_Debit_Account_Number__c, trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
        System.assertEquals(trans.MDA_GL_Posting_Type__c, 'Automated');
    }


// /**
//  * @description:Scenario28
//  * @Comments: Check situation where Transaction is "Null", there is a "Corrected Transaction" 
//  * and Transaction Type is "Payment"
// **/
    static testmethod void scenario28(){
        //ADD BATCH DATA
    	//AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
        //Get Voided Transaction Record
        AQB__Transaction__c transVoid = mda_TestDataFactory.chooseVoidedTransaction();
        //Get Correct Transaction
        AQB__Transaction__c correctTrans = mda_TestDataFactory.createMatchingTransaction();
        //Get Gift
        AQB__Gift__c gift = mda_TestDataFactory.getGift();
        
        
        
        //Query COA        
      	AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];

        //Add Transactions
        AQB__Transaction__c trans1 = new AQB__Transaction__c();
        trans1.AQB__Account__c = acc.Id; 
        trans1.AQB__Date__c = date.today();
        trans1.AQB__Reference__c= '28';
        trans1.AQB__Type__c = 'Payment';
        trans1.AQB__VoidedTransaction__c = transVoid.Id;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id;
        trans1.AQB__OriginatingBatchItemTransaction__c = correctTrans.AQB__OriginatingBatchItemTransaction__c;
        trans1.AQB__Gift__c = correctTrans.AQB__Gift__c;
        trans1.AQB__PledgePayment__c = false;

 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest(); 
        
        
        AQB__Transaction__c trans =[Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '28' LIMIT 1];
        
        AQB__Transaction__c uCorrectTrans =[Select Id, MDA_GL_Posting_Type__c,  AQB__DebitAccount__c, MDA_Credit_Account_Number__c, MDA_Credit_AccountLookup__c, MDA_Debit_Account_Number__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= 'correctTrans' LIMIT 1];
  
        System.assertEquals(trans.AQB__Do_not_push_to_Accounting__c, True);
        System.assertEquals(uCorrectTrans.MDA_Credit_Account_Number__c, uCorrectTrans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
        System.assertEquals(uCorrectTrans.MDA_Credit_AccountLookup__c, uCorrectTrans.AQB__ChartofAccounts__c);
        System.assertEquals(uCorrectTrans.MDA_Debit_Account_Number__c, trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
        System.assertEquals(uCorrectTrans.MDA_Debit_Account__c, trans.AQB__ChartofAccounts__c);
        System.assertEquals(uCorrectTrans.MDA_GL_Posting_Type__c , 'Automated');
    }
/**
//  * @description:Scenario29
//  * @Comments: Check situation where Transaction is "Null", there is not a "Corrected Transaction" 
//  * and Transaction Type is "Payment"
// **/
    static testmethod void scenario29(){
        //ADD BATCH DATA
    	//AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
        //Get Voided Transaction Record
        AQB__Transaction__c transVoid = mda_TestDataFactory.chooseVoidedTransaction();
        //Get Correct Transaction
        AQB__Transaction__c correctTrans = mda_TestDataFactory.createMatchingTransaction();
        //Get Gift
        AQB__Gift__c gift = mda_TestDataFactory.getGift();
        
        
        
        //Query COA        
      	AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];

        //Add Transactions
        AQB__Transaction__c trans1 = new AQB__Transaction__c();
        trans1.AQB__Account__c = acc.Id; 
        trans1.AQB__Date__c = date.today();
        trans1.AQB__Reference__c= '29';
        trans1.AQB__Type__c = 'Payment';
        trans1.AQB__VoidedTransaction__c = transVoid.Id;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id;
        trans1.AQB__PledgePayment__c = false;

 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest(); 
        
        
        AQB__Transaction__c trans =[Select Id,AQB__DebitAccount__c, MDA_GL_Posting_Type__c, AQB__DebitAccount__r.AQB__DesignationAccountNumber__c, AQB__Do_not_push_to_Accounting__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '29' LIMIT 1];
        

  
    	 System.assertEquals(trans.MDA_Credit_AccountLookup__c, trans.AQB__DebitAccount__c);
         System.assertEquals(trans.MDA_Credit_Account_Number__c, trans.AQB__DebitAccount__r.AQB__DesignationAccountNumber__c);
         System.assertEquals(trans.MDA_Debit_Account__c, trans.AQB__ChartofAccounts__c);
         System.assertEquals(trans.MDA_Debit_Account_Number__c, trans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
         System.assertEquals(trans.MDA_GL_Posting_Type__c , 'Automated');
      
    }

/**
//  * @description:Scenario20
//  * @Comments: Check situation where Transaction is "Null", Transaction Type is Payment,Pledge payment is true and
//     pledge stipulation is anything but conditional
// **/
static testmethod void scenario30(){
    //ADD BATCH DATA
    //AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
    //Get Voided Transaction Record
    AQB__Transaction__c transVoid = mda_TestDataFactory.chooseVoidedTransaction();
    //Get Correct Transaction
    AQB__Transaction__c correctTrans = mda_TestDataFactory.createMatchingTransaction();
    //Get Gift
    AQB__Gift__c gift = mda_TestDataFactory.getGift();
    
    
    
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__Reference__c= '30';
    trans1.AQB__Type__c = 'Payment';
    trans1.AQB__VoidedTransaction__c = transVoid.Id;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__PledgePayment__c = true;
    trans1.AQB__PledgeStipulation__c = 'Unconditional';


    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest(); 
    
    
    AQB__Transaction__c trans =[Select Id,AQB__DebitAccount__c, MDA_GL_Posting_Type__c, AQB__DebitAccount__r.AQB__DesignationAccountNumber__c, AQB__Do_not_push_to_Accounting__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    AQB__Reference__c= '30' LIMIT 1];
   
     System.assertEquals(trans.MDA_GL_Posting_Type__c , 'Manual');
  
}

// /**
//  * @description:Scenario31
//  * @Comments: Check situation where Transaction is "Null" and type
//  * is soft credit
// **/
    static testmethod void scenario31(){
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
        //Get Voided Transaction Record
        AQB__Transaction__c transVoid = mda_TestDataFactory.chooseVoidedTransaction();
        //Get Correct Transaction
        AQB__Transaction__c correctTrans = mda_TestDataFactory.createMatchingTransaction();
        //Get Gift
        AQB__Gift__c gift = mda_TestDataFactory.getGift();
        
        
        
        //Query COA        
      	AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];

        //Add Transactions
        AQB__Transaction__c trans1 = new AQB__Transaction__c();
        trans1.AQB__Account__c = acc.Id; 
        trans1.AQB__Date__c = date.today();
        trans1.AQB__Reference__c= '31';
        trans1.AQB__Type__c = 'Soft Credit';
        trans1.AQB__VoidedTransaction__c = transVoid.Id;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id;

       

 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest(); 
        
        AQB__Transaction__c trans =[Select Id,  MDA_Credit_Debit_Account_Error__c, AQB__Do_not_push_to_Accounting__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '31' LIMIT 1];
        
        system.AssertEquals(trans.AQB__Do_not_push_to_Accounting__c, True);
        
    }


// /**
//  * @description:Scenario32
//  * @Comments: Check situation where Transaction is "Null" and type
//  * is 'Pledge' with pledge stipulation of 'Unconditional'
// **/
static testmethod void scenario32(){
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
    //Get Voided Transaction Record
    AQB__Transaction__c transVoid = mda_TestDataFactory.chooseVoidedTransaction();
    //Get Correct Transaction
    AQB__Transaction__c correctTrans = mda_TestDataFactory.createMatchingTransaction();
    //Get Gift
    AQB__Gift__c gift = mda_TestDataFactory.getGift();
    
    
    
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__Reference__c= '32';
    trans1.AQB__Type__c = 'Pledge';
    trans1.AQB__VoidedTransaction__c = transVoid.Id;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.AQB__PledgeStipulation__c = 'Unconditional';
    trans1.AQB__Method__c= 'Pledge';

    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest(); 
    
    AQB__Transaction__c trans =[Select Id, MDA_GL_Posting_Type__c,  MDA_Credit_Debit_Account_Error__c, AQB__Do_not_push_to_Accounting__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    AQB__Reference__c= '32' LIMIT 1];
    
    system.AssertEquals(trans.MDA_GL_Posting_Type__c, 'Manual');
    
}

// /**
//  * @description:Scenario33
//  * @Comments: Check situation where Transaction is "Null" and transaction type
//  * is not Grant Payment, Payment, Grant, Soft Credit, Pledge Soft Credit
// **/
static testmethod void scenario33(){
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
    //Get Voided Transaction Record
    AQB__Transaction__c transVoid = mda_TestDataFactory.chooseVoidedTransaction();
    //Get Correct Transaction
    AQB__Transaction__c correctTrans = mda_TestDataFactory.createMatchingTransaction();
    //Get Gift
    AQB__Gift__c gift = mda_TestDataFactory.getGift();
    
    
    
    //Query COA        
      AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Date__c = date.today();
    trans1.AQB__Reference__c= '33';
    //trans1.AQB__Type__c = 'Pledge';
    trans1.AQB__VoidedTransaction__c = transVoid.Id;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    //trans1.AQB__PledgeStipulation__c = 'Unconditional';
   


    insert trans1;
          
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest(); 
    
    AQB__Transaction__c trans =[Select Id, MDA_GL_Posting_Type__c,  MDA_Credit_Debit_Account_Error__c, AQB__Do_not_push_to_Accounting__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    AQB__Reference__c= '33' LIMIT 1];
    
    system.AssertEquals(trans.MDA_Credit_Debit_Account_Error__c, True);
    
}
           
 }