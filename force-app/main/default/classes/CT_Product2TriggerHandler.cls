/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Trigger on Product object. 
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author       Vincent Ip (vip@liquidhub.com)
* @version      1.0
* @created      2017-08-08
*
* NOTE : the Trigger REQUIRES that a Standard Price Book exists. 
* (i.e. any price book marked with the "Is Standard Price Book" check box on)
*/
public with sharing class CT_Product2TriggerHandler {
    private CT_Common_Settings__c settings;
    private static Map<String,Plants__c> codeToPlantMap;

    static{
        // This assumes all plant info isn't a large set of data.  
        //  Currently (10/8/2017), plant data is at a count of 33
        codeToPlantMap = new Map<String, Plants__c>();
        List<Plants__c> plantsList = [SELECT id, SAP_Plant__c,SAP_Plant_Name__c , Name from Plants__c WHERE SAP_Plant__c != null];
        for (Plants__c currPlant : plantsList){
            codeToPlantMap.put(currPlant.SAP_Plant__c, currPlant);
        }
    }
    public CT_Product2TriggerHandler(){
        settings = CT_Common_Settings__c.getInstance();
    }

    // template methods ---------------------------------------------------------------------------
    public void beforeInsertHandler(List<Product2> newList){
        translatePlantCodes(newList);
        setProductTypeCodeToQuoteSpecial(newList);
    }

    public void setProductTypeCodeToQuoteSpecial (List<Product2> newList) {
        Set<String> sapMaterialIds = new Set<String>();
        for (Product2 prod : newList) {
            if(prod.sap_material__c != null && prod.sap_material__c != '') {
                sapMaterialIds.add(prod.sap_material__c);
            }
        }
        Set<String> existingSAPMaterialIds = new Set<String>();

        if (sapMaterialIds.size() > 0) {
            List<Product2> existingProdsWithMatchingSAPMaterials = [select sap_material__c
                                                                    from Product2
                                                                    where SAP_material__c in :sapMaterialIds];
            for (Product2 nextProd : existingProdsWithMatchingSAPMaterials) {
                existingSAPMaterialIds.add(nextProd.sap_material__c);
            }
        }
        id newProductsRTid = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('New Products').getRecordTypeId();



        for (Product2 prod : newList) {
            System.debug('*** prod recordtype is ' + prod.recordtype.name);
            if (prod.recordTypeid == newProductsRTid) {
                prod.productcode = 'QUOTE SPECIAL';
                if (prod.sap_material__c != null && existingSAPMaterialIds.contains(prod.sap_material__c))
                    prod.SAP_Material__c = '';
                prod.Old_JDE_Material_ID__c = '';
                prod.sap_product__c = null;
            }
        }
        /*
        if (UserInfo != null && UserInfo.getProfileId != null) {
            id runningUserProfile = userinfo.getProfileId();
            String profileName = [select Name from profile where id = :runningUserProfile];
            if (profileName != 'Integration User') {

            }
        }
        */
    }

    public void afterInsertHandler(List<Product2> newList){
        createStandardPriceBookEntry(newList);
    }
    public void beforeUpdateHandler(List<Product2> newList, Map<Id, Product2> oldMap){
        translatePlantCodes_update(newList, oldMap);
        //adding in before update
        translatePlantCodes(newList);
    }
    public void afterUpdateHandler(List<Product2> newList, Map<Id, Product2> oldMap){
        if (settings.Force_PriceBookEntry_Create_on_Update__c) createStandardPriceBookEntry_update(newList, oldMap);

        updateQuoteProducts(newList, oldMap);
    }

    public void updateQuoteProducts(List<Product2> prods, Map<Id, Product2> oldMap) {
        List<id> newlyApprovedProducts = new List<Id>();
        for (Product2 currProd : prods) {
            if (currProd.request_status__c == 'Approved' && oldMap.get(currProd.id).request_status__c != 'Approved')
                newlyApprovedProducts.add(currProd.id);
        }
        List<ljq_product__c> quoteProdsToUpdate = [select id, Is_Unapproved_Request__c
                                                    from ljq_product__c
                                                    where product__c in :newlyApprovedProducts
                                                    and Is_Unapproved_Request__c = 1];
        for (ljq_product__c ljqProduct : quoteProdsToUpdate) {
            ljqProduct.Is_Unapproved_Request__c = 0;
        }
        update quoteProdsToUpdate;

    }

    // business logic methods ---------------------------------------------------------------------
    public void createStandardPriceBookEntry(List<Product2> newList){
        if (newList.size()>0){
            Id standardPriceBookId;
            
            List<PriceBook2> standardPriceBookList = [Select id from PriceBook2 where isStandard = true];
            if (standardPriceBookList.size()>0) standardPriceBookId = standardPriceBookList.get(0).Id;
            if (Test.isRunningTest()) standardPriceBookId = Test.getStandardPricebookId();

            List<PriceBookEntry> newPbeList = new List<PriceBookEntry>();

            for (Product2 currProduct: newList){
                newPbeList.add( 
                    new PriceBookEntry(
                         PriceBook2Id = standardPriceBookId
                        ,Product2Id = currProduct.Id 
                        ,UnitPrice = 0
                        ,isActive = true
                    )
                );
            }

            if (newPbeList.size()>0) insert newPbeList;
        }
    }
    public void createStandardPriceBookEntry_update(List<Product2> newList, Map<Id, Product2> oldMap){
        List<Product2> workingList = new List<Product2>();
        List<PriceBookEntry> existingPbeList = [SELECT id, Product2Id 
                                                FROM PriceBookEntry 
                                                WHERE Product2Id in :newList 
                                                AND PriceBook2.isStandard = true];

        Set<Id> existingStandardPbrProducts = new Set<Id>();
        for (PriceBookEntry currPbe : existingPbeList){
            existingStandardPbrProducts.add(currPbe.Product2Id);
        }

        for (Product2 currProduct : newList){
            if (existingStandardPbrProducts.contains(currProduct.Id)==false) workingList.add(currProduct);
        }

        createStandardPriceBookEntry( workingList );
    }


    public void translatePlantCodes(List<Product2> newList){
        for(Product2 currProduct: newList){
            if (String.isNotBlank(currProduct.Plants__c)){
                List<String> codeList = splitMultiSelectValue(currProduct.Plants__c);
                Set<String> nameSet = new Set<String>();
                Set<String> plantNameSet = new Set<String>();
                for (String currCode : codeList){
                    Plants__c currPlant = codeToPlantMap.get(currCode);
                    if (currPlant!=null) 
                    {
                    nameSet.add(currPlant.Name);
                    plantNameSet.add(currPlant.SAP_Plant_Name__c);
                    system.debug('plantNameSet size==>'+plantNameSet);
                    }
                }
               //ig(CHG1044966)  for 1300 and 1503 on product Object , plant Names to be updated with SAP_Plant_Name__c
                system.debug(' currProduct.Sales_Org__c==>'+currProduct.Sales_Org__c);
                if(currProduct.Sales_Org__c =='1300' || currProduct.Sales_Org__c =='1503')
                {
                system.debug('Inside if currProduct.Sales_Org__c==>'+currProduct.Sales_Org__c);
                 currProduct.Plant_Names__c = createMultiSelectValue(plantNameSet);
                }
                else
                {
                 currProduct.Plant_Names__c = createMultiSelectValue(nameSet);
                }
            }
        }
    }
    public void translatePlantCodes_update(List<Product2> newList, Map<Id, Product2> oldMap){
        List<Product2> workingList = new List<Product2>();

        for (Product2 currProduct : newList){
            if (currProduct.Plants__c != oldMap.get(currProduct.Id).Plants__c){
                workingList.add(currProduct);
            }
        }

        translatePlantCodes(workingList);
    }
    public List<String> splitMultiSelectValue(String inValue){
        List<String> retList = new List<String>();
        if (String.isNotBlank(inValue)){
            retList = inValue.split(';');
        }
        return retList;
    }
    public String createMultiSelectValue(Set<String> inSet){
        String retValue = '';
        if (inSet.isEmpty()==false){
            List<String> tempList = new List<String>();
            tempList.addAll(inSet);
            tempList.sort();
            retValue = String.join(tempList,';');
        }
        return retValue;
    }
}