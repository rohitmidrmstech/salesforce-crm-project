global class WOD_AssignUsersToGroups implements Database.batchable<Sobject>, Database.stateful{
    String userId;
    global WOD_AssignUsersToGroups(){
        
    }
    global WOD_AssignUsersToGroups(String userId){
        this.userId=userId; 
    }
    /**
* @description Start method of batch class
* @param BC BatchableContext
* @return QueryLocator
*/
    global database.QueryLocator start(Database.BatchableContext BC){
        WOD_2.ResponseWrapper res = WOD_2.BaseController.fetchConfigurationSettingMetaData('WOD_Territory_Sharing_Profile');
        WOD_2__Configuration_Setting__mdt cm = (WOD_2__Configuration_Setting__mdt)JSON.deserialize(res.data,WOD_2__Configuration_Setting__mdt.Class);
        String profiles=cm.WOD_2__Configuration_Value__c;
        List<String> profileList=profiles.split('\r\n');
        String query='select id,User_Territory_Code__c,Sales_Org__c from User where  User_Territory_Code__c !=null and profile.name in:profileList' ;
        if(this.userId!=null && this.userId!=''){
            query=query+' and id =\''+userId+'\''; 
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<User> listUsers){
        system.debug('userdetails---------->'+listUsers);
        List<GroupMember> newGroupMembersList = new List<GroupMember>();
         set<String> territoryprefix=new Set<String>{'TC%','TR%'};
        List<Territory__c>territoryCodes=[select id,Territory_Code__c,Territory_SalesOrg__c from Territory__c where Territory_Code__c like:territoryprefix and Territory_SalesOrg__c!=null and Sales_Org__c in('1102','1501')];// CER-211
        for(User u:listUsers){
            List<Territory__c> newTeritores = new List<Territory__c>(); 
            map<String,id> teritorestobeadded = new  Map<String,id>();
            List<String> publicgrouptobemodified= new List<String>();   
            if(u.User_Territory_Code__c!=null && u.Sales_Org__c!=null && (u.Sales_Org__c.contains('1501') || u.Sales_Org__c.contains('1102') /*|| u.Sales_Org__c.contains('1111') || u.Sales_Org__c.contains('1021')*/)){//CER-211
                for(Territory__c t:territoryCodes){
                    if(u.User_Territory_Code__c.containsIgnoreCase(t.Territory_Code__c)){
                     newTeritores.add(t);   
                    }
                }
                system.debug('new values'+newteritores);
            }
            if(newteritores!=null && newteritores.size()>0){
                for(Territory__c t : newteritores){                                    
                    String publicgroupnameadd='WarrantyGroup_'+t.Territory_SalesOrg__c;
                    publicgrouptobemodified.add(publicgroupnameadd);
                    teritorestobeadded.put(publicgroupnameadd,u.id);
                    
                }  
                
                List<Group> listOfPublicGroup =[Select Name, Type, Id from Group Where type='Regular' and Name in :publicgrouptobemodified];
                system.debug('pubic grouplst'+listOfPublicGroup);
                Map<String, ID> mapOfPublicGroup = new Map<String, ID>();
                if(listOfPublicGroup != null)
                {
                    for(Group g : listOfPublicGroup)            
                        mapOfPublicGroup.put(g.Name, g.Id);           
                } 
                
                for(string s: teritorestobeadded.keySet())
                {
                    GroupMember eachGroupUser = new GroupMember();
                    eachGroupUser.GroupId = mapOfPublicGroup.get(s); 
                    eachGroupUser.UserOrGroupId = teritorestobeadded.get(s);
                    if(eachGroupUser.GroupId!=null)
                        newGroupMembersList.add(eachGroupUser);                    
                    
                }
            }
        }
        If(newGroupMembersList.size()>0)
        {
            System.debug('inert operration'+newGroupMembersList);
            Insert newGroupMembersList;
        }
        
        
    }
   /* 
    public static Boolean isEligibleUser(String userId){
        Boolean isEligibleUser=false;
        if(isSandbox()){
            List<PermissionSetAssignment> psa=[SELECT PermissionSet.Name, PermissionSet.Profile.Name  FROM PermissionSetAssignment WHERE AssigneeId=: userId];
            if(psa!=null && psa.size()>0){
                for(PermissionSetAssignment p:psa){
                    if((p.PermissionSet!=null && p.PermissionSet.Name!=null && p.PermissionSet.Name.containsIgnoreCase('warranty'))|| (p.PermissionSet.Profile!=null && p.PermissionSet.Profile.Name!=null && p.PermissionSet.Profile.Name.containsIgnoreCase('warranty'))){
                        isEligibleUser=true;
                        break;                          
                    }   
                }
                
            }
        }
        else{
            List<UserPackageLicense> upl=[Select UserId From UserPackageLicense where PackageLicense.NamespacePrefix ='WOD_2' and UserId=:userId];
            if(upl!=null && upl.size()>0){
                isEligibleUser=true;    
            }
        }
        return isEligibleUser;
    }
    
    public static Boolean isSandbox() {
        Boolean org = ([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox);
        if(org){
            return true;
        } else{
            return false;
        }
    }
*/
    global void finish(Database.BatchableContext BC){  
        
    }
}