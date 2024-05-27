/**
 * Apex Class Name      : mda_contactHistoricalUpdateTest
 * Created Date         : May 27th, 2024 
 * @description         : This class is used to test the update primary and secondary contacts based on gift recognition credit percentage
 * Test Class           : @see mda_contactHistoricalUpdate for class being tested
 * @author              : M. Eleanya (Contractor: Precision Partners) 
**/

@isTest()
public class mda_contactHistoricalUpdateTest {
    /**
      * @description:checkPrimaryContact
      * @Comments: Check situation where the Contact is a primary contact and updates 
      * AQB__AwardGiftCredit__c to True, AQB__PrimaryGiftRecognitionCredit_Percent__c to 100 percent and AQB__SecondaryGiftRecognitionCreditPercent__c to 100 percent
    **/ 
    static testmethod void checkPrimaryContact(){
        Account acc = mda_TestDataFactory.createAccount('TestAccount',true);  
        Contact con = new Contact(
                        lastName ='TestContact',
                        AccountId = acc.Id,
            			AQB__Type__c = 'Individual',
                        AQB__SecondaryGiftRecognitionCreditPercent__c = 0.00,
                        AQB__PrimaryGiftRecognitionCredit_Percent__c = 0.00
                        );
        insert con;

        // Make the Account related to that contact a Primary Account
        Contact con1 =[Select Id, lastName, Name, AQB__SecondaryGiftRecognitionCreditPercent__c from Contact WHERE lastName = 'TestContact'];

        //retrieve Contact Again and Update
        Account acc1 = [Select Id from Account WHERE Name = 'TestAccount'];
        acc1.AQB__PrimaryContact__c = con1.Id;
        update acc1;

        Test.startTest();
        mda_contactHistoricalUpdate b = new mda_contactHistoricalUpdate();
        Database.executeBatch(b);
        Test.stopTest();

        Contact con2 =[Select Id, AQB__IsPrimaryContact__c, AQB__AwardGiftCredit__c, AQB__PrimaryGiftRecognitionCredit_Percent__c, AQB__SecondaryGiftRecognitionCreditPercent__c  from Contact WHERE lastName = 'TestContact'];

        System.assertEquals(con2.AQB__IsPrimaryContact__c, 'Yes', 'Expected record to be Primary Contact');
        System.assertEquals(con2.AQB__AwardGiftCredit__c, true, 'Expected Award Gift Credit to be set to true');
        System.assertEquals(con2.AQB__PrimaryGiftRecognitionCredit_Percent__c, 100, 'Expected Primary Gift Recognition at 100 percent');
        System.assertEquals(con2.AQB__SecondaryGiftRecognitionCreditPercent__c, 100, 'Expected Secondary Gift Recognition at 100 percent');

    }

    /**
      * @description:checkSecondaryContact
      * @Comments: Check situation where the Contact is not a  primary contact and updates 
      * AQB__AwardGiftCredit__c to True, AQB__PrimaryGiftRecognitionCredit_Percent__c to 0 percent and AQB__SecondaryGiftRecognitionCreditPercent__c to 100 percent
    **/ 

    static testmethod void checkSecondaryContact(){
        Account acc = mda_TestDataFactory.createAccount('TestAccount',true);  
        Contact con = new Contact(
                        lastName ='TestContact',
                        AccountId = acc.Id,
            			AQB__Type__c = 'Individual',
                        AQB__SecondaryGiftRecognitionCreditPercent__c = 0.00,
                        AQB__PrimaryGiftRecognitionCredit_Percent__c = 0.00
                        );
        insert con;

        Test.startTest();
        mda_contactHistoricalUpdate b = new mda_contactHistoricalUpdate();
        Database.executeBatch(b);
        Test.stopTest();

        Contact con2 =[Select Id, AQB__IsPrimaryContact__c, AQB__AwardGiftCredit__c, AQB__PrimaryGiftRecognitionCredit_Percent__c, AQB__SecondaryGiftRecognitionCreditPercent__c  from Contact WHERE lastName = 'TestContact'];

        System.assertEquals(con2.AQB__IsPrimaryContact__c, 'No', 'Expected record to not be Secondary Contact');
        System.assertEquals(con2.AQB__AwardGiftCredit__c, true, 'Expected Award Gift Credit to be set to true');
        System.assertEquals(con2.AQB__PrimaryGiftRecognitionCredit_Percent__c, 0, 'Expected Primary Gift Recognition at 0 percent');
        System.assertEquals(con2.AQB__SecondaryGiftRecognitionCreditPercent__c, 100, 'Expected Secondary Gift Recognition at 100 percent');

    }

}