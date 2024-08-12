
/**
 * Apex Class Name      : mda_transactionHistoricalUpdateTest
 * Created Date         : February 26, 2024 
 * @description         : This class is used to test code for mda_updateTransNonAdj.
 * @author              : M. Eleanya (Contractor: Precision Partners) 
**/


@isTest(seeAllData=True)
public with sharing class mda_updateTransNonAdjTest {
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

/**
 * @description:pledgeTruePayment
 * @Comments: Check situation where Pledge Payment is False with no Third Party Payoff
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


    }