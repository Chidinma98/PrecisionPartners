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
        
        insert coaList;

        Test.startTest();
        mda_COAbatchUpdate b = new mda_COAbatchUpdate();
        Database.executeBatch(b);
        Test.stopTest();

        AQB__LLChartofAccounts__c[] updatedCOAlist1 = [SELECT Id, AQB__DesignationAccountNumberGroupNine__c FROM AQB__LLChartofAccounts__c WHERE AQB__Category__c = 'Grant Fund'];
        System.assertEquals(null, updatedCOAlist1[0].AQB__DesignationAccountNumberGroupNine__c, 'Expected Designation Nine to Equal Null');
    }

    static testmethod void unrestrictedGiftwithEndowment(){

        List<AQB__LLChartofAccounts__c> coaList = new List<AQB__LLChartofAccounts__c>();
        //Insert 50 Grant Fund Records
         for (Integer i=0;i<50;i++) {
            AQB__LLChartofAccounts__c coa1 = new AQB__LLChartofAccounts__c(MDACC_COAExternalID__c = 'COA123' + i,                                                             
                                                                           AQB__Active__c = true,
                                                                           MDA_Clearing_Account__c = false,
                                                                           AQB__DesignationAccountNumberGroupTwo__c='Test',
                                                                           AQB__Category__c = 'Gift Fund',
                                                                           AQB__Restricted__c= false,
                                                                           AQB__Account_Type__c='Endowment');
            coaList.add(coa1); 
        } 
        
        insert coaList;

        Test.startTest();
        mda_COAbatchUpdate b = new mda_COAbatchUpdate();
        Database.executeBatch(b);
        Test.stopTest();

        AQB__LLChartofAccounts__c[] updatedCOAlist1 = [SELECT Id, AQB__DesignationAccountNumberGroupNine__c FROM AQB__LLChartofAccounts__c WHERE AQB__Category__c = 'Gift Fund' AND AQB__Account_Type__c='Endowment']; 
        System.assertEquals(null, updatedCOAlist1[0].AQB__DesignationAccountNumberGroupNine__c, 'Expected Designation Nine to Equal Null');
    }


    static testmethod void unrestrictedGiftwithCurrentOperation(){

        List<AQB__LLChartofAccounts__c> coaList = new List<AQB__LLChartofAccounts__c>();
        //Insert 50 Grant Fund Records
         for (Integer i=0;i<50;i++) {
            AQB__LLChartofAccounts__c coa1 = new AQB__LLChartofAccounts__c(MDACC_COAExternalID__c = 'COA123' + i,                                                             
                                                                           AQB__Active__c = true,
                                                                           MDA_Clearing_Account__c = false,
                                                                           AQB__DesignationAccountNumberGroupTwo__c='Test',
                                                                           AQB__Category__c = 'Gift Fund',
                                                                           AQB__Restricted__c= false,
                                                                           AQB__Account_Type__c='Current Operations');
            coaList.add(coa1); 
        } 
        
        insert coaList;

        Test.startTest();
        mda_COAbatchUpdate b = new mda_COAbatchUpdate();
        Database.executeBatch(b);
        Test.stopTest();

        AQB__LLChartofAccounts__c[] updatedCOAlist1 = [SELECT Id, AQB__DesignationAccountNumberGroupNine__c FROM AQB__LLChartofAccounts__c WHERE AQB__Category__c = 'Gift Fund' AND AQB__Account_Type__c='Current Operations'];
        System.assertEquals('42511', updatedCOAlist1[0].AQB__DesignationAccountNumberGroupNine__c, 'Expected Designation Nine to Equal 42511');
    }

    static testmethod void unrestrictedGiftwithNoAccountType(){

        List<AQB__LLChartofAccounts__c> coaList = new List<AQB__LLChartofAccounts__c>();
        //Insert 50 Grant Fund Records
         for (Integer i=0;i<50;i++) {
            AQB__LLChartofAccounts__c coa1 = new AQB__LLChartofAccounts__c(MDACC_COAExternalID__c = 'COA123' + i,                                                             
                                                                           AQB__Active__c = true,
                                                                           MDA_Clearing_Account__c = false,
                                                                           AQB__DesignationAccountNumberGroupTwo__c='Test',
                                                                           AQB__Category__c = 'Gift Fund',
                                                                           AQB__Restricted__c= false,
                                                                           AQB__DesignationAccountNumberGroupNine__c = 'test',
                                                                           AQB__Account_Type__c='');
            coaList.add(coa1); 
        } 
        
        insert coaList;

        Test.startTest();
        mda_COAbatchUpdate b = new mda_COAbatchUpdate();
        Database.executeBatch(b);
        Test.stopTest();

        AQB__LLChartofAccounts__c[] updatedCOAlist1 = [SELECT Id, AQB__DesignationAccountNumberGroupNine__c FROM AQB__LLChartofAccounts__c WHERE AQB__Category__c = 'Gift Fund' AND  AQB__Account_Type__c= null];
        System.assertEquals(null, updatedCOAlist1[0].AQB__DesignationAccountNumberGroupNine__c, 'Expected Designation Nine to Equal Null');
    }


    static testmethod void restrictedGiftwithEndowmentAccountType(){

        List<AQB__LLChartofAccounts__c> coaList = new List<AQB__LLChartofAccounts__c>();
        //Insert 50 Grant Fund Records
         for (Integer i=0;i<50;i++) {
            AQB__LLChartofAccounts__c coa1 = new AQB__LLChartofAccounts__c(MDACC_COAExternalID__c = 'COA123' + i,                                                             
                                                                           AQB__Active__c = true,
                                                                           MDA_Clearing_Account__c = false,
                                                                           AQB__DesignationAccountNumberGroupTwo__c='Test',
                                                                           AQB__Category__c = 'Gift Fund',
                                                                           AQB__Restricted__c= true,
                                                                           AQB__DesignationAccountNumberGroupNine__c = 'test',
                                                                           AQB__Account_Type__c='Endowment');
            coaList.add(coa1); 
        } 
        
        insert coaList;

        Test.startTest();
        mda_COAbatchUpdate b = new mda_COAbatchUpdate();
        Database.executeBatch(b);
        Test.stopTest();

        AQB__LLChartofAccounts__c[] updatedCOAlist1 = [SELECT Id, AQB__DesignationAccountNumberGroupNine__c FROM AQB__LLChartofAccounts__c WHERE AQB__Category__c = 'Gift Fund' AND  AQB__Account_Type__c='Endowment' AND AQB__Restricted__c= true];
        System.assertEquals(null, updatedCOAlist1[0].AQB__DesignationAccountNumberGroupNine__c, 'Expected Designation Nine to Equal Null');
    }

    static testmethod void restrictedGiftwithCurrentOperationsAccountType(){

        List<AQB__LLChartofAccounts__c> coaList = new List<AQB__LLChartofAccounts__c>();
        //Insert 50 Grant Fund Records
         for (Integer i=0;i<50;i++) {
            AQB__LLChartofAccounts__c coa1 = new AQB__LLChartofAccounts__c(MDACC_COAExternalID__c = 'COA123' + i,                                                             
                                                                           AQB__Active__c = true,
                                                                           MDA_Clearing_Account__c = false,
                                                                           AQB__DesignationAccountNumberGroupTwo__c='Test',
                                                                           AQB__Category__c = 'Gift Fund',
                                                                           AQB__Restricted__c= true,
                                                                           AQB__DesignationAccountNumberGroupNine__c = 'test',
                                                                           AQB__Account_Type__c='Current Operations');
            coaList.add(coa1); 
        } 
        
        insert coaList;

        Test.startTest();
        mda_COAbatchUpdate b = new mda_COAbatchUpdate();
        Database.executeBatch(b);
        Test.stopTest();

        AQB__LLChartofAccounts__c[] updatedCOAlist1 = [SELECT Id, AQB__DesignationAccountNumberGroupNine__c FROM AQB__LLChartofAccounts__c WHERE AQB__Category__c = 'Gift Fund' AND  AQB__Account_Type__c='Current Operations' AND AQB__Restricted__c= true];
        System.assertEquals('42521', updatedCOAlist1[0].AQB__DesignationAccountNumberGroupNine__c, 'Expected Designation Nine to equal 42521');
  
    }

    static testmethod void restrictedGiftwithCapitalPurposedAccountType(){

        List<AQB__LLChartofAccounts__c> coaList = new List<AQB__LLChartofAccounts__c>();
        //Insert 50 Grant Fund Records
         for (Integer i=0;i<50;i++) {
            AQB__LLChartofAccounts__c coa1 = new AQB__LLChartofAccounts__c(MDACC_COAExternalID__c = 'COA123' + i,                                                             
                                                                           AQB__Active__c = true,
                                                                           MDA_Clearing_Account__c = false,
                                                                           AQB__DesignationAccountNumberGroupTwo__c='Test',
                                                                           AQB__Category__c = 'Gift Fund',
                                                                           AQB__Restricted__c= true,
                                                                           AQB__DesignationAccountNumberGroupNine__c = 'test',
                                                                           AQB__Account_Type__c='Capital Purposes');
            coaList.add(coa1); 
        } 
        
        insert coaList;

        Test.startTest();
        mda_COAbatchUpdate b = new mda_COAbatchUpdate();
        Database.executeBatch(b);
        Test.stopTest();

        AQB__LLChartofAccounts__c[] updatedCOAlist1 = [SELECT Id, AQB__DesignationAccountNumberGroupNine__c FROM AQB__LLChartofAccounts__c WHERE AQB__Category__c = 'Gift Fund' AND  AQB__Account_Type__c='Capital Purposes' AND AQB__Restricted__c= true];
        System.assertEquals('46710', updatedCOAlist1[0].AQB__DesignationAccountNumberGroupNine__c, 'Expected Designation Nine to equal 46710');
  
    }


    static testmethod void restrictedGiftwithNoAccountType(){

        List<AQB__LLChartofAccounts__c> coaList = new List<AQB__LLChartofAccounts__c>();
        //Insert 50 Grant Fund Records
         for (Integer i=0;i<50;i++) {
            AQB__LLChartofAccounts__c coa1 = new AQB__LLChartofAccounts__c(MDACC_COAExternalID__c = 'COA123' + i,                                                             
                                                                           AQB__Active__c = true,
                                                                           MDA_Clearing_Account__c = false,
                                                                           AQB__DesignationAccountNumberGroupTwo__c='Test',
                                                                           AQB__Category__c = 'Gift Fund',
                                                                           AQB__Restricted__c= true,
                                                                           AQB__Account_Type__c='');
            coaList.add(coa1); 
        } 
        
        insert coaList;

        Test.startTest();
        mda_COAbatchUpdate b = new mda_COAbatchUpdate();
        Database.executeBatch(b);
        Test.stopTest();

        AQB__LLChartofAccounts__c[] updatedCOAlist1 = [SELECT Id, AQB__DesignationAccountNumberGroupNine__c FROM AQB__LLChartofAccounts__c WHERE AQB__Category__c = 'Gift Fund' AND  AQB__Account_Type__c=null AND AQB__Restricted__c= true];
        System.assertEquals(null, updatedCOAlist1[0].AQB__DesignationAccountNumberGroupNine__c, 'Expected Designation Nine to equal null');
  
    }

    

}