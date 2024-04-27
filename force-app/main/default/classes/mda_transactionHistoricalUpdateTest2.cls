/**
 * Apex Class Name      : mda_transactionHistoricalUpdateTest
 * Created Date         : February 26, 2024 
 * @description         : This class is used to test code for mda_transactionHistoricalRecordUpdate.
 * @author              : M. Eleanya (Contractor: Precision Partners) 
**/


@isTest(seeAllData=True)
public class mda_transactionHistoricalUpdateTest2 {
 /**
 * @description:Scenario 1
 * @Comments: Check situation where Batch Source of Data is "Annual Fund Lockbox" and Transaction Type is "Payment"
**/     
    static testmethod void scenario1(){
        //ADD BATCH DATA
    	AQB__Batch__c batch = mda_TestDataFactory.createBatch('Annual Fund Lockbox',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
        //Query COA        
      	AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108380-19-11324' LIMIT 1];

        //Add Transactions
        AQB__Transaction__c trans1 = new AQB__Transaction__c();
        trans1.AQB__Account__c = acc.Id; 
        trans1.AQB__Date__c = date.today();
        trans1.AQB__Reference__c= '1';
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
        
        AQB__Transaction__c uTrans1 =[Select Id, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '1' LIMIT 1];       
        System.assertEquals(uTrans1.AQB__DebitAccount__c , coa.Id);
        System.assertEquals(uTrans1.MDA_Debit_Account__c , coa.Id);
        System.assertEquals(uTrans1.MDA_Debit_Account_Number__c , coa.AQB__DesignationAccountNumber__c);
        System.assertEquals(uTrans1.MDA_Credit_AccountLookup__c, uTrans1.AQB__ChartofAccounts__c);
        System.assertEquals(uTrans1.MDA_Credit_Account_Number__c, uTrans1.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
 	
    } 
    
 /**
 * @description:Scenario 2
 * @Comments: Check situation where Batch Source of Data 
 * is "Annual Fund Lockbox" and Transaction Type is anything but "Soft Credit"
**/
    static testmethod void scenario2(){
        //ADD BATCH DATA
    	AQB__Batch__c batch = mda_TestDataFactory.createBatch('Annual Fund Lockbox',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
        //Query COA        
      	AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108380-19-11324' LIMIT 1];

        //Add Transactions
        AQB__Transaction__c trans1 = new AQB__Transaction__c();
        trans1.AQB__Account__c = acc.Id; 
        trans1.AQB__Date__c = date.today();
        trans1.AQB__Reference__c= '2';
        trans1.AQB__Type__c = ''; 
		trans1.AQB__Batch__c = batch.Id;
        trans1.AQB__VoidedTransaction__c = NULL;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id; 
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest();  
        
        AQB__Transaction__c uTrans1 =[Select Id, MDA_Credit_Debit_Account_Error__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '2' LIMIT 1];       
        System.assertEquals(uTrans1.MDA_Credit_Debit_Account_Error__c, True);

   	
    }
 /**
 * @description:Scenario 3
 * @Comments: Check situation where Batch Source of Data 
 * is Mail Transaction Type is "Grant Payment" and Payment Method is "Check"
**/
    static testmethod void scenario3(){
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
        trans1.AQB__Reference__c= '3';
        trans1.AQB__Type__c = 'Grant Payment';
        trans1.AQB__Method__c = 'Check';
		trans1.AQB__Batch__c = batch.Id;
        trans1.AQB__VoidedTransaction__c = NULL;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id; 
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest();  
        
        AQB__Transaction__c uTrans1 =[Select Id, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '3' LIMIT 1];       
        System.assertEquals(uTrans1.AQB__DebitAccount__c , coa.Id);
        System.assertEquals(uTrans1.MDA_Debit_Account__c , coa.Id);
        System.assertEquals(uTrans1.MDA_Debit_Account_Number__c , coa.AQB__DesignationAccountNumber__c);
        System.assertEquals(uTrans1.MDA_Credit_AccountLookup__c, uTrans1.AQB__ChartofAccounts__c);
        System.assertEquals(uTrans1.MDA_Credit_Account_Number__c, uTrans1.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);

   	
    }
 /**
 * @description:Scenario 4
 * @Comments: Check situation where Batch Source of Data 
 * is Mail and Transaction Type is "Grant Payment" and Payment Method is "Real Property"
**/
    static testmethod void scenario4(){
        //ADD BATCH DATA
    	AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();      
        //Query COA        
      	AQB__LLChartofAccounts__c coa = [Select Id,  AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];

        //Add Transactions
        AQB__Transaction__c trans1 = new AQB__Transaction__c();
        trans1.AQB__Account__c = acc.Id; 
        trans1.AQB__Date__c = date.today();
        trans1.AQB__Reference__c= '4';
        trans1.AQB__Type__c = 'Grant Payment';
        trans1.AQB__Method__c= 'Real Property';
		trans1.AQB__Batch__c = batch.Id;
        trans1.AQB__VoidedTransaction__c = NULL;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id; 
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest();  
        
        AQB__Transaction__c uTrans1 =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '4' LIMIT 1]; 
        System.assertEquals(uTrans1.MDA_Credit_Debit_Account_Error__c, True);
   	
    }
    
/**
 * @description:Scenario 5
 * @Comments: Check situation where Batch Source of Data 
 * is Mail and Transaction Type is "Payment" and Pledge Payment is "True" 
 * and Pledge Stipulation is "Conditional" and Transaction Method is "Check"
**/
    static testmethod void scenario5(){
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
        trans1.AQB__Reference__c= '5';
        trans1.AQB__Type__c = 'Payment';
        trans1.AQB__Method__c = 'Check';
		trans1.AQB__Batch__c = batch.Id;
        trans1.AQB__VoidedTransaction__c = NULL;
        trans1.AQB__PledgePayment__c = true;
        trans1.AQB__PledgeStipulation__c = 'Conditional';
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id; 
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest();  
        
        AQB__Transaction__c uTrans1 =[Select Id, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '5' LIMIT 1];       
        System.assertEquals(uTrans1.AQB__DebitAccount__c , coa.Id);
        System.assertEquals(uTrans1.MDA_Debit_Account__c , coa.Id);
        System.assertEquals(uTrans1.MDA_Debit_Account_Number__c , coa.AQB__DesignationAccountNumber__c);
        System.assertEquals(uTrans1.MDA_Credit_AccountLookup__c, uTrans1.AQB__ChartofAccounts__c);
        System.assertEquals(uTrans1.MDA_Credit_Account_Number__c, uTrans1.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);

   	
    }
    
/**
 * @description:Scenario 6
 * @Comments: Check situation where Batch Source of Data 
 * is Mail and Transaction Type is "Payment" and Pledge Payemnt 
 * is "True" and Pledge Stipulation is "Conditional" and Transaction Method is "Credit Card"
**/
    static testmethod void scenario6(){
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
        trans1.AQB__Reference__c= '6';
        trans1.AQB__Type__c = 'Payment';
        trans1.AQB__Method__c = 'Credit Card';
		trans1.AQB__Batch__c = batch.Id;
        trans1.AQB__VoidedTransaction__c = NULL;
        trans1.AQB__PledgePayment__c = true;
        trans1.AQB__PledgeStipulation__c = 'Conditional';
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id; 
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest();  
        
        AQB__Transaction__c uTrans1 =[Select Id, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '6' LIMIT 1];       
        System.assertEquals(uTrans1.AQB__DebitAccount__c , coa.Id);
        System.assertEquals(uTrans1.MDA_Debit_Account__c , coa.Id);
        System.assertEquals(uTrans1.MDA_Debit_Account_Number__c , coa.AQB__DesignationAccountNumber__c);
        System.assertEquals(uTrans1.MDA_Credit_AccountLookup__c, uTrans1.AQB__ChartofAccounts__c);
        System.assertEquals(uTrans1.MDA_Credit_Account_Number__c, uTrans1.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);

   	
    }
    
/**
 * @description:Scenario 7
 * @Comments: Check situation where Batch Source of Data 
 * is Mail and Transaction Type is "Payment" and Pledge Payment 
 * is "True" and Pledge Stipulation is "Conditional" and Transaction Method is "Real Property"
**/
    static testmethod void scenario7(){
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
        trans1.AQB__Reference__c= '7';
        trans1.AQB__Type__c = 'Payment';
        trans1.AQB__Method__c = 'Real Property';
		trans1.AQB__Batch__c = batch.Id;
        trans1.AQB__VoidedTransaction__c = NULL;
        trans1.AQB__PledgePayment__c = true;
        trans1.AQB__PledgeStipulation__c = 'Conditional';
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id; 
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest();  
        
                
        AQB__Transaction__c uTrans1 =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '7' LIMIT 1]; 
        System.assertEquals(uTrans1.MDA_Credit_Debit_Account_Error__c, True);
   	
    }
    
/**
 * @description:Scenario 8
 * @Comments: Check situation where Batch Source of Data 
 * is Mail and Transaction Type is "Payment" and Pledge Payment 
 * is "False" and Transaction Method is "Cash" and Transaction Type is "Payment"
**/
    static testmethod void scenario8(){
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
        trans1.AQB__Reference__c= '8';
        trans1.AQB__Type__c = 'Payment';
        trans1.AQB__Method__c = 'Cash';
		trans1.AQB__Batch__c = batch.Id;
        trans1.AQB__VoidedTransaction__c = NULL;
        trans1.AQB__PledgePayment__c = false;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id; 
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest();  
        
                
        AQB__Transaction__c uTrans1 =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '8' LIMIT 1]; 
        System.assertEquals(uTrans1.AQB__DebitAccount__c , coa.Id);
        System.assertEquals(uTrans1.MDA_Debit_Account__c , coa.Id);
        System.assertEquals(uTrans1.MDA_Debit_Account_Number__c , coa.AQB__DesignationAccountNumber__c);
        System.assertEquals(uTrans1.MDA_Credit_AccountLookup__c, uTrans1.AQB__ChartofAccounts__c);
        System.assertEquals(uTrans1.MDA_Credit_Account_Number__c, uTrans1.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);

   	
    }
    
/**
 * @description:Scenario 9
 * @Comments: Check situation where Batch Source of Data 
 * is Mail and Transaction Type is "Payment" and Pledge Payment 
 * is "False" and Transaction Method is "Credit Card" and Transaction Type is "Payment"
**/
    static testmethod void scenario9(){
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
        trans1.AQB__Reference__c= '9';
        trans1.AQB__Type__c = 'Payment';
        trans1.AQB__Method__c = 'Credit Card';
		trans1.AQB__Batch__c = batch.Id;
        trans1.AQB__VoidedTransaction__c = NULL;
        trans1.AQB__PledgePayment__c = false;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id; 
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest();  
        
                
        AQB__Transaction__c uTrans1 =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '9' LIMIT 1]; 
        System.assertEquals(uTrans1.AQB__DebitAccount__c , coa.Id);
        System.assertEquals(uTrans1.MDA_Debit_Account__c , coa.Id);
        System.assertEquals(uTrans1.MDA_Debit_Account_Number__c , coa.AQB__DesignationAccountNumber__c);
        System.assertEquals(uTrans1.MDA_Credit_AccountLookup__c, uTrans1.AQB__ChartofAccounts__c);
        System.assertEquals(uTrans1.MDA_Credit_Account_Number__c, uTrans1.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);

   	
    }
    
/**
 * @description:Scenario 10
 * @Comments: Check situation where Batch Source of Data 
 * is Mail Pledge Payment is "False" Transaction Type is "Payment" Transaction Method is "Real Property"
**/
    static testmethod void scenario10(){
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
        trans1.AQB__Reference__c= '10';
        trans1.AQB__Type__c = 'Payment';
        trans1.AQB__Method__c = 'Real Property';
		trans1.AQB__Batch__c = batch.Id;
        trans1.AQB__VoidedTransaction__c = NULL;
        trans1.AQB__PledgePayment__c = false;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id; 
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest(); 
        
        
        AQB__Transaction__c uTrans1 =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '10' LIMIT 1]; 
        System.assertEquals(uTrans1.MDA_Credit_Debit_Account_Error__c, True);
       
    }
/**
 * @description:Scenario 11
 * @Comments: Check situation where Batch Source of Data 
 * is Mail and Transaction Type is "Transfer" 
**/
    static testmethod void scenario11(){
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
        trans1.AQB__Reference__c= '11';
        trans1.AQB__Type__c = 'Transfer';
		trans1.AQB__Batch__c = batch.Id;
        trans1.AQB__VoidedTransaction__c = NULL;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id; 
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest(); 
        
        
        AQB__Transaction__c uTrans1 =[Select Id, MDA_Credit_Debit_Account_Error__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, AQB__DebitAccount__r.MDACC_COAExternalID__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '11' LIMIT 1]; 
        System.assertEquals(uTrans1.MDA_Credit_Debit_Account_Error__c, True);
       
    }

/**
 * @description:Scenario 12
 * @Comments: Check situation where Transaction is "Null", there is a "Corrected Transaction" 
 * and Transaction Type is "Grant Payment"
**/
    static testmethod void scenario12(){
        //ADD BATCH DATA
    	//AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
        //Get Voided Transaction Record
        AQB__Transaction__c trans = mda_TestDataFactory.chooseVoidedTransaction();
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
        trans1.AQB__Reference__c= '12';
        trans1.AQB__Type__c = 'Grant Payment';
        trans1.AQB__VoidedTransaction__c = trans.Id;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id;
        trans1.AQB__OriginatingBatchItemTransaction__c = correctTrans.AQB__OriginatingBatchItemTransaction__c;
        trans1.AQB__Gift__c = correctTrans.AQB__Gift__c;
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest(); 
        
        
        AQB__Transaction__c uTrans1 =[Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '12' LIMIT 1];
        
        AQB__Transaction__c uCorrectTrans =[Select Id, AQB__DebitAccount__c, MDA_Credit_Account_Number__c, MDA_Credit_AccountLookup__c, MDA_Debit_Account_Number__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= 'correctTrans' LIMIT 1];
 
        System.assertEquals(uTrans1.AQB__Do_not_push_to_Accounting__c, True);
        System.assertEquals(uCorrectTrans.MDA_Credit_Account_Number__c, uCorrectTrans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
        System.assertEquals(uCorrectTrans.MDA_Credit_AccountLookup__c, uCorrectTrans.AQB__ChartofAccounts__c);
        System.assertEquals(uCorrectTrans.MDA_Debit_Account_Number__c, uTrans1.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
        System.assertEquals(uCorrectTrans.MDA_Debit_Account__c, uTrans1.AQB__ChartofAccounts__c);
        
    }
    
/**
 * @description:Scenario 13
 * @Comments: Check situation where Transaction is "Null", there is not a "Corrected Transaction" 
 * and Transaction Type is "Grant Payment"
**/
    static testmethod void scenario13(){
        //ADD BATCH DATA
    	//AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
        //Get Voided Transaction Record
        AQB__Transaction__c trans = mda_TestDataFactory.chooseVoidedTransaction();
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
        trans1.AQB__Reference__c= '13';
        trans1.AQB__Type__c = 'Grant Payment';
        trans1.AQB__VoidedTransaction__c = trans.Id;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id;

 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest(); 
        
        
        AQB__Transaction__c uTrans1 =[Select Id, AQB__Do_not_push_to_Accounting__c, AQB__DebitAccount__c, AQB__DebitAccount__r.AQB__DesignationAccountNumber__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '13' LIMIT 1];

      
          		 System.assertEquals(uTrans1.MDA_Credit_AccountLookup__c, uTrans1.AQB__DebitAccount__c);
                 System.assertEquals(uTrans1.MDA_Credit_Account_Number__c, uTrans1.AQB__DebitAccount__r.AQB__DesignationAccountNumber__c);
                 System.assertEquals(uTrans1.MDA_Debit_Account__c, uTrans1.AQB__ChartofAccounts__c);
                 System.assertEquals(uTrans1.MDA_Debit_Account_Number__c, uTrans1.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
    }
/**
 * @description:Scenario 14
 * @Comments: Check situation where Transaction is "Null", there is a "Corrected Transaction" 
 * and Transaction Type is "Payment"
**/
    static testmethod void scenario14(){
        //ADD BATCH DATA
    	//AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
        //Get Voided Transaction Record
        AQB__Transaction__c trans = mda_TestDataFactory.chooseVoidedTransaction();
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
        trans1.AQB__Reference__c= '14';
        trans1.AQB__Type__c = 'Payment';
        trans1.AQB__VoidedTransaction__c = trans.Id;
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
        
        
        AQB__Transaction__c uTrans1 =[Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '14' LIMIT 1];
        
        AQB__Transaction__c uCorrectTrans =[Select Id, AQB__DebitAccount__c, MDA_Credit_Account_Number__c, MDA_Credit_AccountLookup__c, MDA_Debit_Account_Number__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= 'correctTrans' LIMIT 1];
  
        System.assertEquals(uTrans1.AQB__Do_not_push_to_Accounting__c, True);
        System.assertEquals(uCorrectTrans.MDA_Credit_Account_Number__c, uCorrectTrans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
        System.assertEquals(uCorrectTrans.MDA_Credit_AccountLookup__c, uCorrectTrans.AQB__ChartofAccounts__c);
        System.assertEquals(uCorrectTrans.MDA_Debit_Account_Number__c, uTrans1.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
        System.assertEquals(uCorrectTrans.MDA_Debit_Account__c, uTrans1.AQB__ChartofAccounts__c);
      
    }
/**
 * @description:Scenario 15
 * @Comments: Check situation where Transaction is "Null", there is not a "Corrected Transaction" 
 * and Transaction Type is "Payment"
**/
    static testmethod void scenario15(){
        //ADD BATCH DATA
    	//AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
        //Get Voided Transaction Record
        AQB__Transaction__c trans = mda_TestDataFactory.chooseVoidedTransaction();
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
        trans1.AQB__Reference__c= '15';
        trans1.AQB__Type__c = 'Payment';
        trans1.AQB__VoidedTransaction__c = trans.Id;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id;
        trans1.AQB__PledgePayment__c = true;
        trans1.AQB__PledgeStipulation__c = 'Conditional';
 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest(); 
        
        
        AQB__Transaction__c uTrans1 =[Select Id,AQB__DebitAccount__c, AQB__DebitAccount__r.AQB__DesignationAccountNumber__c, AQB__Do_not_push_to_Accounting__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '15' LIMIT 1];

  
				 System.assertEquals(uTrans1.MDA_Credit_AccountLookup__c, uTrans1.AQB__DebitAccount__c);
                 System.assertEquals(uTrans1.MDA_Credit_Account_Number__c, uTrans1.AQB__DebitAccount__r.AQB__DesignationAccountNumber__c);
                 System.assertEquals(uTrans1.MDA_Debit_Account__c, uTrans1.AQB__ChartofAccounts__c);
                 System.assertEquals(uTrans1.MDA_Debit_Account_Number__c, uTrans1.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
    }
/**
 * @description:Scenario 16
 * @Comments: Check situation where Transaction is "Null", there is a "Corrected Transaction" 
 * and Transaction Type is "Payment"
**/
    static testmethod void scenario16(){
        //ADD BATCH DATA
    	//AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
        //Get Voided Transaction Record
        AQB__Transaction__c trans = mda_TestDataFactory.chooseVoidedTransaction();
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
        trans1.AQB__Reference__c= '16';
        trans1.AQB__Type__c = 'Payment';
        trans1.AQB__VoidedTransaction__c = trans.Id;
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
        
        
        AQB__Transaction__c uTrans1 =[Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '16' LIMIT 1];
        
        AQB__Transaction__c uCorrectTrans =[Select Id, AQB__DebitAccount__c, MDA_Credit_Account_Number__c, MDA_Credit_AccountLookup__c, MDA_Debit_Account_Number__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= 'correctTrans' LIMIT 1];
  
      System.assertEquals(uTrans1.AQB__Do_not_push_to_Accounting__c, True);
        System.assertEquals(uCorrectTrans.MDA_Credit_Account_Number__c, uCorrectTrans.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
        System.assertEquals(uCorrectTrans.MDA_Credit_AccountLookup__c, uCorrectTrans.AQB__ChartofAccounts__c);
        System.assertEquals(uCorrectTrans.MDA_Debit_Account_Number__c, uTrans1.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
        System.assertEquals(uCorrectTrans.MDA_Debit_Account__c, uTrans1.AQB__ChartofAccounts__c);
    }
/**
 * @description:Scenario 17
 * @Comments: Check situation where Transaction is "Null", there is not a "Corrected Transaction" 
 * and Transaction Type is "Payment"
**/
    static testmethod void scenario17(){
        //ADD BATCH DATA
    	//AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
        //Get Voided Transaction Record
        AQB__Transaction__c trans = mda_TestDataFactory.chooseVoidedTransaction();
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
        trans1.AQB__Reference__c= '17';
        trans1.AQB__Type__c = 'Payment';
        trans1.AQB__VoidedTransaction__c = trans.Id;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id;
        trans1.AQB__PledgePayment__c = false;

 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest(); 
        
        
        AQB__Transaction__c uTrans1 =[Select Id,AQB__DebitAccount__c, AQB__DebitAccount__r.AQB__DesignationAccountNumber__c, AQB__Do_not_push_to_Accounting__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '17' LIMIT 1];
        

  
    			 System.assertEquals(uTrans1.MDA_Credit_AccountLookup__c, uTrans1.AQB__DebitAccount__c);
                 System.assertEquals(uTrans1.MDA_Credit_Account_Number__c, uTrans1.AQB__DebitAccount__r.AQB__DesignationAccountNumber__c);
                 System.assertEquals(uTrans1.MDA_Debit_Account__c, uTrans1.AQB__ChartofAccounts__c);
                 System.assertEquals(uTrans1.MDA_Debit_Account_Number__c, uTrans1.AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c);
      
    }

/**
 * @description:Scenario 18
 * @Comments: Check situation where Transaction is "Null", there is not a "Corrected Transaction" 
 * and Transaction Type is "Transfer"
**/
    static testmethod void scenario18(){
        //ADD BATCH DATA
    	//AQB__Batch__c batch = mda_TestDataFactory.createBatch('Mail',true);        
        //ADD ACCOUNT DATA
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);              
        //QUERY OTHER OBJECTS  
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA(); 
        //Get Voided Transaction Record
        AQB__Transaction__c trans = mda_TestDataFactory.chooseVoidedTransaction();
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
        trans1.AQB__Reference__c= '18';
        trans1.AQB__Type__c = 'Transfer';
        trans1.AQB__VoidedTransaction__c = trans.Id;
        trans1.AQB__Acknowledgement__c = ack.Id; 
        trans1.AQB__ChartofAccounts__c = aoc.Id;
        trans1.AQB__PledgePayment__c = false;

 
        insert trans1;
              
        Test.startTest();
        mda_transactionHistoricalRecordUpdate b = new mda_transactionHistoricalRecordUpdate();
        Database.executeBatch(b);
        Test.stopTest(); 
        
        AQB__Transaction__c uTrans1 =[Select Id, MDA_Credit_Debit_Account_Error__c, AQB__Do_not_push_to_Accounting__c, MDA_Credit_AccountLookup__c, MDA_Credit_Account_Number__c, AQB__ChartofAccounts__r.AQB__DesignationAccountNumber__c, AQB__ChartofAccounts__c, MDA_Debit_Account__c, MDA_Debit_Account_Number__c  FROM AQB__Transaction__c WHERE 
        AQB__Reference__c= '18' LIMIT 1];
        
        system.AssertEquals(uTrans1.MDA_Credit_Debit_Account_Error__c, True);
        
    }
           
}