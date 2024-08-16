
/**
 * Apex Class Name      : mda_transactionHistoricalUpdateTest
 * Created Date         : February 26, 2024 
 * @description         : This class is used to test code for mda_updateTransNonAdj.
 * @author              : M. Eleanya (Contractor: Precision Partners) 
**/


@isTest(seeAllData=True)
public with sharing class mda_updateTransNonAdjTest {

private static final AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c 
    WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90-11324' LIMIT 1];
        
private static final  AQB__LLChartofAccounts__c coa2 = [Select Id, AQB__DesignationAccountNumber__c from AQB__LLChartofAccounts__c 
    WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];
        
private static final AQB__LLChartofAccounts__c coa3 = [Select Id, AQB__DesignationAccountNumber__c from AQB__LLChartofAccounts__c 
    WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];  
        
private static final Set<String> dataSource = new Set<String>{'Mail','Institutional Lockbox', 'Children\'s Art Project (CAP)', 'Live Check / Credit Card (MD Anderson Front Office)', 
                                                  'MDA Treasury', 'Special Events Lockbox', 'MDA Cashier Office', 'Online - Donation Sites',
                                                   'Online - Peer 2 Peer Sites', 'UT Foundation'};  
private static final Set<String> paymentMethod = new Set<String>{'Cash','Check','Securities','ACH','Wire', 'Paypal', 'Transfer'};

/**
 * @description:pledgeTruePayment
 * //Scenario 105: New and Adjusted Pledges, Matching Gifts, Planned Gifts
**/ 

static testmethod void pledgeFalsePayment(){

    AQB__Transaction__c  trans105 =[Select Id, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__Type__c = 'Pledge' AND AQB__ThirdPartyPayoff__c = false AND AQB__PledgePayment__c = false
    LIMIT 1];
        
    trans105.mda_testRecord__c = true;
   
    update trans105;
  
            
     
      Test.startTest();
      mda_updateTransNonAdj b = new mda_updateTransNonAdj();
      Database.executeBatch(b);
      Test.stopTest();  
      
      AQB__Transaction__c trans =[Select Id, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
      WHERE AQB__Type__c = 'Pledge' AND AQB__ThirdPartyPayoff__c = false AND AQB__PledgePayment__c = false AND
      mda_testRecord__c = true LIMIT 1]; 
      System.assertEquals(true, trans.AQB__Do_not_push_to_Accounting__c);
      
  } 
/**
 * @description:newAdjGrant
 * 106 - New and Adjusted Grants
**/ 

    static testmethod void newAdjGrant(){
        AQB__Transaction__c trans106 =[Select Id, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
        WHERE AQB__Type__c = 'Grant' AND AQB__ThirdPartyPayoff__c = false AND AQB__PledgePayment__c = false LIMIT 1];

        trans106.mda_testRecord__c = true;
        update trans106;

        Test.startTest();
        mda_updateTransNonAdj b = new mda_updateTransNonAdj();
        Database.executeBatch(b);
        Test.stopTest();  

        AQB__Transaction__c trans =[Select Id, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
        WHERE AQB__Type__c = 'Grant' AND AQB__ThirdPartyPayoff__c = false AND AQB__PledgePayment__c = false 
        AND mda_testRecord__c = true LIMIT 1];

        System.assertEquals(true, trans.AQB__Do_not_push_to_Accounting__c);
    }

/**
 * @description:gpGrantCGR
 * Scenario 107: Grant Payments where the source is the Click Grants Report 
**/ 

static testmethod void gpGrantCGR(){
    AQB__Transaction__c trans107 =[Select Id, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c = 'Grants Management System' AND (AQB__Type__c = 'Grant Payment' OR AQB__Type__c = 'Payment') 
    AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false LIMIT 1];

    trans107.mda_testRecord__c = true;
    update trans107;

    Test.startTest();
    mda_updateTransNonAdj b = new mda_updateTransNonAdj();
    Database.executeBatch(b);
    Test.stopTest();  

    AQB__Transaction__c trans =[Select Id, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c = 'Grants Management System' AND (AQB__Type__c = 'Grant Payment' OR AQB__Type__c = 'Payment') 
    AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false
    AND mda_testRecord__c = true LIMIT 1];

    System.assertEquals(true, trans.AQB__Do_not_push_to_Accounting__c);
}

/**
 * @description:oPaymentCGR
 * Scenario 108:Grant Overpayment where the source is the Click Grants Report
**/ 

static testmethod void oPaymentCGR(){
    AQB__Transaction__c trans108 =[Select Id, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c = 'Grants Management System' AND (AQB__Type__c = 'Grant Payment' OR AQB__Type__c = 'Payment') 
    AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false LIMIT 1];

    trans108.mda_testRecord__c = true;
    update trans108;

    Test.startTest();
    mda_updateTransNonAdj b = new mda_updateTransNonAdj();
    Database.executeBatch(b);
    Test.stopTest();  

    AQB__Transaction__c trans =[Select Id, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c = 'Grants Management System' AND (AQB__Type__c = 'Grant Payment' OR AQB__Type__c = 'Payment') 
    AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false AND mda_testRecord__c = true LIMIT 1];

    System.assertEquals(true, trans.AQB__Do_not_push_to_Accounting__c);
}

/**
 * @description:giftsKind
 * Scenario 109: Gifts in Kind
**/ 

static testmethod void giftsKind(){
    AQB__Transaction__c trans109 =[Select Id, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__Type__c = 'Payment' AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false AND
    AQB__SourceofData__c = 'Gift in Kind Form / Documentation' LIMIT 1];

    trans109.mda_testRecord__c = true;
    update trans109;

    Test.startTest();
    mda_updateTransNonAdj b = new mda_updateTransNonAdj();
    Database.executeBatch(b);
    Test.stopTest();  

    AQB__Transaction__c trans =[Select Id, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__Type__c = 'Payment' AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false AND
    AQB__SourceofData__c = 'Gift in Kind Form / Documentation' AND mda_testRecord__c = true LIMIT 1];

    System.assertEquals(true, trans.AQB__Do_not_push_to_Accounting__c);
}

/**
 * @description:pCageAFL
 * Scenario 110:Payments from Caging - Annual Fund Lockbox 
**/ 

static testmethod void pCageAFL(){
    AQB__Transaction__c trans110 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__Type__c = 'Payment' AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false AND 
    AQB__SourceofData__c = 'Annual Fund Lockbox' AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' LIMIT 1];

    trans110.mda_testRecord__c = true;
    update trans110;

    Test.startTest();
    mda_updateTransNonAdj b = new mda_updateTransNonAdj();
    Database.executeBatch(b);
    Test.stopTest();  

    AQB__Transaction__c trans =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__Type__c = 'Payment' AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false AND 
    AQB__SourceofData__c = 'Annual Fund Lockbox' AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND mda_testRecord__c = true LIMIT 1];

    System.assertEquals(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(coa.Id, trans.AQB__DebitAccount__c);
    Assert.areEqual(coa.Id, trans.MDA_Debit_Account__c);
    Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
}

/**
 * @description:conditionalPPC
 * Scenario 111:Conditional Pledge Payments from Caging - Annual Fund Lockbox
**/ 

static testmethod void conditionalPPC(){
    AQB__Transaction__c trans111 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__Type__c = 'Payment' AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false AND 
    AQB__SourceofData__c = 'Annual Fund Lockbox' AND AQB__PledgeStipulation__c = 'Conditional' AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' LIMIT 1];

    trans111.mda_testRecord__c = true;
    update trans111;

    Test.startTest();
    mda_updateTransNonAdj b = new mda_updateTransNonAdj();
    Database.executeBatch(b);
    Test.stopTest();  

    AQB__Transaction__c trans =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__Type__c = 'Payment' AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false AND 
    AQB__SourceofData__c = 'Annual Fund Lockbox' AND AQB__PledgeStipulation__c = 'Conditional' AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND mda_testRecord__c = true LIMIT 1];

    System.assertEquals(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(coa.Id, trans.AQB__DebitAccount__c);
    Assert.areEqual(coa.Id, trans.MDA_Debit_Account__c);
    Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
}

/**
 * @description:unconditionalPPC
 * Scenario 112: Unconditional Pledge Payments from Caging - Annual Fund Lockbox
**/ 

static testmethod void unconditionalPPC(){
    AQB__Transaction__c trans112 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__Type__c = 'Payment' AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false AND 
    AQB__SourceofData__c = 'Annual Fund Lockbox' AND AQB__PledgeStipulation__c = 'Unconditional' AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' LIMIT 1];

    trans112.mda_testRecord__c = true;
    update trans112;

    Test.startTest();
    mda_updateTransNonAdj b = new mda_updateTransNonAdj();
    Database.executeBatch(b);
    Test.stopTest();  

    AQB__Transaction__c trans =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__Type__c = 'Payment' AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false AND 
    AQB__SourceofData__c = 'Annual Fund Lockbox' AND AQB__PledgeStipulation__c = 'Unconditional' AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND mda_testRecord__c = true LIMIT 1];

    System.assertEquals(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(coa.Id, trans.AQB__DebitAccount__c);
    Assert.areEqual(coa.Id, trans.MDA_Debit_Account__c);
    Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
}

/**
 * @description:dsPostGL
 * Scenario 113: Donations from Sources that Post to the GL; funds received via credit card 
**/ 

static testmethod void dsPostGL(){
    AQB__Transaction__c trans113 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false
    AND AQB__Method__c = 'Credit Card'  AND AQB__Type__c = 'Payment' AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' LIMIT 1];

    trans113.mda_testRecord__c = true;
    update trans113;

    Test.startTest();
    mda_updateTransNonAdj b = new mda_updateTransNonAdj();
    Database.executeBatch(b);
    Test.stopTest();  

    AQB__Transaction__c trans =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false
    AND AQB__Method__c = 'Credit Card'  AND AQB__Type__c = 'Payment' AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND mda_testRecord__c = true LIMIT 1];

    System.assertEquals(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(coa2.Id, trans.AQB__DebitAccount__c);
    Assert.areEqual(coa2.Id, trans.MDA_Debit_Account__c);
    Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
}

/**
 *  @description:dsPostGLPayment
 *  Scenario 114: Donations from Sources that Post to the GL; funds received via ACH, Cash, Check, PayPal,Securities, Transfer, Wire            
**/ 

static testmethod void dsPostGLPayment(){
    AQB__Transaction__c trans114 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false
    AND AQB__Method__c IN :paymentMethod AND AQB__Type__c = 'Payment' AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' LIMIT 1];

    trans114.mda_testRecord__c = true;
    update trans114;

    Test.startTest();
    mda_updateTransNonAdj b = new mda_updateTransNonAdj();
    Database.executeBatch(b);
    Test.stopTest();  

    AQB__Transaction__c trans =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false
    AND AQB__Method__c IN :paymentMethod AND AQB__Type__c = 'Payment' AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND mda_testRecord__c = true LIMIT 1];

    System.assertEquals(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(coa3.Id, trans.AQB__DebitAccount__c);
    Assert.areEqual(coa3.Id, trans.MDA_Debit_Account__c);
    Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
}

/**
 *  @description:dsPostGLCredit
 *  Scenario 115: Conditional Pledge Payments from Sources that Post to the GL; funds received via credit card  
**/ 

static testmethod void dsPostGLCredit(){
    AQB__Transaction__c trans115 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false
    AND AQB__Method__c ='Credit Card' AND (AQB__PledgeStipulation__c = 'Conditional' OR AQB__PledgeStipulation__c = Null) AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__Type__c = 'Payment'  LIMIT 1];

    trans115.mda_testRecord__c = true;
    update trans115;

    Test.startTest();
    mda_updateTransNonAdj b = new mda_updateTransNonAdj();
    Database.executeBatch(b);
    Test.stopTest();  

    AQB__Transaction__c trans =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false
    AND AQB__Method__c ='Credit Card' AND (AQB__PledgeStipulation__c = 'Conditional' OR AQB__PledgeStipulation__c = Null) AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__Type__c = 'Payment'  AND mda_testRecord__c = true LIMIT 1];

    System.assertEquals(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(coa2.Id, trans.AQB__DebitAccount__c);
    Assert.areEqual(coa2.Id, trans.MDA_Debit_Account__c);
    Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
}

/**
 *  @description:conditionalPPCredit
 *  Scenario 116:Conditional Pledge Payments from Sources that Post to the GL; funds received via ACH, Cash, Check, PayPal, Securities, Transfer, Wire  
**/ 

static testmethod void conditionalPPCredit(){
    AQB__Transaction__c trans116 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false
    AND AQB__Method__c IN :paymentMethod AND (AQB__PledgeStipulation__c = 'Conditional' OR AQB__PledgeStipulation__c = Null) AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND(AQB__Type__c = 'Payment' OR AQB__Type__c = 'Grant Payment') LIMIT 1];

    trans116.mda_testRecord__c = true;
    update trans116;

    Test.startTest();
    mda_updateTransNonAdj b = new mda_updateTransNonAdj();
    Database.executeBatch(b);
    Test.stopTest();  

    AQB__Transaction__c trans =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false
    AND AQB__Method__c IN :paymentMethod AND (AQB__PledgeStipulation__c = 'Conditional' OR AQB__PledgeStipulation__c = Null) AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND(AQB__Type__c = 'Payment' OR AQB__Type__c = 'Grant Payment')  AND mda_testRecord__c = true LIMIT 1];

    System.assertEquals(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(coa2.Id, trans.AQB__DebitAccount__c);
    Assert.areEqual(coa2.Id, trans.MDA_Debit_Account__c);
    Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
}

/**
 *  @description:unconditionalPPFunds
 *  Scenario 117:Unconditional Pledge Payments from Sources that Post to the GL; funds received via credit card 
**/ 

static testmethod void unconditionalPPFunds(){
    AQB__Transaction__c trans117 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false
    AND AQB__Method__c ='Credit Card' AND AQB__PledgeStipulation__c = 'Unconditional' AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__Type__c = 'Payment' LIMIT 1];

    trans117.mda_testRecord__c = true;
    update trans117;

    Test.startTest();
    mda_updateTransNonAdj b = new mda_updateTransNonAdj();
    Database.executeBatch(b);
    Test.stopTest();  

    AQB__Transaction__c trans =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false
    AND AQB__Method__c ='Credit Card' AND AQB__PledgeStipulation__c = 'Unconditional' AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__Type__c = 'Payment' AND mda_testRecord__c = true LIMIT 1];

    System.assertEquals(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(coa2.Id, trans.AQB__DebitAccount__c);
    Assert.areEqual(coa2.Id, trans.MDA_Debit_Account__c);
    Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
}

/**
 *  @description:unconditionalPPMultiple
 *  Scenario 118:Unconditional Pledge Payments from Sources that Post to the GL; funds received via ACH, Cash, Check, PayPal, Securities, Transfer, Wire 
**/ 

static testmethod void unconditionalPPMultiple(){
    AQB__Transaction__c trans118 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false
    AND AQB__Method__c IN :paymentMethod AND AQB__PledgeStipulation__c = 'Unconditional' AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__Type__c = 'Payment' LIMIT 1];

    trans118.mda_testRecord__c = true;
    update trans118;

    Test.startTest();
    mda_updateTransNonAdj b = new mda_updateTransNonAdj();
    Database.executeBatch(b);
    Test.stopTest();  

    AQB__Transaction__c trans =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false
    AND AQB__Method__c IN :paymentMethod AND AQB__PledgeStipulation__c = 'Unconditional' AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__Type__c = 'Payment' AND mda_testRecord__c = true LIMIT 1];

    System.assertEquals(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(coa3.Id, trans.AQB__DebitAccount__c);
    Assert.areEqual(coa3.Id, trans.MDA_Debit_Account__c);
    Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Credit_AccountLookup__c);
    Assert.areEqual('Manual-Historical', trans.MDA_GL_Posting_Type__c);
}


//END OF CODE
    }