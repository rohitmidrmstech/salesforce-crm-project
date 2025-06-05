/**********************************************************************
Name: WOD_ClaimTriggerHandler
Copyright ? 2021  Tavant Technology Inc
==============================================================
===============================================================
Purpose: Trigger Handler Class for Claim.

-------                                                             
===============================================================
===============================================================
***********************************************************************/
public class WOD_ClaimTriggerHandler extends WOD_TriggerHandler{
    
    Map<Id, WOD_2__Claim__c> oldClaimMap;
    Map<Id, WOD_2__Claim__c> newClaimMap;
    List<WOD_2__Claim__c> newClaimList;
    /*
        Constructor
    */
    public WOD_ClaimTriggerHandler (){
        oldClaimMap = (Map<Id, WOD_2__Claim__c>)Trigger.oldMap;
        newClaimMap = (Map<Id, WOD_2__Claim__c>)Trigger.newMap;
        newClaimList= ( List<WOD_2__Claim__c>)Trigger.new;
    }
    
    public override void beforeInsert(){
        onBeforeInsert(newClaimList);
    }
    public override void afterInsert(){
        onAfterInsert(newClaimList);
    }
    public override void beforeUpdate(){
        //onBeforeUpdate(newClaimList, oldClaimMap);
        updatesalesorgBeforeUpdate(oldClaimMap,newClaimMap);
        quantityUpdatesBeforeUpdate();
        copySharing();
    }
    
    public override void afterUpdate(){
        
    }
    /*
    public void quantityUpdatesBeforeInsert(){
        for(WOD_2__Claim__c clm : newClaimList){
            if(clm.Business_Units__c == 'Siding'){
                if(clm.Quantity__c != null){
                    clm.Total_Quantity_of_Complaint_Material__c=clm.Quantity__c;
                }
                // if(clm.Total_Quantity_of_Complaint_Material__c != null){
                //     clm.Quantity__c=clm.Total_Quantity_of_Complaint_Material__c;
                // }
            }
        }
    }*/
    public void quantityUpdatesBeforeUpdate(){
        for(WOD_2__Claim__c clm : newClaimList){
            if(clm.Business_Units__c == 'Siding'){
                if(clm.Quantity__c != null){
                    clm.Total_Quantity_of_Complaint_Material__c=newClaimMap.get(clm.Id).Quantity__c;
                }
                // if(clm.Total_Quantity_of_Complaint_Material__c != null){
                //     clm.Quantity__c=newClaimMap.get(clm.Id).Total_Quantity_of_Complaint_Material__c;
                // }
            }
        }
    }
    public void onAfterInsert(List<WOD_2__Claim__c> newList){
         List<WOD_2__Claim__c> lstClaim = new List<WOD_2__Claim__c>(); 
        String ClName;
        Integer ClNo;
        String UpperClNo;
        String LowerClNo;
        for(WOD_2__Claim__c objClaim: newList){
             if(objClaim.Business_Units__c == 'Roofing' || objClaim.Business_Units__c =='Solar Solutions' || objClaim.Business_Units__c =='Commercial Building & Infrastructure'){//CER-211 claim Name
                ClName=objClaim.Auto_Number_Formula__c;
                //ClName=ClName.substring(2); TECP-731
                system.debug('ClName-->'+ClName);
                ClNo=Integer.valueof(ClName);
                Integer len=Integer.valueOf((System.Label.CT_DocLink).split(',')[0]);
                String lower=(System.Label.CT_DocLink).split(',')[1];
                String UpperStr=(System.Label.CT_DocLink).split(',')[2];
                Integer upper=Integer.valueOf((System.Label.CT_DocLink).split(',')[2]);
                WOD_2__Claim__c cl=new WOD_2__Claim__c(Id=objClaim.Id);
                cl.Warranty_Data_Link__c=(System.Label.CT_DocLink).split(',')[3];
                ClNo=ClNo / (upper+1);
                LowerClNo=String.valueof(ClNo)+lower;
                UpperClNo=String.valueof(ClNo)+UpperStr;
                while(LowerClNo.length() <len){
                    LowerClNo='0'+LowerClNo;
                    UpperClNo='0'+UpperClNo;
                }
                
                cl.Warranty_Data_Link__c=cl.Warranty_Data_Link__c+'CR'+LowerClNo+'-'+'CR'+UpperClNo+'/';
                cl.Name = 'CR'+objClaim.Auto_Number_Formula__c;
                lstClaim.add(cl);
            }
            else{
                 ClName=objClaim.Auto_Number_Formula__c;
                ClName=ClName; //ClName=ClName.substring(3);
                system.debug('ClName-->'+ClName);
                ClNo=Integer.valueof(ClName);
                Integer len=Integer.valueOf((System.Label.CT_DocLink_S).split(',')[0]);
                String lower=(System.Label.CT_DocLink_S).split(',')[1];
                String UpperStr=(System.Label.CT_DocLink_S).split(',')[2];
                Integer upper=Integer.valueOf((System.Label.CT_DocLink_S).split(',')[2]);
                WOD_2__Claim__c cl=new WOD_2__Claim__c(Id=objClaim.Id);
                cl.Warranty_Data_Link__c=(System.Label.CT_DocLink_S).split(',')[3];
                ClNo=ClNo / (upper+1);
                LowerClNo=String.valueof(ClNo)+lower;
                UpperClNo=String.valueof(ClNo)+UpperStr;
                while(LowerClNo.length() <len){
                    LowerClNo='0'+LowerClNo;
                    UpperClNo='0'+UpperClNo;
                }
                
                cl.Warranty_Data_Link__c=cl.Warranty_Data_Link__c+ 'CS'+ LowerClNo+'-'+'CS' + UpperClNo+'/';
                cl.name = 'CS'+objClaim.Auto_Number_Formula__c;
                lstClaim.add(cl);
            }
            
        }
        update lstClaim;
    }
    /**
        @MethodName : onBeforeInsert
        @Description:Method to perform before insert functionality of Claim.
    **/
    public void onBeforeInsert(List<WOD_2__Claim__c> MapNew){
        List<WOD_2__Claim__c> lstClaim=new List<WOD_2__Claim__c>();
       // List<WOD_2__Claim__c> updateClaim=new List<WOD_2__Claim__c>();
        Integer listSize;
        Map<Id,List<WOD_2__claim__c>> customerClaimMap=new Map<Id,List<WOD_2__claim__c>>();
        system.debug('Trigger Map-->'+MapNew);
        set<Id> customers=new set<Id>();
        set<String> business=new set <String>();
        Set<Id> clmTerr = new Set<Id>();
        Map<id, Territory__c> terriMap = new Map<Id, Territory__c> ();
        
        
        // Added below code to assign site claim to Queue
        String currentUsrId = UserInfo.getUserId();
        Map<String,String> claimQueueMap =  new Map<String,String>();
        For(Group grp: [select Id,DeveloperName from Group where Type = 'Queue' AND DeveloperName IN('Claim_Queue','Claim_Queue_Siding')]){
            claimQueueMap.put(grp.DeveloperName,grp.Id);
        }
        map<id,user> guestUserMap = new map<id,user>([select id from user where id =:currentUsrId AND UserType='Guest']);

        for(WOD_2__claim__c objClaim: MapNew){
            //Added by Ashraf
            if(objClaim.Business_Units__c == 'Siding'){
                if(guestUserMap!=null && guestUserMap.containsKey(currentUsrId)){
                    objClaim.ownerId = claimQueueMap.get('Claim_Queue_Siding');
                }
                
                if(objClaim.Quantity__c != null){
                    objClaim.Total_Quantity_of_Complaint_Material__c=objClaim.Quantity__c;
                }
                // if(clm.Total_Quantity_of_Complaint_Material__c != null){
                //     clm.Quantity__c=clm.Total_Quantity_of_Complaint_Material__c;
                // }
            }
            if(objClaim.Territory__c != null){
                clmTerr.add(objClaim.Territory__c);
            }
            if(!string.isEmpty(objClaim.Customer__c))
                customers.add(objClaim.Customer__c);
             business.add(objclaim.Business_Units__c);
        //CT Multi currency changes
            /*if(objClaim.Business_Units__c == 'Roofing'){
                if(guestUserMap!=null && guestUserMap.containsKey(currentUsrId)){
                    objClaim.ownerId = claimQueueMap.get('Claim_Queue');
                }
                
                if(objClaim.Country_BL__c =='Canada')
                {
                   objClaim.Currency__c = 'CAD';
                   objClaim.Sales_Org__c = '1102';
                }
                else
                {
                  objClaim.Currency__c = 'USD';
                  objClaim.Sales_Org__c = '1501';
                }
            }
            else{
                objClaim.Currency__c = 'USD';
                objClaim.Sales_Org__c = '1502';
            }*/
             //----CER-211 Satart---
            calcSalesOrgonInsert(objClaim);
                //----CER-211 END----
        }
        if(clmTerr <> null && clmTerr.size() > 0){
            terriMap  = fetchTerrMap(clmTerr);
        }
        if(Customers.size()>0){
            for(WOD_2__claim__c objClaim:[Select Id,Customer__c, isDuplicate__c  from WOD_2__claim__c where Customer__c IN: Customers and Business_Units__c IN: business]){
                List<WOD_2__claim__c> li;
                if(customerClaimMap.get(objClaim.Customer__c) == null){
                    li=new List<WOD_2__claim__c>();                
                }else{
                    li=customerClaimMap.get(objClaim.Customer__c);                
                }
                li.add(objClaim);
                customerClaimMap.put(objClaim.Customer__c, li);
            }
            
        }
        for(WOD_2__claim__c objClaim: MapNew){ 
            if(customerClaimMap.containsKey(objClaim.Customer__c)){
                lstClaim=customerClaimMap.get(objClaim.Customer__c);
                listSize=0;
                if(lstClaim!=null)
                    listSize=lstClaim.size();
                system.debug('nyclaim '+listSize);
                if(listSize>0){
                    objClaim.isDuplicate__c=true;
                   /* Change Request CER-67
                   for(WOD_2__Claim__c c:lstClaim){ 
                        if(!c.isDuplicate__c){
                            c.isDuplicate__c=true;
                            updateClaim.add(c) ;            
                        }
                    } */                   
                    //updateClaim.addAll(lstClaim) ;            
                }
            }
            if(objClaim.Territory__c != null && terriMap.containsKey(objClaim.Territory__c)){
                objClaim.Territory_Number__c = terriMap.get(objClaim.Territory__c).Territory_Code__c;
            }
        }
       /* Change Request CER-67  system.debug('updateClaim-->'+updateClaim.size());
        if(updateClaim <> null && updateClaim.size() > 0){
            Set<WOD_2__claim__c> claimSet=new Set<WOD_2__claim__c>(updateClaim);
            updateClaim=new List<WOD_2__claim__c>(claimSet);
            update updateClaim;
        }*/
    }    
    
    @InvocableMethod
    public static void updateOldestPaymentdateOnClaim(List<Id> claimId){

        System.debug('claimId-->' + claimId);
        List<WOD_Payment__c> lst_Payments = new List<WOD_Payment__c>();
        List<Wod_payment__c> update_payments=new List<WOD_Payment__c>();
        Map<ID, WOD_Payment__c> map_payments = new Map<ID, WOD_Payment__c>();
        for(WOD_Payment__c obj_pay : [SELECT ID,Void_WOD_Payment__c,Payment_Date__c,First_Payment__c,Claim__c FROM WOD_Payment__c WHERE Payment_Date__c != null
                                  AND Claim__c in : claimId  ORDER BY Payment_Date__c ASC]){
             if(!map_payments.containsKey(obj_pay.Claim__c)){
                map_payments.put(obj_pay.Claim__c, obj_pay);
                 lst_Payments.add(obj_pay);
             }
             else if(obj_pay.First_Payment__c==1 && obj_pay.Void_WOD_Payment__c!=true ){
             update_payments.add(obj_pay);
             }
        }
       List<WOD_2__claim__c> lst_Claim = [SELECT ID,Date_of_First_Payment__c FROM WOD_2__claim__c WHERE Id in: claimId];
       List<WOD_2__claim__c> newlst_Claim;
        if(lst_Claim.size() > 0){
            newlst_Claim = new List<WOD_2__claim__c>();
            for(WOD_2__claim__c obj_Claim : lst_Claim){
                if(map_payments.containsKey(obj_Claim.id)){
                    if(obj_Claim.Date_of_First_Payment__c!=map_payments.get(obj_Claim.id).Payment_Date__c){
                      obj_Claim.Date_of_First_Payment__c = map_payments.get(obj_Claim.id).Payment_Date__c;
                      //obj_Claim.Update_First_Payment__c = false;
                      newlst_Claim.add(obj_Claim);
                    }
                }              
            }
            if(newlst_Claim!=null && newlst_Claim.size()>0){
               
           update newlst_Claim;
                
            }
        }
        
         List<WOD_Payment__c> newlst_Payments= new List<WOD_Payment__c>(); 
         if(lst_Payments.size()>0){
             for(WOD_Payment__c obj_Payment : lst_Payments){
                if(obj_Payment.Void_WOD_Payment__c!=true && obj_Payment.First_Payment__c!=1){
                  obj_Payment.First_Payment__c  = 1; 
                  obj_Payment.Updated_First_Payment__c  = true; 
                  newlst_Payments.add(obj_Payment);
                }
             }
            }
            if(update_payments.size()>0) {
              for(WOD_Payment__c obj_Payment : update_payments){
              obj_Payment.First_Payment__c=null;
              }
            }
        
         if(newlst_Payments.size()>0|| update_payments.size()>0)
         {
             system.debug('Paymentupdate------->'+newlst_Payments);
             newlst_Payments.addAll(update_payments);
             update newlst_Payments;
         }
        
         }
    public static Map<Id, Territory__c> fetchTerrMap(Set<Id> terrIds){
        Map<Id, Territory__c> terMap= new Map<Id, Territory__c>([SELECT Id,name, Territory_Code__c
        from Territory__c where id In : terrIds]);
        return terMap;
        
    }
    
    public void copySharing(){
        
        Set<Id> claimIds = new Set<Id>();
        for(Wod_2__Claim__c claim: newClaimList)
            if(claim.OwnerId != oldClaimMap.get(claim.Id).OwnerId) {
                claimIds.add(claim.Id);
            }
        if(claimIds!=null && claimIds.size()>0){
        WOD_RecordSharing.persistSharing(
            JSON.serialize(
                [SELECT Id, AccessLevel, parentID, RowCause, UserOrGroupId 
                 FROM   WOD_2__Claim__Share 
                 WHERE  parentId IN :claimIds AND 
                 RowCause = 'Manual']));
            }
    }
    public void updatesalesorgBeforeUpdate(Map<Id, WOD_2__Claim__c> oldMap, Map<Id, WOD_2__Claim__c> newMap) {
    system.debug('newMap: '+newMap);
    system.debug('oldMap: '+oldMap);
    for (Id claimId : newMap.keySet()) {
         System.debug('Record Id: ' + claimId);
        WOD_2__Claim__c objClaim = newMap.get(claimId);
        WOD_2__Claim__c oldClaim = oldMap.get(claimId);
         if (objClaim.WOD_2__Claim_Status__c == 'Pre-Claim' || objClaim.WOD_2__Claim_Status__c == 'Need more Information') {
            system.debug('--Passing Update---');
             calcSalesOrgonInsert(objClaim);
         }
    }
}

    //CER-211        //calcSalesOrgonInsert(objClaim);
    public void calcSalesOrgonInsert(WOD_2__Claim__c objClaim){
        System.debug(objClaim);
        if(objClaim.WOD_2__Claim_Type__c=='International' ){
            system.debug('--Passing International---');
            if(objClaim.Business_Units__c=='Siding'){
                objClaim.Sales_Org__c = '1502';
                objClaim.Currency__c = objClaim.Country_BL__c=='Canada' ? 'USD' : 'USD';

            }
            else{
                objClaim.Sales_Org__c = '1501';
                objClaim.Currency__c = objClaim.Country_BL__c=='Canada' ? 'CAD' : 'USD';
            }
        }
        else {
            if(objClaim.Business_Units__c=='Solar Solutions' && objClaim.Division_Code__c!=null && objClaim.Country_BL__c !=null){
                if(objClaim.Division_Code__c =='Solar' && objClaim.Country_BL__c=='United States'){
                    objClaim.Currency__c = 'USD';
                    objClaim.Sales_Org__c = '1501';
                }
                else{
                    objClaim.Currency__c = 'CAD';
                    objClaim.Sales_Org__c = '1102';
                }
            }
            if (objClaim.Business_Units__c == 'Commercial Building & Infrastructure' && objClaim.Division_Code__c != null && objClaim.Country_BL__c != null) {
                if (objClaim.Country_BL__c == 'United States' && (objClaim.Division_Code__c == 'Commercial' || objClaim.Division_Code__c == 'SBM Commercial WP' )) {
                    objClaim.Currency__c = 'USD';
                    objClaim.Sales_Org__c = '1501';
                } 
                else if ( objClaim.Country_BL__c == 'United States' && (objClaim.Division_Code__c == 'SBM Fireproofing' || objClaim.Division_Code__c == 'SBM Infrastructure' 
                || objClaim.Division_Code__c == 'CBI Deneef')) {
                    objClaim.Currency__c = 'USD';
                    objClaim.Sales_Org__c = '1021';
                }  
            }
            //twodcs-3093 changed condition Country_BL__c=='Canada' and currency was changed to CAD
            if (objClaim.Business_Units__c == 'Commercial Building & Infrastructure' && objClaim.Division_Code__c != null && objClaim.Country_BL__c != null && objClaim.Country_BL__c == 'Canada'){
                if (objClaim.Division_Code__c == 'Commercial' || objClaim.Division_Code__c == 'SBM Commercial WP') {
                    objClaim.Currency__c = 'CAD';
                    objClaim.Sales_Org__c = '1102';
                }else if (objClaim.Division_Code__c == 'SBM Fireproofing' || objClaim.Division_Code__c == 'SBM Infrastructure' || objClaim.Division_Code__c == 'CBI Deneef') {
                    objClaim.Currency__c = 'CAD';
                    objClaim.Sales_Org__c = '1111';
                } 
            }
    
            if (objClaim.Business_Units__c == 'Roofing' && objClaim.Division_Code__c != null && objClaim.Country_BL__c != null && objClaim.Country_BL__c == 'United States') {
                if (objClaim.Division_Code__c == 'Residential'|| objClaim.Division_Code__c == 'Symphony' || objClaim.Division_Code__c == 'Metal Roofing' 
                    || objClaim.Division_Code__c == 'SBM Residential WP' ) {
                    objClaim.Currency__c = 'USD';
                    objClaim.Sales_Org__c = '1501';
                } 
            }
            if(objClaim.Business_Units__c == 'Roofing' && objClaim.Division_Code__c != null && objClaim.Country_BL__c != null && objClaim.Country_BL__c == 'Canada'){
                if (objClaim.Division_Code__c == 'Residential'|| objClaim.Division_Code__c == 'Symphony' || objClaim.Division_Code__c == 'Metal Roofing' 
                    || objClaim.Division_Code__c == 'SBM Residential WP' ) {
                    objClaim.Currency__c = 'CAD';
                    objClaim.Sales_Org__c = '1102';
                }
            }
            if(objClaim.Business_Units__c=='Siding' && objClaim.Division_Code__c!=null && objClaim.Country_BL__c !=null && objClaim.Country_BL__c=='United States'){
                if(objClaim.Division_Code__c =='ABTCo Vinyl' && objClaim.Country_BL__c=='United States'){
                    objClaim.Currency__c = 'USD';
                    objClaim.Sales_Org__c = '1020';
                }
                else if(objClaim.Division_Code__c =='KP Vinyl' || objClaim.Division_Code__c =='Kaycan Vinyl'
                || objClaim.Division_Code__c =='SPG Polymer Shakes' || objClaim.Division_Code__c =='SPG Kaycan Metal' 
                || objClaim.Division_Code__c =='SPG Fence' || objClaim.Division_Code__c =='SPG Railing' || objClaim.Division_Code__c =='SPG Deck'
                || objClaim.Division_Code__c =='SPG CT Metal' || objClaim.Division_Code__c =='Fiber Cement' || objClaim.Division_Code__c =='Windows' 
                || objClaim.Division_Code__c =='Pipe'){
                    objClaim.Currency__c = 'USD';
                    objClaim.Sales_Org__c = '1502';
                }
                else if(objClaim.Division_Code__c =='Coated Coil' && objClaim.Country_BL__c=='United States'){
                    objClaim.Currency__c = 'USD';
                    objClaim.Sales_Org__c = '1019';
                }
                else if(objClaim.Division_Code__c =='SPG CT Siding'|| objClaim.Division_Code__c =='SPG Norandex Siding' || objClaim.Division_Code__c =='SPG Millwork'
                || objClaim.Division_Code__c =='SPG Wolverine Siding' || objClaim.Division_Code__c =='SPG Stone' || objClaim.Division_Code__c =='SPG Hardboard Siding' ){
                    objClaim.Currency__c = 'USD';
                    objClaim.Sales_Org__c = '1502';
                }
                
                
            }
            if(objClaim.Business_Units__c=='Siding' && objClaim.Division_Code__c!=null && objClaim.Country_BL__c !=null && objClaim.Country_BL__c=='Canada'){
                if(objClaim.Division_Code__c =='SPG Norandex Siding' ||  objClaim.Division_Code__c =='SPG Wolverine Siding' || objClaim.Division_Code__c =='SPG Polymer Shakes' 
                  || objClaim.Division_Code__c =='SPG CT Siding' || objClaim.Division_Code__c =='SPG Stone' || objClaim.Division_Code__c =='SPG Hardboard Siding'
                  || objClaim.Division_Code__c =='SPG Fence' || objClaim.Division_Code__c =='SPG Millwork' ){
                    objClaim.Currency__c = 'USD';
                    objClaim.Sales_Org__c = '1502';
                }
                else if(objClaim.Division_Code__c =='SPG Railing' ||objClaim.Division_Code__c =='SPG Deck' || objClaim.Division_Code__c =='SPG CT Metal' 
                  || objClaim.Division_Code__c =='Fiber Cement' || objClaim.Division_Code__c =='Pipe' || objClaim.Division_Code__c =='Windows' ){
                    objClaim.Currency__c = 'USD';
                    objClaim.Sales_Org__c = '1502';
                }
                else if(objClaim.Division_Code__c =='ABTCo Vinyl' ||objClaim.Division_Code__c =='KP Vinyl' || objClaim.Division_Code__c =='Kaycan Vinyl' 
                  || objClaim.Division_Code__c =='Coated Coil' || objClaim.Division_Code__c =='SPG Kaycan Metal'){ // CER-245
                    objClaim.Currency__c = 'USD';
                    objClaim.Sales_Org__c = '1502';
                }
                
            }
        }    
        System.debug(objClaim);   
        System.debug(objClaim.Sales_Org__c);   
        //END - CER-211  

    }
}