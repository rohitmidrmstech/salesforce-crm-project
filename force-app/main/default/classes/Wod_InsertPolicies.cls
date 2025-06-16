public class Wod_InsertPolicies {
    public  void queryPolicies(List<id> polIds){
        List<WOD_Policy_Dummy__c> lstPolicy = [select Id, OwnerId, IsDeleted, Name, Algae_Protection_YR__c, Building_Type_Application__c, 
        Claim_Type__c, Defect_Code__c, End_Date__c, Homeowner_s_Insurance_First_Y_N__c, Ignore_Defect_Code__c, Labor_Included_Y_N__c, 
        Market_Family_Code__c, Material_Included_Y_N__c, Maxiumum_Liability__c, Ownership__c, PAT_Policy_ExternalId__c, 
        Policy_Active_Y_N__c, Priority__c, Product_Type_Code__c, Prorated_Y_N__c, Proration_Schedule__c, Reduction_Factor_MO__c, 
        Second_Owner_IN_Surestart__c, Second_Owner_OUT_Surestart__c, Start_Date__c, SureStart_Period__c, 
        Unique_Warranty_Registration__c, WR_External_Id__c, Warranty_Period__c, Warranty_Registration_Type__c, Wind_Speed__c, 
        Wind_Warranty_Term_Years__c, Workmanship_Coverage_Years__c, Description__c, Policy_Full_Name__c, 
        Warranty_Period_2nd_owner_after_SS__c, Warranty_Period_2nd_owner_within_SS__c, Roofing_Id__c, Siding_Id__c, Sales_Org__c, 
        Business_Units__c
        from WOD_Policy_Dummy__c where id in : polIds];
        insertPolicies(lstPolicy);
    }
    public void insertPolicies(List<WOD_Policy_Dummy__c> lstPolicyDummy){
        Savepoint sp = Database.SetSavepoint();
        
        try{
            Map<Id, WOD_2__Policy_Definition__c> policyMap = new Map<ID, WOD_2__Policy_Definition__c >();
            List<WOD_2__Policy_Definition__c > lstPolicyToInsert = new List<WOD_2__Policy_Definition__c >();
            List<WOD_2__Applicability_Term__c > applTermLst = new List<WOD_2__Applicability_Term__c >();
            /*
            for(WOD_Policy_Dummy__c objPolicyDummy: lstPolicyDummy){
                //Loop to fetch records to query
            }
            */
            
            for(WOD_Policy_Dummy__c objPolicyDummy: lstPolicyDummy){
                WOD_2__Policy_Definition__c  objPolicyDef = new WOD_2__Policy_Definition__c();
                String polBU = '';
                if(objPolicyDummy.Business_Units__c == 'Roofing'){
                    /*
                    if(objPolicyDummy.Ownership__c == '2' || objPolicyDummy.Ownership__c == '2+'){
                        if(objPolicyDummy.Second_Owner_OUT_Surestart__c != null) 
                            objPolicyDef.After_SureShort_Warranty_Period__c = objPolicyDummy.Second_Owner_OUT_Surestart__c*12;
                        if(objPolicyDummy.Second_Owner_IN_Surestart__c != null) 
                            objPolicyDef.twod__Months_Covered__c = objPolicyDummy.Second_Owner_IN_Surestart__c*12;
                    }else{
                        if(objPolicyDummy.Warranty_Period__c != null) 
                            objPolicyDef.twod__Months_Covered__c = objPolicyDummy.Warranty_Period__c*12;
                    }                    
                    */    
                }
                else{
                }
                objPolicyDef.Product_Type_Code__c= objPolicyDummy.Product_Type_Code__c;
                objPolicyDef.WOD_2__Active_From__c = objPolicyDummy.Start_Date__c;
                objPolicyDef.WOD_2__Active_Until__c = objPolicyDummy.End_Date__c;
                objPolicyDef.Policy_External_Id__c = objPolicyDummy.PAT_Policy_ExternalId__c;
                objPolicyDef.WOD_2__Priority__c = objPolicyDummy.Priority__c;
                objPolicyDef.SureStart_Period__c = objPolicyDummy.SureStart_Period__c; //*12;
                //Siding
                objPolicyDef.Proration_Schedule__c = objPolicyDummy.Proration_Schedule__c;                
                objPolicyDef.Name = objPolicyDummy.PAT_Policy_ExternalId__c;
                //Siding    
                objPolicyDef.Policy_Full_Name__c = objPolicyDummy.Policy_Full_Name__c;                
                objPolicyDef.Reduction_Factor_MO__c = objPolicyDummy.Reduction_Factor_MO__c;
                objPolicyDef.Workmanship_Coverage_Years__c = objPolicyDummy.Workmanship_Coverage_Years__c; //*12;
                objPolicyDef.Maxiumum_Liability__c = objPolicyDummy.Maxiumum_Liability__c;
                //objPolicyDef.Wind_Speed__c = objPolicyDummy.Wind_Speed__c;
                objPolicyDef.WOD_2__Status__c='Active';
                //objPolicyDef.After_SureShort_Warranty_Period__c = objPolicyDummy.Second_Owner_OUT_Surestart__c;//*12;
                //see line 18
                objPolicyDef.WOD_2__Months_Covered__c = objPolicyDummy.Warranty_Period__c; //*12;
                if(objPolicyDummy.Homeowner_s_Insurance_First_Y_N__c == 'Y'){
                    objPolicyDef.Homeowner_s_Insurance_First_Y_N__c = true;
                }
                else{
                    objPolicyDef.Homeowner_s_Insurance_First_Y_N__c = false;
                }
                
                if(objPolicyDummy.Labor_Included_Y_N__c == 'Y'){
                    objPolicyDef.Labor_Included_Y_N__c = true;
                }
                else{
                    objPolicyDef.Labor_Included_Y_N__c = false;
                }
                
                if(objPolicyDummy.Material_Included_Y_N__c == 'Y'){
                    objPolicyDef.Material_Included_Y_N__c = true;
                }
                else{
                    objPolicyDef.Material_Included_Y_N__c = false;
                }
                
                if(objPolicyDummy.Prorated_Y_N__c == 'Y'){
                    objPolicyDef.Prorated_Y_N__c = true;
                }
                else{
                    objPolicyDef.Prorated_Y_N__c = false;
                }
    
                //Siding
                if(objPolicyDummy.Policy_Active_Y_N__c == 'Y'){
                    objPolicyDef.WOD_2__Status__c = 'Active';
                }
                else{
                    objPolicyDef.WOD_2__Status__c = 'Inactive';
                }
                //policyMap.put(objPolicyDef.Policy_External_Id__c , objPolicyDef);
                lstPolicyToInsert.add(objPolicyDef);   
                
                WOD_2__Applicability_Term__c appTerm=new WOD_2__Applicability_Term__c( );    
                appTerm.WOD_2__Policy_Definition__r=new WOD_2__Policy_Definition__c(Policy_External_Id__c = objPolicyDef.Policy_External_Id__c);
                appTerm.WOD_2__Applicability_Term_Type__c='Inclusion'; 
                appTerm.WOD_2__Functionality__c='Warranty Rule';
                appTerm.WOD_2__isCustomLogicalExpression__c=true;
                appTerm.WOD_2__isValidExpression__c  = true;
                appTerm.WOD_2__Rule_Object_API_Name__c='WOD_2__Claim__c';
                applTermLst.add(appTerm);
                
                system.debug(appTerm);
            }
            
            insert lstPolicyToInsert;
            system.debug(lstPolicyToInsert);
            //insert policyMap.values();
            insert applTermLst;
            System.debug(applTermLst);
            List<WOD_2__Policy_Definition__c> policyLst = [SELECT ID, name,Policy_External_Id__c , 
                (SELECT Id, name from WOD_2__Applicability_Terms__r) 
                FROM WOD_2__Policy_Definition__c 
                WHERE ID IN :lstPolicyToInsert ];
            loadACs(lstPolicyDummy, policyLst );
        }
        catch(Exception ex){
            Database.rollback(sp);
            throw ex;
            
        }
        
    }
    
    public void loadACs(List<WOD_Policy_Dummy__c> lstPolicyDummy, List<WOD_2__Policy_Definition__c> policies ){
        Map<String, String> polATMap = new Map<String, String>();
        List<WOD_2__Applicability_Criteria__c> appCritLst=new List<WOD_2__Applicability_Criteria__c>();
        Map<String, WOD_2__Policy_Definition__c> policyMap = new Map<String, WOD_2__Policy_Definition__c >();
        List<WOD_2__Applicability_Criteria__c  > appCritList = new List<WOD_2__Applicability_Criteria__c  >();
        List<WOD_2__Applicability_Term__c > applTermUpd = new List<WOD_2__Applicability_Term__c >();
        Map<String, AC_Mapper__mdt> acWrapMap = new Map<String, AC_Mapper__mdt>();
        
        for(WOD_2__Policy_Definition__c pol : policies){
                //polMap.put(pol.Policy_External_Id__c , pol);
                policyMap.put(pol.Policy_External_Id__c , pol);        
        }
        
        for(AC_Mapper__mdt ac : [SELECT MasterLabel, DF__c, fldPath__c,fldPathL__c, fldType__c, Logical_Grping__c, Operator__c, 
        PolDummyFld__c, ValType__c FROM AC_Mapper__mdt ]){
            acWrapMap.put(ac.PolDummyFld__c, ac);
        }
        
        for(WOD_Policy_Dummy__c objPolicyDummy: lstPolicyDummy){
            Id appTermId= policyMap.get(objPolicyDummy.PAT_Policy_ExternalId__c).WOD_2__Applicability_Terms__r[0].Id;
            WOD_2__Applicability_Term__c appTerm = new WOD_2__Applicability_Term__c (id=appTermId);
            String logicalGrouping = '';
            Integer logicalCount=1;
            
            for(String polFld : acWrapMap.keySet()){
                AC_Mapper__mdt acWrap = acWrapMap.get(polFld);
                String polFldVal =(String) objPolicyDummy.get(polFld);
                if(!String.isBlank(polFldVal)){
                    List<String> fldVals= polFldVal.split(',');
                    if(fldVals.size() > 0){
                        logicalGrouping+= logicalGrouping!= '' ? ' AND (' : '(';
                        for(Integer i=1; i<fldVals.size()+1; i++){
                            // String dispF,String fldPath, String fldPathL, String fldType, String opertor, String valType, Integer seq)
                            WOD_2__Applicability_Criteria__c applCrit = createAC(appTermId, fldVals[i-1], fldVals[i-1], acWrap.DF__c,
                            acWrap.fldPath__c, acWrap.fldPathL__c, acWrap.fldType__c, acWrap.Operator__c, acWrap.ValType__c, logicalCount);
                            appCritList.add(applCrit);
                            
                            if(i==fldVals.size()){
                                logicalGrouping+= logicalCount;
                            }
                            else{
                                String logGrp = acWrap.Logical_Grping__c!= null ?acWrap.Logical_Grping__c : '';
                                logicalGrouping+= logicalCount + ' ' + logGrp   + ' ';
                            }
                            logicalCount++;
                        }
                        logicalGrouping+= ')';
                    }
                }
            }
            
            appTerm.WOD_2__Logical_Grouping__c = logicalGrouping;
            applTermUpd.add(appTerm);
            
        }
        insert appCritList;
        update applTermUpd;
        
    }
    
    public WOD_2__Applicability_Criteria__c  createAC(id termId, String criValT, String criVal, String dispF,String fldPath, 
        String fldPathL, String fldType, String opertor, String valType, Integer seq){
        WOD_2__Applicability_Criteria__c  applCrit=new WOD_2__Applicability_Criteria__c (WOD_2__Applicability_Term__c=termId);
        applCrit.WOD_2__Criteria_Value_Text__c=criValT;
        applCrit.WOD_2__Criteria_Value__c=criVal;
        applCrit.WOD_2__Delimiter__c=',';
        applCrit.WOD_2__Display_Format__c=dispF;
        applCrit.WOD_2__Field_Path_Label__c=fldPathL;
        applCrit.WOD_2__Field_Path__c  = fldPath;
        applCrit.WOD_2__Field_Type__c=fldType;
        applCrit.WOD_2__Object_Name__c='WOD_2__Claim__c';
        applCrit.WOD_2__Operator__c = opertor;
        applCrit.WOD_2__Sequence__c=seq;
        applCrit.WOD_2__Value_Type__c=valType;
        return applCrit;
    }
}

/*
            if(!String.isBlank(objPolicyDummy.Business_Units__c)){
                
                WOD_2__Applicability_Criteria__c applCrit = createAC(appTermId, objPolicyDummy.Business_Units__c, objPolicyDummy.Business_Units__c, 
                'String','WOD_2__BusinessCategory__r.Name','WOD_2__BusinessCategory__r.Name', 'STRING', 'Equals', 'Static', logicalCount);
                appCritList.add(applCrit);
                logicalGrouping += logicalCount ;
                logicalCount++;
            }
            
            if(objPolicyDummy.Defect_Code__c != null && objPolicyDummy.Defect_Code__c != ''){
                List<String> lstDefectCode = objPolicyDummy.Defect_Code__c.split(',');
                if(lstDefectCode.size() > 0){
                    logicalGrouping+= logicalGrouping!= '' ? ' AND (' : '(';
                    for(Integer i=1; i<lstDefectCode.size()+1; i++){
                        WOD_2__Applicability_Criteria__c applCrit = createAC(appTermId, lstDefectCode[i-1], lstDefectCode[i-1], 'String',
                        'Primary_Defect_Code__r.Name','Primary_Defect_Code__r.Name', 'STRING', 'Equals', 'Static', logicalCount);
                        appCritList.add(applCrit);
                        
                        if(i==lstDefectCode.size()){
                            logicalGrouping+= logicalCount;
                        }
                        else{
                            logicalGrouping+= logicalCount + ' OR ';
                        }
                        logicalCount++;
                    }
                    logicalGrouping+= ')';
                }
            }
            
            if(objPolicyDummy.Ignore_Defect_Code__c!= null && objPolicyDummy.Ignore_Defect_Code__c != ''){
                List<String> lstDefectCode = objPolicyDummy.Ignore_Defect_Code__c.split(',');
                if(lstDefectCode.size() > 0){
                    logicalGrouping+= logicalGrouping!= '' ? ' AND (' : '(';
                    for(Integer i=1; i<lstDefectCode.size()+1; i++){
                        WOD_2__Applicability_Criteria__c applCrit = createAC(appTermId, lstDefectCode[i-1], lstDefectCode[i-1], 'String',
                        'Primary_Defect_Code__r.Name','Primary_Defect_Code__r.Name', 'STRING', 'Not Equals', 'Static', logicalCount);
                        appCritList.add(applCrit);
                        
                        if(i==lstDefectCode.size()){
                            logicalGrouping+= logicalCount;
                        }
                        else{
                            logicalGrouping+= logicalCount + ' AND ';
                        }
                        logicalCount++;
                    }
                    logicalGrouping+= ')';
                }
            }
            
            if(objPolicyDummy.Claim_Type__c != null && objPolicyDummy.Claim_Type__c!= ''){
                List<String> clmTypes = objPolicyDummy.Claim_Type__c.split(',');
                if(clmTypes.size() > 0){
                    logicalGrouping+= logicalGrouping!= '' ? ' AND (' : '(';
                    for(Integer i=1; i<clmTypes.size()+1; i++){
                        WOD_2__Applicability_Criteria__c applCrit = createAC(appTermId, clmTypes[i-1], clmTypes[i-1], 'String',
                        'RecordType.DeveloperName','RecordType.DeveloperName', 'STRING', 'Equals', 'Static', logicalCount);
                        appCritList.add(applCrit);
                        
                        if(i==clmTypes.size()){
                            logicalGrouping+= logicalCount;
                        }
                        else{
                            logicalGrouping+= logicalCount + ' OR ';
                        }
                        logicalCount++;
                    }
                    logicalGrouping+= ')';
                }
            }
            
            if(objPolicyDummy.Building_Type_Application__c!= null && objPolicyDummy.Building_Type_Application__c!= ''){
                List<String> valList = objPolicyDummy.Building_Type_Application__c.split(',');
                if(valList .size() > 0){
                    logicalGrouping+= logicalGrouping!= '' ? ' AND (' : '(';
                    for(Integer i=1; i<valList.size()+1; i++){
                        WOD_2__Applicability_Criteria__c applCrit = createAC(appTermId, valList [i-1], valList [i-1], 'String',
                        'Building_Type__c','Building_Type__c', 'PICKLIST', 'Equals', 'Static', logicalCount);
                        appCritList.add(applCrit);
                        
                        if(i==valList.size()){
                            logicalGrouping+= logicalCount;
                        }
                        else{
                            logicalGrouping+= logicalCount + ' OR ';
                        }
                        logicalCount++;
                    }
                    logicalGrouping+= ')';
                }
            }
            
            if(objPolicyDummy.Ownership__c!= null && objPolicyDummy.Ownership__c!= ''){
                List<String> valList = objPolicyDummy.Ownership__c.split(',');
                if(valList .size() > 0){
                    logicalGrouping+= logicalGrouping!= '' ? ' AND (' : '(';
                    for(Integer i=1; i<valList.size()+1; i++){
                        WOD_2__Applicability_Criteria__c applCrit = createAC(appTermId, valList [i-1], valList [i-1], 'String',
                        'OwnershipType__c','OwnershipType__c', 'PICKLIST', 'Equals', 'Static', logicalCount);
                        appCritList.add(applCrit);
                        
                        if(i==valList.size()){
                            logicalGrouping+= logicalCount;
                        }
                        else{
                            logicalGrouping+= logicalCount + ' OR ';
                        }
                        logicalCount++;
                    }
                    logicalGrouping+= ')';
                }
            }
            
            if(objPolicyDummy.Product_Type_Code__c!= null && objPolicyDummy.Product_Type_Code__c!= ''){
                List<String> valList = objPolicyDummy.Product_Type_Code__c.split(',');
                if(valList .size() > 0){
                    logicalGrouping+= logicalGrouping!= '' ? ' AND (' : '(';
                    for(Integer i=1; i<valList.size()+1; i++){
                        WOD_2__Applicability_Criteria__c applCrit = createAC(appTermId, valList [i-1], valList [i-1], 'String',
                        'WOD_2__Warranty_Product__r.Product_Type__r.Product_Type_Code__c','WOD_2__Warranty_Product__r.Product_Type__r.Product_Type_Code__c', 'PICKLIST', 'Equals', 'Static', logicalCount);
                        appCritList.add(applCrit);
                        
                        if(i==valList.size()){
                            logicalGrouping+= logicalCount;
                        }
                        else{
                            logicalGrouping+= logicalCount + ' OR ';
                        }
                        logicalCount++;
                    }
                    logicalGrouping+= ')';
                }
            }
            
            if(objPolicyDummy.Market_Family_Code__c!= null && objPolicyDummy.Market_Family_Code__c!= ''){
                List<String> valList = objPolicyDummy.Market_Family_Code__c.split(',');
                if(valList .size() > 0){
                    logicalGrouping+= logicalGrouping!= '' ? ' AND (' : '(';
                    for(Integer i=1; i<valList.size()+1; i++){
                        WOD_2__Applicability_Criteria__c applCrit = createAC(appTermId, valList [i-1], valList [i-1], 'String',
                        'WOD_2__Warranty_Product__r.Market_Family__r.BPCS_Code__c','WOD_2__Warranty_Product__r.Market_Family__r.BPCS_Code__c', 'PICKLIST', 'Equals', 'Static', logicalCount);
                        appCritList.add(applCrit);
                        
                        if(i==valList.size()){
                            logicalGrouping+= logicalCount;
                        }
                        else{
                            logicalGrouping+= logicalCount + ' OR ';
                        }
                        logicalCount++;
                    }
                    logicalGrouping+= ')';
                }
            }
            */