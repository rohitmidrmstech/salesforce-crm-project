public class WOD_UserTriggerHelper {
    
    public static void adduserpublic(List<User> newuser){
        List<GroupMember> newGroupMembersList = new List<GroupMember>();
        WOD_2.ResponseWrapper res = WOD_2.BaseController.fetchConfigurationSettingMetaData('WOD_Territory_Sharing_Profile');
        WOD_2__Configuration_Setting__mdt cm = (WOD_2__Configuration_Setting__mdt)JSON.deserialize(res.data,WOD_2__Configuration_Setting__mdt.Class);
        String profiles=cm.WOD_2__Configuration_Value__c;
        system.debug('profiles------------->'+profiles);
        set<String> territoryprefix=new Set<String>{'TC%','TR%'};
        List<Territory__c>territoryCodes=[select id,Territory_Code__c,Territory_SalesOrg__c from Territory__c where Territory_Code__c like:territoryprefix and Territory_SalesOrg__c!=null and Sales_Org__c in('1102','1501')  ];
        Map<Id,Profile> profileMap = new Map<Id,Profile>([SELECT Id,Name FROM Profile]);
        for(User u:newuser){
            List<Territory__c> newTerritories = new List<Territory__c>(); 
            map<String,id> teritorestobeadded = new  Map<String,id>();
            List<String> publicgrouptobemodified= new List<String>();
            String currentProfile=profileMap.get(u.profileId).name;
            if(profiles!=null && profiles.containsIgnoreCase(currentProfile) && u.User_Territory_Code__c!=null && u.Sales_Org__c!=null && (u.Sales_Org__c.contains('1501') || u.Sales_Org__c.contains('1102'))){
                for(Territory__c t:territoryCodes){
                    if(u.User_Territory_Code__c.containsIgnoreCase(t.Territory_Code__c)){
                        newTerritories.add(t);   
                    }
                    system.debug('new values'+newTerritories);
                }
            }
            if(newTerritories!=null && newTerritories.size()>0){
                //List<Territory__c>listTerritories=[select id, Territory_SalesOrg__c from Territory__c where Territory_Code__c in:newteritores ];
                
                for(Territory__c t : newTerritories){                                    
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
    public static void addUserToPublicgroup(map<id,user> oldmap,List<User> newuser){
        WOD_2.ResponseWrapper res = WOD_2.BaseController.fetchConfigurationSettingMetaData('WOD_Territory_Sharing_Profile');
        WOD_2__Configuration_Setting__mdt cm = (WOD_2__Configuration_Setting__mdt)JSON.deserialize(res.data,WOD_2__Configuration_Setting__mdt.Class);
        String profiles=cm.WOD_2__Configuration_Value__c;
        set<String> territoryprefix=new Set<String>{'TC%','TR%'};
        List<Territory__c>territoryCodes=[select id,Territory_Code__c,Territory_SalesOrg__c from Territory__c where Territory_Code__c like:territoryprefix and Territory_SalesOrg__c!=null and Sales_Org__c in('1102','1501')  ]; 
        Map<Id,Profile> profileMap = new Map<Id,Profile>([SELECT Id,Name FROM Profile]);
        for(user u: newuser){
            List<String> oldteritores = new List<String>();
            List<String> newTeritores = new List<String>();
            map<String,User> olddtermap= new map<String,user>();
            map<String,User> newtermap= new map<String,user>();       
            Map<String,id> teritorestoberemoved = new  Map<String,id>();
            map<String,id> teritorestobeadded = new  Map<String,id>();
            List<String> publicgrouptobemodified= new List<String>();
            user olduser = oldmap.get(u.id);
            List<Territory__c>listOldTerritories=new  List<Territory__c>();
            List<Territory__c>listNewTerritories=new  List<Territory__c>();
             String currentProfile=profileMap.get(u.profileId).name;
            if(profiles!=null && profiles.containsIgnoreCase(currentProfile) && u.User_Territory_Code__c!=olduser.User_Territory_Code__c && u.Sales_Org__c!=null && (u.Sales_Org__c.contains('1501') || u.Sales_Org__c.contains('1102'))){
                
                if(olduser.User_Territory_Code__c!=null && olduser.User_Territory_Code__c!='')
                {
                    for(Territory__c t:territoryCodes){
                        if(olduser.User_Territory_Code__c.containsIgnoreCase(t.Territory_Code__c)){
                            listOldTerritories.add(t);
                        olddtermap.put(t.Territory_Code__c,u); 
                        }
                    } 
                }           
                system.debug('old map values'+olddtermap);
                if(u.User_Territory_Code__c!=null && u.User_Territory_Code__c!=''){
                    for(Territory__c t:territoryCodes){
                        if(u.User_Territory_Code__c.containsIgnoreCase(t.Territory_Code__c)){
                            listNewTerritories.add(t);
                        newtermap.put(t.Territory_Code__c,u);
                        }
                    } 
                }
                for(Territory__c t : listOldTerritories){
                    if( !newtermap.containskey(t.Territory_Code__c))
                    {
                        String publicgroupname='WarrantyGroup_'+t.Territory_SalesOrg__c;
                        publicgrouptobemodified.add(publicgroupname);
                        teritorestoberemoved.put(publicgroupname,u.id);
                    }
                    
                }
                
                for(Territory__c t : listNewTerritories){
                    if( !olddtermap.containskey(t.Territory_Code__c) ) 
                    {
                        String publicgroupnameadd='WarrantyGroup_'+t.Territory_SalesOrg__c;
                        publicgrouptobemodified.add(publicgroupnameadd);
                        
                        teritorestobeadded.put(publicgroupnameadd,u.id);
                    }
                    
                }
                
            }
            if(publicgrouptobemodified.size()>0){
                AddorRemoveMembers(publicgrouptobemodified,teritorestoberemoved,teritorestobeadded);
            }   
        }
        
    }
    public static void AddorRemoveMembers(List<String>publicgroupquery,Map<String,id>removedteritories,Map<String,id>addedteritories){
        system.debug('into second metho');
        system.debug('query input'+publicgroupquery);
        List<Group> listOfPublicGroup =[Select Name, Type, Id from Group Where type='Regular' and Name in :publicgroupquery];
        system.debug('pubic grouplst'+listOfPublicGroup);
        Map<String, ID> mapOfPublicGroup = new Map<String, ID>();
        if(listOfPublicGroup != null)
        {
            for(Group g : listOfPublicGroup)            
                mapOfPublicGroup.put(g.Name, g.Id);           
        } 
        List<GroupMember> newGroupMembersList = new List<GroupMember>();
        
        for(string s: addedteritories.keySet())
        {
            
            GroupMember eachGroupUser = new GroupMember();
            eachGroupUser.GroupId = mapOfPublicGroup.get(s); 
            eachGroupUser.UserOrGroupId = addedteritories.get(s);
            if(eachGroupUser.GroupId!=null)
                newGroupMembersList.add(eachGroupUser); 
            
            
        }
        system.debug('newgrop'+newGroupMembersList);
        List<GroupMember> removeGroupMembersList = new List<GroupMember>();            
        set<Id> setGroupIdForRemove = new set<Id>();
        set<Id> setUserIdForRemove = new set<Id>();
        for(string s: removedteritories.keySet())
        {
            
            setGroupIdForRemove.add(mapOfPublicGroup.get(s));  
            setUserIdForRemove.add(removedteritories.get(s));                    
            
        }
        if(setGroupIdForRemove!=null && setUserIdForRemove!=null && setUserIdForRemove.size()>0 && setGroupIdForRemove.size()>0){
            List<GroupMember> grpListRemove  = [Select Id from GroupMember where GroupId in :setGroupIdForRemove and UserOrGroupId in :setUserIdForRemove ];
            for(GroupMember gm : grpListRemove)
            {
                removeGroupMembersList.add(gm);     
            }
        }
        
        System.debug('***newGroupMembersList-->'+newGroupMembersList);
        System.debug('***removeGroupMembersList-->'+removeGroupMembersList);
        If(newGroupMembersList.size()>0)
        {
            System.debug('inert operration'+newGroupMembersList);
            Insert newGroupMembersList;
        }
        If(removeGroupMembersList.size()>0)
        {
            delete removeGroupMembersList;
        }
    }
    /*
public static Boolean isEligibleUser(String userId){
Boolean isEligibleUser=false;
if(isSandbox()){
List<PermissionSetAssignment> psa=[SELECT PermissionSet.Name, PermissionSet.Profile.Name  FROM PermissionSetAssignment WHERE AssigneeId=: userId];
if(psa!=null && psa.size()>0){
for(PermissionSetAssignment p:psa){
if((p.PermissionSet!=null && p.PermissionSet.Name!=null && p.PermissionSet.Name.containsIgnoreCase('warranty'))|| (p.PermissionSet.Profile!=null && p.PermissionSet.Profile.Name!=null && p.PermissionSet.Profile.Name.contains('warranty'))){
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
} */
    
}