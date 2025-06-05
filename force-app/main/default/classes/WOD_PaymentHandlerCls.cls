/**
 * @description This Class has been used to handle payment record and invoked from lwc component
*/
public with sharing class WOD_PaymentHandlerCls {
    /**
     * @description To get Payment details
     * @param recId Payment Id
     * @return Payment Record
    */
    @AuraEnabled
    public static WOD_Payment__c fetchPaymentForURL(String recId){
        WOD_Payment__c payment =  new WOD_Payment__c();        
        Id objId = Id.valueOf(recId);
        String sObjName = objId.getSObjectType().getDescribe().getName();
        String paymentRecordId ='';
        if(sObjName =='WOD_Payment_Line__c'){
            WOD_Payment_Line__c pl = new WOD_Payment_Line__c();
            pl = [Select id,Payment__c from WOD_Payment_Line__c where id=:recId];
            paymentRecordId = pl.Payment__c;
        }else{
            paymentRecordId= recId;
        }
        payment =[Select Id,Name,RecordType.Name,Currency__c,Sales_Org__c,Claim__r.Name,Claim__r.WOD_2__Claim_Status__c from WOD_Payment__c where id=:paymentRecordId];
        return payment;
    }
    /**
     * @description This method user to get WOD_Payment_Line__c
     * @param paymentLineId Payment Line Id
     * @return List of Payment Line Records
    */
    @AuraEnabled(cacheable=false)
    public static WOD_Payment__c getPaymentFromPLId(String paymentLineId){  
        System.debug('TTTTTTT'+paymentLineId);    
        return fetchPaymentForURL(paymentLineId);
        //return [Select Id,Payment__c,Payment__r.Name,Payment__r.Claim__r.WOD_2__Claim_Status__c,Payment__r.Sales_Org__c,Payment__r.Claim__c ,Payment__r.Claim__r.Name,Payment__r.RecordType.Name from WOD_Payment_Line__c where id=:paymentLineId];
    }
    /**
     * @description This method user to get pitch cost
     * @param pitch pitch value
     * @return Decimal Value
    */
    @AuraEnabled(cacheable=false)
    public static Decimal getPitchCost(Integer pitch, String stype){
        Decimal price = 0;
        if(stype == 'HAN' || stype == 'HAP'){            
            price = WOD_PaymentManager.GetPitchRoofCostwithSType(pitch, stype).setScale(2);
        }
        else{
            price = WOD_PaymentManager.GetPitchRoofCost(pitch).setScale(2);
        }        
        return price;
    }
    /**
     * @description This method user to get WOD_2__Warranty_Product__c.
     * @param packageRecordType Record Type
     * @param warrantyProductId Warranty Product Id
     * @return Warranty Product record
    */
    @AuraEnabled(cacheable=false)
    public static WOD_2__Warranty_Product__c getProductDescription(String packageRecordType,String warrantyProductId){
        WOD_2__Warranty_Product__c warrantyProduct = new WOD_2__Warranty_Product__c();  
        try{
            if(packageRecordType !='Credit/Debit'){
                if(warrantyProductId !=null){
                    WOD_2__Warranty_Product__c wp=[select id,WOD_2__Product_Name__c,Gross_Weight__c,UOM_Conversion__c from WOD_2__Warranty_Product__c where id=:warrantyProductId];
                    warrantyProduct.WOD_2__Product_Name__c=wp.WOD_2__Product_Name__c;
                    warrantyProduct.Gross_Weight__c=null;
                    if(packageRecordType == 'Free Material'){
                        warrantyProduct.Gross_Weight__c=wp.Gross_Weight__c; 
                        warrantyProduct.UOM_Conversion__c = wp.UOM_Conversion__c;
                    }
                }
                else{
                    warrantyProduct.WOD_2__Product_Name__c='';
                    warrantyProduct.Gross_Weight__c=null;
                }
            }
            if(packageRecordType =='Credit/Debit'){
                if(warrantyProductId !=null){
                    warrantyProduct.WOD_2__Product_Name__c=[select id,WOD_2__Product_Name__c from WOD_2__Warranty_Product__c where id=:warrantyProductId].WOD_2__Product_Name__c;
                }
                else{
                    warrantyProduct.WOD_2__Product_Name__c='';
                }
            }
        }   
        catch(exception ex){
            System.debug('=====>'+ex);
        }
        return warrantyProduct; 
    }

    /**
     * @description This method user to list of payment lines.
     * @param paymentlist List of Payment Line
     * @return message
    */
    @AuraEnabled(cacheable=false)
    public static String deletePaymentLineLst(List<WOD_Payment_Line__c> paymentlist){
        // for all paymentline the payment id is same so considering 1st row from list
        try{
            String paymentid = paymentlist[0].Payment__c;
            Database.delete(paymentlist,false);
            calculateTotalAmountOnPackage(paymentid,'');
            return 'success';
        }
        catch(DMLException  ex){
            return ex.getDmlMessage(0);
        }
        
    }

    /**
     * @description This method user to get list of payment line details.
     * @param paymentId Payment Id
     * @return list of WOD_Payment_Line__c object
    */
    @AuraEnabled
    public static List<WOD_Payment_Line__c> getPaymentLineLst(String paymentId){
        List<WOD_Payment_Line__c> listPL = new List<WOD_Payment_Line__c>();
        listPL = [SELECT Payment__r.Exchange_Rate__c, Additional_Story__c,Amount__c,Amount_Converted__c,Comments__c,UOM__c,Demolish_TearOff__c,Previous_Amount__c,Months_Covered__c,Months_Used__c,Material_Name__c,
                         Description__c,Id,Manufacturing_Plant__c,Manufacturing_Plant__r.Id,Manufacturing_Plant__r.Name,Material_Code__c,Material_Number__c,Total_Weight__c,Gross_Weight__c,Sales_Org__c,
                         Name,On_Hold__c,Payment__c,Plant_Code__c,Policy_Requestor__c,Quantity__c,Remit_To__c,Product_Name__c,LocationFactor__c,OriginalPrice__c,Product_Filter__c,Policy_Requestor1__c, 
                         Sequence_Number__c,Previous_Recieved_Amount__c ,Settlement_Basis__c,Settlement_Type_new__c,Steep_Pitch__c,is_Primary_Material__c,Payment__r.Claim__r.Quantity__c,Other_Settlement_Type_Reason__c, 
                         Total_Payment_Amount__c,Total_Payment_Amount_Converted__c,Unit_of_Measure__c,Pitch__c,Warranty_Product__c,Warranty_Product__r.Name,Calculation_Formula__c,Payment__r.recordType.Name,Payment__r.Settlement_Type__c FROM 
                         WOD_Payment_Line__c where Payment__c =: paymentId order by createdDate];
        return listPL;
    }
    /**
     * @description This method user to get payment details.
     * @param paymentId Payment Id
     * @return Payment record
    */
    @AuraEnabled(cacheable=false)
    public static WOD_Payment__c getPaymentDetial(String paymentId){
        WOD_Payment__c payment = new WOD_Payment__c();
        payment =[Select id,RecordTypeId,RecordType.Name,Settlement_Type__c,Claim__r.Primary_Defect_Code_Code__c,Remit_To__c,Claim__c,Claim__r.WOD_2__Claim_Status__c,Sales_Org__c,Order_Type__c,Approved__c,
                  Currency__c,Exchange_Rate__c,Claim__r.Quantity__c,Claim__r.ClaimType__c,Claim__r.Plant__r.Name,Claim__r.WOD_2__Warranty_Product__r.Name,Claim__r.WOD_2__Warranty_Product__c,
                  Released_To_SAP__c,Claim__r.WOD_2__Warranty_Product__r.Id,Claim__r.WOD_2__Warranty_Product__r.WOD_2__Product_Name__c,Ship_To__c,Plant_Code__c,Discontinued__c,  
                  Claim__r.WOD_2__Warranty_Product__r.Product_Type__r.Warranty_Labor_Cost__c,Void_WOD_Payment__c,Total_Weight__c,Claim__r.WOD_2__BusinessCategory__r.WOD_Max_weight__c from WOD_Payment__c where Id=:paymentId];
        return payment;
    }
    /**
     * @description this method used for payment line DML operation
     * @param paymentLine Payment Line
     * @return message
    */
    @AuraEnabled(cacheable=false)
    public static String savePayment(WOD_Payment_Line__c paymentLine,String settlementType){
        try{
            upsert paymentLine;
            calculateTotalAmountOnPackage(paymentLine.Payment__c,settlementType);
            return 'success';
        }
        catch(DMLException  ex){
            return ex.getDmlMessage(0);
        }
    }
    /**
     * @description remote method for PRS,RCW,RCT,RCR,WAR(no warranty product or uom req...function called on load)
     * @param setChar Filter Text
     * @param Claimid Claim Id
     * @return fetchSapAmt
    */
    @AuraEnabled(cacheable=false)
    public static fetchSapAmt getPriceOnLoad(String setChar,Id Claimid){        
        fetchSapAmt sapAmt;        
        Decimal price;
        Decimal prevAmt;
        WOD_Payment_Line__c payFromSAP = new WOD_Payment_Line__c();
        Decimal months_covered;
        Decimal months_Used;

        if(setChar == 'PRS'){
           /*price = twod_PaymentManager.GetProrateMaterialLaborCost(Claimid).setScale(2);
            sapAmt = new fetchSapAmt('',price,0.0,0.0,0.0,0.0,0.0);*/
            payFromSAP = WOD_PaymentManager.GetProrateMaterialLaborCost(Claimid);
            price = payFromSAP.Amount__c.setScale(4);
            months_covered = payFromSAP.Months_Covered__c ;
            months_Used = payFromSAP.Months_Used__c;            
            sapAmt = new fetchSapAmt('',price,0.0,months_covered,months_Used,0.0,0.0,null);
        }
        else if(setChar == 'WAR'){
            /*price = twod_PaymentManager.GetProrateMaterialCost(Claimid).setScale(2);
            sapAmt = new fetchSapAmt('',price,0.0,0.0,0.0,0.0,0.0);*/
            payFromSAP = WOD_PaymentManager.GetProrateMaterialCost(Claimid);
            price = payFromSAP.Amount__c.setScale(4);
            months_covered = payFromSAP.Months_Covered__c ;
            months_Used = payFromSAP.Months_Used__c;
            sapAmt = new fetchSapAmt('',price,0.0,months_covered,months_Used,0.0,0.0,null);            
        }
        else if(setChar == 'RCW'){
            system.debug('****Inside block3****');
            payFromSAP = WOD_PaymentManager.GetWarrantyClassActionCost(Claimid);
            price = payFromSAP.Amount__c.setScale(4);
            months_covered = payFromSAP.Months_Covered__c ;
            months_Used = payFromSAP.Months_Used__c;
            sapAmt = new fetchSapAmt('',price,0.0,months_covered,months_Used,0.0,0.0,null);
        }
        return sapAmt;        
    }
    /**
     * @description to  get amount
     * @param setChar for filter
     * @param setBasis Set Basis
     * @param packageRecordType Record Type 
     * @param Claimid Claim Id
     * @param paymentId Payment Id
     * @param productId Warranty Product Id
     * @param roofing_siding Bu flag
     * @param steepPitch Steep Pitch flag
     * @param addstorey add storey falg
     * @param demolish flag
     * @return fetchSapAmt
    */
    @AuraEnabled(cacheable=false)
    public static fetchSapAmt getAmountCheckCost(String setChar,String setBasis,String packageRecordType,String Claimid,String paymentId,String productId,boolean roofing_siding,boolean steepPitch,boolean addstorey,boolean demolish){        
        //roofing_siding-->true means siding org
        //roofing_siding -->false means roofing org        
        fetchSapAmt sapAmt;
        String uom;
        boolean isRoofing;
        Decimal price;
        Decimal OriginalPrice;
        Decimal LocationFactor;
        WOD_WS.PricingSuccess ps;
        WOD_2__Warranty_Product__c wr;
        WOD_2__Claim__c clm = new WOD_2__Claim__c();
        WOD_Payment__c pay = new WOD_Payment__c();
        if(roofing_siding == true){
            isRoofing = false;
        }
        else{
            isRoofing = true;
        }
        //warranty product UOM for labor type
        System.debug('====>'+productId);
        wr = [Select Id,Base_UOM__c,Alt_UOM__c,UOM_Conversion__c From WOD_2__Warranty_Product__c where Id=: productId];
        clm =[Select Plant_Code__c,Country_BL__c ,State_BL__c,Postal_Code_BL__c,City_BL__c,Sold_To_Party__c,Ship_to__c from WOD_2__Claim__c where Id =: Claimid];
        pay = [Select Ship_To__c,Sold_To__c From WOD_Payment__c Where Id=: paymentId];
        if(clm.State_BL__c == ''){
            throw new customException('State is not present on the claim,thus price is not fetched: ');
        }
        if(clm.Postal_Code_BL__c == ''){
            throw new customException('Zip Code is not present on the claim,thus price is not fetched: ');
        }
        if(clm.City_BL__c  == ''){
            throw new customException('City is not present on the claim,thus price is not fetched:');
        }
        
        if(setChar == 'RSL'||setChar == 'STP'||setChar == 'TOF'||setChar == '2ND'){
            if(clm.Country_BL__c != 'Canada'){     
                WOD_PaymentManager.PriceWrapper wrapper = WOD_PaymentManager.GetLaborCost(isRoofing ,productId,clm.State_BL__c,clm.Postal_Code_BL__c,clm.City_BL__c ,steepPitch,addstorey,demolish);
                price = wrapper.Price.setScale(2);
                OriginalPrice = wrapper.OriginalPrice.setScale(2);
                LocationFactor = wrapper.LocationFactor.setScale(2);
            }else{
                 WOD_PaymentManager.PriceWrapper wrapper = WOD_PaymentManager.GetLaborCost(isRoofing ,productId,clm.State_BL__c,'',clm.City_BL__c ,steepPitch,addstorey,demolish);
                price = wrapper.Price.setScale(2);
                OriginalPrice = wrapper.OriginalPrice.setScale(2);
                LocationFactor = wrapper.LocationFactor.setScale(2);
            }
            uom =wr.Base_UOM__c ;
            sapAmt = new fetchSapAmt(uom,price,0.0,0.0,0.0,OriginalPrice,LocationFactor,wr);
        }
        else if(setChar == 'MTL'){            
            ps = WOD_PaymentManager.GetMaterialPrice(isRoofing ,productId,clm.Plant_Code__c,pay.Ship_to__c,pay.Sold_To__c,paymentId);
            if(ps.strUOM!=null){
                uom=ps.strUOM;
            }
            price = ps.decPrice.setScale(2);
            sapAmt = new fetchSapAmt(uom,price,0.0,0.0,0.0,0.0,0.0,wr);
        }
        else if(setChar == 'RSM'){
            if(clm.Country_BL__c != 'Canada'){     
                WOD_PaymentManager.PriceWrapper wrapper = WOD_PaymentManager.GetMaterialCost(clm.State_BL__c,clm.Postal_Code_BL__c,clm.City_BL__c,productId);
                price = wrapper.Price.setScale(2);
                OriginalPrice = wrapper.OriginalPrice.setScale(2);
                LocationFactor = wrapper.LocationFactor.setScale(2);
                
            }else{
                WOD_PaymentManager.PriceWrapper wrapper = WOD_PaymentManager.GetMaterialCost(clm.State_BL__c,'',clm.City_BL__c,productId);
                price = wrapper.Price.setScale(2);
                OriginalPrice = wrapper.OriginalPrice.setScale(2);
                LocationFactor = wrapper.LocationFactor.setScale(2);

            }
            uom=wr.Base_UOM__c ;
            sapAmt = new fetchSapAmt(uom,price,0.0,0.0,0.0,OriginalPrice,LocationFactor,wr);
        }        
        return sapAmt;        
    }
    /**
     * @description to  get amount
     * @param setChar for filter
     * @param setBasis Set Basis
     * @param packageRecordType Record Type 
     * @param Claimid Claim Id
     * @param paymentId Payment Id
     * @param productId Warranty Product Id
     * @param roofing_siding Bu flag
     * @return fetchSapAmt
    */
    @AuraEnabled(cacheable=false)
    public static fetchSapAmt getAmountCreditDebit(String setChar,String setBasis,String packageRecordType,Id Claimid,Id paymentId,Id productId,boolean roofing_siding){
        fetchSapAmt sapAmt;
        String uom;
        boolean isRoofing;
        Decimal price;    
        WOD_WS.PricingSuccess ps;
        WOD_2__Claim__c clm = new WOD_2__Claim__c();
        WOD_Payment__c pay = new WOD_Payment__c();
        if(roofing_siding == true){
            isRoofing = false;}
        else{
            isRoofing = true;
        }
       
        clm =[Select Plant_Code__c,State_BL__c,Postal_Code_BL__c,City_BL__c,Sold_To_Party__c,Ship_to__c from WOD_2__Claim__c where Id =: Claimid];
        WOD_2__Warranty_Product__c wr = [Select Id,Base_UOM__c,Alt_UOM__c,UOM_Conversion__c From WOD_2__Warranty_Product__c where Id=: productId];
        //clm =[Select Plant_Code__c,State_BL__c,Postal_Code_BL__c,City_BL__c,Sold_To_Party__c,Ship_to__c, Plant__r.Name from twod__Claim__c where Id =: Claimid];
        pay = [Select Ship_To__c,Sold_To__c From WOD_Payment__c Where Id=: paymentId];
        if(clm.State_BL__c == ''){
            throw new customException('State is not present on the claim,thus price is not fetched: ');
        }
        if(clm.Postal_Code_BL__c == ''){
            throw new customException('Zip Code is not present on the claim,thus price is not fetched: ');
        }
        if(clm.City_BL__c  == ''){
            throw new customException('City is not present on the claim,thus price is not fetched:');
        }
        //this if loop will be exceuted only for record type Credit/Debit and Basis type Material which will be passed from page
        if(setBasis =='Material' && packageRecordType== 'Credit/Debit'){
            ps = WOD_PaymentManager.GetMaterialPrice(isRoofing ,productId,clm.Plant_Code__c,pay.Ship_to__c,pay.Sold_To__c,paymentId );
            uom=ps.strUOM;
            price = ps.decPrice.setScale(2);
            sapAmt = new fetchSapAmt(uom,price,0.0,0.0,0.0,0.0,0.0,wr);            
        }
        return sapAmt;
    }
    /**
     * @description to  get amount
     * @param setBasis Set Basis
     * @param Claimid Claim Id
     * @param paymentId Payment Id
     * @param productId Warranty Product Id
     * @param roofing_siding Bu flag
     * @param steepPitch Steep Pitch flag
     * @param addstorey add storey falg
     * @param demolish flag
     * @return fetchSapAmt
    */
    @AuraEnabled(cacheable=false)
    public static fetchSapAmt getAmountCheckCostForSiding(String setBasis,Id Claimid,Id paymentId,Id productId,boolean roofing_siding,boolean steepPitch,boolean addstorey,boolean demolish){
        //roofing_siding-->true means siding org
        //roofing_siding -->false means roofing org
        fetchSapAmt sapAmt;
        String uom;
        Decimal price;
        boolean isRoofing = false;
        WOD_WS.PricingSuccess ps;
        WOD_2__Warranty_Product__c wr;
        WOD_2__Claim__c clm = new WOD_2__Claim__c();
        WOD_Payment__c pay = new WOD_Payment__c();
        
        //warranty product UOM for labor type
        wr = [Select id,UOM__c,Base_UOM__c,Selling_UOM__c,UOM_Conversion__c From WOD_2__Warranty_Product__c where Id=: productId];
        clm =[Select id,Plant_Code__c,Country_BL__c,State_BL__c,Postal_Code_BL__c,City_BL__c,Sold_To_Party__c,Ship_to__c from WOD_2__Claim__c where Id =: Claimid];
        pay = [Select id,Ship_To__c,Sold_To__c From WOD_Payment__c Where Id=: paymentId];
        
        if(setBasis == 'Labor'){
            if(clm.State_BL__c == null){
                throw new customException('Unable to fetch the Price as State is not filled for the Claim');
            }
            if(clm.Postal_Code_BL__c ==null){
                throw new customException('Unable to fetch the Price as Zip Code is not filled for the Claim');
            }
            if(clm.City_BL__c == null){
                throw new customException('Unable to fetch the Price as City is not filled for the Claim');
            }
            if(clm.Country_BL__c != 'Canada'){     
                WOD_PaymentManager.PriceWrapper wrapper = WOD_PaymentManager.GetLaborCost(isRoofing,productId,clm.State_BL__c,clm.Postal_Code_BL__c,clm.City_BL__c ,steepPitch,addstorey,demolish);
                price=wrapper.Price.setScale(2);
            }else{
                WOD_PaymentManager.PriceWrapper wrapper = WOD_PaymentManager.GetLaborCost(isRoofing,productId,clm.State_BL__c,'',clm.City_BL__c ,steepPitch,addstorey,demolish);
                price=wrapper.Price.setScale(2);
            }            
            sapAmt = new fetchSapAmt(uom,price,0.0,null,null,0.0,0.0,null);
        }
        else if(setBasis == 'Material' && roofing_siding == true){
            if(pay.Ship_To__c ==null){
                throw new customException('Unable to fetch the Price as Ship To is not filled on the Payment');
            }
            if(pay.Sold_To__c ==null){
                throw new customException('Unable to fetch the Price as Sold To is not filled on the Payment');
            }  
            ps = WOD_PaymentManager.GetMaterialPrice(isRoofing,productId,clm.Plant_Code__c,pay.Ship_to__c,pay.Sold_To__c,paymentId );
            uom=ps.strUOM;
            if(uom==wr.Base_UOM__c){
                price = ps.decPrice * wr.UOM_Conversion__c;    
            }else{
                price = ps.decPrice;
            }            
            sapAmt = new fetchSapAmt('',price,0.0,null,null,0.0,0.0,null);
        }       
        return sapAmt;        
    }
    /**
     * @description to  get amount
     * @param setBasis Set Basis
     * @param Claimid Claim Id
     * @param paymentId Payment Id
     * @param productId Warranty Product Id
     * @param roofing_siding Bu flag
     * @param steepPitch Steep Pitch flag
     * @param addstorey add storey falg
     * @param demolish flag
     * @return fetchSapAmt
    */
    @AuraEnabled(cacheable=false)
    public static fetchSapAmt getAmountCostForSiding(String setBasis,Id Claimid,Id paymentId,Id productId,boolean roofing_siding,boolean steepPitch,boolean addstorey,boolean demolish){
        //roofing_siding-->true means siding org
        //roofing_siding -->false means roofing org
        fetchSapAmt sapAmt;
        String uom;
        Decimal price;
        boolean isRoofing =false;
        WOD_WS.PricingSuccess ps;
        WOD_2__Warranty_Product__c wr = new WOD_2__Warranty_Product__c ();
        WOD_2__Claim__c clm = new WOD_2__Claim__c();
        WOD_Payment__c pay = new WOD_Payment__c();
        
        wr = [Select Id,UOM__c,Base_UOM__c,UOM_Conversion__c From WOD_2__Warranty_Product__c where Id=: productId];
        clm =[Select Id,Plant_Code__c,Country_BL__c ,State_BL__c,Postal_Code_BL__c,City_BL__c,Sold_To_Party__c,Ship_to__c from WOD_2__Claim__c where Id =: Claimid];
        pay = [Select Id,Ship_To__c,Sold_To__c From WOD_Payment__c Where Id=: paymentId];

        if(setBasis == 'Material'){
            if(pay.Ship_To__c ==null){
                throw new customException('Unable to fetch the Price as Ship To is not filled on the Payment');
            }
            if(pay.Sold_To__c ==null){
                throw new customException('Unable to fetch the Price as Sold To is not filled on the Payment');
            }       
            
            ps = WOD_PaymentManager.GetMaterialPrice(isRoofing,productId,clm.Plant_Code__c,pay.Ship_to__c,pay.Sold_To__c,paymentId);
             uom=ps.strUOM;
             System.debug('PS====>'+ps);
            if(uom==wr.Base_UOM__c){
                price = ps.decPrice * wr.UOM_Conversion__c;    
            }else{
                price = ps.decPrice;
            }
            sapAmt = new fetchSapAmt(uom,price,0.0,null,null,0.0,0.0,null);
            
        }else if(setBasis == 'Labor'){
            if(clm.State_BL__c == null){
                throw new customException('Unable to fetch the Price as State is not filled for the Claim');
            }
            if(clm.Postal_Code_BL__c ==null){
                throw new customException('Unable to fetch the Price as Zip Code is not filled for the Claim');
            }
            if(clm.City_BL__c == null){
                throw new customException('Unable to fetch the Price as City is not filled for the Claim');
            }
            if(clm.Country_BL__c != 'Canada'){ 
                WOD_PaymentManager.PriceWrapper wrapper = WOD_PaymentManager.GetLaborCost(isRoofing,productId,clm.State_BL__c,clm.Postal_Code_BL__c,clm.City_BL__c ,steepPitch,addstorey,demolish);    
                price=wrapper.Price.setScale(2);
            }else{
                WOD_PaymentManager.PriceWrapper wrapper = WOD_PaymentManager.GetLaborCost(isRoofing,productId,clm.State_BL__c,'',clm.City_BL__c ,steepPitch,addstorey,demolish); 
                price=wrapper.Price.setScale(2);
            }
            uom =wr.UOM__c ;
            sapAmt = new fetchSapAmt('',price,0.0,null,null,0.0,0.0,null);
        }        
        return sapAmt ; 
    }
    /**
     * @description roll up amount 
     * @param paymentId Payment Id
     * @return message
    */
    @AuraEnabled(cacheable=false)
    public Static String calculateTotalAmountOnPackage(String paymentId,String settlementType){
        List<aggregateResult> aggResults = new List<aggregateResult>();
        List<WOD_Payment_Line__c> lstPayLine = new List<WOD_Payment_Line__c>();
        try{
            aggResults= [SELECT SUM(Total_Payment_Amount__c)sumTmt, SUM(Total_Payment_Amount_Converted__c)sumTmtConv from WOD_Payment_Line__c where Payment__c=:paymentId];
            WOD_Payment__c payment = new WOD_Payment__c();
            payment.Id = paymentId;
            payment.Total_Amount__c = double.ValueOf(aggResults[0].get('sumTmt'));
            payment.Total_Amount_Converted__c = double.ValueOf(aggResults[0].get('sumTmtConv'));
            update payment;

            // Added to populate Calculation formula
            if(String.isNotBlank(settlementType) && (settlementType == 'WAR'||settlementType == 'PRS'||settlementType == 'RCW')){ 
                lstPayLine = [Select Calculation_Formula__c from WOD_Payment_Line__c  where Payment__c=: paymentId Limit 1];
               if(lstPayLine.size() > 0 && lstPayLine[0].Calculation_Formula__c != null){
                   payment.Calculation_Formula__c = lstPayLine[0].Calculation_Formula__c;
               }  
           }
           update payment;

            return 'success';
        }catch(DMLException  ex){
            return ex.getDmlMessage(0);
        }
    }
    /**
     * @description get dependent picklist values
     * @param paymentId Payment Id
     * @return List of piklist values
    */
    @AuraEnabled(cacheable=false)
    public Static List<String> listOfMaterialCode(String paymentId){
        List<String> pickVal = new List<String>();
        List<String> tempList = new List<String>();
        String sobjName = 'WOD_Payment_Line__c';
        String controllingField = 'Sales_Org__c';
        String dependentField = 'Material_Code__c';
        WOD_Payment__c payment = [Select id,Sales_Org__c,Settlement_Type__c from WOD_Payment__c where id=:paymentId];
        tempList = WOD_PicklistFieldController.getDependentOptions(sobjName,controllingField,dependentField,false).get(payment.Sales_Org__c);   
        Schema.SObjectType s = Schema.getGlobalDescribe().get(sobjName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(dependentField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
            if((payment.Sales_Org__c =='1502' || payment.Sales_Org__c =='1018' || payment.Sales_Org__c =='1019' || payment.Sales_Org__c =='1020') && 'POL - Policy Adjustment' == payment.Settlement_Type__c ){//CER-230
                if(tempList.contains(pickListVal.getLabel()) && pickListVal.getLabel().contains('POL')){
                    pickVal.add(pickListVal.getLabel()+';'+pickListVal.getValue());
                }
            }else if((payment.Sales_Org__c =='1502' || payment.Sales_Org__c =='1018' || payment.Sales_Org__c =='1019' || payment.Sales_Org__c =='1020') && 'WAR - Warranty Adjustment' == payment.Settlement_Type__c){//CER-230
                if(tempList.contains(pickListVal.getLabel()) && pickListVal.getLabel().contains('WAR')){
                    pickVal.add(pickListVal.getLabel()+';'+pickListVal.getValue());
                }
            }
            else{
                if(tempList.contains(pickListVal.getLabel())){
                    pickVal.add(pickListVal.getLabel()+';'+pickListVal.getValue());
                }
            }
        }     
        return pickVal;
    }
      /**
     * @description Check Record create access
     * @param objectApi Object API Name
     * @return Wrapper
    */
    @AuraEnabled(cacheable=true)
    public static WOD_ClaimQuickActionController.ResponseWrapper hasRecordCreateAccess(String objectApi){
        WOD_ClaimQuickActionController.ResponseWrapper response = WOD_ClaimQuickActionController.hasRecordCreateAccess(objectApi);
        return response;
    }
  


    /**
     * @description Wrapper for fetching Amount and UOM from SAP
    */
    public class fetchSapAmt {
        @AuraEnabled
        public String uom {get; set;}
        @AuraEnabled
        public Decimal price {get; set;}
        @AuraEnabled
        public Decimal previousAmount {get;set;} 
        @AuraEnabled
        public Decimal monthsCovered {get;set;}
        @AuraEnabled
        public Decimal monthsUsed {get;set;}
        @AuraEnabled
        public decimal OriginalPrice {get;set;}
        @AuraEnabled
        public Decimal LocationFactor {get;set;}
        @AuraEnabled
        public WOD_2__Warranty_Product__c warrantyProductObj {get;set;}
        //This is the contructor method.
        public fetchSapAmt(String uom_sap,Decimal price_sap,Decimal previousAmount_sap,Decimal monthsCovered_sap, Decimal monthsUsed_sap,Decimal OriginalPrice_sap,Decimal LocationFactor_sap,WOD_2__Warranty_Product__c warrantyProductObj) {
            this.uom = uom_sap;
            this.price = price_sap;
            this.previousAmount = previousAmount_sap;
            this.monthsCovered = monthsCovered_sap;
            this.monthsUsed = monthsUsed_sap;
            this.OriginalPrice = OriginalPrice_sap;
            this.LocationFactor = LocationFactor_sap;
            this.warrantyProductObj = warrantyProductObj;
        }
    }
    /**
     * @description Custom Exception class
    */
    public class customException extends Exception{} 
}