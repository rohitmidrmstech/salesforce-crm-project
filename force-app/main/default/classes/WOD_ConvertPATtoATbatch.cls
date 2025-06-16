/**
 * @description This batch class is used for converting Policy Applicability Term to Applicability Term 
*/
global class WOD_ConvertPATtoATbatch implements Database.batchable<Sobject>, Database.stateful{
    String policyId;
    global WOD_ConvertPATtoATbatch(){
        
    }
    global WOD_ConvertPATtoATbatch(String policyId){
        this.policyId=policyId; 
    }
    /**
     * @description Start method of batch class
     * @param BC BatchableContext
     * @return QueryLocator
    */
    global database.QueryLocator start(Database.BatchableContext BC){
        String query='select id,Product_Type_Code__c,Roofing_Id__c,Siding_Id__c from WOD_2__Policy_Definition__c ' ;
        if(this.policyId!=null && this.policyId!=''){
            query=query+' where id =\''+policyId+'\''; 
        }
        return Database.getQueryLocator(query);
    }
    /**
     * @description execute method of batch class
     * @param BC BatchableContext
     * @param policyDefinitions List of Policy Definition records
     * @return void
    */
    global void execute(Database.BatchableContext BC, List<WOD_2__Policy_Definition__c> policyDefinitions){
        system.debug('policyDefinitions--------'+policyDefinitions);
        Map<Id,Id> PDWRMap=new Map<Id,Id>();
        Map<Id,List<WOD_2__Policy_Applicability_Term__c>>pdPATMap=new Map<Id,List<WOD_2__Policy_Applicability_Term__c>>();
        Map<Id,List<WOD_2__Warranty_Rule_Criteria__c>>WR_WRC_Map=new Map<Id,List<WOD_2__Warranty_Rule_Criteria__c>>();
        Map<Id,WOD_2__Policy_Definition__c>pds=new Map<Id,WOD_2__Policy_Definition__c>(policyDefinitions);
        Map<Id,WOD_2__Warranty_Rule_Association__c> pdWRAMap=new Map<Id,WOD_2__Warranty_Rule_Association__c>();
        List<WOD_2__Policy_Applicability_Term__c> patList=[select id,WOD_2__Policy_Definition__c,WOD_2__Applicability_Label__c, WOD_2__Applicability_SubType__c, WOD_2__Applicability_Term_Type__c, WOD_2__Applicability_Value__c, WOD_2__Related_To__c, WOD_2__WR_Field_Mapping_NS__c, WOD_2__WR_Field_Mapping__c from WOD_2__Policy_Applicability_Term__c where WOD_2__Policy_Definition__c in:pds.Keyset() order by Id asc];
        for(WOD_2__Policy_Applicability_Term__c pat:patList){
            system.debug('pdPATMap.containsKey(pat.WOD_2__Policy_Definition__c)'+pdPATMap.containsKey(pat.WOD_2__Policy_Definition__c));
            if(pdPATMap.containsKey(pat.WOD_2__Policy_Definition__c)){
                List<WOD_2__Policy_Applicability_Term__c> tempList=pdPATMap.get(pat.WOD_2__Policy_Definition__c);
                tempList.add(pat);
                pdPATMap.put(pat.WOD_2__Policy_Definition__c,tempList);
            }
            else{
                pdPATMap.put(pat.WOD_2__Policy_Definition__c,new List<WOD_2__Policy_Applicability_Term__c>{pat});
            }
        }
        List<WOD_2__Warranty_Rule_Association__c>WRAList=[select id, WOD_2__Warranty_Rule__c,WOD_2__Warranty_Rule__r.WOD_2__Logical_Grouping__c,WOD_2__Warranty_Rule__r.WOD_2__Enabled__c, WOD_2__Associated_Record_Id__c, WOD_2__Contact__c, WOD_2__Is_Active__c, WOD_2__Policy_Definition__c, Roofing_Id__c, Siding_Id__c  from WOD_2__Warranty_Rule_Association__c where WOD_2__Policy_Definition__c in:pds.Keyset() and WOD_2__Is_Active__c=true];
        for(WOD_2__Warranty_Rule_Association__c wra:WRAList){
            PDWRMap.put(wra.WOD_2__Policy_Definition__c,wra.WOD_2__Warranty_Rule__c);
            pdWRAMap.put(wra.WOD_2__Policy_Definition__c,wra);		 
        }
        List<WOD_2__Warranty_Rule_Criteria__c> wrcList=[select Id,WOD_2__Warranty_Rule__c,  WOD_2__Criteria_Type__c, WOD_2__Criteria_Value__c,  WOD_2__Related_Object__c  from WOD_2__Warranty_Rule_Criteria__c where WOD_2__Warranty_Rule__c in:PDWRMap.values()];
        for(WOD_2__Warranty_Rule_Criteria__c wrc:wrcList){
            if(WR_WRC_Map.containsKey(wrc.WOD_2__Warranty_Rule__c)){
                List<WOD_2__Warranty_Rule_Criteria__c> tempList=WR_WRC_Map.get(wrc.WOD_2__Warranty_Rule__c);
                tempList.add(wrc);
                WR_WRC_Map.put(wrc.WOD_2__Warranty_Rule__c,tempList);
            }
            else{
                WR_WRC_Map.put(wrc.WOD_2__Warranty_Rule__c,new List<WOD_2__Warranty_Rule_Criteria__c>{wrc});
            }
        }			  
        for(WOD_2__Policy_Definition__c pd:policyDefinitions){
            List<WOD_2__Policy_Applicability_Term__c> pats=pdPATMap.get(pd.Id);
            List<WOD_2__Applicability_Criteria__c> ACs=new List<WOD_2__Applicability_Criteria__c>();
            WOD_2__Applicability_Term__c AT=new WOD_2__Applicability_Term__c();
            AT.WOD_2__Policy_Definition__c=pd.Id;
            AT.WOD_2__Applicability_Term_Type__c='Inclusion'; 
            AT.WOD_2__Functionality__c='Warranty Rule';
            AT.WOD_2__isCustomLogicalExpression__c=true;
            AT.WOD_2__isValidExpression__c  = true;
            AT.WOD_2__Rule_Object_API_Name__c='WOD_2__Claim__c';
            //AT.WOD_2__Logical_Grouping__c='test';
            Integer Count=1;
            String LogicalGroupAND='';
            String LogicalGroupOR='';
            String FinalLogicalGroup='';
            String LogicalGroupOR1='';
            String LogicalGroupAND1='';
            String subLogicalGroup='';
            String sidingGroupAND='';
            String SidingGroupOR='';
            if(pats!=null && pats.size()>0){
                for(WOD_2__Policy_Applicability_Term__c pat:pats){
                    WOD_2__Applicability_Criteria__c  Ac=new WOD_2__Applicability_Criteria__c ();
                    String operator='';
                    Ac.WOD_2__Criteria_Value_Text__c=pat.WOD_2__Applicability_Value__c;
                    Ac.WOD_2__Criteria_Value__c=pat.WOD_2__Applicability_Value__c;
                    Ac.WOD_2__Delimiter__c=',';
                    Ac.WOD_2__Display_Format__c='String';
                    Ac.WOD_2__Field_Path_Label__c=pat.WOD_2__Applicability_SubType__c;
                    Ac.WOD_2__Field_Path__c  = pat.WOD_2__Applicability_SubType__c;
                    if('OwnershipType__c'.equals(pat.WOD_2__Applicability_SubType__c) || 'Building_Type__c'.equals(pat.WOD_2__Applicability_SubType__c)){
                        Ac.WOD_2__Field_Type__c='PICKLIST'; 
                    }
                    else{
                        Ac.WOD_2__Field_Type__c='STRING';
                    }
                    Ac.WOD_2__Object_Name__c='WOD_2__Claim__c';
                    AC.WOD_2__Operator__c='Equals';
                    AC.WOD_2__Sequence__c=count;
                    Ac.WOD_2__Value_Type__c='Static';
                    if('WOD_2__Warranty_Product__r.Market_Family__r.BPCS_Code__c'.equals(pat.WOD_2__Applicability_SubType__c) || pd.Product_Type_Code__c!=null && pd.Product_Type_Code__c.contains(',') && pd.Product_Type_Code__c.contains(pat.WOD_2__Applicability_Value__c)){
                        operator=' OR ';
                        if(LogicalGroupOR!=null && LogicalGroupOR!=''){
                            LogicalGroupOR=LogicalGroupOR+String.valueOf(count)+operator;
                        }
                        else{
                            LogicalGroupOR=String.valueOf(count)+operator; 
                        }
                    }
                    else {
                        if(pd.siding_Id__c!=null && 'OwnershipType__c'.equals(pat.WOD_2__Applicability_SubType__c) ){
                            operator=' OR ';
                        if(SidingGroupOR!=null && SidingGroupOR!=''){
                            SidingGroupOR=SidingGroupOR+String.valueOf(count)+operator;
                        }
                        else{
                            SidingGroupOR=String.valueOf(count)+operator; 
                        }  
                        }
                        else{
                        operator=' AND ';
                        if(LogicalGroupAND!=null && LogicalGroupAND!=''){
                            LogicalGroupAnd=LogicalGroupAnd+String.valueOf(count)+operator;
                        }
                        else{
                            LogicalGroupAnd=String.valueOf(count)+operator;
                        }
                        } 
                    }
                    count++;
                    Acs.add(Ac); 
                }
            }
            Boolean isRoofing=false;
            if(pd.Roofing_Id__c!=null){
                isRoofing=true;  
            }
            if(pd.siding_Id__c!=null && LogicalGroupOR!=null && LogicalGroupOR!=''){
               Integer tempCount= LogicalGroupOR.countMatches('OR');
                if(tempCount==1){
                   LogicalGroupOR=LogicalGroupOR.removeEnd('OR ');
                   LogicalGroupAND=LogicalGroupAND+LogicalGroupOR+' AND ';
                   LogicalGroupOR=''; 
                }
            }
            if(pd.siding_Id__c!=null && SidingGroupOR!=null && SidingGroupOR!=''){
               Integer tempCount= SidingGroupOR.countMatches('OR');
                if(tempCount==1){
                   SidingGroupOR=SidingGroupOR.removeEnd('OR ');
                   LogicalGroupAND=LogicalGroupAND+SidingGroupOR+' AND ';
                   SidingGroupOR=''; 
                }
                else{
                // LogicalGroupOR= LogicalGroupOR+SidingGroupOR;  
                }
            }
            system.debug('LogicalGroupAND---------------------'+LogicalGroupAND);
            system.debug('LogicalGroupOR---------------------'+LogicalGroupOR);
            LogicalGroupAND=addBusinessUnit(Acs,LogicalGroupAND, isRoofing,count);
            WOD_2__Warranty_Rule_Association__c WRA=pdWRAMap.get(pd.Id);
            if(WRA!=null){
                Id WarrantyRule= PDWRMap.get(pd.Id);
                if(WarrantyRule!=null){
                    
                    List<WOD_2__Warranty_Rule_Criteria__c> wrcs=WR_WRC_Map.get(WarrantyRule);
                    system.debug('WRCS----'+wrcs);
                    count++;
                  
                    if(wrcs!=null && wrcs.size()>0){
                        for(WOD_2__Warranty_Rule_Criteria__c wrc:wrcs){
                            WOD_2__Applicability_Criteria__c  Ac=new WOD_2__Applicability_Criteria__c ();
                            String operator='';
                            Ac.WOD_2__Criteria_Value_Text__c=wrc.WOD_2__Criteria_Value__c;
                            Ac.WOD_2__Criteria_Value__c=wrc.WOD_2__Criteria_Value__c;
                            Ac.WOD_2__Delimiter__c=',';
                            Ac.WOD_2__Display_Format__c='String';
                            Ac.WOD_2__Field_Path_Label__c='Primary_Defect_Code__r.Name ';
                            Ac.WOD_2__Field_Path__c  ='Primary_Defect_Code__r.Name ' ;
                            Ac.WOD_2__Field_Type__c='STRING';
                            Ac.WOD_2__Object_Name__c='WOD_2__Claim__c';
                            AC.WOD_2__Operator__c=wrc.WOD_2__Criteria_Type__c=='Not Equal To'?'Not Equals':wrc.WOD_2__Criteria_Type__c;
                            AC.WOD_2__Sequence__c=count;
                            Ac.WOD_2__Value_Type__c='Static';
                            if(wrcs.size()>1 && 'OR'.equals(WRA.WOD_2__Warranty_Rule__r.WOD_2__Logical_Grouping__c)){
                                operator=' OR ';
                                if(LogicalGroupOR1!=null && LogicalGroupOR1!=''){
                                    LogicalGroupOR1=LogicalGroupOR1+String.valueOf(count)+operator;
                                }
                                else{
                                    LogicalGroupOR1=String.valueOf(count)+operator; 
                                }
                            }
                            else  if(wrcs.size()==1 || 'AND'.equals(WRA.WOD_2__Warranty_Rule__r.WOD_2__Logical_Grouping__c)){
                                operator=' AND ';
                                if(LogicalGroupAND1!=null && LogicalGroupAND1!=''){
                                    LogicalGroupAND1=LogicalGroupAND1+String.valueOf(count)+operator;
                                }
                                else{
                                    LogicalGroupAND1=String.valueOf(count)+operator;
                                }
                                
                            } 
                            count++;
                            Acs.add(Ac); 
                        }
                    }
                }
            }
             if(LogicalGroupAND1!='' && LogicalGroupOR1!=''){
                LogicalGroupOR1=LogicalGroupOR1.removeEnd('OR ');
                LogicalGroupAND1=LogicalGroupAND1.removeEnd('AND ');
                subLogicalGroup=LogicalGroupAND1+' AND ('+LogicalGroupOR1+')'; 
                
            }
            else if(LogicalGroupAND1!=''){
                LogicalGroupAND1=LogicalGroupAND1.removeEnd('AND ');
                subLogicalGroup=LogicalGroupAND1;   
            }
            else if(LogicalGroupOR1!=''){
                LogicalGroupOR1=LogicalGroupOR1.removeEnd('OR ');
                 Integer tempCount= LogicalGroupOR1.countMatches('OR');
                if(tempCount!=null && tempCount>0){
                  subLogicalGroup= +'( '+LogicalGroupOR1+' )';   
                }
                else{
                subLogicalGroup= LogicalGroupOR1;
                }
            }
            if(LogicalGroupAND!='' && LogicalGroupOR!=''){
                system.debug('inside trim----');
                system.debug('LogicalGroupAND----'+LogicalGroupAND);
                system.debug('LogicalGroupOR----'+LogicalGroupOR);
                LogicalGroupOR=LogicalGroupOR.removeEnd('OR ');
                LogicalGroupAND=LogicalGroupAND.removeEnd('AND ');
                system.debug('after trim----');
                system.debug('LogicalGroupAND----'+LogicalGroupAND);
                system.debug('LogicalGroupOR----'+LogicalGroupOR);
                FinalLogicalGroup=LogicalGroupAND+' AND ('+LogicalGroupOR+')'; 
                
            }
            else if(LogicalGroupAND!=''){
                system.debug('inside LogicalGroupAND----- '+LogicalGroupAND);
                LogicalGroupAND=LogicalGroupAND.removeEnd('AND ');
                FinalLogicalGroup=LogicalGroupAND;
                   system.debug('inside FinalLogicalGroup----- '+FinalLogicalGroup);
            }
            else if(LogicalGroupOR!=''){
                LogicalGroupOR=LogicalGroupOR.removeEnd('OR ');
                FinalLogicalGroup= LogicalGroupOR;
            }
            if(SidingGroupOR!=''){
               SidingGroupOR=SidingGroupOR.removeEnd('OR '); 
               FinalLogicalGroup=FinalLogicalGroup +' AND ('+SidingGroupOR+')';
            }
            if(subLogicalGroup!=''){
                FinalLogicalGroup= FinalLogicalGroup+' AND '+subLogicalGroup;
            }
            AT.WOD_2__Logical_Grouping__c=FinalLogicalGroup;
            insert AT;
            for(WOD_2__Applicability_Criteria__c Ac:Acs){
                Ac.WOD_2__Applicability_Term__c=AT.Id;  
            }
            insert Acs;
        }
    }
    /**
     * @description add more fileds values in ACs
     * @param ACs List of Applicability Criteria
     * @param LogicalGroupAND filter condition
     * @param isRoofing BU filter
     * @param count counter variable
     * @return filter condition
    */
    String addBusinessUnit( List<WOD_2__Applicability_Criteria__c> ACs,String LogicalGroupAND, Boolean isRoofing,Integer count){
        WOD_2__Applicability_Criteria__c ac=new WOD_2__Applicability_Criteria__c();
        Ac.WOD_2__Criteria_Value_Text__c=isRoofing?'Roofing':'Siding';
        Ac.WOD_2__Criteria_Value__c=isRoofing?'Roofing':'Siding';
        Ac.WOD_2__Delimiter__c=',';
        Ac.WOD_2__Display_Format__c='String';
        Ac.WOD_2__Field_Path_Label__c='WOD_2__BusinessCategory__r.Name';
        Ac.WOD_2__Field_Path__c  = 'WOD_2__BusinessCategory__r.Name';
        Ac.WOD_2__Field_Type__c='STRING';
        Ac.WOD_2__Object_Name__c='WOD_2__Claim__c';
        AC.WOD_2__Operator__c='Equals';
        AC.WOD_2__Sequence__c=count;
        Ac.WOD_2__Value_Type__c='Static';
        if(LogicalGroupAND!=null && LogicalGroupAND!=''){
            LogicalGroupAnd=LogicalGroupAnd+String.valueOf(count)+' AND ';
        }
        else{
            LogicalGroupAnd=String.valueOf(count)+' AND ';
        }
        Acs.add(Ac);
        system.debug('inside business unit---------------'+LogicalGroupAnd);
        return LogicalGroupAnd;
    }
    /**
     * @description finish method of batch class
     * @param BC BatchableContext
     * @return void
    */
    global void finish(Database.BatchableContext BC){
        
        
    }
}