/**
 * Apex Class Name      : mda_transactionHistoricalUpdateTest
 * Created Date         : February 26, 2024 
 * @description         : This class is used to test code for mda_updateTransAdjV2.
 * @author              : M. Eleanya (Contractor: Precision Partners) 
**/

@isTest(seeAllData=True)
public with sharing class mda_updateTransAdjV2Test {
    private static final AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c 
    WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90-11324' LIMIT 1];
  
    private static final AQB__LLChartofAccounts__c coa2 = [Select Id, AQB__DesignationAccountNumber__c from AQB__LLChartofAccounts__c 
    WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];
    
    private static final AQB__LLChartofAccounts__c coa3 = [Select Id, AQB__DesignationAccountNumber__c from AQB__LLChartofAccounts__c 
    WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1];  

    private static final Set<String> dataSource = new Set<String>{'Mail','Institutional Lockbox', 'Children\'s Art Project (CAP)', 'Live Check / Credit Card (MD Anderson Front Office)', 
                                                'MDA Treasury', 'Special Events Lockbox', 'MDA Cashier Office', 'Online - Donation Sites',
                                                 'Online - Peer 2 Peer Sites', 'UT Foundation'}; 
    private static final Set<String> paymentMethod = new Set<String>{'Cash','Check','Securities','ACH','Wire', 'Paypal', 'Transfer'};
    private static final Set<String> designationAccountType = new Set<String>{'Endowment','Quasi Endowment'};    

/**
 * @description:voidedDonations
 * Scenario 119A - Voided donations that were entered using a GIfts/Pledges Batch Type - linked to the Voided Transaction; Voided Transaction Source of Data is Annual Fund
**/ 
static testmethod void voidedDonations(){

    Set<Id> originalId = new Set<Id>{};
    Set<Id> correctedId =  new Set<Id>{};
    
    AQB__Transaction__c[] originalTrans = [Select Id, mda_testRecord__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c, 
    AQB__Gift__c from  AQB__Transaction__c WHERE AQB__VoidedTransaction__c != Null AND AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__PledgePayment__c = false 
    AND AQB__ThirdPartyPayoff__c = false AND  AQB__ChartofAccounts__r.AQB__Account_Type__c != NULL 
    AND AQB__ChartofAccounts__r.AQB__Account_Type__c NOT IN :designationAccountType
    AND AQB__VoidedTransaction__r.AQB__SourceofData__c ='Annual Fund Lockbox' AND AQB__SourceofData__c = 'Adjustments'];

    
    for (AQB__Transaction__c trans1 :originalTrans){
                AQB__Transaction__c[] correctTrans = [Select Id
                from AQB__Transaction__c WHERE AQB__Gift__c = :trans1.AQB__Gift__c AND 
                AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :trans1.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c AND Id != :trans1.Id]; 
                    if(correctTrans.size() == 0) {           
                        originalId.add(trans1.Id);
                        break;
                    } 

    }

    AQB__Transaction__c transUpdate = [Select Id from AQB__Transaction__c WHERE Id IN:originalId];
    Id transUpdateId = transUpdate.Id;
    transUpdate.mda_testRecord__c = true;
    update transUpdate;

    Test.startTest();
    mda_updateTransAdjV2 b = new mda_updateTransAdjV2();
    Database.executeBatch(b);
    Test.stopTest();

    AQB__Transaction__c trans = [Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Debit_Account__c,AQB__ChartofAccounts__c, MDA_Credit_AccountLookup__c,
    MDA_GL_Posting_Type__c, MDA_Credit_Debit_Account_Error__c FROM AQB__Transaction__c  WHERE Id = :transUpdateId AND mda_testRecord__c = true ];
    Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Debit_Account__c);
    Assert.areEqual(coa.Id, trans.MDA_Credit_AccountLookup__c);
    Assert.areEqual('Automated-Historical',   trans.MDA_GL_Posting_Type__c);
    Assert.areEqual(false, trans.MDA_Credit_Debit_Account_Error__c);

   

    }

/**
 * @description:voidedTransactionsLinked
 * 119B - Voided donations that were entered using a GIfts/Pledges Batch Type - linked to the Voided Transaction; Voided Transaction Source of Data is Other Sources that Post to GL;  funds received via Credit Card
**/ 

static testmethod void voidedTransactionsLinked(){
    Set<Id> originalId = new Set<Id>{};
    Set<Id> correctedId =  new Set<Id>{};
    
    AQB__Transaction__c[] originalTrans = [Select Id, mda_testRecord__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c, 
    AQB__Gift__c from  AQB__Transaction__c WHERE AQB__VoidedTransaction__c != Null AND AQB__Type__c = 'Payment' AND AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__PledgePayment__c = false 
    AND AQB__ThirdPartyPayoff__c = false AND AQB__Method__c ='Credit Card' AND AQB__ChartofAccounts__r.AQB__Account_Type__c != NULL 
    AND AQB__ChartofAccounts__r.AQB__Account_Type__c NOT IN :designationAccountType AND AQB__SourceofData__c = 'Adjustments'];

    
    for (AQB__Transaction__c trans1 :originalTrans){
                AQB__Transaction__c[] correctTrans = [Select Id
                from AQB__Transaction__c WHERE AQB__Gift__c = :trans1.AQB__Gift__c AND 
                AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :trans1.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c AND Id != :trans1.Id]; 
                    if(correctTrans.size() == 0) {           
                        originalId.add(trans1.Id);
                        break;
                    } 

    }

    AQB__Transaction__c transUpdate = [Select Id from AQB__Transaction__c WHERE Id IN:originalId];
    Id transUpdateId = transUpdate.Id;
    transUpdate.mda_testRecord__c = true;
    update transUpdate;

    Test.startTest();
    mda_updateTransAdjV2 b = new mda_updateTransAdjV2();
    Database.executeBatch(b);
    Test.stopTest();

    AQB__Transaction__c trans = [Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Debit_Account__c,AQB__ChartofAccounts__c, MDA_Credit_AccountLookup__c,
    MDA_GL_Posting_Type__c, MDA_Credit_Debit_Account_Error__c FROM AQB__Transaction__c  WHERE Id = :transUpdateId AND mda_testRecord__c = true ];
    
    Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Debit_Account__c);
    Assert.areEqual(coa2.Id, trans.MDA_Credit_AccountLookup__c);
    Assert.areEqual('Automated-Historical',   trans.MDA_GL_Posting_Type__c);
    Assert.areEqual(false, trans.MDA_Credit_Debit_Account_Error__c);

   

}



/**
 * @description:voidedGiftPledges
 * 119C - Voided donations that were entered using a GIfts/Pledges Batch Type - linked to the Voided Transaction; Voided Transaction Source of Data is Other Sources that Post to GL;  funds received via ACH, Cash, Check, PayPal, Securities, Transfer, Wire
**/ 

static testmethod void voidedGiftPledges(){
    Set<Id> originalId = new Set<Id>{};
    Set<Id> correctedId =  new Set<Id>{};
    
    AQB__Transaction__c[] originalTrans = [Select Id, mda_testRecord__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c, 
    AQB__Gift__c from  AQB__Transaction__c WHERE AQB__VoidedTransaction__c != Null AND AQB__Type__c = 'Payment' AND AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__PledgePayment__c = false 
    AND AQB__ThirdPartyPayoff__c = false AND AQB__Method__c IN :paymentMethod  AND AQB__ChartofAccounts__r.AQB__Account_Type__c != NULL 
    AND AQB__ChartofAccounts__r.AQB__Account_Type__c NOT IN :designationAccountType
    AND AQB__VoidedTransaction__r.AQB__SourceofData__c IN :dataSource AND AQB__SourceofData__c = 'Adjustments'];

    
    for (AQB__Transaction__c trans1 :originalTrans){
                AQB__Transaction__c[] correctTrans = [Select Id
                from AQB__Transaction__c WHERE AQB__Gift__c = :trans1.AQB__Gift__c AND 
                AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :trans1.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c AND Id != :trans1.Id]; 
                    if(correctTrans.size() == 0) {           
                        originalId.add(trans1.Id);
                        break;
                    } 

    }

    AQB__Transaction__c transUpdate = [Select Id from AQB__Transaction__c WHERE Id IN:originalId];
    Id transUpdateId = transUpdate.Id;
    transUpdate.mda_testRecord__c = true;
    update transUpdate;

    Test.startTest();
    mda_updateTransAdjV2 b = new mda_updateTransAdjV2();
    Database.executeBatch(b);
    Test.stopTest();

    AQB__Transaction__c trans = [Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Debit_Account__c,AQB__ChartofAccounts__c, MDA_Credit_AccountLookup__c,
    MDA_GL_Posting_Type__c, MDA_Credit_Debit_Account_Error__c FROM AQB__Transaction__c  WHERE Id = :transUpdateId AND mda_testRecord__c = true AND AQB__SourceofData__c = 'Adjustments' ];
    
    Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Debit_Account__c);
    Assert.areEqual(coa3.Id, trans.MDA_Credit_AccountLookup__c);
    Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
    Assert.areEqual(false, trans.MDA_Credit_Debit_Account_Error__c);

   

}

//119D -Voided donations that were entered using a GIfts/Pledges Batch Type - linked to the Voided Transaction; Voided Transaction Source of Data is null
static testmethod void voidedLinked(){
    Set<Id> originalId = new Set<Id>{};
    Set<Id> correctedId =  new Set<Id>{};
    
    AQB__Transaction__c[] originalTrans = [Select Id, mda_testRecord__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c, 
    AQB__Gift__c from  AQB__Transaction__c WHERE AQB__VoidedTransaction__c != Null AND AQB__Type__c = 'Payment' AND AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__PledgePayment__c = false 
    AND AQB__ThirdPartyPayoff__c = false AND AQB__VoidedTransaction__r.AQB__SourceofData__c = Null AND AQB__SourceofData__c = 'Adjustments'];

    
    for (AQB__Transaction__c trans1 :originalTrans){
                AQB__Transaction__c[] correctTrans = [Select Id
                from AQB__Transaction__c WHERE AQB__Gift__c = :trans1.AQB__Gift__c AND 
                AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :trans1.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c AND Id != :trans1.Id]; 
                    if(correctTrans.size() == 0) {           
                        originalId.add(trans1.Id);
                        break;
                    } 

    }

    // AQB__Transaction__c transUpdate = [Select Id from AQB__Transaction__c WHERE Id IN:originalId];
    // Id transUpdateId = transUpdate.Id;
    // transUpdate.mda_testRecord__c = true;
    // update transUpdate;

    Test.startTest();
    mda_updateTransAdjV2 b = new mda_updateTransAdjV2();
    Database.executeBatch(b);
    Test.stopTest();

    // AQB__Transaction__c trans = [Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Debit_Account__c,AQB__ChartofAccounts__c, MDA_Credit_AccountLookup__c,
    // MDA_GL_Posting_Type__c, MDA_Credit_Debit_Account_Error__c FROM AQB__Transaction__c  WHERE Id = :transUpdateId AND mda_testRecord__c = true ];
    
    // Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    // Assert.areEqual(trans.AQB__ChartofAccounts__c, trans.MDA_Debit_Account__c);
    // Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
    // Assert.areEqual(false, trans.MDA_Credit_Debit_Account_Error__c);

}

//119E - Voided donations that were entered using a GIfts/Pledges Batch Type - linked to the Voided Transaction; Account Type is Endowment

static testmethod void voidedDonationsEntered(){
    Set<Id> originalId = new Set<Id>{};
    Set<Id> correctedId =  new Set<Id>{};
    
    AQB__Transaction__c[] originalTrans = [Select Id, mda_testRecord__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c, 
    AQB__Gift__c from  AQB__Transaction__c WHERE AQB__VoidedTransaction__c != Null AND AQB__Type__c = 'Payment' AND AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__PledgePayment__c = false 
    AND AQB__ThirdPartyPayoff__c = false AND AQB__ChartofAccounts__r.AQB__Account_Type__c != NULL 
    AND AQB__ChartofAccounts__r.AQB__Account_Type__c IN :designationAccountType AND AQB__SourceofData__c = 'Adjustments'];

    
    for (AQB__Transaction__c trans1 :originalTrans){
                AQB__Transaction__c[] correctTrans = [Select Id
                from AQB__Transaction__c WHERE AQB__Gift__c = :trans1.AQB__Gift__c AND 
                AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :trans1.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c AND Id != :trans1.Id]; 
                    if(correctTrans.size() == 0) {           
                        originalId.add(trans1.Id);
                        break;
                    } 

    }

    AQB__Transaction__c transUpdate = [Select Id from AQB__Transaction__c WHERE Id IN:originalId];
    Id transUpdateId = transUpdate.Id;
    transUpdate.mda_testRecord__c = true;
    update transUpdate;

    Test.startTest();
    mda_updateTransAdjV2 b = new mda_updateTransAdjV2();
    Database.executeBatch(b);
    Test.stopTest();

    AQB__Transaction__c trans = [Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Debit_Account__c,AQB__ChartofAccounts__c, MDA_Credit_AccountLookup__c,
    MDA_GL_Posting_Type__c, MDA_Credit_Debit_Account_Error__c FROM AQB__Transaction__c  WHERE Id = :transUpdateId AND mda_testRecord__c = true ];
    
    Assert.areEqual(true, trans.AQB__Do_not_push_to_Accounting__c);
    

}
//119F- Voided donations that were entered using a GIfts/Pledges Batch Type - linked to the Voided Transaction; Account Type is Missing
static testmethod void missingAccounts(){
    Set<Id> originalId = new Set<Id>{};
    Set<Id> correctedId =  new Set<Id>{};
    
    AQB__Transaction__c[] originalTrans = [Select Id, mda_testRecord__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c, 
    AQB__Gift__c from  AQB__Transaction__c WHERE AQB__VoidedTransaction__c != Null AND AQB__Type__c = 'Payment' AND AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__PledgePayment__c = false 
    AND AQB__ThirdPartyPayoff__c = false 
    AND AQB__ChartofAccounts__r.AQB__Account_Type__c = NULL AND AQB__SourceofData__c = 'Adjustments' ];

    
    for (AQB__Transaction__c trans1 :originalTrans){
                AQB__Transaction__c[] correctTrans = [Select Id
                from AQB__Transaction__c WHERE AQB__Gift__c = :trans1.AQB__Gift__c AND 
                AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :trans1.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c AND Id != :trans1.Id]; 
                    if(correctTrans.size() == 0) {           
                        originalId.add(trans1.Id);
                        break;
                    } 

    }

    // AQB__Transaction__c transUpdate = [Select Id from AQB__Transaction__c WHERE Id IN:originalId];
    // Id transUpdateId = transUpdate.Id;
    // transUpdate.mda_testRecord__c = true;
    // update transUpdate;

    Test.startTest();
    mda_updateTransAdjV2 b = new mda_updateTransAdjV2();
    Database.executeBatch(b);
    Test.stopTest();

    // AQB__Transaction__c trans = [Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Debit_Account__c,AQB__ChartofAccounts__c, MDA_Credit_AccountLookup__c,
    // MDA_GL_Posting_Type__c, MDA_Credit_Debit_Account_Error__c FROM AQB__Transaction__c  WHERE Id = :transUpdateId AND mda_testRecord__c = true ];
    
    // Assert.areEqual(true, trans.AQB__Do_not_push_to_Accounting__c);
    

}
// 120 - Adjusted Donations that were entered using a GIfts/Pledges Batch Type, but is not linked to the Voided Transaction


static testmethod void adjustedDonations(){
    Set<Id> originalId = new Set<Id>{};
    Set<Id> correctedId =  new Set<Id>{};
    
    AQB__Transaction__c[] originalTrans = [Select Id, mda_testRecord__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c, 
    AQB__Gift__c from  AQB__Transaction__c WHERE AQB__VoidedTransaction__c = Null AND AQB__Type__c = 'Payment' AND AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__PledgePayment__c = false 
    AND AQB__ThirdPartyPayoff__c = false AND AQB__SourceofData__c = 'Adjustments'];

//     Select Id, mda_testRecord__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c, 
// AQB__Gift__c from  AQB__Transaction__c WHERE AQB__VoidedTransaction__c = Null AND AQB__Type__c = 'Payment' AND AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false 

    
    for (AQB__Transaction__c trans1 :originalTrans){
                AQB__Transaction__c[] correctTrans = [Select Id
                from AQB__Transaction__c WHERE AQB__Gift__c = :trans1.AQB__Gift__c AND 
                AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :trans1.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c AND Id != :trans1.Id]; 
                    if(correctTrans.size() == 0) {           
                        originalId.add(trans1.Id);
                        break;
                    } 

    }

    AQB__Transaction__c transUpdate = [Select Id from AQB__Transaction__c WHERE Id IN:originalId];
    Id transUpdateId = transUpdate.Id;
    transUpdate.mda_testRecord__c = true;
    update transUpdate;

    Test.startTest();
    mda_updateTransAdjV2 b = new mda_updateTransAdjV2();
    Database.executeBatch(b);
    Test.stopTest();

    AQB__Transaction__c trans = [Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Credit_Debit_Account_Error__c, MDA_Debit_Account__c,AQB__ChartofAccounts__c, MDA_Credit_AccountLookup__c,
    MDA_GL_Posting_Type__c FROM AQB__Transaction__c  WHERE Id = :transUpdateId AND mda_testRecord__c = true ];


    
    Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
    Assert.areEqual(true, trans.MDA_Credit_Debit_Account_Error__c);

}

// 121A-Adjusted pledge payment that were entered using a GIfts/Pledges Batch Type - Conditional Pledge

static testmethod void adjustedPlege(){
    Set<Id> originalId = new Set<Id>{};
    Set<Id> correctedId =  new Set<Id>{};
    
    AQB__Transaction__c[] originalTrans = [Select Id, mda_testRecord__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c, 
    AQB__Gift__c from  AQB__Transaction__c WHERE AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__Type__c = 'Payment' AND AQB__PledgePayment__c = true 
    AND AQB__ThirdPartyPayoff__c = false AND AQB__PledgeStipulation__c = 'Conditional' AND AQB__SourceofData__c = 'Adjustments'];

    
    for (AQB__Transaction__c trans1 :originalTrans){
                AQB__Transaction__c[] correctTrans = [Select Id
                from AQB__Transaction__c WHERE AQB__Gift__c = :trans1.AQB__Gift__c AND 
                AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :trans1.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c AND Id != :trans1.Id]; 
                    if(correctTrans.size() == 0) {           
                        originalId.add(trans1.Id);
                        break;
                    } 

    }

    // AQB__Transaction__c transUpdate = [Select Id from AQB__Transaction__c WHERE Id IN:originalId];
    // Id transUpdateId = transUpdate.Id;
    // transUpdate.mda_testRecord__c = true;
    // update transUpdate;

    Test.startTest();
    mda_updateTransAdjV2 b = new mda_updateTransAdjV2();
    Database.executeBatch(b);
    Test.stopTest();

    // AQB__Transaction__c trans = [Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Debit_Account__c,AQB__ChartofAccounts__c, MDA_Credit_AccountLookup__c,
    // MDA_GL_Posting_Type__c, MDA_Credit_Debit_Account_Error__c FROM AQB__Transaction__c  WHERE Id = :transUpdateId AND mda_testRecord__c = true ];
    
    // Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    // Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
    // Assert.areEqual(true, trans.MDA_Credit_Debit_Account_Error__c);

}

//121B-Voided pledge payment that were entered using a GIfts/Pledges Batch Type - Unconditional Pledge

static testmethod void voidedUnconditional(){
    Set<Id> originalId = new Set<Id>{};
    Set<Id> correctedId =  new Set<Id>{};
    
    AQB__Transaction__c originalTrans = [Select Id, mda_testRecord__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c, 
    AQB__Gift__c from  AQB__Transaction__c WHERE AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__Type__c = 'Payment' AND AQB__PledgePayment__c = true 
    AND AQB__ThirdPartyPayoff__c = false AND AQB__PledgeStipulation__c = 'Unconditional' AND AQB__SourceofData__c = 'Adjustments' LIMIT 1];

    
    AQB__Transaction__c transUpdate = [Select Id from AQB__Transaction__c WHERE Id = :originalTrans.Id];
    Id transUpdateId = transUpdate.Id;
    transUpdate.mda_testRecord__c = true;
    update transUpdate;

    Test.startTest();
    mda_updateTransAdjV2 b = new mda_updateTransAdjV2();
    Database.executeBatch(b);
    Test.stopTest();

    AQB__Transaction__c trans = [Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Debit_Account__c,AQB__ChartofAccounts__c, MDA_Credit_AccountLookup__c,
    MDA_GL_Posting_Type__c, MDA_Credit_Debit_Account_Error__c FROM AQB__Transaction__c  WHERE Id = :transUpdateId AND mda_testRecord__c = true ];
    System.debug('testId ===>' + trans.Id);
    
    Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual('Manual-Historical', trans.MDA_GL_Posting_Type__c);
    Assert.areEqual(true, trans.MDA_Credit_Debit_Account_Error__c);
    

}

//121C- Voided pledge payment that were entered using a GIfts/Pledges Batch Type - Missing Pledge Type; Voided Transaction is Conditional OR NULL
static testmethod void missingPledgeType(){
    Set<Id> originalId = new Set<Id>{};
    Set<Id> correctedId =  new Set<Id>{};
    
    AQB__Transaction__c originalTrans = [Select Id, mda_testRecord__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c, 
    AQB__Gift__c from  AQB__Transaction__c WHERE AQB__VoidedTransaction__c != Null AND AQB__Type__c = 'Payment' AND AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__PledgePayment__c = true 
    AND AQB__ThirdPartyPayoff__c = false AND AQB__PledgeStipulation__c = Null
    AND (AQB__VoidedTransaction__r.AQB__PledgeStipulation__c = Null OR AQB__VoidedTransaction__r.AQB__PledgeStipulation__c = 'Conditional') AND AQB__SourceofData__c = 'Adjustments' LIMIT 1];

    
    AQB__Transaction__c transUpdate = [Select Id from AQB__Transaction__c WHERE Id = :originalTrans.Id];
    Id transUpdateId = transUpdate.Id;
    transUpdate.mda_testRecord__c = true;
    update transUpdate;

    Test.startTest();
    mda_updateTransAdjV2 b = new mda_updateTransAdjV2();
    Database.executeBatch(b);
    Test.stopTest();

    AQB__Transaction__c trans = [Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Debit_Account__c,AQB__ChartofAccounts__c, MDA_Credit_AccountLookup__c,
    MDA_GL_Posting_Type__c, MDA_Credit_Debit_Account_Error__c FROM AQB__Transaction__c  WHERE Id = :transUpdateId AND mda_testRecord__c = true ];
    System.debug('testId ===>' + trans.Id);
    
    Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
    Assert.areEqual(true, trans.MDA_Credit_Debit_Account_Error__c);
    

}

 //121D - Voided pledge payment that were entered using a GIfts/Pledges Batch Type - Missing Pledge Type; Voided Transaction is Unconditional
 static testmethod void voidedUnconditionalPay(){
    Set<Id> originalId = new Set<Id>{};
    Set<Id> correctedId =  new Set<Id>{};
    
    AQB__Transaction__c originalTrans = [Select Id, mda_testRecord__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c, 
    AQB__Gift__c from  AQB__Transaction__c WHERE AQB__VoidedTransaction__c != Null AND AQB__Type__c = 'Payment' AND AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__PledgePayment__c = true 
    AND AQB__ThirdPartyPayoff__c = false AND AQB__PledgeStipulation__c = Null
    AND AQB__VoidedTransaction__r.AQB__PledgeStipulation__c = 'Unconditional' AND AQB__SourceofData__c = 'Adjustments' LIMIT 1];

    
    // AQB__Transaction__c transUpdate = [Select Id from AQB__Transaction__c WHERE Id = :originalTrans.Id];
    // Id transUpdateId = transUpdate.Id;
    // transUpdate.mda_testRecord__c = true;
    // update transUpdate;

    Test.startTest();
    mda_updateTransAdjV2 b = new mda_updateTransAdjV2();
    Database.executeBatch(b);
    Test.stopTest();

    // AQB__Transaction__c trans = [Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Debit_Account__c,AQB__ChartofAccounts__c, MDA_Credit_AccountLookup__c,
    // MDA_GL_Posting_Type__c, MDA_Credit_Debit_Account_Error__c FROM AQB__Transaction__c  WHERE Id = :transUpdateId AND mda_testRecord__c = true ];
    // System.debug('testId ===>' + trans.Id);
    
    // Assert.areEqual(false, trans.AQB__Do_not_push_to_Accounting__c);
    // Assert.areEqual('Automated-Historical', trans.MDA_GL_Posting_Type__c);
    // Assert.areEqual(true, trans.MDA_Credit_Debit_Account_Error__c);
    

}

//122-Adjusted donation that was entered using a GIfts/Pledges Batch Type - the Void and Correct Feature was Used; This is the Voided Transaction
static testmethod void adjustedVoided(){
    Set<Id> originalId = new Set<Id>{};
    Set<Id> correctedId =  new Set<Id>{};
    
    AQB__Transaction__c[] originalTrans = [Select Id, mda_testRecord__c, AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c, 
    AQB__Gift__c from  AQB__Transaction__c WHERE AQB__VoidedTransaction__c != Null AND AQB__Type__c = 'Payment' AND AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__PledgePayment__c = false 
    AND AQB__ThirdPartyPayoff__c = false AND AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__r.AQB__Method__c = 'Void' AND AQB__SourceofData__c = 'Adjustments'];

    
    for (AQB__Transaction__c trans1 :originalTrans){
        AQB__Transaction__c[] correctTrans = [Select Id
        from AQB__Transaction__c WHERE AQB__Gift__c = :trans1.AQB__Gift__c AND 
        AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c = :trans1.AQB__OriginatingBatchItemTransaction__r.AQB__BatchItemID__c AND Id != :trans1.Id]; 
            if(correctTrans.size() > 0) {           
                originalId.add(trans1.Id);
                break;
            } 

}

AQB__Transaction__c transUpdate = [Select Id from AQB__Transaction__c WHERE Id IN:originalId];
Id transUpdateId = transUpdate.Id;
transUpdate.mda_testRecord__c = true;
update transUpdate;

    Test.startTest();
    mda_updateTransAdjV2 b = new mda_updateTransAdjV2();
    Database.executeBatch(b);
    Test.stopTest();

    AQB__Transaction__c trans = [Select Id, AQB__Do_not_push_to_Accounting__c, MDA_Debit_Account__c,AQB__ChartofAccounts__c, MDA_Credit_AccountLookup__c,
    MDA_GL_Posting_Type__c, MDA_Credit_Debit_Account_Error__c FROM AQB__Transaction__c  WHERE Id = :transUpdateId AND mda_testRecord__c = true ];   
    
    Assert.areEqual(true, trans.AQB__Do_not_push_to_Accounting__c);    

}
 //123A - Adjusted  donation that was entered using a GIfts/Pledges Batch Type - the Void and Correct Feature was Used; This is the Corrected Transaction;  properly linked to the Void Transaction; Old Designation is a Gift Fund, Non-Endowment; New Designation is a Gift Fund, Non-Endowment


}