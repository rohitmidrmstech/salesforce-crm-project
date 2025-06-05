global class testRebateClaimBatch implements Database.Batchable<SObject>,Database.Stateful {
    global set<Id> sidingResiDenCommercialContacts = new set<Id>();
    global set<Id> sidingResidRoofingContacts = new set<Id>();
    Set<String> SIDING_CATEGORIES = new Set<String>{
        'Northwoods', 'Value Soffit', 'Vytec Soffit,D5" Select & T4" Soffit*', 'CedarBoards',
            'Soffit - Vytec Triple 3-1/3"', 'Restoration Millwork', 'Urban Reserve', 'Beaded Porch Panel',
            'Wolverine', 'Soffit - InvisiVent Triple 3 1/3"', 'Housewrap', 'Soffit - Ironmax',
            'Soffit - Value Triple 4"', 'Vytec Prestige', 'Soffit - Universal Double 5"', 'STONEfacade',
            'American Legend', 'Soffit - Value Double 5"', 'Carolina Beaded', 'Cedar Impressions Mitered Corners',
            'Cedar Impressions', 'Board & Batten', 'Vytec Board & Batten', 'Lineals and Supercorners',
            'Restoration Classic', 'CERTAplank Reinforced Siding', 'Soffit - Perimeter',
            'Soffit - Universal Triple 4"', 'Encore', 'RISE', 'MainStreet', 'Monogram', 'Vytec Heartwood Shingles'
            };
                Set<String> RESIDENTIAL_ROOFING_CATEGORIES = new Set<String>{
                    'Roofing Shingles', 'Integrity Roof System', 'Ventilation'
                        };
                            Set<String> COMMERCIAL_ROOFING_CATEGORIES = new Set<String>{
                                'SmartCoat', 'Low Slope Roofing'
                                    };
                                        global Database.QueryLocator start(Database.BatchableContext BC) {
                                            return Database.getQueryLocator([
                                                SELECT Id, Rebate_Claim__r.Submitted_By__c, Product_Category1__c, Rebate_Claim__r.Status__c, ClaimDate, Rebate_Claim__r.Program_Name__c 
                                                FROM RebateClaim 
                                                WHERE ClaimDate >= :Date.newInstance(2024, 1, 1) 
                                                AND ClaimDate <= :Date.newInstance(2024, 12, 31)
												AND Rebate_Claim__r.Status__c = 'Payout Completed' 

                                                AND Rebate_Claim__r.Program_Name__c = 'Contractor Cash Back'
                                            ]);
                                        }
    global void execute(Database.BatchableContext BC, List<RebateClaim> claimList) {
        Map<Id, Set<String>> contractorCategories = new Map<Id, Set<String>>();

        for (RebateClaim line : claimList) {
            Id contractorId = line.Rebate_Claim__r.Submitted_By__c;

            String category = line.Product_Category1__c;
            if (category != null) {
                if (!contractorCategories.containsKey(contractorId)) {
                    contractorCategories.put(contractorId, new Set<String>());
                }

                if (SIDING_CATEGORIES.contains(category)) {
                    contractorCategories.get(contractorId).add('Siding');
                }
                if (RESIDENTIAL_ROOFING_CATEGORIES.contains(category)) {
                    contractorCategories.get(contractorId).add('Residential Roofing');
                }
                if (COMMERCIAL_ROOFING_CATEGORIES.contains(category)) {
                    contractorCategories.get(contractorId).add('Commercial Roofing');
                }
            }
        }
        // Filter Contractors who submitted claims in all 3 categories
        
        for (Id contactId : contractorCategories.keySet()) {
            Set<String> categories = contractorCategories.get(contactId);
            if (categories.contains('Siding') && categories.contains('Residential Roofing') && categories.contains('Commercial Roofing')) {
                sidingResiDenCommercialContacts.add(contactId);
            }
            if (categories.contains('Siding') && categories.contains('Residential Roofing')) {
                sidingResidRoofingContacts.add(contactId);
            }
        }
        System.debug('sidingResiDenCommercialContacts==>'+ sidingResiDenCommercialContacts);
        System.debug('sidingResidRoofingContacts==>'+ sidingResidRoofingContacts);
        System.debug('sidingResidRoofingContacts==>'+ sidingResidRoofingContacts.size());
        System.debug('sidingResiDenCommercialContacts==>'+ sidingResiDenCommercialContacts.size());
        
    }
    // Output the result
    global void finish(Database.BatchableContext BC) {
        String emailBody = 'Rebate Claim Summary (' + 'RebateClaimContrctor' + ') for 2024\n\n';
        emailBody += '**Total Contractors Who Submitted in All 3 Categories:** ' + sidingResiDenCommercialContacts.size() + '\n\n';
        emailBody += '**Total Contractors Who Submitted in All 2 Categories:** ' + sidingResidRoofingContacts.size() + '\n\n';
        
        emailBody += '**Individual Contractor Totals:**\n\n';
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[]{'hithesh.r@idrms.tech'}); 
        mail.setSubject('Rebate Claim Summary - ');
        mail.setPlainTextBody(emailBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        
        System.debug('Email sent with total amounts for ');
    }
}