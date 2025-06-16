public class ContractorRecommendation {
        @InvocableVariable(label='Contact')
        @AuraEnabled
        public Contact contact;
        @AuraEnabled
        @InvocableVariable(label='Distance')
        public Double distance;
        @AuraEnabled
        @InvocableVariable(label='Assigned Credential')
        public String ac;
    }