/**
 * Apex Class Name      : mda_COAbatchUpdateTest
 * Created Date         : January 27, 2024 
 * @description         : This class is used to test code for mda_COAbatchUpdate.
 * @author              : M. Eleanya (Contractor: Precision Partners)
 
 
 * Modification Log:
   Ver      Date              Author                  Modification
   1.0      02-21-2024        M. Eleanya              Initial Version
**/

@isTest
public class mda_COAbatchUpdateTest {


    static testmethod void grantFundTest(){

        List<AQB__LLChartofAccounts__c> coaList = new List<AQB__LLChartofAccounts__c>();
        //Insert 50 Grant Fund Records
         for (Integer i=0;i<50;i++) {
            AQB__LLChartofAccounts__c coa1 = new AQB__LLChartofAccounts__c(MDACC_COAExternalID__c = 'COA123' + i, 
                                                                           AQB__Category__c = 'Grant Fund', 
                                                                           AQB__Active__c = true,
                                                                           MDA_Clearing_Account__c = false,
                                                                           AQB__DesignationAccountNumberGroupTwo__c='Test');
            coaList.add(coa1); 
        } 
        
        Test.startTest();
        mda_COAbatchUpdate b = new mda_COAbatchUpdate();
        Database.executeBatch(b);
        Test.stopTest();

        AQB__LLChartofAccounts__c[] updatedCOAlist1 = [SELECT Id, AQB__DesignationAccountNumberGroupNine__c FROM AQB__LLChartofAccounts__c WHERE AQB__Category__c = 'Grant Fund'];
        System.assert(updatedCOAlist1[0].AQB__DesignationAccountNumberGroupNine__c == '');
    }

    static testmethod void test() {

      
    List<AQB__LLChartofAccounts__c> coaList = new List<AQB__LLChartofAccounts__c>();
    //Insert 50 Grant Fund Records
     for (Integer i=0;i<50;i++) {
        AQB__LLChartofAccounts__c coa1 = new AQB__LLChartofAccounts__c(MDACC_COAExternalID__c = 'COA123' + i, 
                                                                       AQB__Category__c = 'Grant Fund', 
                                                                       AQB__Active__c = true,
                                                                       MDA_Clearing_Account__c = false,
                                                                       AQB__DesignationAccountNumberGroupTwo__c='Test');
        coaList.add(coa1); 
    } 
    
    
     for (Integer i=50;i<100;i++) {
        AQB__LLChartofAccounts__c coa2 = new AQB__LLChartofAccounts__c(MDACC_COAExternalID__c = 'COA123' + i, AQB__Category__c = 'Gift Fund', 
        AQB__Restricted__c = false, AQB__Account_Type__c = 'Current Operations');
        coaList.add(coa2);
    }
    for (Integer i=100;i<150;i++) {
        AQB__LLChartofAccounts__c coa3 = new AQB__LLChartofAccounts__c(MDACC_COAExternalID__c = 'COA123' + i, AQB__Category__c = 'Gift Fund', 
        AQB__Restricted__c = true, AQB__Account_Type__c = 'Current Operations');
        coaList.add(coa3);
    }
    for (Integer i=150;i<175;i++) {
        AQB__LLChartofAccounts__c coa4 = new AQB__LLChartofAccounts__c(MDACC_COAExternalID__c = 'COA123' + i, AQB__Category__c = 'Gift Fund', 
        AQB__Restricted__c = true, AQB__Account_Type__c = 'Capital Purposes');
        coaList.add(coa4);
    }
     for (Integer i=175;i<200;i++) {
        AQB__LLChartofAccounts__c coa5 = new AQB__LLChartofAccounts__c(MDACC_COAExternalID__c = 'COA123' + i, AQB__Category__c = 'Gift Fund', 
        AQB__Restricted__c = true, AQB__Account_Type__c = 'Endowment');
        coaList.add(coa5);
    }        
    
    insert coaList;
 
        Test.startTest();
        mda_COAbatchUpdate b = new mda_COAbatchUpdate();
        Database.executeBatch(b);
        Test.stopTest();
       
    AQB__LLChartofAccounts__c[] updatedCOAlist1 = [SELECT Id, AQB__DesignationAccountNumberGroupNine__c FROM AQB__LLChartofAccounts__c WHERE AQB__Category__c = 'Grant Fund'];
    AQB__LLChartofAccounts__c[] updatedCOAlist2 = [SELECT Id, AQB__DesignationAccountNumberGroupNine__c FROM AQB__LLChartofAccounts__c WHERE AQB__Category__c = 'Gift Fund' AND AQB__Restricted__c = false];
    AQB__LLChartofAccounts__c[] updatedCOAlist3 = [SELECT Id, AQB__DesignationAccountNumberGroupNine__c FROM AQB__LLChartofAccounts__c WHERE AQB__Category__c = 'Gift Fund' AND (AQB__Restricted__c = true AND AQB__Account_Type__c = 'Current Operations')];
    AQB__LLChartofAccounts__c[] updatedCOAlist4 = [SELECT Id, AQB__DesignationAccountNumberGroupNine__c FROM AQB__LLChartofAccounts__c WHERE AQB__Category__c = 'Gift Fund' AND (AQB__Restricted__c = true AND AQB__Account_Type__c = 'Capital Purposes')];
    AQB__LLChartofAccounts__c[] updatedCOAlist5 = [SELECT Id, AQB__DesignationAccountNumberGroupNine__c FROM AQB__LLChartofAccounts__c WHERE AQB__Category__c = 'Gift Fund' AND (AQB__Restricted__c = true AND AQB__Account_Type__c = 'Endowment')];
    System.assert(updatedCOAlist1[0].AQB__DesignationAccountNumberGroupNine__c == '');
    System.assert(updatedCOAlist2[0].AQB__DesignationAccountNumberGroupNine__c == '42511');
    System.assert(updatedCOAlist3[0].AQB__DesignationAccountNumberGroupNine__c == '42521');
    System.assert(updatedCOAlist4[0].AQB__DesignationAccountNumberGroupNine__c == '46710');
    System.assert(updatedCOAlist5[0].AQB__DesignationAccountNumberGroupNine__c == '11323'); 
    }

}