/**
* @description - This class contains methods to do apex sharing for Tavant Warranty related functionalities
*/
public without sharing class WOD_RecordSharing {
    
    public static boolean warrantyPublicGroupModified = false;
    public static boolean warrantyClaimShared = false; 
    public static boolean isCalledFromBatch = false;
    
    /** 
* @description Craete Group frpm Territoty
* @param listTerritory List of Territoty   
* @param mapNewUserToTerritory map of new group member
* @param mapNewUserToTerritory map of group member deletion 
*/
    Public static void createpublicGroupfromTerritoryAndUpdateUser(list<Territory__c> listTerritory, Map<string,set<Id>> mapNewUserToTerritory, 
                                                                   Map<string,set<Id>> mapRemoveUserFromTerritory)
    {
        set<String> terGrpIds = new set<String>();
        for(Territory__c eachTer : listTerritory)                  
            terGrpIds.add('WarrantyGroup_' + eachTer.Territory_SalesOrg__c);                
        
        if(terGrpIds != null && terGrpIds.size() > 0)
        {
            List<Group> listOfPublicGroup =[Select Name, Type, Id from Group Where type='Regular' and Name in :terGrpIds];
            Map<String, ID> mapOfPublicGroup = new Map<String, ID>();
            if(listOfPublicGroup != null)
            {
                for(Group g : listOfPublicGroup)            
                    mapOfPublicGroup.put(g.Name, g.Id);           
            } 
            List<Group> newGroupsList = new List<Group>();
            for(Territory__c eachTer: listTerritory)
            {
                if(!mapOfPublicGroup.containsKey('WarrantyGroup_' + eachTer.Territory_SalesOrg__c))
                {
                    //Public groups are not there. Creating new public groups.
                    Group newGroupForTerritory = new Group();
                    newGroupForTerritory.name = 'WarrantyGroup_'+eachTer.Territory_SalesOrg__c; 
                    newGroupsList.add(newGroupForTerritory);            
                }                       
            }
            
            System.debug('***newGroupsList-->'+newGroupsList);
            if(newGroupsList.size() > 0)
            {
                insert newGroupsList;  
                for(Group newG : newGroupsList)
                {
                    mapOfPublicGroup.put(newG.Name, newG.Id);     
                }
            }
            
            //Add Users to Group
            List<string> newGroupMembersList = new List<string>();
            
            for(string s: mapNewUserToTerritory.keySet())
            {
                for(Id userId: mapNewUserToTerritory.get(s))
                {
                    GroupMember eachGroupUser = new GroupMember();
                    eachGroupUser.GroupId = mapOfPublicGroup.get(s); 
                    eachGroupUser.UserOrGroupId = userId;
                    newGroupMembersList.add(JSON.serialize(eachGroupUser));                    
                }          
            }
            
            List<string> removeGroupMembersList = new List<string>();            
            set<Id> setGroupIdForRemove = new set<Id>();
            set<Id> setUserIdForRemove = new set<Id>();
            for(string s: mapRemoveUserFromTerritory.keySet())
            {
                for(Id userId: mapRemoveUserFromTerritory.get(s))
                {
                    setGroupIdForRemove.add(mapOfPublicGroup.get(s));  
                    setUserIdForRemove.add(userId);                    
                }          
            }
            List<GroupMember> grpListRemove  = [Select Id from GroupMember where GroupId in :setGroupIdForRemove and UserOrGroupId in :setUserIdForRemove ];
            for(GroupMember gm : grpListRemove)
            {
                removeGroupMembersList.add(JSON.serialize(gm));	    
            }
            
            System.debug('***newGroupMembersList-->'+newGroupMembersList);
            System.debug('***removeGroupMembersList-->'+removeGroupMembersList);
            if(newGroupMembersList.size() > 0 || removeGroupMembersList.size()>0){
                if(isCalledFromBatch){
                    modifyGroupMemberSync(newGroupMembersList, removeGroupMembersList); 
                }
                else{
                    modifyGroupMember(newGroupMembersList, removeGroupMembersList);  
                }
            }
        }
    }
    
    /**
* @description share records with groups   
* @param listTerritory list of territory code 
* @param removeSharingMap 
*/
    
    Public static void shareRecordsWithRelatedGroup(list<string> listTerritory, Map<string,set<Id>> newSharingMap, 
                                                    Map<string,set<Id>> removeSharingMap, string objectName)
    {
        set<String> terGrpIds = new set<String>();
        for(string eachTer : listTerritory)                  
            terGrpIds.add(eachTer);
        if(terGrpIds != null && terGrpIds.size() > 0)
        {
            List<Group> listOfPublicGroup =[Select Name, Type, Id from Group Where type='Regular' and Name in :terGrpIds];
            Map<String, ID> mapOfPublicGroup = new Map<String, ID>();
            if(listOfPublicGroup != null)
            {
                for(Group g : listOfPublicGroup)            
                    mapOfPublicGroup.put(g.Name, g.Id);           
            } 
            System.debug('***mapOfPublicGroup-->'+mapOfPublicGroup);
            List<String> sharingRecordNewList = new List<String>();
            if(newSharingMap!= null && newSharingMap.size()>0)
            {         	    
                
                for(string s: newSharingMap.keySet())
                {
                    for(Id recId: newSharingMap.get(s))
                    {
                        if(mapOfPublicGroup.containsKey(s))
                        {
                            SharingRecord rec = new SharingRecord();
                            rec.recId = recId;
                            rec.groupId = mapOfPublicGroup.get(s); 
                            //sharingRecordNewList.add(JSON.serialize(rec));
                            sharingRecordNewList.add(JSON.serialize(rec));   
                        }                    	
                    }          
                }
            }
            List<String> sharingRecordRemoveList = new List<String>();
            if(removeSharingMap!= null && removeSharingMap.size()>0)
            {
                
                
                for(string s: removeSharingMap.keySet())
                {
                    for(Id recId: removeSharingMap.get(s))
                    {
                        if(mapOfPublicGroup.containsKey(s))
                        {
                            SharingRecord rec = new SharingRecord();
                            rec.recId = recId;
                            rec.groupId = mapOfPublicGroup.get(s);  
                            //sharingRecordRemoveList.add(JSON.serialize(rec));
                            sharingRecordRemoveList.add(JSON.serialize(rec));   
                        }                    	
                    }          
                }
            }
            
            System.debug('***sharingRecordNewList-->'+sharingRecordNewList);
            System.debug('***sharingRecordRemoveList-->'+sharingRecordRemoveList);
            
            if(sharingRecordNewList.size() > 0 || sharingRecordRemoveList.size()>0)
            {
                modifyShareRecords(sharingRecordNewList, sharingRecordRemoveList,objectName);
            }
            
            
        }
        
    }

  Public static void shareRecordsWithRelatedGroup(string objectName,list<string> listTerritory, Map<string,set<Id>> newSharingMap, 
                                                    Map<string,set<Id>> removeSharingMap)
    {
        set<String> terGrpIds = new set<String>();
        for(string eachTer : listTerritory)                  
            terGrpIds.add(eachTer);
        if(terGrpIds != null && terGrpIds.size() > 0)
        {
            List<Group> listOfPublicGroup =[Select Name, Type, Id from Group Where type='Regular' and Name in :terGrpIds];
            Map<String, ID> mapOfPublicGroup = new Map<String, ID>();
            if(listOfPublicGroup != null)
            {
                for(Group g : listOfPublicGroup)            
                    mapOfPublicGroup.put(g.Name, g.Id);           
            } 
            System.debug('***mapOfPublicGroup-->'+mapOfPublicGroup);
            List<String> sharingRecordNewList = new List<String>();
            if(newSharingMap!= null && newSharingMap.size()>0)
            {         	    
                
                for(string s: newSharingMap.keySet())
                {
                    for(Id recId: newSharingMap.get(s))
                    {
                        if(mapOfPublicGroup.containsKey(s))
                        {
                            SharingRecord rec = new SharingRecord();
                            rec.recId = recId;
                            rec.groupId = mapOfPublicGroup.get(s); 
                            //sharingRecordNewList.add(JSON.serialize(rec));
                            sharingRecordNewList.add(JSON.serialize(rec));   
                        }                    	
                    }          
                }
            }
            List<String> sharingRecordRemoveList = new List<String>();
            if(removeSharingMap!= null && removeSharingMap.size()>0)
            {
                
                
                for(string s: removeSharingMap.keySet())
                {
                    for(Id recId: removeSharingMap.get(s))
                    {
                        if(mapOfPublicGroup.containsKey(s))
                        {
                            SharingRecord rec = new SharingRecord();
                            rec.recId = recId;
                            rec.groupId = mapOfPublicGroup.get(s);  
                            //sharingRecordRemoveList.add(JSON.serialize(rec));
                            sharingRecordRemoveList.add(JSON.serialize(rec));   
                        }                    	
                    }          
                }
            }
            
            System.debug('***sharingRecordNewList-->'+sharingRecordNewList);
            System.debug('***sharingRecordRemoveList-->'+sharingRecordRemoveList);
            
            if(sharingRecordNewList.size() > 0 || sharingRecordRemoveList.size()>0)
            {
                modifyShareRecords(objectName,sharingRecordNewList, sharingRecordRemoveList);
            }
            
            
        }
        
    }
        
    /**
* @description Update sharing
* @param sharingRecordNewList List of new share  
* @param sharingRecordRemoveList List of share remove
*/
    @future
    Public static void modifyShareRecords(List<String> sharingRecordNewList, List<String> sharingRecordRemoveList, string objectName)
    {        
        if(objectName == 'Claim')
        {
            If(sharingRecordNewList.size()>0)
            {               
                List<WOD_2__Claim__Share> claimShareLst = new List<WOD_2__Claim__Share>();                
                for(String sr: sharingRecordNewList)
                {
                    WOD_2__Claim__Share toBeSharedRecord = new WOD_2__Claim__Share();
                    SharingRecord s= (SharingRecord)Json.deserialize(sr, SharingRecord.class);
                    toBeSharedRecord.ParentId = s.recId;
                    toBeSharedRecord.UserOrGroupId = s.groupId;
                    toBeSharedRecord.AccessLevel = 'Edit';
                    toBeSharedRecord.RowCause = 'manual';
                    claimShareLst.add(toBeSharedRecord);
                } 
                try{
                    system.debug('claimShareLst--------->'+claimShareLst);
                    List<Database.saveresult> result= database.insert(claimShareLst,true);
                    system.debug('claimShareLst------>'+claimShareLst);
                    system.debug('claimShareLst------>'+result);
                }
                catch(Exception e){
                    system.debug('exception----->'+e); 
                }
            }
            If(sharingRecordRemoveList.size()>0)
            {
                set<Id> groupId = new set<Id>();
                set<Id> recId = new set<Id>();
                
                for(String st: sharingRecordRemoveList)
                {
                    SharingRecord s=(SharingRecord)JSON.deserialize(st, SharingRecord.class);
                    groupId.add(s.groupId);
                    recId.add(s.recId);
                }
                List<WOD_2__Claim__Share> lstRemoveClaimShare = [select Id from WOD_2__Claim__Share where ParentId in :recId and UserOrGroupId in :groupId];
                if(lstRemoveClaimShare.size()>0)
                    delete lstRemoveClaimShare;
            }
        }
        else if(objectName == 'QC')
        {
        }
        else if(objectName == 'LabAnalysis')
        {            
        }
        else  if(objectName == 'Inspection')
        {
        }
        else  if(objectName == 'ClaimQuestion')
        {
        }
        else  if(objectName == 'ReportStatus')
        {
        }
        
    }  
    
     Public static void modifyShareRecords(string objectName,List<String> sharingRecordNewList, List<String> sharingRecordRemoveList)
    {        
        if(objectName == 'Claim')
        {
            If(sharingRecordNewList.size()>0)
            {               
                List<WOD_2__Claim__Share> claimShareLst = new List<WOD_2__Claim__Share>();                
                for(String sr: sharingRecordNewList)
                {
                    WOD_2__Claim__Share toBeSharedRecord = new WOD_2__Claim__Share();
                    SharingRecord s= (SharingRecord)Json.deserialize(sr, SharingRecord.class);
                    toBeSharedRecord.ParentId = s.recId;
                    toBeSharedRecord.UserOrGroupId = s.groupId;
                    toBeSharedRecord.AccessLevel = 'Edit';
                    toBeSharedRecord.RowCause = 'manual';
                    claimShareLst.add(toBeSharedRecord);
                } 
                try{
                    system.debug('claimShareLst--------->'+claimShareLst);
                    List<Database.saveresult> result= database.insert(claimShareLst,true);
                    system.debug('claimShareLst------>'+claimShareLst);
                    system.debug('claimShareLst------>'+result);
                }
                catch(Exception e){
                    system.debug('exception----->'+e); 
                }
            }
            If(sharingRecordRemoveList.size()>0)
            {
                set<Id> groupId = new set<Id>();
                set<Id> recId = new set<Id>();
                
                for(String st: sharingRecordRemoveList)
                {
                    SharingRecord s=(SharingRecord)JSON.deserialize(st, SharingRecord.class);
                    groupId.add(s.groupId);
                    recId.add(s.recId);
                }
                List<WOD_2__Claim__Share> lstRemoveClaimShare = [select Id from WOD_2__Claim__Share where ParentId in :recId and UserOrGroupId in :groupId];
                if(lstRemoveClaimShare.size()>0)
                    delete lstRemoveClaimShare;
            }
        }
        else if(objectName == 'QC')
        {
        }
        else if(objectName == 'LabAnalysis')
        {            
        }
        else  if(objectName == 'Inspection')
        {
        }
        else  if(objectName == 'ClaimQuestion')
        {
        }
        else  if(objectName == 'ReportStatus')
        {
        }
        
    }    
    
    
    /**
* @description Craete Group frpm Territoty
* @param newGroupMembersList List of new group member   
* @param removeGroupMembersList List of group member removal
*/
    @future
    Public static void modifyGroupMember(List<String> newGroupMembersList, List<String> removeGroupMembersList)
    {
        If(newGroupMembersList.size()>0)
        {
            List<GroupMember> groupMembersInsertLst = new List<GroupMember>();
            for(string s: newGroupMembersList)
            {
                groupMembersInsertLst.add((GroupMember) JSON.deserialize(s, GroupMember.class));
            }
            Insert groupMembersInsertLst;
        }
        If(removeGroupMembersList.size()>0)
        {
            List<GroupMember> groupMembersRemoveLst = new List<GroupMember>();
            for(string s: removeGroupMembersList)
            {
                groupMembersRemoveLst.add((GroupMember) JSON.deserialize(s, GroupMember.class));
            }
            delete groupMembersRemoveLst;
        }
    }
    /**
* @description Craete Group from Territoty (Calling By WOD_BatchTerritoryGroup)
* @param newGroupMembersList List of new group member   
* @param removeGroupMembersList List of group member removal
*/
    
    Public static void modifyGroupMemberSync(List<String> newGroupMembersList, List<String> removeGroupMembersList)
    {
        If(newGroupMembersList.size()>0)
        {
            List<GroupMember> groupMembersInsertLst = new List<GroupMember>();
            for(string s: newGroupMembersList)
            {
                groupMembersInsertLst.add((GroupMember) JSON.deserialize(s, GroupMember.class));
            }
            Insert groupMembersInsertLst;
        }
        If(removeGroupMembersList.size()>0)
        {
            List<GroupMember> groupMembersRemoveLst = new List<GroupMember>();
            for(string s: removeGroupMembersList)
            {
                groupMembersRemoveLst.add((GroupMember) JSON.deserialize(s, GroupMember.class));
            }
            delete groupMembersRemoveLst;
        }
    }
    
    Public class SharingRecord
    {
        Public Id recId {get;set;}
        Public Id groupId {get;set;}
    }
    
    @future
    public static void persistSharing(String ShareString) {
        WOD_2__Claim__Share[] claimShareList = (WOD_2__Claim__Share[])JSON.deserialize(shareString, WOD_2__Claim__Share[].class);
        for(WOD_2__Claim__Share claimShare: claimShareList){
            claimShare.Id = null;
        }
        if(claimShareList!=null && claimShareList.size()>0){
        Database.insert(claimShareList, false);
        }
    }
}