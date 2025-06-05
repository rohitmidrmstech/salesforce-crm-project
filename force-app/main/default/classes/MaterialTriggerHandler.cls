public class MaterialTriggerHandler {
    public static void setProductOwnerasPlantManager(List<Product2> lst_Products){
        List<RecordType> newProdrtType = [SELECT Id,Name FROM RecordType WHERE SobjectType=: constants.materialObjAPIName AND Name =:constants.materialNewPrrodRTName];
       system.debug('****record Type****'+newProdrtType);
        Map<String,Plants__c> map_Plants = New Map<string,Plants__c>();
        Map<Id,Plants__c> map_Plantcodes = New Map<Id,Plants__c>();
        system.debug('***inside Material trigger handler class****');
        for(Plants__c plant : [SELECT ID,SAP_Plant__c,Name,Plant_Queue_Id__c FROM Plants__c]){
            system.debug('****plant ****'+plant);
            map_Plants.put(plant.SAP_Plant__c, plant);
            map_Plantcodes.put(plant.Id, plant);
            system.debug('****map_Plantcodes ****'+map_Plants);
        }        
        Map<String,Group> map_plantQueue = new Map<STring,Group>();
        for(Group grp : [Select Id,Name,Type from Group where (Name =: constants.noPlant OR Name=: constants.ecophon) and Type=:constants.queue]){
            map_plantQueue.put(grp.Name, grp);
            system.debug('****map_plantQueue ****'+map_plantQueue);
        }
       for(Product2 prod : lst_Products){
            system.debug('****lst_Products****'+lst_Products);
            if(newProdrtType.size() > 0 && Prod.RecordTypeId == newProdrtType[0].id){  
                 system.debug('****newProdrtType.size() ****'+newProdrtType.size());
                if(prod.Plants__c !=null && prod.Plants__c !='' && map_Plants.containsKey(prod.Plants__c)){
                   if(prod.Product_Family__c == constants.ecophon && (prod.Plants__c == constants.meridianPlantCode || prod.Plants__c == constants.bigBoardPlantCode) ){                   
                      
                     //  Prod.Owner__c= map_plantQueue.get(constants.ecophon).Id;
                     Prod.Owner__c = map_Plants.get(prod.Plants__c).Plant_Queue_Id__c != null ? map_Plants.get(prod.Plants__c).Plant_Queue_Id__c : prod.Owner__c;
                       system.debug('****Prod.Owner__c.size() ****'+Prod.Owner__c);
                    }
                    else{                    
                        Prod.Owner__c = map_Plants.get(prod.Plants__c).Plant_Queue_Id__c != null ? map_Plants.get(prod.Plants__c).Plant_Queue_Id__c : prod.Owner__c;
                        system.debug('**** Else Prod.Owner__c ****'+Prod.Owner__c);
                    }                
                }
                else if(prod.Plant_Names__c != null && map_Plantcodes.containsKey(prod.Plant_Names__c)){
                   if(prod.Product_Family__c == constants.ecophon && (map_Plantcodes.get(prod.Plant_Names__c).SAP_Plant__c== constants.meridianPlantCode || map_Plantcodes.get(prod.Plant_Names__c).SAP_Plant__c== constants.bigBoardPlantCode) ){                   
                       // Prod.Owner__c = map_plantQueue.get(constants.ecophon).Id;
                       Prod.Owner__c = map_Plants.get(prod.Plants__c).Plant_Queue_Id__c != null ? map_Plants.get(prod.Plants__c).Plant_Queue_Id__c : prod.Owner__c;
                        system.debug('**** Else if Prod.Owner__c ****'+Prod.Owner__c);
                    }
                    else{
                        Prod.Owner__c = map_Plantcodes.get(prod.Plant_Names__c).Plant_Queue_Id__c != null ? map_Plantcodes.get(prod.Plant_Names__c).Plant_Queue_Id__c : prod.Owner__c ;
                     system.debug('**** Else if Prod.Owner__c ****'+Prod.Owner__c);
                    }  
                }
                else{
                   // if(map_plantQueue.containsKey(constants.noPlant)){
                      
                      // Prod.Owner__c = map_plantQueue.get(constants.noPlant).id;
                   // }                   
                }
            }
        }
    }
    
    public static void updateStockingtoSellingConversionFactor(List<product2> lst_Products){        
        for(Product2 prod : lst_Products){            
            if((prod.Stocking_to_Selling_Conversion_Factor__c == null || prod.Stocking_to_Selling_Conversion_Factor__c == 0) 
                && prod.CORP_CLASS__c == 'CTC TECHSTYLE'){
                prod.Stocking_to_Selling_Conversion_Factor__c = prod.Stocking_to_Sq_Feet_Conversion_Factor__c;                    
            }    
            else if((prod.Stocking_to_Selling_Conversion_Factor__c == null || prod.Stocking_to_Selling_Conversion_Factor__c == 0) 
                && prod.MSF_MS_Conversion__c != null && prod.MSF_MS_Conversion__c > 0){
                prod.Stocking_to_Selling_Conversion_Factor__c = prod.MSF_MS_Conversion__c;                    
            }
            else if((prod.Stocking_to_Selling_Conversion_Factor__c == null || prod.Stocking_to_Selling_Conversion_Factor__c == 0) 
                && (prod.MSF_MS_Conversion__c == null || prod.MSF_MS_Conversion__c == 0)){
                prod.Stocking_to_Selling_Conversion_Factor__c = 1;                  
            }
        }        
    }
}