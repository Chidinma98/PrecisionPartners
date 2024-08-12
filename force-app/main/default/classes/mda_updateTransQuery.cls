global class mda_updateTransQuery {
    public void mda_updateTransQuery() {
        //IF STATEMENTS
        //Regular Query

        //Chart of Accounts
        AQB__LLChartofAccounts__c coa = [Select Id, AQB__DesignationAccountNumber__c  from AQB__LLChartofAccounts__c 
        WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90-11324' LIMIT 1];
        AQB__LLChartofAccounts__c coa2 = [Select Id, AQB__DesignationAccountNumber__c from AQB__LLChartofAccounts__c 
        WHERE MDACC_COAExternalID__c = 'MDACC-700057-30-108356-19' LIMIT 1];
        AQB__LLChartofAccounts__c coa3 = [Select Id, AQB__DesignationAccountNumber__c from AQB__LLChartofAccounts__c 
        WHERE MDACC_COAExternalID__c = 'MDACC-700001-30-100001-90' LIMIT 1]; 

        //
        Set<String> dataSource = new Set<String>{'Mail','Institutional Lockbox', 'Children\'s Art Project (CAP)', 'Live Check / Credit Card (MD Anderson Front Office)', 
        'MDA Treasury', 'Special Events Lockbox', 'MDA Cashier Office', 'Online - Donation Sites',
         'Online - Peer 2 Peer Sites', 'UT Foundation'};

        //
        Set<String> paymentMethod = new Set<String>{'Cash','Check','Securities','ACH','Wire', 'Paypal', 'Transfer'};


        // 105 - New and Adjusted Pledges, Matching Gifts, Planned Gifts
        AQB__Transaction__c [] trans105 =[Select Id, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
         WHERE AQB__Type__c = 'Pledge' AND AQB__ThirdPartyPayoff__c = false AND AQB__PledgePayment__c = false
         AND CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z];
            try{
                for(AQB__Transaction__c trans: trans105){
                    trans.AQB__Do_not_push_to_Accounting__c = true;
                }
                Database.SaveResult[] results = Database.update(trans105, false);
                System.debug(trans105.size() + '   ===> trans105 records updated');
            } catch(Exception e){
                System.debug( 'Error Inserting trans105 ==>' +  e );
            }


        //106 - New and Adjusted Grants
        AQB__Transaction__c [] trans106 =[Select Id, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
        WHERE AQB__Type__c = 'Grant' AND AQB__ThirdPartyPayoff__c = false AND AQB__PledgePayment__c = false
        AND CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z];
            try{
                for(AQB__Transaction__c trans: trans106){
                    trans.AQB__Do_not_push_to_Accounting__c = true;
                }
                Database.SaveResult[] results = Database.update(trans106, false);
                System.debug(trans106.size() + '   ===> trans106 records updated');
            } catch(Exception e){
                System.debug( 'Error Inserting trans106 ==>' +  e );
            }

        //Scenario 107: Grant Payments where the source is the Click Grants Report 
         AQB__Transaction__c [] trans107 =[Select Id, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
         WHERE AQB__SourceofData__c = 'Grants Management System' AND (AQB__Type__c = 'Grant Payment' OR AQB__Type__c = 'Payment') 
         AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false
         AND CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z];
        
            try{
                for(AQB__Transaction__c trans: trans107){
                    trans.AQB__Do_not_push_to_Accounting__c = true;
                }
                
                Database.SaveResult[] results = Database.update(trans107, false);
                System.debug(trans107.size() + '   ===> trans107 records updated');
            } catch(Exception e){
                System.debug( 'Error Inserting trans107 ==>' +  e );
            }


        //Scenario 108:Grant Overpayment where the source is the Click Grants Report
        AQB__Transaction__c [] trans108 =[Select Id, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
        WHERE AQB__SourceofData__c = 'Grants Management System' AND (AQB__Type__c = 'Grant Payment' OR AQB__Type__c = 'Payment') 
        AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false
        AND CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z];           
           try{
               for(AQB__Transaction__c trans: trans108){
                   trans.AQB__Do_not_push_to_Accounting__c = true;
               }
               Database.SaveResult[] results = Database.update(trans108, false);
               System.debug(trans108.size() + '   ===> trans108 records updated');
           } catch(Exception e){
               System.debug( 'Error Inserting trans108 ==>' +  e );
           }
        
        //Scenario 109: Gifts in Kind
        AQB__Transaction__c [] trans109 =[Select Id, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
        WHERE AQB__Type__c = 'Payment' AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false AND
        AQB__SourceofData__c = 'Gift in Kind Form / Documentation'
        AND CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z];      
           try{
               for(AQB__Transaction__c trans: trans109){
                   trans.AQB__Do_not_push_to_Accounting__c = true;
               }
               Database.SaveResult[] results = Database.update(trans109, false);
               System.debug(trans109.size() + '   ===> trans109 records updated');
           } catch(Exception e){
               System.debug( 'Error Inserting trans109 ==>' +  e );
           }
  
  
        //Scenario 110:Payments from Caging - Annual Fund Lockbox 
        AQB__Transaction__c [] trans110 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
        ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
        WHERE AQB__Type__c = 'Payment' AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false AND 
        AQB__SourceofData__c = 'Annual Fund Lockbox' AND
        AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges'
        AND CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z ];    
           
        try{
               for(AQB__Transaction__c trans: trans110){
                trans.MDA_Credit_Debit_Account_Error__c = false;
                trans.AQB__Do_not_push_to_Accounting__c  = false;
                trans.AQB__DebitAccount__c = coa.Id;
                trans.MDA_Debit_Account__c = coa.Id;
                trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
               }
               Database.SaveResult[] results = Database.update(trans110, false);
               System.debug(trans110.size() + '   ===> trans110 records updated');
           } catch(Exception e){
               System.debug( 'Error Inserting trans110 ==>' +  e );
           }
        
        //Scenario 111: Conditional Pledge Payments from Caging - Annual Fund Lockbox
        AQB__Transaction__c [] trans111 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
        ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
        WHERE AQB__Type__c = 'Payment' AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false AND 
        AQB__SourceofData__c = 'Annual Fund Lockbox' AND AQB__PledgeStipulation__c = 'Conditional' AND
        AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges'
        AND CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z];    
           
        try{
               for(AQB__Transaction__c trans: trans111){
                trans.MDA_Credit_Debit_Account_Error__c = false;
                trans.AQB__Do_not_push_to_Accounting__c  = false;
                trans.AQB__DebitAccount__c = coa.Id;
                trans.MDA_Debit_Account__c = coa.Id;
                trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
               }
               Database.SaveResult[] results = Database.update(trans111, false);
               System.debug(trans111.size() + ' ==> trans111 records updated');
           } catch(Exception e){
               System.debug( 'Error Inserting trans111 ==>' +  e );
           }
        
        //Scenario 112: Unconditional Pledge Payments from Caging - Annual Fund Lockbox
        AQB__Transaction__c [] trans112 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
        ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
        WHERE AQB__Type__c = 'Payment' AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false AND 
        AQB__SourceofData__c = 'Annual Fund Lockbox' AND AQB__PledgeStipulation__c = 'Unconditional' AND
        AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges'
        AND CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z];    
           
        try{
               for(AQB__Transaction__c trans: trans112){
                trans.MDA_Credit_Debit_Account_Error__c = false;
                trans.AQB__Do_not_push_to_Accounting__c  = false;
                trans.AQB__DebitAccount__c = coa.Id;
                trans.MDA_Debit_Account__c = coa.Id;
                trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                trans.MDA_GL_Posting_Type__c = 'Manual-Historical';
               }
               Database.SaveResult[] results = Database.update(trans112, false);
               System.debug(trans112.size() + ' ==> trans112 records updated');
           } catch(Exception e){
               System.debug( 'Error Inserting trans112 ==>' +  e );
           }
            
        
        //Scenario 113: Donations from Sources that Post to the GL; funds received via credit card 
           AQB__Transaction__c [] trans113 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
           ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
           WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false
           AND AQB__Method__c = 'Credit Card'  AND AQB__Type__c = 'Payment' AND
           AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges'
           AND CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z]; 
        
           try{
            for(AQB__Transaction__c trans: trans113){
                trans.MDA_Credit_Debit_Account_Error__c = false;
                trans.AQB__Do_not_push_to_Accounting__c  = false;
                trans.AQB__DebitAccount__c = coa2.Id;
                trans.MDA_Debit_Account__c = coa2.Id;
                trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
                trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
            }
            Database.SaveResult[] results = Database.update(trans113, false);
            System.debug(trans113.size() + ' ==> trans113 records updated');
        } catch(Exception e){
            System.debug( 'Error Inserting trans113 ==>' +  e );
        }

        //Scenario 114: Donations from Sources that Post to the GL; funds received via ACH, Cash, Check, PayPal,Securities, Transfer, Wire                        
        AQB__Transaction__c [] trans114 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
        ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
        WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = false AND AQB__ThirdPartyPayoff__c = false
        AND AQB__Method__c IN :paymentMethod AND AQB__Type__c = 'Payment' AND
        AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges'
        AND CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z]; 
     
        try{
         for(AQB__Transaction__c trans: trans114){
             trans.MDA_Credit_Debit_Account_Error__c = false;
             trans.AQB__Do_not_push_to_Accounting__c  = false;
             trans.AQB__DebitAccount__c = coa3.Id;
             trans.MDA_Debit_Account__c = coa3.Id;
             trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
             trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                         
         }
         Database.SaveResult[] results = Database.update(trans114, false);
         System.debug(trans114.size() + ' ==> trans114 records updated');
     } catch(Exception e){
         System.debug( 'Error Inserting trans114 ==>' +  e );
     }


     //Scenario 115: Conditional Pledge Payments from Sources that Post to the GL; funds received via credit card  
     AQB__Transaction__c [] trans115 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
     ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
     WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false
     AND AQB__Method__c ='Credit Card' AND (AQB__PledgeStipulation__c = 'Conditional' OR AQB__PledgeStipulation__c = Null) AND
     AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__Type__c = 'Payment' 
     AND CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z]; 
  
     try{
      for(AQB__Transaction__c trans: trans115){
          trans.MDA_Credit_Debit_Account_Error__c = false;
          trans.AQB__Do_not_push_to_Accounting__c  = false;
          trans.AQB__DebitAccount__c = coa2.Id;
          trans.MDA_Debit_Account__c = coa2.Id;
          trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
          trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
          
                      
      }
      Database.SaveResult[] results = Database.update(trans115, false);
      System.debug(trans115.size() + ' ==> trans115 records updated');
  } catch(Exception e){
      System.debug( 'Error Inserting trans115 ==>' +  e );
  }


     //Scenario 116:Conditional Pledge Payments from Sources that Post to the GL; funds received via ACH, Cash, Check, PayPal, Securities, Transfer, Wire  
     AQB__Transaction__c [] trans116 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
     ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
     WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false
     AND AQB__Method__c IN :paymentMethod AND (AQB__PledgeStipulation__c = 'Conditional' OR AQB__PledgeStipulation__c = Null) AND
     AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND(AQB__Type__c = 'Payment' OR AQB__Type__c = 'Grant Payment') AND
     CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z]; 
  
     try{
      for(AQB__Transaction__c trans: trans116){
          trans.MDA_Credit_Debit_Account_Error__c = false;
          trans.AQB__Do_not_push_to_Accounting__c  = false;
          trans.AQB__DebitAccount__c = coa2.Id;
          trans.MDA_Debit_Account__c = coa2.Id;
          trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
          trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                      
      }
      Database.SaveResult[] results = Database.update(trans116, false);
      System.debug(trans116.size() + '  ==> trans116 records updated');
  } catch(Exception e){
      System.debug( 'Error Inserting trans116 ==>' +  e );
  }

       //Scenario 117:Unconditional Pledge Payments from Sources that Post to the GL; funds received via credit card 
       AQB__Transaction__c [] trans117 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
       ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
       WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false
       AND AQB__Method__c ='Credit Card' AND AQB__PledgeStipulation__c = 'Unconditional' AND
       AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__Type__c = 'Payment'  AND
       CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z]; 
    
       try{
        for(AQB__Transaction__c trans: trans117){
            trans.MDA_Credit_Debit_Account_Error__c = false;
            trans.AQB__Do_not_push_to_Accounting__c  = false;
            trans.AQB__DebitAccount__c = coa2.Id;
            trans.MDA_Debit_Account__c = coa2.Id;
            trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
            trans.MDA_GL_Posting_Type__c = 'Automated-Historical';
                        
        }
        Database.SaveResult[] results = Database.update(trans117, false);
        System.debug(trans117.size() + '  ==> trans117 records updated');
    } catch(Exception e){
        System.debug( 'Error Inserting trans117 ==>' +  e );
    }


    //Scenario 118:Unconditional Pledge Payments from Sources that Post to the GL; funds received via ACH, Cash, Check, PayPal, Securities, Transfer, Wire 
    AQB__Transaction__c [] trans118 =[Select Id,AQB__DebitAccount__c,MDA_Debit_Account__c, MDA_Credit_AccountLookup__c
    ,AQB__ChartofAccounts__c, MDA_GL_Posting_Type__c, AQB__Do_not_push_to_Accounting__c from AQB__Transaction__c 
    WHERE AQB__SourceofData__c IN :dataSource AND AQB__PledgePayment__c = true AND AQB__ThirdPartyPayoff__c = false
    AND AQB__Method__c IN :paymentMethod AND AQB__PledgeStipulation__c = 'Unconditional' AND
    AQB__Batch__r.AQB__BatchType__c = 'Gifts/Pledges' AND AQB__Type__c = 'Payment'  AND
    CreatedDate >= 2023-10-17T19:00:00Z AND CreatedDate <= 2024-07-16T19:00:00Z]; 
 
    try{
     for(AQB__Transaction__c trans: trans118){
         trans.MDA_Credit_Debit_Account_Error__c = false;
         trans.AQB__Do_not_push_to_Accounting__c  = false;
         trans.AQB__DebitAccount__c = coa3.Id;
         trans.MDA_Debit_Account__c = coa3.Id;
         trans.MDA_Credit_AccountLookup__c = trans.AQB__ChartofAccounts__c;
         trans.MDA_GL_Posting_Type__c = 'Manual-Historical';
                     
     }
     Database.SaveResult[] results = Database.update(trans118, false);
     System.debug(trans118.size() + ' ==> trans118 records updated');
 } catch(Exception e){
     System.debug( 'Error Inserting trans118 ==>' +  e );
 }

 //ADJUSTMENTS
 //Scenario 119A: Voided donations that were entered using a GIfts/Pledges Batch Type - linked to the Voided Transaction; Voided Transaction Source of Data is Annual Fund









        }

        


}