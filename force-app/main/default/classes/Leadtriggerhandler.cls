public class LeadTriggerHandler {
    public static void afterOperation(map<Id, Lead> leadMap){
        System.debug('====leadMap==='+leadMap);
        List<Lead> lstLeadOwner = [select Id,OwnerId,Community_User__c from Lead where Id in : leadMap.Keyset()];
    	Set<Id> userIds = new Set<Id>();
        Set<Id> commUserIds = new Set<Id>();
        List<User> userUpdateList = new List<User>();
        System.debug('====lstLeadOwner==='+lstLeadOwner);
        if(lstLeadOwner != NULL && lstLeadOwner.size()>0){
            for(Lead ld : lstLeadOwner){
                if(ld.OwnerId != NULL){
                	userIds.add(ld.OwnerId);
                }
                if(ld.Community_User__c != NULL){
                	commUserIds.add(ld.Community_User__c);
                }
            }
        }
        System.debug('====userIds==='+userIds);
        if(userIds != NULL && userIds.size()>0){
            Integer qualifiedLeads = 0;
            Integer totalLeads = 0;
            qualifiedLeads = [ SELECT COUNT() FROM Lead WHERE OwnerId IN : userIds];
            if(commUserIds != NULL && commUserIds.size()>0){
                totalLeads = [ SELECT COUNT() FROM Lead WHERE OwnerId IN : commUserIds];
            }
            System.debug('====totalLeads==='+totalLeads);
            System.debug('====qualifiedLeads==='+qualifiedLeads);
            if(totalLeads > 0 || qualifiedLeads > 0){
            	List<User> usrList = [SELECT Id,Number_of_Leads_Assigned__c,Number_of_Leads_Accepted__c,Rating__c from User WHERE ID IN : userIds];
                for(user usr : usrList){
                    if(usr.Number_of_Leads_Assigned__c != totalLeads || usr.Number_of_Leads_Accepted__c != qualifiedLeads){
                        double d;
                        usr.Number_of_Leads_Assigned__c = totalLeads;
                        usr.Number_of_Leads_Accepted__c = qualifiedLeads;
                        if(totalLeads > 0){
                        	d = (double.valueOf(qualifiedLeads)/totalLeads);
                        }else{
                            d = double.valueOf(qualifiedLeads);
                        }
                        System.debug('====d==='+d);
                        usr.Rating__c = d;
                        System.debug('====usr.Rating__c==='+usr.Rating__c);
                        userUpdateList.add(usr);
                    }
            	}
                System.debug('====userUpdateList==='+userUpdateList);
                if(userUpdateList != NULL && userUpdateList.size() > 0){
                    update userUpdateList;
                }
            }
    	}
	}
}