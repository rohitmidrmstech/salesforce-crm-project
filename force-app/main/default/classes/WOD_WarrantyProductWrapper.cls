/**
 * @description This class is used to handle Warranty Products 
*/
public class WOD_WarrantyProductWrapper {
    public static map<String,String> mapProductDetails;
    public static WOD_2__Warranty_Product__c objWarrantyProduct;
    /**
     * @description to get Warranty Product details
     * @param objWarrantyProductId Warranty Product Id
     * @param isRoofing flag for Roofing BU 
     * @return map of Warranty Product properties and value
    */
    public static map<String,String> getProductDetails(Id objWarrantyProductId, Boolean isRoofing){
        mapProductDetails = new map<String,String>();
        Map<string,Certain_Teed__c> CertainTeed = Certain_Teed__c.getAll(); 
            /*
            Boolean isSiding =CertainTeed.get('isSiding').BooleanValue__c;
            Boolean isRoofing = CertainTeed.get('isRoofing').BooleanValue__c;
            Boolean isDev = CertainTeed.get('isDev').BooleanValue__c;
            */
        	System.debug('===>'+isRoofing);
            if( isRoofing == true){
                objWarrantyProduct = [Select Id,Name,Product_Type__c, Product_Type__r.Additional_Story__c,Product_Type__r.Demolish_Tearoff__c,Product_Type__r.Steep_Pitch__c,
                Product_Type__r.Warranty_Labor_Cost__c,Product_Type__r.Warranty_Material_Cost__c, Item_class__c,Product__r.IDC__c,   
                Product__c,Producing_Plant__c,Producing_Plant__r.Facility_Code__c,Producing_Plant__r.Name , Product_Type__r.Name
                from WOD_2__Warranty_Product__c Where Id=:objWarrantyProductId Limit 1];
                /*Producing_Plant__r.Price_Area__r.Name, Product_Type__r.IDC__c,*/
                System.debug('*******'+objWarrantyProduct.Product_Type__r.Warranty_Labor_Cost__c);
                if(objWarrantyProduct.Product__c != null || objWarrantyProduct.Product_Type__c != null )
                {
                    mapProductDetails.put('PlantCode',objWarrantyProduct.Producing_Plant__c);
                    mapProductDetails.put('facilityCode',objWarrantyProduct.Producing_Plant__r.Facility_Code__c);
                    mapProductDetails.put('PlantName',objWarrantyProduct.Producing_Plant__r.Name);
                    mapProductDetails.put('ProductCode', objWarrantyProduct.Name);
                    mapProductDetails.put('DivisonCode', objWarrantyProduct.Item_class__c);
                    //mapProductDetails.put('District', objWarrantyProduct.Producing_Plant__r.Price_Area__r.Name);
                    //mapProductDetails.put('IDC', objWarrantyProduct.Product_Type__r.IDC__c);
                    //mapProductDetails.put('District', objWarrantyProduct.Producing_Plant__r.Name); //--Divya //Commented as this is not used
                    mapProductDetails.put('IDC', objWarrantyProduct.Product__r.IDC__c); 
                    mapProductDetails.put('LaborCost', string.valueof(objWarrantyProduct.Product_Type__r.Warranty_Labor_Cost__c));
                    mapProductDetails.put('MaterialCost', string.valueof(objWarrantyProduct.Product_Type__r.Warranty_Material_Cost__c));
                    mapProductDetails.put('SteepPitch', string.valueof(objWarrantyProduct.Product_Type__r.Steep_Pitch__c));
                    mapProductDetails.put('DemolishTearOff', string.valueof(objWarrantyProduct.Product_Type__r.Demolish_Tearoff__c));
                    mapProductDetails.put('AdditionalStory', string.valueof(objWarrantyProduct.Product_Type__r.Additional_Story__c));
                }else{
                    mapProductDetails.put('PlantCode',null);
                }
            }else {
                objWarrantyProduct = [Select Id,Name, Product_Line__c, Market_Family__r.Cedar_Impression_Factor__c, Market_Family__r.Demolish_Reinstall__c, Market_Family__r.Reduction_Factor__c  from WOD_2__Warranty_Product__c where id=:objWarrantyProductId Limit 1];
                if(objWarrantyProduct != null ){
                    if(objWarrantyProduct.Market_Family__c != null){
                        mapProductDetails.put('ReductionFactor',string.valueof(objWarrantyProduct.Market_Family__r.Reduction_Factor__c));
                        mapProductDetails.put('CedarImpressionFactor',string.valueof(objWarrantyProduct.Market_Family__r.Cedar_Impression_Factor__c));
                        mapProductDetails.put('DemolishReinstall',string.valueof(objWarrantyProduct.Market_Family__r.Demolish_Reinstall__c));     
                    }
                    mapProductDetails.put('DivisonCode',objWarrantyProduct.Product_Line__c);
                    mapProductDetails.put('ProductCode', objWarrantyProduct.Name);
                    mapProductDetails.put('PlantCode',null);
                    
                }else{
                    mapProductDetails.put('PlantCode',null);
                }
                
            }
    return mapProductDetails;
    }

}