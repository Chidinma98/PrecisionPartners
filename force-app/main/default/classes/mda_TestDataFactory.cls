/**
 * Apex Class Name: mda_TestDataFactory
 *
 * Created Date: February 26, 2024 
 *
 * @description: This class is used to mass generate records of various object that are used for testing mda_transactionHistoricalRecordUpdate. 
 * @author: M. Eleanya (Contractor: Precision Partners)
 *
**/

@isTest
public class mda_TestDataFactory {
    public static AQB__Batch__c createBatch(String name, Boolean doInsert) {
        AQB__Batch__c batch = new AQB__Batch__c(AQB__SourceofData__c = name);
		if(doInsert) {
			insert batch;
		}
		return batch;
	}
    
    public static Account createAccount(String name, Boolean doInsert) {
        Account acc = new Account(name = name);
			if(doInsert) {
			insert acc;
			}
			return acc;      
 		}
    
    public static AQB__Acknowledgement__c getAcknowledgement(){
        AQB__Acknowledgement__c ack = [Select Id from AQB__Acknowledgement__c LIMIT 1];
        return ack;
    }
    
    public static AQB__LLChartofAccounts__c getCOA(){
        AQB__LLChartofAccounts__c aoc = [Select Id from AQB__LLChartofAccounts__c LIMIT 1];
        return aoc;
    }
    
      public static AQB__BatchItemTransaction__c getOBI(){
        AQB__BatchItemTransaction__c obi = [Select Id, AQB__BatchItemID__c from AQB__BatchItemTransaction__c LIMIT 1];
        return obi;
    }
    
       public static AQB__Gift__c getGift(){
        AQB__Gift__c gift = [Select Id, Name from AQB__Gift__c LIMIT 1];
        return gift;
    }
    
    public static AQB__Transaction__c createMatchingTransaction(){
        AQB__Gift__c gift = mda_TestDataFactory.getGift();
        AQB__BatchItemTransaction__c obi = mda_TestDataFactory.getOBI();
        Account acc = mda_TestDataFactory.createAccount('Test Account',true);               
        AQB__Acknowledgement__c ack = mda_TestDataFactory.getAcknowledgement();       
        AQB__LLChartofAccounts__c aoc = mda_TestDataFactory.getCOA();  
        
        //Values
        AQB__Transaction__c trans= new AQB__Transaction__c(
        AQB__OriginatingBatchItemTransaction__c = obi.Id,
        AQB__Gift__c = gift.Id, 
        AQB__Acknowledgement__c = ack.Id, 
        AQB__ChartofAccounts__c = aoc.Id,
        AQB__Account__c = acc.Id,
        AQB__Reference__c= 'correctTrans'
        );
        
        insert trans;        
        return trans;
        
    }
    
    public static AQB__Transaction__c chooseVoidedTransaction(){
        AQB__Transaction__c trans = [Select Id FROM AQB__Transaction__c LIMIT 1];
        return trans;        
    }
    


}