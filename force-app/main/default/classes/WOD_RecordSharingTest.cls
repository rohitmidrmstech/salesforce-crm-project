/**
 * @description Test class for WOD_RecordSharing
*/
@isTest
public class WOD_RecordSharingTest {
    /**
     * @description data set up and execution
    */
    public static testmethod void ShareTestMethod(){
        Account acc  = WOD_TestDataFactory.createAccount('TestAccount2','','Warranty Account');
        insert acc;
        Territory__c t1 = new Territory__c();
        t1.Name ='WarrantyGroup_Tavant';
        t1.Territory_SalesOrg__c ='WarrantyGroup_a12345';
        t1.Sales_Org__c ='1501';
        t1.Sales_Rep__c =UserInfo.getUserId();
        t1.Sales_Rep2__c= UserInfo.getUserId();
        t1.Sales_Rep3__c = UserInfo.getUserId();
        t1.Sales_Rep4__c = UserInfo.getUserId();
        t1.Sales_Rep5__c = UserInfo.getUserId();
        insert t1;
        WOD_2__Claim__c clm1 = WOD_TestDataFactory.CreateClaim('Short_Term','Short Term',acc.id,'Roofing');
        clm1.Territory__r = t1;
        insert clm1;
       List<string> listTerritory = new List<string>();
       Map<string,set<Id>> newSharingMap = new Map<string,set<Id>>();
        Map<string,set<Id>> removeSharingMap = new Map<string,set<Id>>();
        List<WOD_2__Claim__c> lstClaims = new List<WOD_2__Claim__c>{clm1};
        for(WOD_2__Claim__c t : lstClaims)
            {
                listTerritory.add('WarrantyGroup_'+ t.Territory__r.Territory_SalesOrg__c);
                if(newSharingMap.containsKey('WarrantyGroup_'+ t.Territory__r.Territory_SalesOrg__c))
                {
                    newSharingMap.get('WarrantyGroup_'+ t.Territory__r.Territory_SalesOrg__c).add(t.Id);        
                }else
                {
                    newSharingMap.put('WarrantyGroup_'+ t.Territory__r.Territory_SalesOrg__c, new set<Id>{t.Id});
                }
                
            }
       
        if (newSharingMap!= null && newSharingMap.size() >0 )
               
            {
               
                WOD_RecordSharing.shareRecordsWithRelatedGroup(listTerritory,newSharingMap,removeSharingMap,'Claim');
                 WOD_RecordSharing.shareRecordsWithRelatedGroup('Claim',listTerritory,newSharingMap,removeSharingMap);
                WOD_RecordSharing.shareRecordsWithRelatedGroup(listTerritory,newSharingMap,removeSharingMap,'QC');
                WOD_RecordSharing.shareRecordsWithRelatedGroup(listTerritory,newSharingMap,removeSharingMap,'LabAnalysis');
                 WOD_RecordSharing.shareRecordsWithRelatedGroup('QC',listTerritory,newSharingMap,removeSharingMap);
                WOD_RecordSharing.shareRecordsWithRelatedGroup('LabAnalysis',listTerritory,newSharingMap,removeSharingMap);
                 WOD_RecordSharing.shareRecordsWithRelatedGroup('Inspection',listTerritory,newSharingMap,removeSharingMap); 
                WOD_RecordSharing.shareRecordsWithRelatedGroup('ClaimQuestion',listTerritory,newSharingMap,removeSharingMap); 
                WOD_RecordSharing.shareRecordsWithRelatedGroup('ReportStatus',listTerritory,newSharingMap,removeSharingMap);
            }
    }
    /**
     * @description data set up and execution
    */
    public static testmethod void ShareTestMethod1(){
        Account acc  = WOD_TestDataFactory.createAccount('TestAccount2','','Warranty Account');
        insert acc;
        Territory__c t1 = new Territory__c();
        t1.Name ='WarrantyGroup_Tavant';
        t1.Territory_SalesOrg__c ='WarrantyGroup_a12345';
        t1.Sales_Org__c ='1501';
        t1.Sales_Rep__c =UserInfo.getUserId();
        t1.Sales_Rep2__c= UserInfo.getUserId();
        t1.Sales_Rep3__c = UserInfo.getUserId();
        t1.Sales_Rep4__c = UserInfo.getUserId();
        t1.Sales_Rep5__c = UserInfo.getUserId();
        insert t1;
        WOD_2__Claim__c clm1 = WOD_TestDataFactory.CreateClaim('Short_Term','Short Term',acc.id,'Roofing');
        clm1.Territory__r = t1;
        insert clm1;
       List<string> listTerritory = new List<string>();
       Map<string,set<Id>> newSharingMap = new Map<string,set<Id>>();
        Map<string,set<Id>> removeSharingMap = new Map<string,set<Id>>();
        List<WOD_2__Claim__c> lstClaims = new List<WOD_2__Claim__c>{clm1};
        for(WOD_2__Claim__c t : lstClaims)
            {
                listTerritory.add('WarrantyGroup_'+ t.Territory__r.Territory_SalesOrg__c);
                if(removeSharingMap.containsKey('WarrantyGroup_'+ t.Territory__r.Territory_SalesOrg__c))
                {
                    removeSharingMap.get('WarrantyGroup_'+ t.Territory__r.Territory_SalesOrg__c).add(t.Id);        
                }else
                {
                    removeSharingMap.put('WarrantyGroup_'+ t.Territory__r.Territory_SalesOrg__c, new set<Id>{t.Id});
                }
                
            }
       
        if (removeSharingMap!= null && removeSharingMap.size() >0 )
               
            {
               
                WOD_RecordSharing.shareRecordsWithRelatedGroup(listTerritory,newSharingMap,removeSharingMap,'Claim'); 
                WOD_RecordSharing.shareRecordsWithRelatedGroup(listTerritory,newSharingMap,removeSharingMap,'Inspection'); 
                WOD_RecordSharing.shareRecordsWithRelatedGroup(listTerritory,newSharingMap,removeSharingMap,'ClaimQuestion'); 
                WOD_RecordSharing.shareRecordsWithRelatedGroup(listTerritory,newSharingMap,removeSharingMap,'ReportStatus');
                WOD_RecordSharing.shareRecordsWithRelatedGroup('Claim',listTerritory,newSharingMap,removeSharingMap); 
                WOD_RecordSharing.shareRecordsWithRelatedGroup('Inspection',listTerritory,newSharingMap,removeSharingMap); 
                WOD_RecordSharing.shareRecordsWithRelatedGroup('ClaimQuestion',listTerritory,newSharingMap,removeSharingMap); 
                WOD_RecordSharing.shareRecordsWithRelatedGroup('ReportStatus',listTerritory,newSharingMap,removeSharingMap);
            }
    }
}