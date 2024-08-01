/**
 * Apex Class Name      : mda_transactionHistoricalUpdateTest
 * Created Date         : February 26, 2024 
 * @description         : This class is used to test code for mda_transactionHistoricalRecordUpdate.
 * @author              : M. Eleanya (Contractor: Precision Partners) 
**/


@isTest(seeAllData=True)
public class mda_transactionHistoricalUpdateTest2 {

  private static final AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c 
  WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90-11324' LIMIT 1];

  private static final AQB__LLChartofAccounts__c coa2 = [Select Id, AQB__DesignationAccountNumber__c from AQB__LLChartofAccounts__c 
  WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];
  
  private static final AQB__LLChartofAccounts__c coa3 = [Select Id, AQB__DesignationAccountNumber__c from AQB__LLChartofAccounts__c 
  WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];  

/**
 * @description:pledgeTruePayment
 * @Comments: Check situation where Pledge Payment is False with no Third Party Payoff
**/     
static testmethod void pledgeFalsePayment(){
    //ADD BATCH DATA
    AQB__Batch__c batch = mda_TestDataFactory.createBatch('Annual Fund Lockbox',true);        
    //ADD ACCOUNT DATA
    Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
    //QUERY OTHER OBJECTS  
    AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
    AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
    //Query COA        
    AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90-11324' LIMIT 1];

    //Add Transactions
    AQB__Transaction__c trans1 = new AQB__Transaction__c();
    //Core Fields
    trans1.AQB__Date__c = date.today();
    trans1.AQB__Account__c = acc.Id; 
    trans1.AQB__Batch__c = batch.Id;
    trans1.AQB__Acknowledgement__c = ack.Id; 
    trans1.AQB__ChartofAccounts__c = aoc.Id;
    trans1.mda_testRecord__c = true;
    //Test Data
    trans1.AQB__Type__c = 'Pledge';
    trans1.AQB__Method__c = 'Pledge';
    trans1.AQB__ThirdPartyPayoff__c = false;
    trans1.AQB__PledgePayment__c = false;

    insert trans1;

          
   
    Test.startTest();
    mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
    Database.executeBatch(b);
    Test.stopTest();  
    
    AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
    AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
    MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
    mda_testRecord__c = true LIMIT 1]; 
    System.assertEquals(true, trans.AQB__Do_not_push_to_Accounting__c);
    
} 

/**
 * @description:grantFalsePayment
 * @Comments: Check situation where Transaction Type is Grant no Third Party Payoff and False Pledge Payment
**/     
static testmethod void grantFalsePayment(){
  //ADD BATCH DATA
  AQB__Batch__c batch = mda_TestDataFactory.createBatch('Annual Fund Lockbox',true);        
  //ADD ACCOUNT DATA
  Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
  //QUERY OTHER OBJECTS  
  AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
  AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
  //Query COA        
  AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90-11324' LIMIT 1];

  //Add Transactions
  AQB__Transaction__c trans1 = new AQB__Transaction__c();
  //Core Fields
  trans1.AQB__Date__c = date.today();
  trans1.AQB__Account__c = acc.Id; 
  trans1.AQB__Batch__c = batch.Id;
  trans1.AQB__Acknowledgement__c = ack.Id; 
  trans1.AQB__ChartofAccounts__c = aoc.Id;
  trans1.mda_testRecord__c = true;
  //Test Data
  trans1.AQB__Type__c = 'Grant';
  trans1.AQB__ThirdPartyPayoff__c = false;
  trans1.AQB__PledgePayment__c = false;

  insert trans1;

        
 
  Test.startTest();
  mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
  Database.executeBatch(b);
  Test.stopTest();  
  
  AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
  AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
  mda_testRecord__c = true LIMIT 1]; 
  System.assertEquals(true, trans.AQB__Do_not_push_to_Accounting__c);
  
} 

/**
 * @description:grantManagementPayment
 * @Comments: Check situation where Source of Data is Grant Management Payment and Type is
 * Grant Payment
**/     
static testmethod void grantManagementPayment(){
  //ADD BATCH DATA
  AQB__Batch__c batch = mda_TestDataFactory.createBatch('Grants Management System',true);        
  //ADD ACCOUNT DATA
  Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
  //QUERY OTHER OBJECTS  
  AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
  AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
  //Query COA        
  AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90-11324' LIMIT 1];

  //Add Transactions
  AQB__Transaction__c trans1 = new AQB__Transaction__c();
  //Core Fields
  trans1.AQB__Date__c = date.today();
  trans1.AQB__Account__c = acc.Id; 
  trans1.AQB__Batch__c = batch.Id;
  trans1.AQB__Acknowledgement__c = ack.Id; 
  trans1.AQB__ChartofAccounts__c = aoc.Id;
  trans1.mda_testRecord__c = true;
  //Test Data
  trans1.AQB__Type__c = 'Grant Payment';
  trans1.AQB__ThirdPartyPayoff__c = false;
  trans1.AQB__PledgePayment__c = true;

  insert trans1;

        
  Test.startTest();
  mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
  Database.executeBatch(b);
  Test.stopTest();  
  
  AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
  AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
  mda_testRecord__c = true LIMIT 1]; 
  System.assertEquals(true, trans.AQB__Do_not_push_to_Accounting__c);
  
} 

/**
 * @description:grantManagementNoPayment
 * @Comments: Check situation where Source of Data is Grant Management Payment and Type is
 * Grant Payment without a payment
**/     
static testmethod void grantManagementNoPayment(){
  //ADD BATCH DATA
  AQB__Batch__c batch = mda_TestDataFactory.createBatch('Grants Management System',true);        
  //ADD ACCOUNT DATA
  Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
  //QUERY OTHER OBJECTS  
  AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
  AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
  //Query COA        
  AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90-11324' LIMIT 1];

  //Add Transactions
  AQB__Transaction__c trans1 = new AQB__Transaction__c();
  //Core Fields
  trans1.AQB__Date__c = date.today();
  trans1.AQB__Account__c = acc.Id; 
  trans1.AQB__Batch__c = batch.Id;
  trans1.AQB__Acknowledgement__c = ack.Id; 
  trans1.AQB__ChartofAccounts__c = aoc.Id;
  trans1.mda_testRecord__c = true;
  //Test Data
  trans1.AQB__Type__c = 'Grant Payment';
  trans1.AQB__ThirdPartyPayoff__c = false;
  trans1.AQB__PledgePayment__c = false;

  insert trans1;

        
 
  Test.startTest();
  mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
  Database.executeBatch(b);
  Test.stopTest();  
  
  AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
  AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
  mda_testRecord__c = true LIMIT 1]; 
  System.assertEquals(true, trans.AQB__Do_not_push_to_Accounting__c);
  
} 


/**
 * @description:giftInKindPayment
 * @Comments: Check situation where Source of Data is Gift in Kind Form / Documentation and Type is
 * Payment 
**/     
static testmethod void giftInKindPayment(){
  //ADD BATCH DATA
  AQB__Batch__c batch = mda_TestDataFactory.createBatch('Gift in Kind Form / Documentation',true);        
  //ADD ACCOUNT DATA
  Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
  //QUERY OTHER OBJECTS  
  AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
  AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
  //Query COA        
  AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90-11324' LIMIT 1];

  //Add Transactions
  AQB__Transaction__c trans1 = new AQB__Transaction__c();
  //Core Fields
  trans1.AQB__Date__c = date.today();
  trans1.AQB__Account__c = acc.Id; 
  trans1.AQB__Batch__c = batch.Id;
  trans1.AQB__Acknowledgement__c = ack.Id; 
  trans1.AQB__ChartofAccounts__c = aoc.Id;
  trans1.mda_testRecord__c = true;
  //Test Data
  trans1.AQB__Type__c = 'Payment';
  trans1.AQB__ThirdPartyPayoff__c = false;
  trans1.AQB__PledgePayment__c = false;


  insert trans1;

        
 
  Test.startTest();
  mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
  Database.executeBatch(b);
  Test.stopTest();  
  
  AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
  AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
  mda_testRecord__c = true LIMIT 1]; 
  System.assertEquals(true, trans.AQB__Do_not_push_to_Accounting__c);
  
} 

/**
 * @description:annualFundPayment
 * @Comments: Check situation where Source of Data is Annual Fund Lockbox  and Type is
 * Payment 
**/     
static testmethod void annualFundPayment(){
  //ADD BATCH DATA
  AQB__Batch__c batch = mda_TestDataFactory.createBatch('Annual Fund Lockbox',true);        
  //ADD ACCOUNT DATA
  Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
  //QUERY OTHER OBJECTS  
  AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
  AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
  //Query COA        
  //AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324' LIMIT 1];

  //Add Transactions
  AQB__Transaction__c trans1 = new AQB__Transaction__c();
  //Core Fields
  trans1.AQB__Date__c = date.today();
  trans1.AQB__Account__c = acc.Id; 
  trans1.AQB__Batch__c = batch.Id;
  trans1.AQB__Acknowledgement__c = ack.Id; 
  trans1.AQB__ChartofAccounts__c = aoc.Id;
  trans1.mda_testRecord__c = true;
  //Test Data
  trans1.AQB__Type__c = 'Payment';
  trans1.AQB__ThirdPartyPayoff__c = false;
  //
  trans1.AQB__PledgePayment__c = false;

  insert trans1;

        
 
  Test.startTest();
  mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
  Database.executeBatch(b);
  Test.stopTest();  
  
  AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
  AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
  mda_testRecord__c = true LIMIT 1]; 
  Assert.areEqual(coa.Id, trans.AQB__DebitAccount__c );
  Assert.areEqual(coa.Id, trans.MDA_Debit_Account__c);
  Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
  Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
  
} 

/**
 * @description:annualFundPledgePayment
 * @Comments: Check situation where Source of Data is Annual Fund Lockbox  and Type is
 * Payment with Pledge Payment
**/     
static testmethod void annualFundPledgePayment(){
  //ADD BATCH DATA
  AQB__Batch__c batch = mda_TestDataFactory.createBatch('Annual Fund Lockbox',true);        
  //ADD ACCOUNT DATA
  Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
  //QUERY OTHER OBJECTS  
  AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
  AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
  //Query COA        
  //AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324' LIMIT 1];

  //Add Transactions
  AQB__Transaction__c trans1 = new AQB__Transaction__c();
  //Core Fields
  trans1.AQB__Date__c = date.today();
  trans1.AQB__Account__c = acc.Id; 
  trans1.AQB__Batch__c = batch.Id;
  trans1.AQB__Acknowledgement__c = ack.Id; 
  trans1.AQB__ChartofAccounts__c = aoc.Id;
  trans1.mda_testRecord__c = true;
  //Test Data
  trans1.AQB__Type__c = 'Payment';
  trans1.AQB__ThirdPartyPayoff__c = false;
  //
  trans1.AQB__PledgePayment__c = true;
  trans1.AQB__PledgeStipulation__c = 'Conditional';

  insert trans1;

        
 
  Test.startTest();
  mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
  Database.executeBatch(b);
  Test.stopTest();  
  
  AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
  AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
  mda_testRecord__c = true LIMIT 1]; 
  Assert.areEqual(coa.Id, trans.AQB__DebitAccount__c );
  Assert.areEqual(coa.Id, trans.MDA_Debit_Account__c);
  Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
  Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
  
} 

/**
 * @description:annualFundPledgePaymentUncon
 * @Comments: Check situation where Source of Data is Annual Fund Lockbox  and Type is
 * Payment with Pledge Payment and Unconditinal Pledge Stipulation
**/     
static testmethod void annualFundPledgePaymentUncon(){
  //ADD BATCH DATA
  AQB__Batch__c batch = mda_TestDataFactory.createBatch('Annual Fund Lockbox',true);        
  //ADD ACCOUNT DATA
  Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
  //QUERY OTHER OBJECTS  
  AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
  AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
  //Query COA        
  //AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324' LIMIT 1];

  //Add Transactions
  AQB__Transaction__c trans1 = new AQB__Transaction__c();
  //Core Fields
  trans1.AQB__Date__c = date.today();
  trans1.AQB__Account__c = acc.Id; 
  trans1.AQB__Batch__c = batch.Id;
  trans1.AQB__Acknowledgement__c = ack.Id; 
  trans1.AQB__ChartofAccounts__c = aoc.Id;
  trans1.mda_testRecord__c = true;
  //Test Data
  trans1.AQB__Type__c = 'Payment';
  trans1.AQB__ThirdPartyPayoff__c = false;
  //
  trans1.AQB__PledgePayment__c = true;
  trans1.AQB__PledgeStipulation__c = 'Unconditional';

  insert trans1;

        
 
  Test.startTest();
  mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
  Database.executeBatch(b);
  Test.stopTest();  
  
  AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
  AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
  mda_testRecord__c = true LIMIT 1]; 
  Assert.areEqual(coa.Id, trans.AQB__DebitAccount__c );
  Assert.areEqual(coa.Id, trans.MDA_Debit_Account__c);
  Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
  Assert.areEqual('Manual-Historical', trans.MDA_GL_Posting_Type__c);
  
} 

/**
 * @description:mailFalsepledgePayment
 * @Comments: Check situation where Source of Data is Mail and Type is
 * Payment with Pledge Payment and False Pledge Payment
**/     
static testmethod void mailFalsepledgePayment(){
  //ADD BATCH DATA
  AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
  //ADD ACCOUNT DATA
  Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
  //QUERY OTHER OBJECTS  
  AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
  AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
  //Query COA        
  //AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324' LIMIT 1];

  //Add Transactions
  AQB__Transaction__c trans1 = new AQB__Transaction__c();
  //Core Fields
  trans1.AQB__Date__c = date.today();
  trans1.AQB__Account__c = acc.Id; 
  trans1.AQB__Batch__c = batch.Id;
  trans1.AQB__Acknowledgement__c = ack.Id; 
  trans1.AQB__ChartofAccounts__c = aoc.Id;
  trans1.mda_testRecord__c = true;
  //Test Data
  trans1.AQB__Type__c = 'Payment';
  trans1.AQB__ThirdPartyPayoff__c = false;
  //
  trans1.AQB__PledgePayment__c = false;
  trans1.AQB__Method__c = 'Credit Card';

  insert trans1;

        
 
  Test.startTest();
  mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
  Database.executeBatch(b);
  Test.stopTest();  
  
  AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
  AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
  mda_testRecord__c = true LIMIT 1]; 
  Assert.areEqual(coa2.Id, trans.AQB__DebitAccount__c );
  Assert.areEqual(coa2.Id, trans.MDA_Debit_Account__c);
  Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
  Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
  
} 

/**
 * @description:mailFalsepledgePaymentDataSource
 * @Comments: Check situation where Source of Data is Mail and Type is
 * Payment with Pledge Payment and False Pledge Payment
**/     
static testmethod void mailFalsepledgePaymenDataSource(){
  //ADD BATCH DATA
  AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
  //ADD ACCOUNT DATA
  Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
  //QUERY OTHER OBJECTS  
  AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
  AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
  //Query COA        
  //AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324' LIMIT 1];

  //Add Transactions
  AQB__Transaction__c trans1 = new AQB__Transaction__c();
  //Core Fields
  trans1.AQB__Date__c = date.today();
  trans1.AQB__Account__c = acc.Id; 
  trans1.AQB__Batch__c = batch.Id;
  trans1.AQB__Acknowledgement__c = ack.Id; 
  trans1.AQB__ChartofAccounts__c = aoc.Id;
  trans1.mda_testRecord__c = true;
  //Test Data
  trans1.AQB__Type__c = 'Payment';
  trans1.AQB__ThirdPartyPayoff__c = false;
  //
  trans1.AQB__PledgePayment__c = false;
  trans1.AQB__Method__c = 'Transfer';

  insert trans1;

        
 
  Test.startTest();
  mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
  Database.executeBatch(b);
  Test.stopTest();  
  
  AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
  AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
  mda_testRecord__c = true LIMIT 1]; 
  Assert.areEqual(coa3.Id, trans.AQB__DebitAccount__c );
  Assert.areEqual(coa3.Id, trans.MDA_Debit_Account__c);
  Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
  Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
  
} 

/**
 * @description:mailFalsepledgePaymentDataSource
 * @Comments: Check situation where Source of Data is Mail and Type is
 * Payment with Pledge Payment and True Pledge Payment
**/     
static testmethod void mailTruepledgePaymenDataSource(){
  //ADD BATCH DATA
  AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
  //ADD ACCOUNT DATA
  Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
  //QUERY OTHER OBJECTS  
  AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
  AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
  //Query COA        
  //AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324' LIMIT 1];

  //Add Transactions
  AQB__Transaction__c trans1 = new AQB__Transaction__c();
  //Core Fields
  trans1.AQB__Date__c = date.today();
  trans1.AQB__Account__c = acc.Id; 
  trans1.AQB__Batch__c = batch.Id;
  trans1.AQB__Acknowledgement__c = ack.Id; 
  trans1.AQB__ChartofAccounts__c = aoc.Id;
  trans1.mda_testRecord__c = true;
  //Test Data
  trans1.AQB__Type__c = 'Payment';
  trans1.AQB__ThirdPartyPayoff__c = false;
  //
  trans1.AQB__PledgePayment__c = true;
  trans1.AQB__PledgeStipulation__c = 'Conditional';
  trans1.AQB__Method__c = 'Credit Card';

  insert trans1;

        
 
  Test.startTest();
  mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
  Database.executeBatch(b);
  Test.stopTest();  
  
  AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
  AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
  mda_testRecord__c = true LIMIT 1]; 
  Assert.areEqual(coa2.Id, trans.AQB__DebitAccount__c );
  Assert.areEqual(coa2.Id, trans.MDA_Debit_Account__c);
  Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
  Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
  
} 

/**
 * @description:mailFalsepledgePaymentDataSourceCon
 * @Comments: Check situation where Source of Data is Mail and Type is
 * Payment with Pledge Payment and True Pledge Payment
**/     
static testmethod void mailTruepledgePaymenDataSourceCon(){
  //ADD BATCH DATA
  AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
  //ADD ACCOUNT DATA
  Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
  //QUERY OTHER OBJECTS  
  AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
  AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
  //Query COA        
  //AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324' LIMIT 1];

  //Add Transactions
  AQB__Transaction__c trans1 = new AQB__Transaction__c();
  //Core Fields
  trans1.AQB__Date__c = date.today();
  trans1.AQB__Account__c = acc.Id; 
  trans1.AQB__Batch__c = batch.Id;
  trans1.AQB__Acknowledgement__c = ack.Id; 
  trans1.AQB__ChartofAccounts__c = aoc.Id;
  trans1.mda_testRecord__c = true;
  //Test Data
  trans1.AQB__Type__c = 'Payment';
  trans1.AQB__ThirdPartyPayoff__c = false;
  //
  trans1.AQB__PledgePayment__c = true;
  trans1.AQB__PledgeStipulation__c = 'Conditional';
  trans1.AQB__Method__c = 'Transfer';

  insert trans1;

        
 
  Test.startTest();
  mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
  Database.executeBatch(b);
  Test.stopTest();  
  
  AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
  AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
  mda_testRecord__c = true LIMIT 1]; 
  Assert.areEqual(coa3.Id, trans.AQB__DebitAccount__c );
  Assert.areEqual(coa3.Id, trans.MDA_Debit_Account__c);
  Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
  Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
  
} 

/**
 * @description:mailTruepledgePaymenDataSourceUnCon
 * @Comments: Check situation where Source of Data is Mail and Type is
 * Payment with Pledge Payment and True Pledge Payment and Unconditional Stipulation
**/     
static testmethod void mailTruepledgePaymenDataSourceUnCon(){
  //ADD BATCH DATA
  AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
  //ADD ACCOUNT DATA
  Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
  //QUERY OTHER OBJECTS  
  AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
  AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
  //Query COA        
  //AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324' LIMIT 1];

  //Add Transactions
  AQB__Transaction__c trans1 = new AQB__Transaction__c();
  //Core Fields
  trans1.AQB__Date__c = date.today();
  trans1.AQB__Account__c = acc.Id; 
  trans1.AQB__Batch__c = batch.Id;
  trans1.AQB__Acknowledgement__c = ack.Id; 
  trans1.AQB__ChartofAccounts__c = aoc.Id;
  trans1.mda_testRecord__c = true;
  //Test Data
  trans1.AQB__Type__c = 'Payment';
  trans1.AQB__ThirdPartyPayoff__c = false;
  //
  trans1.AQB__PledgePayment__c = true;
  trans1.AQB__PledgeStipulation__c = 'Unconditional';
  trans1.AQB__Method__c = 'Credit Card';

  insert trans1;

        
 
  Test.startTest();
  mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
  Database.executeBatch(b);
  Test.stopTest();  
  
  AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
  AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
  mda_testRecord__c = true LIMIT 1]; 
  Assert.areEqual(coa2.Id, trans.AQB__DebitAccount__c );
  Assert.areEqual(coa2.Id, trans.MDA_Debit_Account__c);
  Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
  Assert.areEqual('Manual-Historical', trans.MDA_GL_Posting_Type__c);
  
} 


/**
 * @description:mailTruepledgePaymenDataSourceUnConTr
 * @Comments: Check situation where Source of Data is Mail and Type is
 * Payment with Pledge Payment and True Pledge Payment
**/     
static testmethod void mailTruepledgePaymenDataSourceUnConTr(){
  //ADD BATCH DATA
  AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
  //ADD ACCOUNT DATA
  Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
  //QUERY OTHER OBJECTS  
  AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
  AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
  //Query COA        
  //AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324' LIMIT 1];

  //Add Transactions
  AQB__Transaction__c trans1 = new AQB__Transaction__c();
  //Core Fields
  trans1.AQB__Date__c = date.today();
  trans1.AQB__Account__c = acc.Id; 
  trans1.AQB__Batch__c = batch.Id;
  trans1.AQB__Acknowledgement__c = ack.Id; 
  trans1.AQB__ChartofAccounts__c = aoc.Id;
  trans1.mda_testRecord__c = true;
  //Test Data
  trans1.AQB__Type__c = 'Payment';
  trans1.AQB__ThirdPartyPayoff__c = false;
  //
  trans1.AQB__PledgePayment__c = true;
  trans1.AQB__PledgeStipulation__c = 'Unconditional';
  trans1.AQB__Method__c = 'Transfer';

  insert trans1;

        
 
  Test.startTest();
  mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
  Database.executeBatch(b);
  Test.stopTest();  
  
  AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
  AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
  mda_testRecord__c = true LIMIT 1]; 
  Assert.areEqual(coa3.Id, trans.AQB__DebitAccount__c );
  Assert.areEqual(coa3.Id, trans.MDA_Debit_Account__c);
  Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
  Assert.areEqual('Manual-Historical', trans.MDA_GL_Posting_Type__c);
  
} 


/**
 * @description:adjFalsePledgeUnique
 * @Comments: Check Situation of Adjustment with Unique Batch Item Id.
**/     
static testmethod void adjFalsePledgeUnique(){
  //ADD BATCH DATA
  AQB__Batch__c batch = mda_TestDataFactory.createBatchGP('Adjustments',true);        
  //ADD ACCOUNT DATA
  Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
  //QUERY OTHER OBJECTS  
  AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
  AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
  //Query COA        
  //AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324' LIMIT 1];

  //Add Transactions
  AQB__Transaction__c trans1 = new AQB__Transaction__c();
  //Core Fields
  trans1.AQB__Date__c = date.today();
  trans1.AQB__Account__c = acc.Id; 
  trans1.AQB__Batch__c = batch.Id;
  trans1.AQB__Acknowledgement__c = ack.Id; 
  trans1.AQB__ChartofAccounts__c = aoc.Id;
  trans1.mda_testRecord__c = true;
  //Test Data
  trans1.AQB__Type__c ='Payment';
  trans1.AQB__PledgePayment__c = false;
  trans1.AQB__ThirdPartyPayoff__c = false;
  trans1.AQB__VoidedTransaction__c = mda_TestDataFactory.chooseVoidedTransaction().Id;

  //

 

  insert trans1;

        
 
  Test.startTest();
  mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
  Database.executeBatch(b);
  Test.stopTest();  
  
  AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
  AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
  mda_testRecord__c = true LIMIT 1]; 
  Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c );
  Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Debit_Account__c);
  Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
  Assert.areEqual(true,  trans.MDA_Credit_Debit_Account_Error__c);
  
} 

/**
 * @description:adjFalsePledgeNonUnique
 * @Comments: Check Situation of Adjustment with Non Unique Batch Item Id.
**/     
static testmethod void adjFalsePledgeNonUnique(){
  //ADD BATCH DATA
  AQB__Batch__c batch = mda_TestDataFactory.createBatchGP('Adjustments',true);        
  //ADD ACCOUNT DATA
  Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
  //QUERY OTHER OBJECTS  
  AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
  AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
  //Query COA        
  //AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90 -11324' LIMIT 1];

  //Add Transactions
  AQB__Transaction__c trans1 = new AQB__Transaction__c();
  //Core Fields
  trans1.AQB__Date__c = date.today();
  trans1.AQB__Account__c = acc.Id; 
  trans1.AQB__Batch__c = batch.Id;
  trans1.AQB__Acknowledgement__c = ack.Id; 
  trans1.AQB__ChartofAccounts__c = aoc.Id;
  trans1.mda_testRecord__c = true;
  //Test Data
  trans1.AQB__Type__c ='Payment';
  trans1.AQB__PledgePayment__c = false;
  trans1.AQB__ThirdPartyPayoff__c = false;
  trans1.AQB__VoidedTransaction__c = mda_TestDataFactory.chooseVoidedTransaction().Id;

  //

 

  insert trans1;

        
 
  Test.startTest();
  mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
  Database.executeBatch(b);
  Test.stopTest();  
  
  AQB__Transaction__c trans =[Select Id,AQB__Do_not_push_to_Accounting__c,
  AQB__FinancialSystemDate__c, MDA_Journal_ID__c, 
  MDA_Original_Transaction__c, MDA_Related_Void_Transaction__c, MDA_Credit_Debit_Account_Error__c, mda_testRecord__c, MDA_GL_Posting_Type__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
  mda_testRecord__c = true LIMIT 1]; 
  Assert.areEqual(true, trans.AQB__Do_not_push_to_Accounting__c );
  
} 


}