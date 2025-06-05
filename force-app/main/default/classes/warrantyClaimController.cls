/**
* @File Name : warrantyClaimController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : April 10, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | April 10, 2025 |   | Initial Version
**/

public with sharing class warrantyClaimController {

	//creating a warranty claim record
		@AuraEnabled
		public static Warranty_Claim__c createRebateClaim(Decimal BranchName, Date SubmitDate, String AdditionalProcessingNotes) {
			System.debug('BranchName => ' + BranchName);
			System.debug('SubmitDate => ' + SubmitDate);
			System.debug('ProductName => ' + AdditionalProcessingNotes);

			// Id userId = UserInfo.getUserId();

			// // Get current user's ProfileId and ContactId
			// User currentUser = [
			// 	SELECT Id, Name, Contact.Id, ProfileId 
			// 	FROM User 
			// 	WHERE Id = :userId 
			// 	LIMIT 1
			// ];

			// // Get the Profile Name separately
			// String profileName = [SELECT Name FROM Profile WHERE Id = :currentUser.ProfileId].Name;

			// System.debug('User Profile => ' + profileName);

			// Id contactId;

			// if (profileName == 'System Administrator') {
			// 	// Admin fallback: use any Contact for testing
			// 	contactId = [SELECT Id FROM Contact LIMIT 1].Id;
			// } else {
			// 	// Use associated contact from logged-in user
			// 	if (currentUser.Contact.Id == null) {
			// 		throw new AuraHandledException('No Contact is associated with this user.');
			// 	}
			// 	contactId = currentUser.Contact.Id;
			// }

			// Create Warranty Claim
			Warranty_Claim__c newClaim = new Warranty_Claim__c(
				Invoice_Number__c = BranchName,
				Contact__c = '003Va00000Kb38yIAB',
				Invoice_Date__c = SubmitDate,
				Product_Name__c = AdditionalProcessingNotes,
				Status__c = 'Submitted'
			);

			insert newClaim;
			
			// Fetch full record including Auto Number and Contact Name
			newClaim = [
				SELECT Id, Name, Invoice_Number__c, Invoice_Date__c, Product_Name__c, Status__c, Contact__r.Name
				FROM Warranty_Claim__c
				WHERE Id = :newClaim.Id
				LIMIT 1
			];
						return newClaim;
				}


           // Method to fetch warranty claims for the current user's related Contact
			@AuraEnabled(cacheable=true)
			public static List<Warranty_Claim__c> getMyClaims() {
				// Id userId = UserInfo.getUserId();

				// // Get the ContactId for the current user
				// User currentUser = [SELECT ContactId FROM User WHERE Id = :userId LIMIT 1];

				// if (currentUser.ContactId == null) {
				// 	throw new AuraHandledException('No Contact is associated with the current user.');
				// }

				return [
					SELECT Id, Name, Invoice_Number__c, Invoice_Date__c, Product_Name__c, Status__c,Contact__r.Name
					FROM Warranty_Claim__c
					WHERE Contact__c = '003Va00000Kb38yIAB'
					ORDER BY CreatedDate DESC
				];
			}


    /** Added be Rohit to get the Searched Claims**/
     @AuraEnabled(cacheable=true)
    public static List<Warranty_Claim__c> searchClaims(String claimNumber, String lastName, String zip) {
        return [
            SELECT Id, Name,Warranty_Update_Date__c, Invoice_Number__c, Invoice_Date__c,Status__c, Product_Name__c, Contact__c
            FROM Warranty_Claim__c
            WHERE Name = :claimNumber
            LIMIT 1
        ];
    }

}