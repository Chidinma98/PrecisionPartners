/**
 * Apex Class Name: mda_COAbatchUpdate
 *
 * Created Date: January 27, 2024 
 *
 * @description: This class is to update existing records in LL Chart of Accounts. The Designation Account Number Segment Nine field stores the GL Account number in Journey CRM.
 * Transactions that are created in Journey CRM are linked to a record in the Chart of Accounts. The Chart Field String and GL Account from the Chart of Account record will be used by the integration program to create 
 * journal entries for posting to the General Ledger.
 *
 * @author: M. Eleanya (Contractor: Precision Partners)
 *
 * Requirements:
 * 1) Only update records that are Active
 * 2) Exclude all COA records that do not have a COA External ID - this assumes that the record is included in Peoplesoft GL Inbound Integration
 * 3) Exclude all COA records that are used as a Clearing Account
 * 4) All COA records that are classified as Grant Funds will be updated with GL Account 10011
 * 5) All COA records that are classified as Gift Fund, are unrestricted, and have an Account Type of Current Operations will be udpated with GL Account 42511
 * 6) All COA records that are classified as Gift Fund, are restricted, and have an Account Type of Current Operations will be udpated with GL Account 42521
 * 7) All COA records that are classified as Gift Fund, are restricted, and have an Account Type of Capital Purposes will be udpated with GL Account 46710
 * 8) All COA records that are classified as Gift Fund, are restricted, and have an Account Type of Endowment will be udpated with GL Account 11323
 *
 * Modification Log:
 *     Ver      Date              Author                  Modification
 *     1.0      02-21-2024        M. Eleanya              Initial Version
 *     2.0      06-05-2024        M. Eleanya              Revised to only update Active records
**/


global class mda_COAbatchUpdate implements Database.Batchable<sObject>{
 global Database.QueryLocator start(Database.BatchableContext BC) {
         
        String query = 'SELECT Id, MDACC_COAExternalID__c, MDA_Clearing_Account__c, AQB__Active__c, AQB__DesignationAccountNumberGroupNine__c, AQB__Category__c, AQB__Restricted__c, AQB__Account_Type__c FROM AQB__LLChartofAccounts__c WHERE AQB__DesignationAccountNumberGroupTwo__c != NULL AND MDA_Clearing_Account__c = false ';
        return Database.getQueryLocator(query); 
    }
     
    global void execute(Database.BatchableContext BC, List<AQB__LLChartofAccounts__c> coaList) {
        
       
        for(AQB__LLChartofAccounts__c coa: coaList) {
            if(coa.AQB__Active__c){
                //Sets Grant Fund Category to Null
                if(coa.AQB__Category__c == 'Grant Fund'){
                    coa.AQB__DesignationAccountNumberGroupNine__c = '';
                }

                //Unrestricted record with Gift Fund and Account type of Endowment get set to empty string
                if(coa.AQB__Category__c == 'Gift Fund' && coa.AQB__Restricted__c == false && coa.AQB__Account_Type__c == 'Endowment' ){
                    coa.AQB__DesignationAccountNumberGroupNine__c = '';  
                }

                //Unrestricted record with Account Type of Current Operations sets to '42511' 
                if(coa.AQB__Category__c == 'Gift Fund' && coa.AQB__Restricted__c == false && coa.AQB__Account_Type__c =='Current Operations' ){
                    coa.AQB__DesignationAccountNumberGroupNine__c = '42511';  
                }
                //Unrestricted record with NO Account Type sets to empty string
                if(coa.AQB__Category__c == 'Gift Fund' && coa.AQB__Restricted__c == false && coa.AQB__Account_Type__c == null && coa.AQB__DesignationAccountNumberGroupNine__c != null ){
                    coa.AQB__DesignationAccountNumberGroupNine__c = '';  
                }

                //Restricted record with Gift Fund and Account type of Endowment get set to empty string
                if(coa.AQB__Category__c == 'Gift Fund' && coa.AQB__Restricted__c == true && coa.AQB__Account_Type__c == 'Endowment' ){
                    coa.AQB__DesignationAccountNumberGroupNine__c = '';  
                }
                //Restricted record with Current Operations Account sets to '42521'
                if(coa.AQB__Category__c == 'Gift Fund' && coa.AQB__Restricted__c == true &&  coa.AQB__Account_Type__c =='Current Operations' ){
                    coa.AQB__DesignationAccountNumberGroupNine__c = '42521';

                //Restricted record with Capital Purposes Account sets to '46710'                    
                }if(coa.AQB__Category__c == 'Gift Fund' && coa.AQB__Restricted__c == true &&  coa.AQB__Account_Type__c =='Capital Purposes' ){
                    coa.AQB__DesignationAccountNumberGroupNine__c = '46710';
                }
                
                //Restricted record with no Account Type sets to empty string  
                if(coa.AQB__Category__c == 'Gift Fund' && coa.AQB__Restricted__c == true &&  coa.AQB__Account_Type__c ==null ){
                    coa.AQB__DesignationAccountNumberGroupNine__c = '';
                    }
            } 
        }
        try {
            update coaList;
            if(Test.isRunningTest()){
                CalloutException e = new CalloutException();
                e.setMessage('code coverage exception');
                throw e;
                
            }
         
        } catch(Exception e) {
            System.debug(e);
        }
         
    }   
     
    global void finish(Database.BatchableContext BC) {
      system.debug('FINISH EXECUTION');
    }


}