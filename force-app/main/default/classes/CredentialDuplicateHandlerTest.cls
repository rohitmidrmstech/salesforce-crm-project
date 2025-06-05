@isTest
public class CredentialDuplicateHandlerTest {
    
    @isTest
    static void testCreatePromotionCredential_OverlapThrowsException() {
        Credential__c cred1= new Credential__c(Name='CERTAplank',Status__c='Active',
                                               Applicable_Program__c='CCB;BSP',Max_Payout_Quantity__c=40,
                                               //   Unit_of_Measure__c=unitMeasure.Id,
                                               Product_Category__c='CERTAplank Reinforced Siding',
                                               Start_Date__c=Date.today().addMonths(-12),
                                               End_Date__c=Date.today().addMonths(+12)
                                              );
        
        insert cred1;
        
        Credential__c cred2= new Credential__c(Name='CERTAplank',Status__c='Active',
                                               Applicable_Program__c='CCB;BSP',Max_Payout_Quantity__c=40,
                                               //     Unit_of_Measure__c=unitMeasure.Id,
                                               Product_Category__c='CERTAplank Reinforced Siding',
                                               Start_Date__c=Date.today().addMonths(-12),
                                               End_Date__c=Date.today().addMonths(+12)
                                              );
        
        Test.startTest();
        try {
            CredentialDuplicateHandler.createPromotionCredential(cred2);
            System.assert(false, 'Expected exception was not thrown.');
        } catch (CredentialDuplicateHandler.CustomException e) {
            System.assertEquals(
                'A Credential with the same product category and overlapping date range already exists.',
                e.getMessage(),
                'Unexpected exception message.'
            );
        }
        Test.stopTest();
    }
}