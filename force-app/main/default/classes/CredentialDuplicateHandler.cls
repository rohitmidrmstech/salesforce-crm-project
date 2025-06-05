/* **********************************************************************************************************************************
* Class Name   : CredentialDuplicateHandler
* Description  : This class is to throw an error when any duplicate record is getting created with an overlapping date 
*                for any existing record, excluding a specific record type.
* Author       : Hithesh
* Modified On  : 
* Test Class   : CredentialDuplicateHandlerTest
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                 Date             Modification ID      Description 
* --------------------------------------------------------------------------------------------------------------------------------------
* Hithesh		          25-11-2024          
* Updated by               <Your Name>       <Date>              Clarified and improved record type exclusion logic
**************************************************************************************************************************************/
public class CredentialDuplicateHandler {
    public static void createPromotionCredential(Credential__c newCredential) {
        // Get the RecordTypeId for 'Contractor Credentials'
        Id credRecordTypeId = Schema.SObjectType.Credential__c.getRecordTypeInfosByName().get('Contractor Credentials').getRecordTypeId();

        // Query for existing records with overlapping date ranges, same Product_Category__c,
        // excluding the record type 'Contractor Credentials' and the current record
        List<Credential__c> overlappingPromotions = [
            SELECT Id, Start_Date__c, End_Date__c, Product_Category__c 
            FROM Credential__c 
            WHERE 
                Product_Category__c = :newCredential.Product_Category__c
                AND Id != :newCredential.Id // Exclude the current record if being updated
                AND Status__c = 'Active' // Check only active credentials
                AND RecordTypeId != :credRecordTypeId // Exclude 'Contractor Credentials' record type
                AND (
                    Start_Date__c <= :newCredential.End_Date__c 
                    AND End_Date__c >= :newCredential.Start_Date__c
                )
        ];

        // If any overlapping records are found, throw an exception
        if (!overlappingPromotions.isEmpty()) {
            throw new CustomException('A Credential with the same product category and overlapping date range already exists.');
        }
    }
    
    // Custom exception to handle validation errors
    public class CustomException extends Exception {}
}